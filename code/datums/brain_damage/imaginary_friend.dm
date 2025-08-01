/datum/brain_trauma/special/imaginary_friend
	name = "Imaginary Friend"
	desc = "Patient can see and hear an imaginary person."
	scan_desc = "partial schizophrenia"
	gain_text = span_notice("You feel in good company, for some reason.")
	lose_text = span_warning("You feel lonely again.")
	var/mob/camera/imaginary_friend/friend
	var/friend_initialized = FALSE

/datum/brain_trauma/special/imaginary_friend/on_gain()
	var/mob/living/M = owner
	if(M.stat == DEAD || !M.client)
		qdel(src)
		return
	..()
	make_friend()
	get_ghost()

/datum/brain_trauma/special/imaginary_friend/on_life(seconds_per_tick, times_fired)
	if(get_dist(owner, friend) > 9)
		friend.recall()
	if(!friend)
		qdel(src)
		return
	if(!friend.client && friend_initialized)
		addtimer(CALLBACK(src, PROC_REF(reroll_friend)), 600)

/datum/brain_trauma/special/imaginary_friend/on_death()
	..()
	qdel(src) //friend goes down with the ship

/datum/brain_trauma/special/imaginary_friend/on_lose()
	..()
	QDEL_NULL(friend)

//If the friend goes afk, make a brand new friend. Plenty of fish in the sea of imagination.
/datum/brain_trauma/special/imaginary_friend/proc/reroll_friend()
	if(friend.client) //reconnected
		return
	friend_initialized = FALSE
	QDEL_NULL(friend)
	make_friend()
	get_ghost()

/datum/brain_trauma/special/imaginary_friend/proc/make_friend()
	friend = new(get_turf(owner), owner)

/datum/brain_trauma/special/imaginary_friend/proc/get_ghost()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = SSpolling.poll_ghost_candidates(
		question = "Do you want to play as [owner.real_name]'s imaginary friend?",
		check_jobban = ROLE_PAI,
		poll_time = 10 SECONDS,
		ignore_category = POLL_IGNORE_IMAGINARYFRIEND,
		alert_pic = owner,
		role_name_text = "imaginary friend"
	)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		friend.PossessByPlayer(C.key)
		friend_initialized = TRUE
	else
		qdel(src)

/mob/camera/imaginary_friend
	name = "imaginary friend"
	real_name = "imaginary friend"
	move_on_shuttle = TRUE
	desc = "A wonderful yet fake friend."
	sight = NONE
	mouse_opacity = MOUSE_OPACITY_ICON
	see_invisible = SEE_INVISIBLE_LIVING
	invisibility = INVISIBILITY_MAXIMUM
	has_emotes = TRUE
	var/icon/human_image
	var/image/current_image
	var/hidden = FALSE
	var/move_delay = 0
	var/mob/living/owner
	//var/bubble_icon = "default" // MONKESTATION REMOVAL

	var/datum/action/innate/imaginary_join/join
	var/datum/action/innate/imaginary_hide/hide

/mob/camera/imaginary_friend/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	greet()
	Show()

/mob/camera/imaginary_friend/proc/greet()
	to_chat(src, span_notice("<b>You are the imaginary friend of [owner]!</b>"))
	to_chat(src, span_notice("You are absolutely loyal to your friend, no matter what."))
	to_chat(src, span_notice("You cannot directly influence the world around you, but you can see what [owner] cannot."))

/**
 * Arguments:
 * * imaginary_friend_owner - The living mob that owns the imaginary friend.
 * * appearance_from_prefs - If this is a valid set of prefs, the appearance of the imaginary friend is based on these prefs.
 */
/mob/camera/imaginary_friend/Initialize(mapload, mob/living/imaginary_friend_owner, datum/preferences/appearance_from_prefs = null)
	. = ..()

	//Monkestation Edit Begin
	if(istype(src, /mob/camera/imaginary_friend/mentor))
		return
	//Monkestation Edit End

	owner = imaginary_friend_owner

	if(appearance_from_prefs)
		INVOKE_ASYNC(src, PROC_REF(setup_friend_from_prefs), appearance_from_prefs)
	else
		INVOKE_ASYNC(src, PROC_REF(setup_friend))

	join = new
	join.Grant(src)
	hide = new
	hide.Grant(src)

	if(!owner.imaginary_group)
		owner.imaginary_group = list(owner)
	owner.imaginary_group += src

/mob/camera/imaginary_friend/proc/setup_friend()
	var/gender = pick(MALE, FEMALE)
	real_name = random_unique_name(gender)
	name = real_name
	human_image = get_flat_human_icon(null, pick(SSjob.joinable_occupations))

/**
 * Sets up the imaginary friend's name and look using a set of datum preferences.
 *
 * Arguments:
 * * appearance_from_prefs - If this is a valid set of prefs, the appearance of the imaginary friend is based on the currently selected character in them. Otherwise, it's random.
 */
/mob/camera/imaginary_friend/proc/setup_friend_from_prefs(datum/preferences/appearance_from_prefs)
	if(!istype(appearance_from_prefs))
		stack_trace("Attempted to create imaginary friend appearance from null prefs. Using random appearance.")
		setup_friend()
		return

	real_name = appearance_from_prefs.read_preference(/datum/preference/name/real_name)
	name = real_name

	// Determine what job is marked as 'High' priority.
	var/datum/job/appearance_job
	var/highest_pref = 0
	for(var/job in appearance_from_prefs.job_preferences)
		var/this_pref = appearance_from_prefs.job_preferences[job]
		if(this_pref > highest_pref)
			appearance_job = SSjob.GetJob(job)
			highest_pref = this_pref

	if(!appearance_job)
		appearance_job = SSjob.GetJob(JOB_ASSISTANT)

	if(istype(appearance_job, /datum/job/ai))
		human_image = icon('icons/mob/silicon/ai.dmi', icon_state = resolve_ai_icon(appearance_from_prefs.read_preference(/datum/preference/choiced/ai_core_display)), dir = SOUTH)
		return

	if(istype(appearance_job, /datum/job/cyborg))
		human_image = icon('icons/mob/silicon/robots.dmi', icon_state = "robot")
		return

	human_image = get_flat_human_icon(null, appearance_job, appearance_from_prefs)

/// Returns all member clients of the imaginary_group
/mob/camera/imaginary_friend/proc/group_clients()
	var/group_clients = list()
	for(var/mob/person as anything in owner.imaginary_group)
		if(person.client)
			group_clients += person.client
	return group_clients

/mob/camera/imaginary_friend/proc/Show()
	if(!client) //nobody home
		return

	var/list/friend_clients = group_clients() - src.client
	//Remove old image from group
	remove_image_from_clients(current_image, friend_clients)

	//Generate image from the static icon and the current dir
	current_image = image(human_image, src, , MOB_LAYER, dir=src.dir)
	current_image.override = TRUE
	current_image.name = name
	if(hidden)
		current_image.alpha = 150

	//Add new image to owner and friend
	if(!hidden)
		add_image_to_clients(current_image, friend_clients)

	src.client.images |= current_image

/mob/camera/imaginary_friend/Destroy()
	if(owner?.client)
		owner.client.images.Remove(human_image)
	if(client)
		client.images.Remove(human_image)
	owner.imaginary_group -= src
	return ..()

/mob/camera/imaginary_friend/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list(), message_range)
	if (client?.prefs.read_preference(/datum/preference/toggle/enable_runechat) && (client.prefs.read_preference(/datum/preference/toggle/enable_runechat_non_mobs) || ismob(speaker)))
		create_chat_message(speaker, message_language, raw_message, spans)
	to_chat(src, compose_message(speaker, message_language, raw_message, radio_freq, spans, message_mods))

/mob/camera/imaginary_friend/send_speech(message, range = 7, obj/source = src, bubble_type = bubble_icon, list/spans = list(), datum/language/message_language = null, list/message_mods = list(), forced = null)
	message = get_message_mods(message, message_mods)
	message = capitalize(message)

	if(message_mods[RADIO_EXTENSION] == MODE_ADMIN)
		SSadmin_verbs.dynamic_invoke_verb(client, /datum/admin_verb/cmd_admin_say, message)
		return

	if(message_mods[RADIO_EXTENSION] == MODE_DEADMIN)
		SSadmin_verbs.dynamic_invoke_verb(client, /datum/admin_verb/dsay, message)
		return

	if(check_emote(message, forced))
		return

	if(message_mods[MODE_SING])
		var/randomnote = pick("♩", "♪", "♫")
		message = "[randomnote] [capitalize(message)] [randomnote]"
		spans |= SPAN_SINGING

	var/eavesdrop_range = 0
	var/eavesdropped_message = ""

	if (message_mods[MODE_CUSTOM_SAY_ERASE_INPUT])
		message = message_mods[MODE_CUSTOM_SAY_EMOTE]
		log_message(message, LOG_RADIO_EMOTE)
	else
		if(message_mods[WHISPER_MODE] == MODE_WHISPER)
			log_talk(message, LOG_WHISPER, tag="imaginary friend", forced_by = forced, custom_say_emote = message_mods[MODE_CUSTOM_SAY_EMOTE])
			spans |= SPAN_ITALICS
			eavesdrop_range = EAVESDROP_EXTRA_RANGE
			// "This proc is dangerously laggy, avoid it or die"
			// What other option do I have here? I guess I'll die
			eavesdropped_message = stars(message)
		else
			log_talk(message, LOG_SAY, tag="imaginary friend", forced_by = forced, custom_say_emote = message_mods[MODE_CUSTOM_SAY_EMOTE])

	var/quoted_message = say_quote(say_emphasis(message), spans, message_mods)
	var/rendered = "[span_name("[name]")] [quoted_message]"
	var/dead_rendered = "[span_name("[name] (Imaginary friend of [owner])")] [quoted_message]"

	var/language = message_language || owner.language_holder.get_selected_language()
	Hear(rendered, src, language, message, null, spans, message_mods) // We always hear what we say
	var/group = owner.imaginary_group - src // The people in our group don't, so we have to exclude ourselves not to hear twice
	for(var/mob/person in group)
		if(eavesdrop_range && get_dist(src, person) > WHISPER_RANGE + eavesdrop_range && !HAS_TRAIT(person, TRAIT_GOOD_HEARING))
			var/new_rendered = "[span_name("[name]")] [say_quote(say_emphasis(eavesdropped_message), spans, message_mods)]"
			person.Hear(new_rendered, src, language, eavesdropped_message, null, spans, message_mods)
		else
			person.Hear(rendered, src, language, message, null, spans, message_mods)

	// Speech bubble, but only for those who have runechat off
	var/list/speech_bubble_recipients = list()
	for(var/mob/user as anything in (group + src)) // Add ourselves back in
		if(user.client && (!user.client.prefs.read_preference(/datum/preference/toggle/enable_runechat) || (SSlag_switch.measures[DISABLE_RUNECHAT] && !HAS_TRAIT(src, TRAIT_BYPASS_MEASURES))))
			speech_bubble_recipients.Add(user.client)

	var/image/bubble = image('icons/mob/effects/talk.dmi', src, "[bubble_type][say_test(message)]", FLY_LAYER)
	SET_PLANE_EXPLICIT(bubble, ABOVE_GAME_PLANE, src)
	bubble.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay_global), bubble, speech_bubble_recipients, 3 SECONDS)
	LAZYADD(update_on_z, bubble)
	addtimer(CALLBACK(src, PROC_REF(clear_saypopup), bubble), 3.5 SECONDS)

	var/turf/center_turf = get_turf(src)
	if(!center_turf)
		return

	for(var/mob/dead_player in GLOB.dead_mob_list)
		if(dead_player.z != z || get_dist(src, dead_player) > 7)
			if(eavesdrop_range)
				if(!(dead_player.client?.prefs.chat_toggles & CHAT_GHOSTWHISPER))
					continue
			else if(!(dead_player.client?.prefs.chat_toggles & CHAT_GHOSTEARS))
				continue
		var/link = FOLLOW_LINK(dead_player, owner)
		to_chat(dead_player, "[link] [dead_rendered]")

/mob/camera/imaginary_friend/proc/clear_saypopup(image/say_popup)
	LAZYREMOVE(update_on_z, say_popup)

/mob/camera/imaginary_friend/whisper(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language, ignore_spam = FALSE, forced, filterproof)
	if(!message)
		return
	say("#[message]", bubble_type, spans, sanitize, language, ignore_spam, forced, filterproof)

/datum/emote/imaginary_friend
	mob_type_allowed_typecache = /mob/camera/imaginary_friend

// We have to create our own since we can only show emotes to ourselves and our owner
/datum/emote/imaginary_friend/run_emote(mob/user, params, type_override, intentional = FALSE)
	user.log_talk(message, LOG_EMOTE)
	if(!can_run_emote(user, FALSE, intentional))
		return FALSE

	var/msg = select_message_type(user, message, intentional)
	if(params && message_param)
		msg = select_param(user, params)

	msg = replace_pronoun(user, msg)

	if(!msg)
		return TRUE

	var/mob/camera/imaginary_friend/friend = user
	var/dchatmsg = "[span_bold("[friend] (Imaginary friend of [friend.owner])")] [msg]"
	message = "[span_name("[user]")] [msg]"

	var/user_turf = get_turf(user)
	if (user.client)
		for(var/mob/ghost as anything in GLOB.dead_mob_list)
			if(!ghost.client || isnewplayer(ghost))
				continue
			if(ghost.client.prefs.chat_toggles & CHAT_GHOSTSIGHT && !(ghost in viewers(user_turf, null)))
				ghost.show_message("[FOLLOW_LINK(ghost, user)] [dchatmsg]")

	for(var/mob/person in friend.owner.imaginary_group)
		to_chat(person, message)
		if(person.client?.prefs.read_preference(/datum/preference/toggle/enable_runechat))
			person.create_chat_message(friend, raw_message = msg, runechat_flags = EMOTE_MESSAGE)
	return TRUE

/datum/emote/imaginary_friend/point
	key = "point"
	key_third_person = "points"
	message = "points."
	message_param = "points at %t."

/datum/emote/imaginary_friend/point/run_emote(mob/camera/imaginary_friend/friend, params, type_override, intentional)
	message_param = initial(message_param) // reset
	return ..()

/datum/emote/imaginary_friend/custom
	key = "me"
	key_third_person = "custom"
	message = null

/datum/emote/imaginary_friend/custom/can_run_emote(mob/user, status_check, intentional)
	return ..() && intentional

/datum/emote/imaginary_friend/custom/run_emote(mob/user, params, type_override = null, intentional = FALSE)
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	if(is_banned_from(user.ckey, "Emote"))
		to_chat(user, span_boldwarning("You cannot send custom emotes (banned)."))
		return FALSE
	else if(QDELETED(user))
		return FALSE
	else if(user.client && user.client.prefs.muted & MUTE_IC)
		to_chat(user, span_boldwarning("You cannot send IC messages (muted)."))
		return FALSE
	else if(!params)
		message = copytext(sanitize(input("Choose an emote to display.") as text|null), 1, MAX_MESSAGE_LEN)
	else
		message = params
	. = ..()
	message = null

/datum/emote/imaginary_friend/custom/replace_pronoun(mob/user, message)
	return message

// Another snowflake proc, when will they end... should have refactored it differently
/mob/camera/imaginary_friend/point_at(atom/pointed_atom)
	if(!isturf(loc))
		return

	if (pointed_atom in src)
		create_point_bubble(pointed_atom)
		return

	var/turf/tile = get_turf(pointed_atom)
	if (!tile)
		return

	var/turf/our_tile = get_turf(src)
	var/obj/visual = image('icons/hud/screen_gen.dmi', our_tile, "arrow", FLY_LAYER)

	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(flick_overlay_global), visual, group_clients(), 2.5 SECONDS)
	animate(visual, pixel_x = (tile.x - our_tile.x) * world.icon_size + pointed_atom.pixel_x, pixel_y = (tile.y - our_tile.y) * world.icon_size + pointed_atom.pixel_y, time = 1.7, easing = EASE_OUT)

/mob/camera/imaginary_friend/create_thinking_indicator()
	if(active_thinking_indicator || active_typing_indicator || !HAS_TRAIT(src, TRAIT_THINKING_IN_CHARACTER))
		return FALSE
	active_thinking_indicator = image('icons/mob/effects/talk.dmi', src, "[bubble_icon]3", TYPING_LAYER)
	add_image_to_clients(active_thinking_indicator, group_clients())

/mob/camera/imaginary_friend/remove_thinking_indicator()
	if(!active_thinking_indicator)
		return FALSE
	remove_image_from_clients(active_thinking_indicator, group_clients())
	active_thinking_indicator = null

/mob/camera/imaginary_friend/create_typing_indicator()
	if(active_typing_indicator || active_thinking_indicator || !HAS_TRAIT(src, TRAIT_THINKING_IN_CHARACTER))
		return FALSE
	active_typing_indicator = image('icons/mob/effects/talk.dmi', src, "[bubble_icon]0", TYPING_LAYER)
	add_image_to_clients(active_typing_indicator, group_clients())

/mob/camera/imaginary_friend/remove_typing_indicator()
	if(!active_typing_indicator)
		return FALSE
	remove_image_from_clients(active_typing_indicator, group_clients())
	active_typing_indicator = null

/mob/camera/imaginary_friend/remove_all_indicators()
	REMOVE_TRAIT(src, TRAIT_THINKING_IN_CHARACTER, CURRENTLY_TYPING_TRAIT)
	remove_thinking_indicator()
	remove_typing_indicator()

/mob/camera/imaginary_friend/Move(NewLoc, Dir = 0)
	if(world.time < move_delay)
		return FALSE
	setDir(Dir)
	if(get_dist(src, owner) > 9)
		recall()
		move_delay = world.time + 10
		return FALSE
	abstract_move(NewLoc)
	move_delay = world.time + 1

/mob/camera/imaginary_friend/setDir(newdir)
	. = ..()
	Show() // The image does not actually update until Show() gets called

/mob/camera/imaginary_friend/proc/recall()
	if(!owner || loc == owner)
		return FALSE
	abstract_move(owner)

/datum/action/innate/imaginary_join
	name = "Join"
	desc = "Join your owner, following them from inside their mind."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_revenant_border"
	button_icon_state = "join"

/datum/action/innate/imaginary_join/Activate()
	var/mob/camera/imaginary_friend/I = owner
	I.recall()

/datum/action/innate/imaginary_hide
	name = "Hide"
	desc = "Hide yourself from your owner's sight."
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_revenant_border"
	button_icon_state = "hide"

/datum/action/innate/imaginary_hide/proc/update_status()
	var/mob/camera/imaginary_friend/I = owner
	if(I.hidden)
		name = "Show"
		desc = "Become visible to your owner."
		button_icon_state = "unhide"
	else
		name = "Hide"
		desc = "Hide yourself from your owner's sight."
		button_icon_state = "hide"
	build_all_button_icons()

/datum/action/innate/imaginary_hide/Activate()
	var/mob/camera/imaginary_friend/fake_friend = owner
	fake_friend.hidden = !fake_friend.hidden
	fake_friend.Show()
	build_all_button_icons(UPDATE_BUTTON_NAME|UPDATE_BUTTON_ICON)

/datum/action/innate/imaginary_hide/update_button_name(atom/movable/screen/movable/action_button/button, force)
	var/mob/camera/imaginary_friend/fake_friend = owner
	if(fake_friend.hidden)
		name = "Show"
		desc = "Become visible to your owner."
	else
		name = "Hide"
		desc = "Hide yourself from your owner's sight."
	return ..()

/datum/action/innate/imaginary_hide/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	var/mob/camera/imaginary_friend/fake_friend = owner
	if(fake_friend.hidden)
		button_icon_state = "unhide"
	else
		button_icon_state = "hide"

	return ..()

//down here is the trapped mind
//like imaginary friend but a lot less imagination and more like mind prison//

/datum/brain_trauma/special/imaginary_friend/trapped_owner
	name = "Trapped Victim"
	desc = "Patient appears to be targeted by an invisible entity."
	gain_text = ""
	lose_text = ""
	random_gain = FALSE

/datum/brain_trauma/special/imaginary_friend/trapped_owner/make_friend()
	friend = new /mob/camera/imaginary_friend/trapped(get_turf(owner), src)

/datum/brain_trauma/special/imaginary_friend/trapped_owner/reroll_friend() //no rerolling- it's just the last owner's hell
	if(friend.client) //reconnected
		return
	friend_initialized = FALSE
	QDEL_NULL(friend)
	qdel(src)

/datum/brain_trauma/special/imaginary_friend/trapped_owner/get_ghost() //no randoms
	return

/mob/camera/imaginary_friend/trapped
	name = "figment of imagination?"
	real_name = "figment of imagination?"
	desc = "The previous host of this body."

/mob/camera/imaginary_friend/trapped/greet()
	to_chat(src, span_notice(span_bold("You have managed to hold on as a figment of the new host's imagination!")))
	to_chat(src, span_notice("All hope is lost for you, but at least you may interact with your host. You do not have to be loyal to them."))
	to_chat(src, span_notice("You cannot directly influence the world around you, but you can see what the host cannot."))

/mob/camera/imaginary_friend/trapped/setup_friend()
	real_name = "[owner.real_name]?"
	name = real_name
	human_image = icon('icons/mob/simple/lavaland/lavaland_monsters.dmi', icon_state = "curseblob")

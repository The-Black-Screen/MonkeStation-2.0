/// Any humanoid (non-Xeno) mob, such as humans, plasmamen, lizards.
/mob/living/carbon/human
	name = "Unknown"
	real_name = "Unknown"
	icon = 'icons/mob/species/human/human.dmi'
	icon_state = "human_basic"
	appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE|LONG_GLIDE
	hud_possible = list(HEALTH_HUD,STATUS_HUD,ID_HUD,WANTED_HUD,IMPLOYAL_HUD,IMPCHEM_HUD,IMPTRACK_HUD,ANTAG_HUD,GLAND_HUD,SENTIENT_DISEASE_HUD,FAN_HUD,NANITE_HUD,DIAG_NANITE_FULL_HUD,PERMIT_HUD,SENSOR_HUD,CREW_HUD)
	hud_type = /datum/hud/human
	pressure_resistance = 25
	can_buckle = TRUE
	buckle_lying = 0
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	can_be_shoved_into = TRUE

	bodytemp_cold_damage_limit = BODYTEMP_COLD_DAMAGE_LIMIT
	bodytemp_heat_damage_limit = BODYTEMP_HEAT_DAMAGE_LIMIT

	//Hair colour and style
	var/hair_color = "#000000"
	var/hairstyle = "Bald"

	///Colours used for hair and facial hair gradients.
	var/list/grad_color
	///Styles used for hair and facial hair gradients.
	var/list/grad_style

	//Facial hair colour and style
	var/facial_hair_color = "#000000"
	var/facial_hairstyle = "Shaved"

	//Eye colour
	var/eye_color_left = "#000000"
	var/eye_color_right = "#000000"
	/// Var used to keep track of a human mob having a heterochromatic right eye. To ensure prefs don't overwrite shit
	var/eye_color_heterochromatic = FALSE

	var/skin_tone = "caucasian1" //Skin tone

	var/lip_style = null //no lipstick by default- arguably misleading, as it could be used for general makeup
	var/lip_color = COLOR_WHITE

	var/age = 30 //Player's age

	/// Which body type to use
	var/physique = MALE

	//consider updating /mob/living/carbon/human/copy_clothing_prefs() if adding more of these
	var/underwear = "Nude" //Which underwear the player wants
	var/underwear_color = "#000000"
	var/undershirt = "Nude" //Which undershirt the player wants
	var/socks = "Nude" //Which socks the player wants
	var/backpack = DBACKPACK //Which backpack type the player has chosen.
	var/jumpsuit_style = PREF_SUIT //suit/skirt

	//Equipment slots
	var/obj/item/clothing/wear_suit = null
	var/obj/item/clothing/w_uniform = null
	var/obj/item/belt = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/name_override //For temporary visible name changes

	var/datum/physiology/physiology

	/// What types of mobs are allowed to ride/buckle to this mob
	var/static/list/can_ride_typecache = typecacheof(list(
		/mob/living/basic/parrot,
		/mob/living/carbon/human,
		/mob/living/basic/slime,
	))
	var/lastpuke = 0
	var/account_id

	var/hardcore_survival_score = 0

	/// How many "units of blood" we have on our hands
	var/blood_in_hands = 0

	/// When an braindead player has their equipment fiddled with, we log that info here for when they come back so they know who took their ID while they were DC'd for 30 seconds
	var/list/afk_thefts

	/// Base height of the mob, modified by stuff like dwarfism or species
	VAR_PRIVATE/base_mob_height = HUMAN_HEIGHT_MEDIUM
	/// Actual height of the mob. Don't touch this one, it is set via update_mob_height()
	VAR_FINAL/mob_height = HUMAN_HEIGHT_MEDIUM

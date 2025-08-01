/// The random offset applied to square coordinates, causes intermingling at biome borders
#define BIOME_RANDOM_SQUARE_DRIFT 2

/datum/map_generator/cave_generator
	var/name = "Cave Generator"
	///Weighted list of the types that spawns if the turf is open
	var/weighted_open_turf_types = list(/turf/open/misc/asteroid/airless = 1)
	///Expanded list of the types that spawns if the turf is open
	var/open_turf_types
	///Weighted list of the types that spawns if the turf is closed
	var/weighted_closed_turf_types = list(/turf/closed/mineral/random = 1)
	///Expanded list of the types that spawns if the turf is closed
	var/closed_turf_types


	///Weighted list of mobs that can spawn in the area.
	var/list/weighted_mob_spawn_list
	///Expanded list of mobs that can spawn in the area. Reads from the weighted list
	var/list/mob_spawn_list
	///The mob spawn list but with no megafauna markers. autogenerated
	var/list/mob_spawn_no_mega_list
	// Weighted list of Megafauna that can spawn in the area
	var/list/weighted_megafauna_spawn_list
	///Expanded list of Megafauna that can spawn in the area. Reads from the weighted list
	var/list/megafauna_spawn_list
	///Weighted list of flora that can spawn in the area.
	var/list/weighted_flora_spawn_list
	///Expanded list of flora that can spawn in the area. Reads from the weighted list
	var/list/flora_spawn_list
	///Weighted list of extra features that can spawn in the area, such as geysers.
	var/list/weighted_feature_spawn_list
	///Expanded list of extra features that can spawn in the area. Reads from the weighted list
	var/list/feature_spawn_list
	/// The turf types to replace with a biome-related turf, as typecache.
	/// Leave empty for all open turfs (but not closed turfs) to be hijacked.
	var/list/biome_accepted_turfs = list()
	/// An associative list of biome type to the list of turfs that were
	/// generated of that biome specifically. Helps to improve the efficiency
	/// of biome-related operations. Is populated through
	/// `generate_terrain_with_biomes()`.
	var/list/generated_turfs_per_biome = list()
	/// 2D list of all biomes based on heat and humidity combos. Associative by
	/// `BIOME_X_HEAT` and then by `BIOME_X_HUMIDITY` (i.e.
	/// `possible_biomes[BIOME_LOW_HEAT][BIOME_LOWMEDIUM_HUMIDITY]`).
	/// Check /datum/map_generator/cave_generator/jungle for an example
	/// of how to set it up properly.
	var/list/possible_biomes = list()
	/// Used to select "zoom" level into the perlin noise, higher numbers
	/// result in slower transitions
	var/perlin_zoom = 65

	///Base chance of spawning a mob
	var/mob_spawn_chance = 6
	///Base chance of spawning flora
	var/flora_spawn_chance = 2
	///Base chance of spawning features
	var/feature_spawn_chance = 0.25
	///Unique ID for this spawner
	var/string_gen

	///Chance of cells starting closed
	var/initial_closed_chance = 45
	///Amount of smoothing iterations
	var/smoothing_iterations = 20
	///How much neighbours does a dead cell need to become alive
	var/birth_limit = 4
	///How little neighbours does a alive cell need to die
	var/death_limit = 3


/datum/map_generator/cave_generator/New()
	. = ..()
	if(!weighted_mob_spawn_list)
		weighted_mob_spawn_list = list(
			/mob/living/basic/mining/basilisk = 4,
			/mob/living/basic/mining/goldgrub = 1,
			/mob/living/basic/mining/goliath/ancient = 5,
			/mob/living/basic/mining/hivelord = 3,
		)
	mob_spawn_list = expand_weights(weighted_mob_spawn_list)
	mob_spawn_no_mega_list = expand_weights(weighted_mob_spawn_list - SPAWN_MEGAFAUNA)
	if(!weighted_megafauna_spawn_list)
		weighted_megafauna_spawn_list = GLOB.megafauna_spawn_list
	megafauna_spawn_list = expand_weights(weighted_megafauna_spawn_list)
	if(!weighted_flora_spawn_list)
		weighted_flora_spawn_list = list(
			/obj/structure/flora/ash/leaf_shroom = 2,
			/obj/structure/flora/ash/cap_shroom = 2,
			/obj/structure/flora/ash/stem_shroom = 2,
			/obj/structure/flora/ash/cacti = 1,
			/obj/structure/flora/ash/tall_shroom = 2,
			/obj/structure/flora/ash/seraka = 2,
		)
	flora_spawn_list = expand_weights(weighted_flora_spawn_list)
	if(!weighted_feature_spawn_list)
		weighted_feature_spawn_list = list(
			/obj/structure/geyser/random = 1,
			/obj/structure/ore_vent/random = 1,
		)
	feature_spawn_list = expand_weights(weighted_feature_spawn_list)
	open_turf_types = expand_weights(weighted_open_turf_types)
	closed_turf_types = expand_weights(weighted_closed_turf_types)


/datum/map_generator/cave_generator/generate_terrain(list/turfs, area/generate_in)
	. = ..()
	if(!(generate_in.area_flags & CAVES_ALLOWED))
		return

	if(length(possible_biomes))
		return generate_terrain_with_biomes(turfs, generate_in)

	var/start_time = REALTIMEOFDAY
	SStitle.add_init_text("[type]gen", "> [name]: Generation", "<font color='yellow'>LOADING</font>")
	string_gen = rustg_cnoise_generate("[initial_closed_chance]", "[smoothing_iterations]", "[birth_limit]", "[death_limit]", "[world.maxx]", "[world.maxy]") //Generate the raw CA data

	for(var/turf/gen_turf as anything in turfs) //Go through all the turfs and generate them

		var/closed = string_gen[world.maxx * (gen_turf.y - 1) + gen_turf.x] != "0"
		var/turf/new_turf = pick(closed ? closed_turf_types : open_turf_types)

		// The assumption is this will be faster then changeturf, and changeturf isn't required since by this point
		// The old tile hasn't got the chance to init yet
		new_turf = new new_turf(gen_turf)

		if(gen_turf.turf_flags & NO_RUINS)
			new_turf.turf_flags |= NO_RUINS

	SStitle.add_init_text("[type]gen", "> [name]: Generation", "<font color='green'>DONE</font>", (REALTIMEOFDAY - start_time) / (1 SECONDS))
	log_world("[name] terrain generation finished in [(REALTIMEOFDAY - start_time)/10]s!")


/**
 * This proc handles including biomes in the cave generation. This is slower than
 * `generate_terrain()`, so please use it only if you actually need biomes.
 *
 * This should only be called by `generate_terrain()`, if you have to call this,
 * you're probably doing something wrong.
 */
/datum/map_generator/cave_generator/proc/generate_terrain_with_biomes(list/turfs, area/generate_in)
	if(!(generate_in.area_flags & CAVES_ALLOWED))
		return

	var/humidity_seed = rand(0, 50000)
	var/heat_seed = rand(0, 50000)

	var/start_time = REALTIMEOFDAY
	string_gen = rustg_cnoise_generate("[initial_closed_chance]", "[smoothing_iterations]", "[birth_limit]", "[death_limit]", "[world.maxx]", "[world.maxy]") //Generate the raw CA data

	var/humidity_gen = list()
	humidity_gen[BIOME_HIGH_HUMIDITY] = rustg_dbp_generate("[humidity_seed]", "60", "75", "[world.maxx]", "-0.1", "1.1")
	humidity_gen[BIOME_MEDIUM_HUMIDITY] = rustg_dbp_generate("[humidity_seed]", "60", "75", "[world.maxx]", "-0.3", "-0.1")

	var/heat_gen = list()
	heat_gen[BIOME_HIGH_HEAT] = rustg_dbp_generate("[heat_seed]", "60", "75", "[world.maxx]", "-0.1", "1.1")
	heat_gen[BIOME_MEDIUM_HEAT] = rustg_dbp_generate("[heat_seed]", "60", "75", "[world.maxx]", "-0.3", "-0.1")

	var/list/expanded_closed_turfs = src.closed_turf_types
	var/list/expanded_open_turfs = src.open_turf_types

	for(var/turf/gen_turf as anything in turfs) //Go through all the turfs and generate them
		var/closed = string_gen[world.maxx * (gen_turf.y - 1) + gen_turf.x] != "0"
		var/new_turf_type = pick(closed ? expanded_closed_turfs : expanded_open_turfs)

		var/datum/biome/selected_biome

		// Here comes the meat of the biome code.
		var/drift_x = clamp(((gen_turf.x + rand(-BIOME_RANDOM_SQUARE_DRIFT, BIOME_RANDOM_SQUARE_DRIFT)) / perlin_zoom), 1, world.maxx)
		var/drift_y = clamp(((gen_turf.y + rand(-BIOME_RANDOM_SQUARE_DRIFT, BIOME_RANDOM_SQUARE_DRIFT)) / perlin_zoom), 2, world.maxy)

		// Where we go in the generated string (generated outside of the loop for s p e e d)
		var/coordinate = world.maxx * (drift_y - 1) + drift_x

		// Type of humidity zone we're in (LOW-MEDIUM-HIGH)
		var/humidity_level = text2num(humidity_gen[BIOME_HIGH_HUMIDITY][coordinate]) ? \
			BIOME_HIGH_HUMIDITY : text2num(humidity_gen[BIOME_MEDIUM_HUMIDITY][coordinate]) ? BIOME_MEDIUM_HUMIDITY : BIOME_LOW_HUMIDITY
		// Type of heat zone we're in (LOW-MEDIUM-HIGH)
		var/heat_level = text2num(heat_gen[BIOME_HIGH_HEAT][coordinate]) ? \
			BIOME_HIGH_HEAT : text2num(heat_gen[BIOME_MEDIUM_HEAT][coordinate]) ? BIOME_MEDIUM_HEAT : BIOME_LOW_HEAT

		selected_biome = possible_biomes[heat_level][humidity_level]

		// Currently, we only affect open turfs, because biomes don't currently
		// have a definition for biome-specific closed turfs.
		if((!length(biome_accepted_turfs) && !closed) || biome_accepted_turfs[new_turf_type])
			LAZYADD(generated_turfs_per_biome[selected_biome], gen_turf)

		else
			// The assumption is this will be faster then changeturf, and changeturf isn't required since by this point
			// The old tile hasn't got the chance to init yet
			var/turf/new_turf = new new_turf_type(gen_turf)

			if(gen_turf.turf_flags & NO_RUINS)
				new_turf.turf_flags |= NO_RUINS

		CHECK_TICK

	for(var/biome in generated_turfs_per_biome)
		var/datum/biome/generating_biome = SSmapping.biomes[biome]

		var/list/turf/generated_turfs = generating_biome.generate_turfs_for_terrain(generated_turfs_per_biome[biome])

		generated_turfs_per_biome[biome] = generated_turfs

	var/message = "[name] terrain generation finished in [(REALTIMEOFDAY - start_time)/10]s!"
	to_chat(world, span_boldannounce("[message]"))
	log_world(message)


/datum/map_generator/cave_generator/populate_terrain(list/turfs, area/generate_in)
	if(length(possible_biomes))
		return populate_terrain_with_biomes(turfs, generate_in)

	// Area var pullouts to make accessing in the loop faster
	var/flora_allowed = (generate_in.area_flags & FLORA_ALLOWED) && length(flora_spawn_list)
	var/feature_allowed = (generate_in.area_flags & FLORA_ALLOWED) && length(feature_spawn_list)
	var/mobs_allowed = (generate_in.area_flags & MOB_SPAWN_ALLOWED) && length(mob_spawn_list)
	var/megas_allowed = (generate_in.area_flags & MEGAFAUNA_SPAWN_ALLOWED) && length(megafauna_spawn_list)

	SStitle.add_init_text("[type]fill", "> [name]: Population", "<font color='yellow'>LOADING</font>")
	var/start_time = REALTIMEOFDAY
	SSore_generation.ore_vent_minerals = (SSore_generation.ore_vent_minerals_default).Copy()

	for(var/turf/target_turf as anything in turfs)
		if(!(target_turf.type in open_turf_types)) //only put stuff on open turfs we generated, so closed walls and rivers and stuff are skipped
			continue

		// If we've spawned something yet
		var/spawned_something = FALSE

		if(!(target_turf.turf_flags & TURF_BLOCKS_POPULATE_TERRAIN_FLORAFEATURES))
			///Spawning isn't done in procs to save on overhead on the 60k turfs we're going through.
			//FLORA SPAWNING HERE
			if(flora_allowed && prob(flora_spawn_chance))
				var/flora_type = pick(flora_spawn_list)
				new flora_type(target_turf)
				spawned_something = TRUE

			//FEATURE SPAWNING HERE
			//we may have generated something from the flora list on the target turf, so let's not place
			//a feature here if that's the case (because it would look stupid)
			if(feature_allowed && !spawned_something && prob(feature_spawn_chance))
				var/can_spawn = TRUE

				var/atom/picked_feature = pick(feature_spawn_list)

				for(var/obj/structure/existing_feature in range(7, target_turf))
					if(istype(existing_feature, picked_feature))
						can_spawn = FALSE
						break

				if(can_spawn)
					new picked_feature(target_turf)
					spawned_something = TRUE

		//MOB SPAWNING HERE
		if(mobs_allowed && !spawned_something && prob(mob_spawn_chance))
			var/atom/picked_mob = pick(mob_spawn_list)
			var/is_megafauna = FALSE

			if(picked_mob == SPAWN_MEGAFAUNA)
				if(megas_allowed) //this is danger. it's boss time.
					picked_mob = pick(megafauna_spawn_list)
					is_megafauna = TRUE
				else //this is not danger, don't spawn a boss, spawn something else
					picked_mob = pick(mob_spawn_no_mega_list) //What if we used 100% of the brain...and did something (slightly) less shit than a while loop?

			var/can_spawn = TRUE

			// prevents tendrils spawning in each other's collapse range
			if(ispath(picked_mob, /obj/structure/spawner/lavaland))
				for(var/obj/structure/spawner/lavaland/spawn_blocker in range(2, target_turf))
					can_spawn = FALSE
					break
			// if the random is not a tendril (hopefully meaning it is a mob), avoid spawning if there's another one within 12 tiles
			else
				var/list/things_in_range = range(12, target_turf)
				for(var/mob/living/mob_blocker in things_in_range)
					if(ismining(mob_blocker))
						can_spawn = FALSE
						break
				// Also block spawns if there's a random lavaland mob spawner nearby and it's not a mega
				if(!is_megafauna)
					can_spawn = can_spawn && !(locate(/obj/effect/spawner/random/lavaland_mob) in things_in_range)
			//if there's a megafauna within standard view don't spawn anything at all (This isn't really consistent, I don't know why we do this. you do you tho)
			if(can_spawn)
				for(var/mob/living/simple_animal/hostile/megafauna/found_fauna in range(7, target_turf))
					can_spawn = FALSE
					break

			if(can_spawn)
				if(ispath(picked_mob, /mob/living/simple_animal/hostile/megafauna/bubblegum)) //there can be only one bubblegum, so don't waste spawns on it
					weighted_megafauna_spawn_list.Remove(picked_mob)
					megafauna_spawn_list = expand_weights(weighted_megafauna_spawn_list)
					megas_allowed = megas_allowed && length(megafauna_spawn_list)
				new picked_mob(target_turf)
				spawned_something = TRUE
		CHECK_TICK

	SStitle.add_init_text("[type]fill", "> [name]: Population", "<font color='green'>DONE</font>", (REALTIMEOFDAY - start_time) / (1 SECONDS))
	log_world("[name] terrain population finished in [(REALTIMEOFDAY - start_time)/10]s!")


/**
 * This handles the population of terrain with biomes. Should only be called by
 * `populate_terrain()`, if you find yourself calling this, you're probably not
 * doing it right.
 *
 * This proc won't do anything if the area we're trying to generate in does not
 * have `FLORA_ALLOWED` or `MOB_SPAWN_ALLOWED` in its `area_flags`.
 */
/datum/map_generator/cave_generator/proc/populate_terrain_with_biomes(list/turfs, area/generate_in)
	// Area var pullouts to make accessing in the loop faster
	var/flora_allowed = (generate_in.area_flags & FLORA_ALLOWED)
	var/features_allowed = (generate_in.area_flags & FLORA_ALLOWED)
	var/fauna_allowed = (generate_in.area_flags & MOB_SPAWN_ALLOWED)

	var/start_time = REALTIMEOFDAY

	// No sense in doing anything here if nothing is allowed anyway.
	if(!flora_allowed && !features_allowed && !fauna_allowed)
		var/message = "[name] terrain population finished in [(REALTIMEOFDAY - start_time)/10]s!"
		to_chat(world, span_boldannounce("[message]"))
		log_world(message)
		return

	for(var/biome in generated_turfs_per_biome)
		var/datum/biome/generating_biome = SSmapping.biomes[biome]
		generating_biome.populate_turfs(generated_turfs_per_biome[biome], flora_allowed, features_allowed, fauna_allowed)

		CHECK_TICK

	var/message = "[name] terrain population finished in [(REALTIMEOFDAY - start_time)/10]s!"
	to_chat(world, span_boldannounce("[message]"))
	log_world(message)


/datum/map_generator/cave_generator/jungle
	possible_biomes = list(
		BIOME_LOW_HEAT = list(
			BIOME_LOW_HUMIDITY = /datum/biome/plains,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/mudlands,
			BIOME_HIGH_HUMIDITY = /datum/biome/water
		),
		BIOME_MEDIUM_HEAT = list(
			BIOME_LOW_HUMIDITY = /datum/biome/plains,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/jungle/deep,
			BIOME_HIGH_HUMIDITY = /datum/biome/jungle
		),
		BIOME_HIGH_HEAT = list(
			BIOME_LOW_HUMIDITY = /datum/biome/wasteland,
			BIOME_MEDIUM_HUMIDITY = /datum/biome/plains,
			BIOME_HIGH_HUMIDITY = /datum/biome/jungle/deep
		)
	)


#undef BIOME_RANDOM_SQUARE_DRIFT

/// Index for all cables, so that powernets don't have to look through the entire world all the time
GLOBAL_LIST_EMPTY(cable_list)
/// list of all /obj/effect/portal
GLOBAL_LIST_EMPTY(portals)
/// list of all airlocks
GLOBAL_LIST_EMPTY(airlocks)
/// list of all curtains
GLOBAL_LIST_EMPTY(curtains)
/// list of all mechs. Used by hostile mobs target tracking.
GLOBAL_LIST_EMPTY(mechas_list)
/// list of all communication consoles and AIs, for automatic shuttle calls when there are none.
GLOBAL_LIST_EMPTY(shuttle_caller_list)
/// list of ALL machines
GLOBAL_LIST_EMPTY(machines)
/// list of all /obj/machinery/computer/camera_advanced/shuttle_docker
GLOBAL_LIST_EMPTY(navigation_computers)
/// important to keep track of for managing nukeops war declarations.
GLOBAL_LIST_EMPTY(syndicate_shuttle_boards)
/// list of all bot nagivation beacons, used for patrolling.
GLOBAL_LIST_EMPTY(navbeacons)
/// list of all tracking beacons used by teleporters
GLOBAL_LIST_EMPTY(teleportbeacons)
/// list of all MULEbot delivery beacons.
GLOBAL_LIST_EMPTY(deliverybeacons)
/// list of all tags associated with delivery beacons.
GLOBAL_LIST_EMPTY(deliverybeacontags)
GLOBAL_LIST_EMPTY(nuke_list)
GLOBAL_LIST_EMPTY(nuke_disk_list) //monkestation addition
/// list of all machines or programs that can display station alerts
GLOBAL_LIST_EMPTY(alarmdisplay)
/// list of all singularities on the station
GLOBAL_LIST_EMPTY_TYPED(singularities, /datum/component/singularity)
/// list of all /obj/machinery/mechpad
GLOBAL_LIST_EMPTY(mechpad_list)
/// list of all crewside CentCom headsets on station
GLOBAL_LIST_EMPTY(crew_cc_keys)

/// list of all /datum/chemical_reaction datums indexed by their typepath. Use this for general lookup stuff
GLOBAL_LIST(chemical_reactions_list)
/// list of all /datum/chemical_reaction datums. Used during chemical reactions. Indexed by REACTANT types
GLOBAL_LIST(chemical_reactions_list_reactant_index)
/// list of all /datum/chemical_reaction datums. Used for the reaction lookup UI. Indexed by PRODUCT type
GLOBAL_LIST(chemical_reactions_list_product_index) /// list of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
GLOBAL_LIST_INIT(chemical_reagents_list, init_chemical_reagent_list())
/// names of reagents used by plumbing UI.
GLOBAL_LIST_INIT(chemical_name_list, init_chemical_name_list())
GLOBAL_LIST(chemical_reactions_results_lookup_list) //List of all reactions with their associated product and result ids. Used for reaction lookups
GLOBAL_LIST(fake_reagent_blacklist) //List of all reagents that are parent types used to define a bunch of children - but aren't used themselves as anything.
GLOBAL_LIST_EMPTY(tech_list) //list of all /datum/tech datums indexed by id.
GLOBAL_LIST_INIT(surgeries_list, init_surgeries()) //list of all surgeries by name, associated with their path.

/// Global list of all non-cooking related crafting recipes.
GLOBAL_LIST_EMPTY(crafting_recipes)
/// This is a global list of typepaths, these typepaths are atoms or reagents that are associated with crafting recipes.
/// This includes stuff like recipe components and results.
GLOBAL_LIST_EMPTY(crafting_recipes_atoms)
/// Global list of all cooking related crafting recipes.
GLOBAL_LIST_EMPTY(cooking_recipes)
/// This is a global list of typepaths, these typepaths are atoms or reagents that are associated with cooking recipes.
/// This includes stuff like recipe components and results.
GLOBAL_LIST_EMPTY(cooking_recipes_atoms)
/// list of Rapid Construction Devices.
GLOBAL_LIST_EMPTY(rcd_list)
/// list of wallmounted intercom radios.
GLOBAL_LIST_EMPTY(intercoms_list)
/// list of all Area Power Controller machines, separate from machines for powernet speeeeeeed.
GLOBAL_LIST_EMPTY(apcs_list)
/// list of all current implants that are tracked to work out what sort of trek everyone is on. Sadly not on lavaworld not implemented...
GLOBAL_LIST_EMPTY(tracked_implants)
/// list of implants the prisoner console can track and send inject commands too
GLOBAL_LIST_EMPTY(tracked_chem_implants)
/// list of all pinpointers. Used to change stuff they are pointing to all at once.
GLOBAL_LIST_EMPTY(pinpointer_list)
/// A list of all zombie_infection organs, for any mass "animation"
GLOBAL_LIST_EMPTY(zombie_infection_list)
/// List of all meteors.
GLOBAL_LIST_EMPTY(meteor_list)
/// List of active radio jammers
GLOBAL_LIST_EMPTY(active_jammers)
GLOBAL_LIST_EMPTY(ladders)
GLOBAL_LIST_EMPTY(stairs)
GLOBAL_LIST_EMPTY(janitor_devices)
GLOBAL_LIST_EMPTY(trophy_cases)
GLOBAL_LIST_EMPTY(experiment_handlers)
///This is a global list of all signs you can change an existing sign or new sign backing to, when using a pen on them.
GLOBAL_LIST_INIT(editable_sign_types, populate_editable_sign_types())

GLOBAL_LIST_EMPTY(wire_color_directory)
GLOBAL_LIST_EMPTY(wire_name_directory)

GLOBAL_LIST_EMPTY(ai_status_displays)

/// List of all instances of /obj/effect/mob_spawn/ghost_role in the game world
GLOBAL_LIST_EMPTY(mob_spawners)
/// List of all mobs with the "ghost_direct_control" component
GLOBAL_LIST_EMPTY(joinable_mobs)
/// List of all station alert consoles, /obj/machinery/computer/station_alert
GLOBAL_LIST_EMPTY(alert_consoles)

/// List of area names of roundstart station cyborg rechargers, for the low charge/no charge cyborg screen alert tooltips.
GLOBAL_LIST_EMPTY(roundstart_station_borgcharger_areas)
/// List of area names of roundstart station mech rechargers, for the low charge/no charge mech screen alert tooltips.
GLOBAL_LIST_EMPTY(roundstart_station_mechcharger_areas)

/// Associative list of alcoholic container typepath to instances, currently used by the alcoholic quirk
GLOBAL_LIST_INIT(alcohol_containers, init_alcohol_containers())

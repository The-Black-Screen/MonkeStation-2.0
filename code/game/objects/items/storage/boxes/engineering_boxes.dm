// This file contains all boxes used by the Engineering department and its purpose on the station. Also contains stuff we use when we wanna fix up stuff as well or helping us live when shit goes southwardly.

/obj/item/storage/box/metalfoam
	name = "box of metal foam grenades"
	desc = "To be used to rapidly seal hull breaches."
	illustration = "grenade"

/obj/item/storage/box/metalfoam/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/grenade/chem_grenade/metalfoam(src)

/obj/item/storage/box/smart_metal_foam
	name = "box of smart metal foam grenades"
	desc = "Used to rapidly seal hull breaches. This variety conforms to the walls of its area."
	illustration = "grenade"

/obj/item/storage/box/smart_metal_foam/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/chem_grenade/smart_metal_foam(src)

//MONKESTATION EDIT START
/obj/item/storage/box/nanofrost
	name = "box of nanofrost grenades"
	desc = "A box of A NanoFrost™ smoke grenades. Nanotrasen's response to frequent plasma related fires onboard their research stations."
	illustration = "grenade"

/obj/item/storage/box/nanofrost/PopulateContents()
	for(var/i in 1 to 7)
		new/obj/item/grenade/smokebomb/nanofrost(src)
//MONKESTATION EDIT STOP

/obj/item/storage/box/material
	name = "box of materials"
	illustration = "implant"

/obj/item/storage/box/material/PopulateContents() //less uranium because radioactive
	// amount should be null if it should spawn with the type's default amount
	var/static/items_inside = list(
		/obj/item/stack/sheet/iron/fifty = null,
		/obj/item/stack/sheet/glass/fifty = null,
		/obj/item/stack/sheet/rglass = 50,
		/obj/item/stack/sheet/plasmaglass = 50,
		/obj/item/stack/sheet/titaniumglass = 50,
		/obj/item/stack/sheet/plastitaniumglass = 50,
		/obj/item/stack/sheet/plasteel = 50,
		/obj/item/stack/sheet/mineral/plastitanium = 50,
		/obj/item/stack/sheet/mineral/titanium = 50,
		/obj/item/stack/sheet/mineral/gold = 50,
		/obj/item/stack/sheet/mineral/silver = 50,
		/obj/item/stack/sheet/mineral/plasma = 50,
		/obj/item/stack/sheet/mineral/uranium = 20,
		/obj/item/stack/sheet/mineral/diamond = 50,
		/obj/item/stack/sheet/bluespace_crystal = 50,
		/obj/item/stack/sheet/mineral/bananium = 50,
		/obj/item/stack/sheet/mineral/wood = 50,
		/obj/item/stack/sheet/plastic/fifty = null,
		/obj/item/stack/sheet/runed_metal/fifty = null,
	)
	for(var/obj/item/stack/stack_type as anything in items_inside)
		var/amt = items_inside[stack_type]
		new stack_type(src, amt, FALSE)

/obj/item/storage/box/debugtools
	name = "box of debug tools"
	icon_state = "syndiebox"

/obj/item/storage/box/debugtools/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_GIGANTIC

/obj/item/storage/box/debugtools/PopulateContents()
	var/static/items_inside = list(
		/obj/item/card/emag=1,
		/obj/item/construction/rcd/combat/admin=1,
		/obj/item/disk/tech_disk/debug=1,
		/obj/item/flashlight/emp/debug=1,
		/obj/item/geiger_counter=1,
		/obj/item/healthanalyzer/advanced=1,
		/obj/item/card/id/advanced/debug=1,
		/obj/item/pipe_dispenser=1,
		/obj/item/stack/spacecash/c1000=50,
		/obj/item/storage/box/beakers/bluespace=1,
		/obj/item/storage/box/beakers/variety=1,
		/obj/item/storage/box/material=1,
		/obj/item/uplink/debug=1,
		/obj/item/uplink/nuclear/debug=1,
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/box/plastic
	name = "plastic box"
	desc = "It's a solid, plastic shell box."
	icon_state = "plasticbox"
	foldable_result = null
	illustration = "writing"
	custom_materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT) //You lose most if recycled.

/obj/item/storage/box/emergencytank
	name = "emergency oxygen tank box"
	desc = "A box of emergency oxygen tanks."
	illustration = "emergencytank"

/obj/item/storage/box/emergencytank/PopulateContents()
	..()
	for(var/i in 1 to 7)
		new /obj/item/tank/internals/emergency_oxygen(src) //in case anyone ever wants to do anything with spawning them, apart from crafting the box

/obj/item/storage/box/engitank
	name = "extended-capacity emergency oxygen tank box"
	desc = "A box of extended-capacity emergency oxygen tanks."
	illustration = "extendedtank"

/obj/item/storage/box/engitank/PopulateContents()
	..()
	for(var/i in 1 to 7)
		new /obj/item/tank/internals/emergency_oxygen/engi(src) //in case anyone ever wants to do anything with spawning them, apart from crafting the box

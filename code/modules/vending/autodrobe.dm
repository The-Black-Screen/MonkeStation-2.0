/obj/machinery/vending/autodrobe
	name = "\improper AutoDrobe"
	desc = "A vending machine for costumes."
	icon_state = "theater"
	icon_deny = "theater-deny"
	panel_type = "panel16"
	req_access = list(ACCESS_THEATRE)
	product_slogans = "Dress for success!;Suited and booted!;It's show time!;Why leave style up to fate? Use AutoDrobe!"
	vend_reply = "Thank you for using AutoDrobe!"
	product_categories = list(
		list(
			"name" = "Costumes",
			"icon" = "mask",
			"products" = list(
				/obj/item/clothing/under/costume/gladiator = 1,
				/obj/item/clothing/head/helmet/gladiator = 1,
				/obj/item/clothing/head/viking/fake_helmet = 1, //monkestation edit
				/obj/item/clothing/under/viking/fake_tunic = 1, //monkestation edit
				/obj/item/clothing/suit/toggle/labcoat/mad = 1,
				/obj/item/clothing/suit/bio_suit/plaguedoctorsuit = 1,
				/obj/item/clothing/head/bio_hood/plague = 1,
				/obj/item/clothing/mask/gas/plaguedoctor = 1,
				/obj/item/clothing/suit/toggle/owlwings = 1,
				/obj/item/clothing/under/costume/owl = 1,
				/obj/item/clothing/mask/gas/owl_mask = 1,
				/obj/item/clothing/suit/toggle/owlwings/griffinwings = 1,
				/obj/item/clothing/under/costume/griffin = 1,
				/obj/item/clothing/shoes/griffin = 1,
				/obj/item/clothing/head/costume/griffin = 1,
				/obj/item/clothing/under/costume/pirate = 1,
				/obj/item/clothing/suit/costume/pirate = 1,
				/obj/item/clothing/head/costume/pirate = 1,
				/obj/item/clothing/head/costume/pirate/bandana = 1,
				/obj/item/clothing/head/costume/pirate/bandana = 1,
				/obj/item/clothing/under/costume/soviet = 1,
				/obj/item/clothing/head/costume/ushanka = 1,
				/obj/item/clothing/accessory/vest_sheriff =1,
				/obj/item/clothing/head/cowboy/brown =1,
				/obj/item/clothing/head/cowboy/red =1,
				/obj/item/clothing/head/cowboy/black =1,
				/obj/item/clothing/head/costume/sombrero/green = 1,
				/obj/item/clothing/suit/costume/poncho = 1,
				/obj/item/clothing/suit/costume/poncho/green = 1,
				/obj/item/clothing/suit/costume/poncho/red = 1,
				/obj/item/clothing/suit/costume/snowman = 1,
				/obj/item/clothing/head/costume/snowman = 1,
				/obj/item/clothing/under/costume/referee = 1,
				/obj/item/clothing/mask/whistle = 1,
				/obj/item/storage/backpack/henchmen = 5,
				/obj/item/clothing/under/suit/henchmen = 5,
				/obj/item/clothing/head/costume/jackbros = 5,
				/obj/item/clothing/under/costume/jackbros = 5,
				/obj/item/clothing/under/costume/deckers = 5,
				/obj/item/clothing/under/costume/sailor = 1,
				/obj/item/clothing/head/costume/delinquent = 1,
				/obj/item/clothing/suit/costume/dracula = 1,
				/obj/item/clothing/under/costume/draculass = 1,
				/obj/item/clothing/suit/costume/gothcoat = 1,
				/obj/item/clothing/glasses/eyepatch = 1,
				/obj/item/clothing/glasses/eyepatch/medical = 1,
				/obj/item/clothing/under/costume/gi = 1,
				/obj/item/clothing/head/soft/propeller_hat = 1,
				/obj/item/clothing/neck/bowtie/rainbow = 1,
				//Monkestation Addition start
				/obj/item/clothing/neck/worldchampioncape = 1,
				/obj/item/clothing/under/costume/worldchampiongi = 1,
				/obj/item/clothing/head/milkmanhat = 2,
				/obj/item/clothing/under/costume/milkman = 2,
				/obj/item/clothing/shoes/bb_slippers = 1,
				/obj/item/clothing/head/bb_wig = 1,
		        /obj/item/clothing/under/costume/bb_dress = 1,
				/obj/item/clothing/head/wizard/ralsei = 1,
				/obj/item/clothing/suit/wizrobe/ralsei = 1,
				/obj/item/clothing/neck/ralsei = 1, 
				/obj/item/clothing/glasses/ralsei = 1,
				/obj/item/clothing/under/costume/susie = 1,
				/obj/item/clothing/under/costume/kris = 1,
				/obj/item/clothing/neck/kris = 1, 
				/obj/item/clothing/shoes/kris = 1,
				/obj/item/clothing/gloves/kris = 1,
				//Monkestation Addition end
			),
		),
		list(
			"name" = "Supernatural",
			"icon" = "hand-sparkles",
			"products" = list(
				/obj/item/clothing/suit/costume/imperium_monk = 1,
				/obj/item/clothing/suit/chaplainsuit/holidaypriest = 1,
				/obj/item/clothing/suit/chaplainsuit/whiterobe = 1,
				/obj/item/clothing/head/wizard/marisa/fake = 1,
				/obj/item/clothing/suit/wizrobe/marisa/fake = 1,
				/obj/item/clothing/head/costume/witchwig = 1,
				/obj/item/staff/broom = 1,
				/obj/item/clothing/suit/wizrobe/fake = 1,
				/obj/item/clothing/head/wizard/fake = 1,
				/obj/item/staff = 3,
				/obj/item/clothing/head/costume/shrine_wig = 1,
				/obj/item/clothing/suit/costume/shrine_maiden = 1,
				/obj/item/gohei = 1,
				/obj/item/clothing/under/costume/skeleton = 1,
				//Monkestation Addition start
				/obj/item/clothing/shoes/costume_2021/infinity_shoes = 5,
				/obj/item/clothing/under/costume/infinity_under = 5,
				/obj/item/clothing/suit/infinity_jacket = 5,
				/obj/item/clothing/gloves/infinity_gloves = 5,
				/obj/item/clothing/suit/thekiller_robe = 1,
				/obj/item/clothing/head/thekiller_head = 1,
				//Monkestation Addition end
			),
		),
		list(
			"name" = "Entertainers",
			"icon" = "masks-theater",
			"products" = list(
				/obj/item/clothing/under/rank/civilian/clown/blue = 1,
				/obj/item/clothing/under/rank/civilian/clown/green = 1,
				/obj/item/clothing/under/rank/civilian/clown/yellow = 1,
				/obj/item/clothing/under/rank/civilian/clown/orange = 1,
				/obj/item/clothing/under/rank/civilian/clown/purple = 1,
				/obj/item/clothing/mask/gas/sexyclown = 1,
				/obj/item/clothing/under/rank/civilian/clown/sexy = 1,
				/obj/item/clothing/head/beret = 6,
				/obj/item/clothing/mask/gas/sexymime = 1,
				/obj/item/clothing/under/rank/civilian/mime/sexy = 1,
				/obj/item/clothing/under/rank/civilian/mime/skirt = 1,
				/obj/item/clothing/head/costume/jester = 1,
				/obj/item/clothing/under/rank/civilian/clown/jester = 1, // MONKESTATION EDIT ADDITION
				/obj/item/clothing/shoes/clown_shoes/green_jester_shoes =1, // MONKESTATION EDIT ADDITION
				/obj/item/clothing/head/costume/jester/alt =1, // MONKESTATION EDIT ADDITION
				/obj/item/clothing/under/rank/civilian/clown/jester/alt =1, // MONKESTATION EDIT ADDITION
				/obj/item/clothing/under/costume/villain = 1,
				/obj/item/clothing/suit/costume/joker = 1,
				/obj/item/clothing/under/costume/joker = 1,
				/obj/item/clothing/shoes/singery = 1,
				/obj/item/clothing/under/costume/singer/yellow = 1,
				/obj/item/clothing/shoes/singerb = 1,
				/obj/item/clothing/under/costume/singer/blue = 1,
				/obj/item/clothing/head/costume/cueball = 1,
				/obj/item/clothing/under/suit/white_on_white = 1,
				/obj/item/clothing/head/tragic = 2,
				/obj/item/clothing/head/harlequinhat =2,//MONKESTATION EDIT ADDITION
				/obj/item/clothing/under/costume/harlequin =2,//MONKESTATION EDIT ADDITION
				/obj/item/clothing/shoes/clown_shoes/harlequin_boots =2,//MONKESTATION EDIT ADDITION
				/obj/item/clothing/under/costume/tragic = 2,
				/obj/item/clothing/under/costume/streetmime = 1,
				/obj/item/clothing/mask/gas/clown_hat/yellow = 1,
				/obj/item/clothing/shoes/clown_shoes/yellow = 1,
				/obj/item/clothing/head/knowingclown = 2,
				/obj/item/clothing/under/knowingclown = 2,
			),
		),
		list(
			"name" = "Fancy",
			"icon" = "user-tie",
			"products" = list(
				/obj/item/clothing/under/rank/captain/suit = 1,
				/obj/item/clothing/under/rank/captain/suit/skirt = 1,
				/obj/item/clothing/under/costume/schoolgirl = 1,
				/obj/item/clothing/under/costume/schoolgirl/red = 1,
				/obj/item/clothing/under/costume/schoolgirl/green = 1,
				/obj/item/clothing/under/costume/schoolgirl/orange = 1,
				/obj/item/clothing/under/dress/skirt = 1,
				/obj/item/clothing/neck/tie = 3,
				/obj/item/clothing/head/hats/tophat = 1,
				/obj/item/clothing/head/wonka = 1,
				/obj/item/clothing/under/costume/kilt = 1,
				/obj/item/clothing/glasses/monocle =1,
				/obj/item/clothing/head/hats/bowler = 1,
				/obj/item/cane = 1,
				/obj/item/clothing/under/dress/sundress = 1,
				/obj/item/clothing/suit/costume/whitedress = 1,
				/obj/item/clothing/suit/costume/changshan_red = 1,
				/obj/item/clothing/suit/costume/changshan_blue = 1,
				/obj/item/clothing/suit/costume/cheongsam_red = 1,
				/obj/item/clothing/suit/costume/cheongsam_blue = 1,
				/obj/item/clothing/under/wonka = 1,
				/obj/item/clothing/shoes/heels = 4, // MONKESTATION EDIT ADDITION
			),
		),
		list(
			"name" = "Animals",
			"icon" = "paw",
			"products" = list(
				/obj/item/clothing/head/costume/kitty = 1,
				/obj/item/clothing/head/costume/rabbitears =1,
				/obj/item/clothing/suit/costume/chickensuit = 1,
				/obj/item/clothing/head/costume/chicken = 1,
				/obj/item/clothing/suit/hooded/carp_costume = 1,
				/obj/item/clothing/suit/hooded/ian_costume = 1,
				/obj/item/clothing/suit/hooded/bee_costume = 1,
				/obj/item/clothing/suit/hooded/dinojammies = 1,
				/obj/item/clothing/mask/animal/small/bat = 1,
				/obj/item/clothing/mask/animal/small/bee = 1,
				/obj/item/clothing/mask/animal/small/bear = 1,
				/obj/item/clothing/mask/animal/small/raven = 1,
				/obj/item/clothing/mask/animal/small/jackal = 1,
				/obj/item/clothing/mask/animal/small/fox = 1,
				/obj/item/clothing/mask/animal/frog = 1,
				/obj/item/clothing/mask/animal/small/rat = 1,
				/obj/item/clothing/mask/animal/pig = 1,
				/obj/item/clothing/mask/animal/cowmask = 1,
				/obj/item/clothing/mask/animal/horsehead = 1,
				/obj/item/clothing/head/lizard = 1,
				/obj/item/clothing/head/costume/bunnyhead/regular = 1,
				/obj/item/clothing/suit/costume/bunnysuit/regular = 1,
			),
		),
		list(
			"name" = "Service",
			"icon" = "kitchen-set",
			"products" = list(
				/obj/item/clothing/under/suit/black = 1,
				/obj/item/clothing/under/suit/sl = 1,
				/obj/item/clothing/accessory/waistcoat = 1,
				/obj/item/clothing/under/suit/waiter = 1,
				/obj/item/clothing/suit/apron = 1,
				/obj/item/clothing/suit/apron/overalls = 1,
				/obj/item/clothing/head/costume/maidheadband = 1,
				/obj/item/clothing/under/costume/maid = 1,
				/obj/item/clothing/gloves/maid = 1,
				/obj/item/clothing/neck/maid = 1,
				/obj/item/clothing/under/rank/civilian/janitor/maid = 1,
				/obj/item/clothing/accessory/maidapron = 1,
				/obj/item/clothing/under/costume/playbunny = 2, // MONKESTATION EDIT ADDITION
				/obj/item/clothing/neck/tie/bunnytie = 2, // MONKESTATION EDIT ADDITION
				/obj/item/clothing/head/playbunnyears = 2, // MONKESTATION EDIT ADDITION
				/obj/item/clothing/suit/jacket/tailcoat = 2, // MONKESTATION EDIT ADDITION
			),
		),
		list(
			"name" = "Other",
			"icon" = "star",
			"products" = list(
				/obj/item/clothing/head/wig/random = 3,
				/obj/item/clothing/head/flatcap = 1,
				/obj/item/clothing/suit/jacket/miljacket = 1,
				/obj/item/clothing/shoes/jackboots = 1,
				/obj/item/clothing/mask/fakemoustache = 1,
				/obj/item/clothing/glasses/cold=1,
				/obj/item/clothing/glasses/heat=1,
				/obj/item/clothing/mask/gas/cyborg = 1,
				/obj/item/clothing/mask/joy = 1,
				/obj/item/clothing/mask/gas/prop = 4,
				/obj/item/clothing/mask/gas/atmosprop = 3,
				/obj/item/clothing/mask/animal/small/tribal = 1,
				/obj/item/clothing/head/shipwreckedhelmet = 2,
				/obj/item/clothing/suit/shipwreckedsuit = 2,
				/obj/item/clothing/head/kingofbugshelmet = 2,
				/obj/item/clothing/suit/kingofbugssuit = 2,
				/obj/item/clothing/shoes/crueltysquad_shoes = 2, // MONKESTATION EDIT ADDITION
				/obj/item/clothing/under/costume/crueltysquad_under = 2, // MONKESTATION EDIT ADDITION
				/obj/item/clothing/glasses/crueltysquad_glasses = 2, // MONKESTATION EDIT ADDITION
				/obj/item/clothing/gloves/crueltysquad_gloves = 2, // MONKESTATION EDIT ADDITION
			),
		),
	)

	contraband = list(
		/obj/item/clothing/glasses/blindfold = 1,
		/obj/item/clothing/glasses/sunglasses/gar = 2,
		/obj/item/clothing/head/costume/powdered_wig = 1,
		/obj/item/clothing/head/costume/tv_head = 1,
		/obj/item/clothing/mask/muzzle = 2,
		/obj/item/clothing/shoes/clown_shoes/ducky_shoes = 1,
		/obj/item/clothing/shoes/clown_shoes/meown_shoes = 1,
		/obj/item/clothing/suit/costume/judgerobe = 1,
		/obj/item/clothing/head/costume/lobsterhat = 1,
		/obj/item/clothing/under/costume/lobster = 1,
		/obj/item/gun/magic/wand/nothing = 2,
		/obj/item/storage/box/tape_wizard = 1,
	)
	premium = list(
		/obj/item/clothing/suit/costume/pirate/captain = 2,
		/obj/item/clothing/head/costume/pirate/captain = 2,
		/obj/item/clothing/under/rank/civilian/clown/rainbow = 1,
		/obj/item/clothing/head/helmet/roman/fake = 1,
		/obj/item/clothing/head/helmet/roman/legionnaire/fake = 1,
		/obj/item/clothing/under/costume/roman = 1,
		/obj/item/clothing/shoes/roman = 1,
		/obj/item/shield/roman/fake = 1,
		/obj/item/clothing/suit/chaplainsuit/clownpriest = 1,
		/obj/item/clothing/head/chaplain/clownmitre = 1,
		/obj/item/skub = 1,
		/obj/item/clothing/suit/hooded/mysticrobe = 1,
		/obj/item/clothing/under/dress/wedding_dress = 1,
		/obj/item/clothing/under/suit/tuxedo = 1,
		/obj/item/clothing/head/costume/weddingveil = 1,
		/obj/item/clothing/under/dress/ballgown = 1, //MONKESTATION EDIT ADDITION
		/obj/item/clothing/under/dress/wlpinafore = 1, //MONKESTATION EDIT ADDITION
		/obj/item/clothing/under/dress/ribbondress = 1, //MONKESTATION EDIT ADDITION
		/obj/item/storage/belt/fannypack/cummerbund = 1,
		/obj/item/clothing/suit/costume/drfreeze_coat = 1,
		/obj/item/clothing/under/costume/drfreeze = 1,
		/obj/item/clothing/head/costume/drfreezehat = 1,
		/obj/item/clothing/head/costume/minicrown = 1, //MONKESTATION EDIT ADDITION
	)
	refill_canister = /obj/item/vending_refill/autodrobe
	default_price = PAYCHECK_CREW * 0.8 //Default of 40.
	extra_price = PAYCHECK_COMMAND
	payment_department = ACCOUNT_SRV
	light_mask="theater-light-mask"

/obj/machinery/vending/autodrobe/all_access
	desc = "A vending machine for costumes. This model appears to have no access restrictions."
	req_access = null

/obj/item/vending_refill/autodrobe
	machine_name = "AutoDrobe"
	icon_state = "refill_costume"

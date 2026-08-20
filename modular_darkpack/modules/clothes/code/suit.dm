//SUITS

//SUITS

//SUITS

/obj/item/clothing/suit/vampire
	icon = 'modular_darkpack/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')

	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	max_integrity = 250
	resistance_flags = NONE
	armor_type = /datum/armor/vampire_suit

/datum/armor/vampire_suit
	melee = 10
	laser = 10
	energy = 10
	bomb = 10
	acid = 10
	wound = 10

/obj/item/clothing/suit/vampire/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling, 10, "suit", FALSE)

/obj/item/clothing/suit/vampire/trench/malkav
	icon_state = "malkav_coat"

/obj/item/clothing/suit/hooded/heisenberg
	name = "chemical costume"
	desc = "A costume made for chemical protection."
	icon = 'modular_darkpack/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	icon_state = "heisenberg"
	body_parts_covered = CHEST | GROIN | ARMS
	cold_protection = CHEST | GROIN | ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	clothing_flags = THICKMATERIAL
	resistance_flags = ACID_PROOF
	armor_type = /datum/armor/chemical_costume
	hoodtype = /obj/item/clothing/head/hooded/heisenberg_hood

/datum/armor/chemical_costume
	laser = 10
	energy = 10
	bomb = 50
	fire = 50
	acid = 100
	wound = 10

/obj/item/clothing/head/hooded/heisenberg_hood
	name = "chemical hood"
	desc = "A hood attached to a chemical costume."
	icon_state = "heisenberg_helm"
	icon = 'modular_darkpack/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEHAIR | HIDEEARS
	clothing_flags = THICKMATERIAL | BLOCK_GAS_SMOKE_EFFECT | SNUG_FIT | STACKABLE_HELMET_EXEMPT | HEADINTERNALS
	resistance_flags = ACID_PROOF
	armor_type = /datum/armor/chemical_costume

//** SPOOOOKY ROBES FROM THE CAPPADOCIAN UPDATE **//
/obj/item/clothing/suit/hooded/robes
	name = "white robe"
	desc = "Some angelic-looking robes."
	icon_state = "robes"
	icon = 'modular_darkpack/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	flags_inv = HIDEJUMPSUIT
	body_parts_covered = CHEST | GROIN | LEGS | ARMS
	cold_protection = CHEST | GROIN | LEGS | ARMS
	hoodtype = /obj/item/clothing/head/hooded/robes_hood

/obj/item/clothing/head/hooded/robes_hood
	name = "white hood"
	desc = "The hood of some angelic-looking robes."
	icon_state = "robes_hood"
	icon = 'modular_darkpack/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	body_parts_covered = HEAD
	cold_protection = HEAD
	flags_inv = HIDEHAIR | HIDEEARS

/obj/item/clothing/suit/hooded/robes/black
	name = "black robe"
	desc = "Some creepy-looking robes."
	icon_state = "robes_black"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/black

/obj/item/clothing/head/hooded/robes_hood/black
	name = "black hood"
	desc = "The hood of some creepy-looking robes."
	icon_state = "robes_black_hood"

/obj/item/clothing/suit/hooded/robes/grey
	name = "grey robe"
	desc = "Some somber-looking robes."
	icon_state = "robes_grey"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/grey

/obj/item/clothing/head/hooded/robes_hood/grey
	name = "grey hood"
	desc = "The hood of some somber-looking robes."
	icon_state = "robes_grey_hood"

/obj/item/clothing/suit/hooded/robes/darkred
	name = "dark red robe"
	desc = "Some zealous-looking robes."
	icon_state = "robes_darkred"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/darkred

/obj/item/clothing/head/hooded/robes_hood/darkred
	name = "dark red hood"
	desc = "The hood of some zealous-looking robes."
	icon_state = "robes_darkred_hood"

/obj/item/clothing/suit/hooded/robes/yellow
	name = "yellow robe"
	desc = "Some happy-looking robes."
	icon_state = "robes_yellow"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/yellow

/obj/item/clothing/head/hooded/robes_hood/yellow
	name = "yellow hood"
	desc = "The hood of some happy-looking robes."
	icon_state = "robes_yellow_hood"

/obj/item/clothing/suit/hooded/robes/green
	name = "green robe"
	desc = "Some earthy-looking robes."
	icon_state = "robes_green"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/green

/obj/item/clothing/head/hooded/robes_hood/green
	name = "green hood"
	desc = "The hood of some earthy-looking robes."
	icon_state = "robes_green_hood"

/obj/item/clothing/suit/hooded/robes/red
	name = "red robe"
	desc = "Some furious-looking robes."
	icon_state = "robes_red"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/red

/obj/item/clothing/head/hooded/robes_hood/red
	name = "red hood"
	desc = "The hood of some furious-looking robes."
	icon_state = "robes_red_hood"

/obj/item/clothing/suit/hooded/robes/purple
	name = "purple robe"
	desc = "Some elegant-looking robes."
	icon_state = "robes_purple"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/purple

/obj/item/clothing/head/hooded/robes_hood/purple
	name = "purple hood"
	desc = "The hood of some elegant-looking robes."
	icon_state = "robes_purple_hood"

/obj/item/clothing/suit/hooded/robes/blue
	name = "blue robe"
	desc = "Some watery-looking robes."
	icon_state = "robes_blue"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/blue

/obj/item/clothing/head/hooded/robes_hood/blue
	name = "blue hood"
	desc = "The hood of some watery-looking robes."
	icon_state = "robes_blue_hood"

/obj/item/clothing/suit/hooded/robes/tremere
	name = "tremere robes"
	desc = "Black robes with red highlights, marked with the emblem of House Tremere."
	icon_state = "tremere_robes"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/tremere

/obj/item/clothing/head/hooded/robes_hood/tremere
	name = "tremere hood"
	desc = "A black hood with red highlights, marked with the emblem of House Tremere."
	icon_state = "tremere_hood"

/obj/item/clothing/suit/hooded/robes/magister
	name = "magister robes"
	desc = "A red robe with an ornate golden trim, marked with the emblem of House Tremere."
	icon_state = "magister_robes"
	hoodtype = /obj/item/clothing/head/hooded/robes_hood/magister

/obj/item/clothing/head/hooded/robes_hood/magister
	name = "magister hood"
	desc = "A red hood with an ornate golden trim, marked with the emblem of House Tremere."
	icon_state = "magister_hood"

/obj/item/clothing/suit/vampire/coat
	name = "brown coat"
	desc = "A warm and heavy brown coat."
	icon_state = "coat1"

/obj/item/clothing/suit/vampire/coat/alt
	name = "green coat"
	desc = "A warm and heavy brown coat."
	icon_state = "coat2"

/obj/item/clothing/suit/vampire/coat/winter
	name = "black fur coat"
	desc = "Warm and heavy clothing."
	icon_state = "winter1"

/obj/item/clothing/suit/vampire/coat/winter/alt
	name = "brown fur coat"
	icon_state = "winter2"

/obj/item/clothing/suit/vampire/coat/leopard
	name = "leopard coat"
	desc = "A coat made from synthetic fur."
	icon_state = "leopard_coat"

/obj/item/clothing/suit/vampire/coat/milparka
	name = "military parka"
	desc = "A thick parka in desert night camoflague."
	icon_state = "desertnightparka"


/obj/item/clothing/suit/hooded/hoodie
	name = "hoodie"
	desc = "A simple hoodie."
	icon_state = "hoodie"
	icon = 'modular_darkpack/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	hoodtype = /obj/item/clothing/head/hooded/hood_hood

/obj/item/clothing/head/hooded/hood_hood
	name = "hoodie hood"
	desc = "A hoodies hoodie hood."
	icon_state = "hoodie_hood"
	icon = 'modular_darkpack/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	// You should not expect this to have an onfloor
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEEARS
	hair_mask = /datum/hair_mask/winterhood

/obj/item/clothing/suit/hooded/hoodie/hoodie_pim
	name = "intruder zim hoodie"
	desc = "A hoodie of a favorite Intruder Zim character, Ger."
	icon_state = "hoodie_zim"
	hoodtype = /obj/item/clothing/head/hooded/hood_hood/hood_pim

/obj/item/clothing/head/hooded/hood_hood/hood_pim
	name = "intruder zim hoodie hood"
	desc = "A hood resembling a favorite Intruder Zim character, Ger."
	icon_state = "hoodie_zim_hood"


/obj/item/clothing/suit/vampire/slickbackcoat
	name = "opulent coat"
	desc = "Lavish, luxurious, and deeply purple. Slickback Clothing Co. It exudes immense energy."
	icon_state = "slickbackcoat"
	armor_type = /datum/armor/opulent_coat

/datum/armor/opulent_coat
	melee = 5
	bullet = 5
	wound = 5

/obj/item/clothing/suit/vampire/jacket
	name = "black leather jacket"
	desc = "True clothing for any punk. Provides some kind of protection."
	icon_state = "jacket1"
	armor_type = /datum/armor/vampire_jacket

/datum/armor/vampire_jacket
	melee = 25
	bullet = 25
	laser = 10
	energy = 10
	bomb = 25
	fire = 25
	acid = 10
	wound = 25

/obj/item/clothing/suit/vampire/jacket/fbi
	name = "Federal Bureau of Investigation jacket"
	desc = "\"FBI OPEN UP!!\""
	icon_state = "fbi"
	armor_type = /datum/armor/vampire_jacket

/obj/item/clothing/suit/vampire/jacket/punk
	icon_state = "punk"
	armor_type = /datum/armor/punk_jacket

/datum/armor/punk_jacket
	melee = 50
	bullet = 50
	laser = 10
	energy = 10
	bomb = 50
	fire = 25
	acid = 10
	wound = 25

/obj/item/clothing/suit/vampire/jacket/better
	name = "brown leather jacket"
	icon_state = "jacket2"
	armor_type = /datum/armor/brown_leather_jacket

/datum/armor/brown_leather_jacket
	melee = 35
	bullet = 35
	laser = 10
	energy = 10
	bomb = 35
	fire = 35
	acid = 10
	wound = 35

/obj/item/clothing/suit/vampire/jacket/better/armored
	name = "armored leather jacket"
	armor_type = /datum/armor/armored_jackets

/datum/armor/armored_jackets
	melee = 50
	bullet = 50
	laser = 50
	energy = 10
	bomb = 40
	bio = 0
	fire = 40
	acid = 10
	wound = 25

/obj/item/clothing/suit/vampire/trench/alt/armored
	name = "armored brown trenchcoat"
	icon_state = "trench2"
	max_integrity = 400
	armor_type = /datum/armor/armored_jackets

/obj/item/clothing/suit/vampire/trench/armored
	name = "armored black trenchcoat"
	max_integrity = 400
	armor_type = /datum/armor/armored_jackets

/obj/item/clothing/suit/vampire/trench
	name = "trenchcoat"
	desc = "Best noir clothes for night. Provides some kind of protection."
	icon_state = "trench1"
	armor_type = /datum/armor/vampire_jacket

/obj/item/clothing/suit/vampire/trench/alt
	name = "brown trenchcoat"
	icon_state = "trench2"

/obj/item/clothing/suit/vampire/trench/archive
	name = "rich trenchcoat"
	desc = "Best choise for pleasant life... or not."
	icon_state = "trench3"

/obj/item/clothing/suit/vampire/trench/strauss
	name = "red trenchcoat"
	desc = "True power lies not in wealth, but in the things it affords you."
	icon_state = "strauss_coat"

/obj/item/clothing/suit/vampire/trench/voivode
	name = "regal coat"
	desc = "A beautiful jacket. Whoever owns this must be important."
	icon_state = "voicoat"
	armor_type = /datum/armor/regal_coat

/datum/armor/regal_coat
	melee = 60
	bullet = 60
	laser = 10
	energy = 10
	bomb = 55
	fire = 45
	acid = 10
	wound = 25

/obj/item/clothing/suit/vampire/vest
	name = "bulletproof vest"
	desc = "Durable, lightweight vest designed to protect against most threats efficiently."
	icon_state = "vest"
	armor_type = /datum/armor/bulletproof_vest
	allowed = list(
		/obj/item/card/id,
		/obj/item/flashlight,
		/obj/item/melee/baton,
		/obj/item/restraints/handcuffs
	)

/datum/armor/bulletproof_vest
	melee = 55
	bullet = 55
	laser = 10
	energy = 10
	bomb = 55
	fire = 45
	acid = 10
	wound = 25

/obj/item/clothing/suit/vampire/vest/medieval
	name = "medieval vest"
	desc = "Probably spanish. Provides good protection."
	icon_state = "medieval"

//Police + Army

/obj/item/clothing/suit/vampire/coat/police
	name = "police raincoat"
	icon_state = "policecoat"
	desc = "A sturdy and reflective raincoat tailored for wet weather patrols."
	custom_price = 20

/obj/item/clothing/suit/vampire/vest/police
	name = "police duty vest"
	icon_state = "pdvest"
	desc = "Lightweight, bulletproof vest with SFPD markings, tailored for active duty."
	custom_price = 50

/obj/item/clothing/suit/vampire/vest/police/fbivest
	name = "FBI duty vest"
	icon_state = "fbivest"
	desc = "Lightweight, bulletproof vest with yellow FBI markings, tailored for active duty. This one has special agent insignia on it."

/obj/item/clothing/suit/vampire/vest/police/sergeant
	name = "police sergeant vest"
	icon_state = "sgtvest"
	desc = "Lightweight, bulletproof vest with SFPD markings, tailored for active duty. This one has sergeant insignia on it."

// They got an Army vest post-PD update. I am just giving them the same, instead coded into their equipment instead of mapped.
/obj/item/clothing/suit/vampire/vest/police/captain
	name = "police captain duty vest"
	icon_state = "capvest"
	desc = "Composite bulletproof vest with SFPD markings, tailored for improved protection. This one has captain insignia on it."
	armor_type = /datum/armor/highly_protective_vest

/datum/armor/highly_protective_vest
	melee = 70
	bullet = 70
	laser = 10
	energy = 10
	bomb = 60
	fire = 50
	acid = 10
	wound = 30

/obj/item/clothing/suit/vampire/vest/army
	name = "army vest"
	desc = "Army equipment. Provides great protection against blunt force."
	icon_state = "army"
	w_class = WEIGHT_CLASS_BULKY
	armor_type = /datum/armor/highly_protective_vest
	masquerade_violating = TRUE

/obj/item/clothing/suit/vampire/eod
	name = "EOD suit"
	desc = "Demoman equipment. Provides best protection against nearly everything."
	icon_state = "eod"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEJUMPSUIT
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 2
	w_class = WEIGHT_CLASS_BULKY
	armor_type = /datum/armor/eod_suit
	masquerade_violating = TRUE

/datum/armor/eod_suit
	melee = 90
	bullet = 90
	laser = 50
	energy = 50
	bomb = 100
	fire = 70
	acid = 90
	wound = 50

/obj/item/clothing/suit/vampire/bogatyr
	name = "bogatyr armor"
	desc = "A regal set of armor made of unknown materials."
	icon_state = "bogatyr_armor"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEJUMPSUIT
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 1
	w_class = WEIGHT_CLASS_BULKY
	armor_type = /datum/armor/highly_protective_vest

/obj/item/clothing/suit/vampire/labcoat
	name = "labcoat"
	desc = "For medicine and research purposes."
	icon_state = "labcoat"
	armor_type = /datum/armor/labcoat

/datum/armor/labcoat
	acid = 90
	wound = 10

/obj/item/clothing/suit/vampire/labcoat/director
	name = "clinic director's labcoat"
	desc = "Special labcoat for clinic director with Saint John Clinic's emblems."
	icon_state = "director"

/obj/item/clothing/suit/vampire/fancy_gray
	name = "fancy gray jacket"
	desc = "Gray-colored jacket"
	icon_state = "fancy_gray_jacket"

/obj/item/clothing/suit/vampire/fancy_red
	name = "fancy red jacket"
	desc = "Red-colored jacket"
	icon_state = "fancy_red_jacket"

/obj/item/clothing/suit/vampire/majima_jacket
	name = "too much fancy jacket"
	desc = "Woahhh, check it out! Two macho men havin' a tussle in the nude!? This is a world of shit I didn't know even existed..."
	icon_state = "majima_jacket"

/obj/item/clothing/suit/vampire/bahari
	name = "dark mother's suit"
	desc = "When I first tasted the fruit of the Trees,\
			felt the seeds of Life and Knowledge, burn within me, I swore that day I would not turn back..."
	icon_state = "bahari"

/obj/item/clothing/suit/vampire/kasaya
	name = "kasaya"
	desc = "A traditional robe worn by monks and nuns of the Buddhist faith."
	icon_state = "kasaya"

/obj/item/clothing/suit/vampire/imam
	name = "imam robe"
	desc = "A traditional robe worn by imams of the Islamic faith."
	icon_state = "imam"

/obj/item/clothing/suit/vampire/noddist
	name = "noddist robe"
	desc = "Shine black the sun! Shine blood the moon! Gehenna is coming soon."
	icon_state = "noddist"

/obj/item/clothing/suit/vampire/orthodox
	name = "orthodox robe"
	desc = "A traditional robe worn by priests of the Orthodox faith."
	icon_state = "vestments"

/obj/item/clothing/suit/vampire/dutch
	name = "dutch's jacket"
	desc = "For those long nights on the beach in Tahiti."
	icon_state = "DutchJacket"

//Pentex Overwear
/obj/item/clothing/suit/vampire/pentex_labcoat
	name = "\improper " + MAIN_EVIL_COMPANY + " labcoat"
	desc = "A crisp white labcoat. This one has the " + MAIN_EVIL_COMPANY + " International logo stiched onto the breast!"
	icon_state = "pentex_closedlabcoat"
	armor_type = /datum/armor/labcoat

/obj/item/clothing/suit/vampire/pentex_labcoat_alt
	name = "\improper " + MAIN_EVIL_COMPANY + " labcoat"
	desc = "A crisp white labcoat. This one has a green trim and the " + MAIN_EVIL_COMPANY + " International logo stiched onto the breast!"
	icon_state = "pentex_labcoat_alt"
	armor_type = /datum/armor/labcoat

/obj/item/clothing/suit/vampire/bomber_jacket_classic
	name = "classic bomber jacket"
	desc = "A classic bomber jacket."
	icon_state = "bomber_classic"

/obj/item/clothing/suit/vampire/bomber_jacket_gray
	name = "gray bomber jacket"
	desc = "A gray bomber jacket."
	icon_state = "bomber_gray"

/obj/item/clothing/suit/vampire/shawl_black
	name = "black shawl"
	desc = "A black shawl."
	icon_state = "shawl_black"

/obj/item/clothing/suit/vampire/shawl_white
	name = "white shawl"
	desc = "A white shawl."
	icon_state = "shawl_white"

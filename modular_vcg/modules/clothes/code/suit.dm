/datum/armor/Class_1
	melee = 20
	bullet = 20
	laser = 20
	energy = 20
	bomb = 20
	fire = 20
	acid = 20

/datum/armor/Class_2
	melee = 30
	bullet = 30
	bomb = 30
	fire = 30
	acid = 30

/datum/armor/Class_3
	melee = 40
	bullet = 40
	bomb = 40
	fire = 40
	acid = 40

/datum/armor/Class_4
	melee = 50
	bullet = 50
	bomb = 50
	fire = 50
	acid = 50

/datum/armor/Class_5
	melee = 60
	bullet = 60
	bomb = 60
	fire = 60
	acid = 60

/obj/item/clothing/suit/vampire/toggled
	var/toggle_noun = "zip"

/obj/item/clothing/suit/vampire/toggled/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/toggle_icon, toggle_noun)

/obj/item/clothing/suit/vampire/toggled/bomber_jacket
	name = "bomber jacket"
	desc = "A bomber jacket."
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "fur1"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/clothes/icons/clothing_onfloor.dmi')

/obj/item/clothing/suit/vampire/toggled/bomber_jacket/inverted
	name = "bomber jacket"
	desc = "A fancy bomber jacket."
	icon_state = "fur2"

/obj/item/clothing/suit/vampire/toggled/plain_jacket
	name = "plain brown jacket"
	desc = "A plain brown jacket."
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "plain1"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/clothes/icons/clothing_onfloor.dmi')

/obj/item/clothing/suit/vampire/toggled/plain_jacket/black
	name = "plain black jacket"
	desc = "A plain black jacket."
	icon_state = "plain2"

/obj/item/clothing/suit/vampire/toggled/military_jacket
	name = "military jacket"
	desc = "A military jacket."
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "m65"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/clothes/icons/clothing_onfloor.dmi')

/obj/item/clothing/suit/vampire/slickbackcoat
	armor_type = /datum/armor/Class_1

/obj/item/clothing/suit/vampire/jacket
	armor_type = /datum/armor/Class_1
	slowdown = .2

/obj/item/clothing/suit/vampire/jacket/fbi
	armor_type = /datum/armor/Class_2
	slowdown = .4

/obj/item/clothing/suit/vampire/jacket/punk
	armor_type = /datum/armor/Class_2
	slowdown = .4

/obj/item/clothing/suit/vampire/jacket/better
	armor_type = /datum/armor/Class_2
	slowdown = .4

/obj/item/clothing/suit/vampire/jacket/better/armored
	armor_type = /datum/armor/Class_3
	slowdown = .4

/obj/item/clothing/suit/vampire/trench/alt/armored
	armor_type = /datum/armor/Class_3
	slowdown = .4

/obj/item/clothing/suit/vampire/trench/armored
	armor_type = /datum/armor/Class_3
	slowdown = .4

/obj/item/clothing/suit/vampire/trench
	armor_type = /datum/armor/Class_1
	slowdown = .2

/obj/item/clothing/suit/vampire/trench/voivode
	armor_type = /datum/armor/Class_4
	slowdown = .6

/obj/item/clothing/suit/vampire/vest
	armor_type = /datum/armor/Class_3
	slowdown = .2

/obj/item/clothing/suit/vampire/vest/medieval
	armor_type = /datum/armor/Class_3
	slowdown = .4

/obj/item/clothing/suit/vampire/vest/police/captain
	armor_type = /datum/armor/Class_4
	slowdown = .2

/obj/item/clothing/suit/vampire/vest/army
	armor_type = /datum/armor/Class_4
	slowdown = .4

/obj/item/clothing/suit/vampire/eod
	armor_type = /datum/armor/Class_5
	slowdown = .6

/obj/item/clothing/suit/vampire/bogatyr
	armor_type = /datum/armor/Class_3
	slowdown = .4

/obj/item/clothing/suit/vampire/bogatyr/captain
	armor_type = /datum/armor/Class_4
	slowdown = .6

/obj/item/clothing/suit/vampire/bogatyr/captain/heavy
	armor_type = /datum/armor/Class_5
	slowdown = .6

/obj/item/clothing/suit/vampire/bogatyr/heavy
	armor_type = /datum/armor/Class_5
	slowdown = .8

/obj/item/clothing/suit/vampire/labcoat
	armor_type = /datum/armor/vampire_suit

/obj/item/clothing/suit/vampire/pentex_labcoat
	armor_type = /datum/armor/vampire_suit

/obj/item/clothing/suit/vampire/pentex_labcoat_alt
	armor_type = /datum/armor/vampire_suit

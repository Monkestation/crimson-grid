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

/obj/item/clothing/suit/vampire/racing_jacket
	name = "Black and Yellow racing jacket"
	desc = "A black and yellow japanese racing jacket."
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "blackyellow_racejacket"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/clothes/icons/clothing_onfloor.dmi')
	armor_type = /datum/armor/racing_jacket

/datum/armor/racing_jacket
	melee = 30
	bullet = 25
	laser = 5
	energy = 5
	bomb = 35
	fire = 35
	acid = 10
	wound = 35

/obj/item/clothing/suit/vampire/racing_jacket/blackblue
	name = "Black and Blue racing jacket"
	desc = "A black and blue japanese racing jacket."
	icon_state = "blackblue_racejacket"

/obj/item/clothing/suit/vampire/racing_jacket/whitered
	name = "White and Red racing jacket"
	desc = "A white and red japanese racing jacket."
	icon_state = "whitered_racejacket"

/obj/item/clothing/suit/vampire/racing_jacket/whiteyellow
	name = "White and Yellow racing jacket"
	desc = "A white and yellow japanese racing jacket."
	icon_state = "whiteyellow_racejacket"

/obj/item/clothing/suit/vampire/racing_jacket/bluewhite
	name = "Blue and White racing jacket"
	desc = "A blue and white japanese racing jacket."
	icon_state = "bluewhite_racejacket"

/obj/item/clothing/suit/vampire/racing_jacket/redwhite
	name = "Red and White racing jacket"
	desc = "A red and white japanese racing jacket."
	icon_state = "redwhite_racejacket"

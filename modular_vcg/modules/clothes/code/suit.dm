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

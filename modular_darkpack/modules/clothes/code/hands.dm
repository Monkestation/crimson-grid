//GLOVES

//GLOVES

//GLOVES

/obj/item/clothing/gloves/vampire
	icon = 'modular_darkpack/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/clothes/icons/clothing_onfloor.dmi')
	undyeable = TRUE

/obj/item/clothing/gloves/vampire/Initialize(mapload)
	.=..()
	AddComponent(/datum/component/selling, 4, "gloves", FALSE)

/obj/item/clothing/gloves/vampire/leather
	name = "leather gloves"
	desc = "Looks dangerous. Provides some kind of protection."
	icon_state = "leather"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	resistance_flags = NONE
	armor_type = /datum/armor/leather_gloves

/datum/armor/leather_gloves
	acid = 30

/obj/item/clothing/gloves/vampire/work
	name = "work gloves"
	desc = "Provides fire protection for working in extreme environments."
	icon_state = "work"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor_type = /datum/armor/work_gloves

/datum/armor/work_gloves
	fire = 70
	acid = 30

/obj/item/clothing/gloves/vampire/investigator
	name = "investigator gloves"
	desc = "Standard issue FBI workgloves tailored for investigators. Made out of latex outer lining and padded for acid and fire protection."
	icon_state = "work"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE
	armor_type = /datum/armor/investigator_gloves

/datum/armor/investigator_gloves
	fire = 70
	acid = 70

/obj/item/clothing/gloves/vampire/cleaning
	name = "cleaning gloves"
	desc = "Provides acid protection."
	icon_state = "cleaning"
	armor_type = /datum/armor/anti_acid_gloves

/datum/armor/anti_acid_gloves
	acid = 70

/obj/item/clothing/gloves/vampire/latex
	name = "latex gloves"
	desc = "Provides acid protection."
	icon_state = "latex"
	armor_type = /datum/armor/anti_acid_gloves

/obj/item/clothing/gloves/vampire/white
	name = "white gloves"
	desc = "A pair of fine, white gloves, a symbol of of cleanliness and quality, and not much else. Getting them dirty shows how unprofessional you are."
	icon_state = "white_gloves"
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = NONE

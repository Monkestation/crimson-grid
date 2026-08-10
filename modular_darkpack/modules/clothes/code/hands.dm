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

/obj/item/clothing/gloves/vampire/brassknuckles
	name = "brass knuckles"
	desc = "A set of tarnished brass rings fused together to create a cruel weapon for back-alley brawls. Illegal in most places."
	icon_state = "brassknuckles"
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/brassknuckles
	clothing_traits = list(TRAIT_BRASSKNUCKLES)

/datum/armor/brassknuckles
	acid = 50


/obj/item/clothing/gloves/vampire/brassknuckles/spiked
	name = "spiked steel knuckles"
	desc = "A set of tarnished steel rings fused together and topped with piercing metal spikes. Illegal in most places."
	icon_state = "spikedknuckles"

/obj/item/clothing/gloves/vampire/brassknuckles/spiked/equipped(mob/living/carbon/human/user, slot)
	..()
	if(ishuman(user) && slot == ITEM_SLOT_GLOVES)
		var/mob/living/carbon/carbon_owner = user
		for(var/obj/item/bodypart/limb as anything in carbon_owner.bodyparts)
			if(istype(limb, /obj/item/bodypart/arm))
				limb.unarmed_sharpness = SHARP_POINTY

/obj/item/clothing/gloves/vampire/brassknuckles/spiked/dropped(mob/living/carbon/human/user, slot)
	..()
	if(user.get_item_by_slot(ITEM_SLOT_GLOVES) == src)
		var/mob/living/carbon/carbon_owner = user
		for(var/obj/item/bodypart/limb as anything in carbon_owner.bodyparts)
			if(istype(limb, /obj/item/bodypart/arm))
				limb.unarmed_sharpness = initial(limb.unarmed_sharpness)

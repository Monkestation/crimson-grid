/obj/item/organ/cyberimp/arm/toolkit/tzimisce
	name = "armblade implant"
	desc = "A concealed serrated bone blade."
	icon_state = "armblade"
	icon = 'modular_vcg/modules/powers/code/discipline/vicissitude/icons/weapons.dmi'
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 30)
	organ_flags = ORGAN_ORGANIC
	aug_overlay = ""
	zone = BODY_ZONE_L_ARM
	slot = ORGAN_SLOT_LEFT_ARM_AUG
	items_to_create = list(/obj/item/melee/vampirearms/tzimisce)
	extend_sound = 'modular_darkpack/modules/powers/sounds/vicissitude.ogg'
	retract_sound =  'modular_darkpack/modules/powers/sounds/vicissitude.ogg'

/obj/item/organ/cyberimp/chest/nutriment/tzimisce
	name = "Secondary Stomach"
	desc = "This secondary stomach is capable of highly efficient digestion of stored biomatter reserves."
	icon_state = "stomach-x"
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 15)
	organ_flags = ORGAN_ORGANIC
	hunger_threshold = NUTRITION_LEVEL_HUNGRY
	poison_amount = 0
	slot = ORGAN_SLOT_STOMACH_AID

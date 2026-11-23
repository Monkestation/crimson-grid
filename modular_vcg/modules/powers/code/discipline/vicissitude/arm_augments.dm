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
	extend_sound = 'modular_darkpack/modules/powers/sounds/vicissitude.ogg'
	retract_sound =  'modular_darkpack/modules/powers/sounds/vicissitude.ogg'

/obj/item/organ/cyberimp/arm/toolkit/tzimisce/get_init_items()
	return list(/obj/item/melee/vampirearms/tzimisce)


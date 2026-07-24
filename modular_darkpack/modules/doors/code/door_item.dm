/obj/item/shield/door
	name = "\improper door"
	desc = "It opens and closes."
	icon_state = "door"
	icon = 'modular_darkpack/modules/weapons/icons/weapons.dmi'
	lefthand_file = 'modular_darkpack/modules/deprecated/icons/lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/deprecated/icons/righthand.dmi'
	force = 15
	block_chance = 25
	throwforce = 10
	throw_speed = 2
	throw_range = 3
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = NONE
	attack_verb_continuous = list("shoves", "bashes")
	attack_verb_simple = list("shove", "bash")
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 10)
	grid_width = 7 GRID_BOXES
	grid_height = 9 GRID_BOXES

/obj/item/chainsaw/vamp
	force_on = 3 LETHAL_TTRPG_DAMAGE

/obj/item/knife/vamp
	throwforce = 1 LETHAL_TTRPG_DAMAGE
	embed_type = /datum/embedding/combat_knife/weak

/obj/item/claymore/machete
	force = 1.5 LETHAL_TTRPG_DAMAGE
	throwforce = 1 LETHAL_TTRPG_DAMAGE
	embed_type = /datum/embedding/combat_knife/weak

/obj/item/melee/vamp/tire
	force = 1 LETHAL_TTRPG_DAMAGE

/obj/item/fireaxe/vamp
	force_wielded = 2 LETHAL_TTRPG_DAMAGE
	block_chance = 15

/obj/item/darkpack/spear
	force = 2 LETHAL_TTRPG_DAMAGE
	reach = 2
	throwforce = 2 LETHAL_TTRPG_DAMAGE 	// WTA pg. 302
	throw_speed = 4
	embed_type = /datum/embedding/spear
	wound_bonus = 15

/obj/item/fireaxe/vamp/battle
	name = "battle axe"
	desc = "For going medieval on someone. A beastly war axe with two heads!"
	icon = 'modular_vcg/modules/weapons/icons/weapons.dmi'
	icon_state = "battleaxe0"
	base_icon_state = "battleaxe"
	lefthand_file = 'modular_vcg/modules/weapons/icons/melee_lefthand.dmi'
	righthand_file = 'modular_vcg/modules/weapons/icons/melee_righthand.dmi'
	worn_icon = 'modular_vcg/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/weapons/icons/weapons_onfloor.dmi')
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT // Should really be suit storage
	w_class = WEIGHT_CLASS_BULKY

	// WTA pg. 302
	force_unwielded = 2 TTRPG_DAMAGE
	force_wielded = 2.5 LETHAL_TTRPG_DAMAGE
	block_chance = 10
	attack_speed = 9
	attack_difficulty = 7

	pixel_w = -8
	custom_price = 2250  // credit to Infared Baron for the sprite

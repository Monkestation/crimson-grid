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
	inhand_icon_state = null
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




/obj/item/darkpack/mace
	name = "mace"
	desc = "Tell me how the grass tastes little man. A mace excelling at damaging someone through armor"
	icon = 'modular_vcg/modules/weapons/icons/weapons.dmi'
	icon_state = "mace"
	inhand_icon_state = null
	base_icon_state = "mace"
	attack_verb_continuous = list("smashes", "hammers")
	attack_verb_simple = list("smash", "hammer")
	hitsound = 'sound/items/weapons/smash.ogg'
	lefthand_file = 'modular_vcg/modules/weapons/icons/melee_lefthand.dmi'
	righthand_file = 'modular_vcg/modules/weapons/icons/melee_righthand.dmi'
	worn_icon = 'modular_vcg/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/weapons/icons/weapons_onfloor.dmi')
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT // Should really be suit storage
	w_class = WEIGHT_CLASS_BULKY

	// WTA pg. 302
	force = 2 TTRPG_DAMAGE
	attack_speed = 8
	attack_difficulty = 7
	armour_penetration = 35
	pixel_w = -8
	custom_price = 2250

//Killing melee dominace
/obj/item/melee/sabre/rapier
	block_chance = 30
	armour_penetration = 0//You are a thin sword you are not going to be piercing armor
/obj/item/melee/sabre/vamp
	armour_penetration = 10//FUN FACT SWORDS ARNT VERY EFFECTIVE AGAINST ARMOR ITS WHY ARMOR EXISTS
	block_chance = 15
/obj/item/claymore/longsword
	armour_penetration = 20//Highest your getting take it or leave it
	block_chance = 5
/obj/item/claymore/longsword/keeper
	block_chance = 0//No This weapon is a insane you dont get EVERYTHING
	armour_penetration = 20//Armor exists for a reason
/obj/item/melee/vampirearms/tzimisce
	block_chance = 0//A shields block chance is 30% this thing had 40 you are a backup weapon not a main armament
	armour_penetration =5//This is a bone blade its not made of a super material you have to care about armor


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

/obj/item/sheriffblade/vamp
	name = "sheriff's special"
	desc = "A sword that was brought by the Sheriff from parts unknown. An odd but efficient design to say the least."
	icon = 'modular_vcg/modules/weapons/icons/weapons64x32.dmi'
	icon_state = "sheriffblade0"
	base_icon_state = "sheriffblade"
	lefthand_file = 'modular_vcg/modules/weapons/icons/melee_lefthand.dmi'
	righthand_file = 'modular_vcg/modules/weapons/icons/melee_righthand.dmi'
	worn_icon = 'modular_vcg/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/weapons/icons/weapons_onfloor.dmi')
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT
	/// How much damage to do unwielded
	var/force_unwielded = 0
	/// How much damage to do wielded
	var/force_wielded = 0

	force_unwielded = 2 LETHAL_TTRPG_DAMAGE // Dual wield if u want smth good.
	force_wielded = 5 LETHAL_TTRPG_DAMAGE // Made up, same force as Brother's Keeper. Equivalent to 5 TTRPG damage.
	attack_difficulty = 7
	armour_penetration = 50 // Normally 75 pen, that pens army armor. Instead, 50. Pens bullet proof.
	w_class = WEIGHT_CLASS_BULKY
	block_chance = 45
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/items/weapons/rapierhit.ogg'
	wound_bonus = 5

	pixel_w = -8
	custom_price = 3750 // Sheriff's either dead or stupid.

/obj/item/sheriffblade/vamp/Initialize(mapload)
	AddComponent(/datum/component/two_handed, force_unwielded=force_unwielded, force_wielded=force_wielded, icon_wielded="[base_icon_state]1")

/obj/item/fireaxe/update_icon_state()
	icon_state = "[base_icon_state]0"
	return ..()

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

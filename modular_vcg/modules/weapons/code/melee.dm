/obj/item/chainsaw/vamp
	force_on = 3 LETHAL_TTRPG_DAMAGE

/obj/item/claymore/machete
	force = 1.5 LETHAL_TTRPG_DAMAGE

/obj/item/melee/vamp/tire
	force = 1 LETHAL_TTRPG_DAMAGE

/obj/item/fireaxe/vamp
	force_wielded = 2 LETHAL_TTRPG_DAMAGE

/obj/item/darkpack/spear
	force = 2 LETHAL_TTRPG_DAMAGE

/obj/item/sheriffblade/vamp
	name = "sheriff's special"
	desc = "A sword that was brought by the Sheriff from parts unknown. An odd but efficient design to say the least."
	icon = 'modular_vcg/modules/weapons/icons/weapons64x32.dmi'
	lefthand_file = 'modular_vcg/modules/weapons/icons/melee_lefthand.dmi'
	righthand_file = 'modular_vcg/modules/weapons/icons/melee_righthand.dmi'
	worn_icon = 'modular_vcg/modules/weapons/icons/worn_melee.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/weapons/icons/weapons_onfloor.dmi')
	icon_state = "sheriffblade"
	slot_flags = ITEM_SLOT_BACK | ITEM_SLOT_BELT

	force = 50 // Made up, same force as Brother's Keeper.
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

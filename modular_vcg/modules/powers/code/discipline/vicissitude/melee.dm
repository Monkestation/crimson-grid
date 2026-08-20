/obj/item/melee/vampirearms/tzimisce
	name = "armblade"
	desc = "A monstrous weapon, made out of sharpened bone."
	icon_state = "armblade"
	icon = 'modular_vcg/modules/powers/code/discipline/vicissitude/icons/weapons.dmi'
	lefthand_file = 'modular_vcg/modules/powers/code/discipline/vicissitude/icons/lefthand.dmi'
	righthand_file = 'modular_vcg/modules/powers/code/discipline/vicissitude/icons/righthand.dmi'
	force = 2 LETHAL_TTRPG_DAMAGE
	w_class = WEIGHT_CLASS_BULKY
	block_chance = 40
	armour_penetration = 40
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	hitsound = 'sound/items/weapons/rapierhit.ogg'
	wound_bonus = 5
	exposed_wound_bonus = 25
	resistance_flags = FIRE_PROOF
	masquerade_violating = TRUE

/obj/item/melee/vampirearms/tzimisce/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NATURAL, INNATE_TRAIT)

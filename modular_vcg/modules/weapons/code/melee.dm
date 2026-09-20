/obj/item/knife/vamp
	throwforce = 1 LETHAL_TTRPG_DAMAGE
	embed_type = /datum/embedding/darkpack_knife

/obj/item/claymore/machete
	force = 1.5 LETHAL_TTRPG_DAMAGE
	throwforce = 1 LETHAL_TTRPG_DAMAGE
	embed_type = /datum/embedding/darkpack_knife

/datum/embedding/darkpack_knife
	pain_mult = 3
	embed_chance = 40
	fall_chance = 10
	ignore_throwspeed_threshold = TRUE

/obj/item/chainsaw/vamp
	force_on = 3 LETHAL_TTRPG_DAMAGE

/obj/item/melee/vamp/tire
	force = 1 LETHAL_TTRPG_DAMAGE

/obj/item/fireaxe/vamp
	force_wielded = 2.5 LETHAL_TTRPG_DAMAGE

/obj/item/darkpack/spear
	armour_penetration = 25
	force = 2 LETHAL_TTRPG_DAMAGE
	reach = 2
	// WTA pg. 302
	throwforce = 2 LETHAL_TTRPG_DAMAGE
	throw_speed = 4
	embed_type = /datum/embedding/spear
	wound_bonus = 15

/obj/item/melee/sabre/vamp
	armour_penetration = 45
	block_chance = 40

/obj/item/melee/sabre/rapier
	armour_penetration = 45
	block_chance = 25

/obj/item/claymore/longsword
	armour_penetration = 30
	w_class = WEIGHT_CLASS_BULKY

/obj/item/katana/vamp
	armour_penetration = 25

/obj/item/katana/vamp/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	// only trujahs can block bullets
	if(attack_type == PROJECTILE_ATTACK || attack_type == LEAP_ATTACK || attack_type == OVERWHELMING_ATTACK)
		if (!owner.is_clan(/datum/subsplat/vampire_clan/true_brujah))
			final_block_chance = 0
	return ..()


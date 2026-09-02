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
	reach = 2

/obj/item/melee/sabre/vamp
	armour_penetration = 30
	attack_difficulty = 5
	block_chance = 35

/obj/item/melee/sabre/rapier
	block_chance = 35

/obj/item/claymore/longsword
	armour_penetration = 20
	w_class = WEIGHT_CLASS_BULKY

/obj/item/katana/vamp
	armour_penetration = 25
	block_chance = 40

/obj/item/katana/vamp/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == PROJECTILE_ATTACK || attack_type == LEAP_ATTACK || attack_type == OVERWHELMING_ATTACK)
		final_block_chance = 0
	return ..()

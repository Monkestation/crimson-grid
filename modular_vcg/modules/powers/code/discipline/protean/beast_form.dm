// Protean 4 buffs
/mob/living/basic/pet/dog/wolf/protean
	maxHealth = 400
	health = 400
	melee_damage_lower = 40
	melee_damage_upper = 40
	melee_attack_cooldown = 8
	random_wolf_color = FALSE
	speed = -0.4

/mob/living/basic/pet/dog/darkpack/protean
	melee_attack_cooldown = 8
	speed = -0.6
	random_dog_color = FALSE

/mob/living/basic/bear/vampire/protean
	maxHealth = 500
	health = 500
	melee_damage_lower = 60
	melee_damage_upper = 60
	melee_attack_cooldown = 10
	speed = -0.2
	slowed_by_drag = FALSE

// FLIGHT FORMS
/mob/living/basic/corvid/protean
	mob_size = MOB_SIZE_SMALL

/mob/living/basic/pet/cat/darkpack/protean // Meow :3
	maxHealth = 300
	health = 300
	mob_size = MOB_SIZE_SMALL
	speed = -0.8
	melee_attack_cooldown = 8
	random_cat_color = FALSE

/datum/action/cooldown/spell/shapeshift/gangrel/beast_form/Grant(mob/grant_to)
	. = ..()
	if(ishuman(grant_to))
		var/mob/living/carbon/human/grant_to_human = grant_to
		if(grant_to_human.is_clan(/datum/subsplat/vampire_clan/gangrel))
			possible_shapes += list(
				/mob/living/basic/bear/vampire/protean,
				/mob/living/basic/pet/dog/darkpack/protean,
				/mob/living/basic/corvid/protean,
				/mob/living/basic/pet/cat/darkpack/protean
			)

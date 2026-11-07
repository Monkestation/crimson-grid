// Protean 4 buffs
/mob/living/basic/pet/dog/wolf/protean
	maxHealth = 400
	health = 400
	melee_damage_lower = 40
	melee_damage_upper = 40
	melee_attack_cooldown = 8
	random_wolf_color = FALSE
	speed = -0.4

/mob/living/basic/pet/dog/wolf/protean/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swing_attack)


/mob/living/basic/pet/dog/darkpack/protean
	melee_attack_cooldown = 8
	speed = -0.6
	random_dog_color = FALSE

/mob/living/basic/pet/dog/darkpack/protean/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swing_attack)


/mob/living/basic/bear/vampire/protean
	maxHealth = 500
	health = 500
	melee_damage_lower = 60
	melee_damage_upper = 60
	melee_attack_cooldown = 10
	speed = -0.2
	slowed_by_drag = FALSE

/mob/living/basic/bear/vampire/protean/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swing_attack)

// FLIGHT FORMS
/mob/living/basic/corvid/protean
	mob_size = MOB_SIZE_SMALL
	speed = -0.6

/mob/living/basic/pet/cat/protean
	name = "cat"
	desc = "Kitty!!"
	maxHealth = 300
	health = 300
	speed = -0.8
	melee_damage_lower = 10
	melee_damage_upper = 10
	melee_attack_cooldown = 4
	mob_size = MOB_SIZE_SMALL
	icon_state = "cat3"
	icon_living = "cat3"
	icon_dead = "cat3_dead"
	base_icon_state = "cat3"
	icon = 'modular_darkpack/master_files/icons/mobs/simple/pets.dmi'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/items/weapons/slash.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	can_breed = FALSE

/mob/living/basic/pet/cat/protean/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swing_attack)

//Da floppa
/mob/living/basic/pet/cat/protean/floppa
	name = "\improper floppa cat"
	desc = "What a distinguished gentleman."
	icon_state = "floppa"
	icon_living = "floppa"
	icon_dead = "floppa_dead"
	base_icon_state = "floppa"
	icon = 'modular_vcg/modules/npc/icons/floppa.dmi'


//Tlacique Exclusive forms

/mob/living/basic/pet/cat/protean/jaguar
	name = "Jaguar"
	desc = "Fast Kitty!!"
	maxHealth = 400
	health = 400
	speed = -0.6
	melee_damage_lower = 60
	melee_damage_upper = 60
	melee_attack_cooldown = 8
	mob_size = MOB_SIZE_LARGE
	icon_state = "jaguar"
	icon_living = "jaguar"
	icon_dead = "jaguar_dead"
	base_icon_state = "jaguar"
	icon = 'modular_vcg/modules/npc/icons/jaguar.dmi'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/items/weapons/slash.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	sharpness = TRUE
	can_breed = FALSE

/mob/living/basic/pet/cat/protean/puma
	name = "Puma"
	desc = "Sneaky Kitty!"
	maxHealth = 300
	health = 300
	speed = -0.4
	melee_damage_lower = 30
	melee_damage_upper = 30
	melee_attack_cooldown = 8
	mob_size = MOB_SIZE_LARGE
	icon_state = "puma"
	icon_living = "puma"
	icon_dead = "puma_dead"
	base_icon_state = "puma"
	icon = 'modular_vcg/modules/npc/icons/jaguar.dmi'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/items/weapons/slash.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW
	sharpness = TRUE
	can_breed = FALSE

/mob/living/basic/pet/cat/protean/puma/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/jumper)

/datum/action/cooldown/spell/shapeshift/gangrel/beast_form/Grant(mob/grant_to)
	. = ..()
	if(ishuman(grant_to))
		var/mob/living/carbon/human/grant_to_human = grant_to
		if(grant_to_human.is_clan(/datum/subsplat/vampire_clan/gangrel))
			possible_shapes += list(
				/mob/living/basic/bear/vampire/protean,
				/mob/living/basic/pet/dog/darkpack/protean,
				/mob/living/basic/corvid/protean,
				/mob/living/basic/pet/cat/protean,
				/mob/living/basic/pet/cat/protean/floppa,
			)
		else if(grant_to_human.is_clan(/datum/subsplat/vampire_clan/setite/tlacique)) // Host requested
			possible_shapes += list(
				/mob/living/basic/pet/cat/protean,
				/mob/living/basic/pet/cat/protean/jaguar,
				/mob/living/basic/pet/cat/protean/puma,
				/mob/living/basic/pet/cat/protean/floppa,
			)
			possible_shapes -= list(
				/mob/living/basic/pet/dog/wolf/protean,
			)

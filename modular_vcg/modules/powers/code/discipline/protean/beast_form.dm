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

/mob/living/basic/cat/protean // Meow :3 - This needs to be it's own mob completely as the cat subtype is horrendously bugged as a player.
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
	base_icon_state = "cat"
	icon = 'modular_darkpack/master_files/icons/mobs/simple/pets.dmi'
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	attack_sound = 'sound/items/weapons/slash.ogg'
	attack_vis_effect = ATTACK_EFFECT_CLAW

/mob/living/basic/cat/protean/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/pet_bonus, "purr", /datum/mood_event/pet_animal)
	AddElement(/datum/element/footstep, footstep_type = FOOTSTEP_MOB_CLAW)
	AddElement(/datum/element/can_be_held)
	AddElement(/datum/element/swing_attack)

/datum/action/cooldown/spell/shapeshift/gangrel/beast_form/Grant(mob/grant_to)
	. = ..()
	if(ishuman(grant_to))
		var/mob/living/carbon/human/grant_to_human = grant_to
		if(grant_to_human.is_clan(/datum/subsplat/vampire_clan/gangrel))
			possible_shapes += list(
				/mob/living/basic/bear/vampire/protean,
				/mob/living/basic/pet/dog/darkpack/protean,
				/mob/living/basic/corvid/protean,
				/mob/living/basic/cat/protean
			)
		if(grant_to_human.is_clan(/datum/subsplat/vampire_clan/setite/tlacique)) // Host requested
			possible_shapes += list(
				/mob/living/basic/cat/protean
			)

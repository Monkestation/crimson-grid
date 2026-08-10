/mob/living/basic/crinos_beast
	name = "wolf-like beast"
	desc = "The peak of abominations damage. Unbelievably deadly..."
	icon = 'modular_darkpack/modules/npc/icons/werewolf.dmi'
	icon_state = "beast_crinos"
	base_icon_state = "beast_crinos"
	icon_living = "beast_crinos"
	icon_dead = "beast_crinos_dead"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BEAST

	speed = 1
	max_stamina = 575
	maxHealth = 575
	health = 575

	butcher_results = list(/obj/item/stack/sheet/meat = 10)

	combat_mode = TRUE
	melee_damage_lower = 35
	melee_damage_upper = 35

	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/items/weapons/slash.ogg'

	pixel_w = -8
	bloodpool = 10
	maxbloodpool = 10
	ai_controller = /datum/ai_controller/basic_controller/crinos_beast
	var/clothing_type = 0 // Set to -1 for random clothing

	faction = list(FACTION_HOSTILE)

/mob/living/basic/crinos_beast/Initialize(mapload)
	if(clothing_type == -1)
		icon_state = "[base_icon_state]-clothing[rand(1,4)]"
		icon_dead = "[base_icon_state]_dead-clothing[rand(1,4)]"
	else if(clothing_type)
		icon_state = "[base_icon_state]-clothing[clothing_type]"
		icon_dead = "[base_icon_state]_dead-clothing[clothing_type]"
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	ADD_TRAIT(src, TRAIT_FRENETIC_AURA, INNATE_TRAIT)

///nothing unique, just retaliation.
/datum/ai_controller/basic_controller/crinos_beast
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/escape_captivity,
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

/mob/living/basic/bane/suffocating
	desc = "A disgusting gasping creature that writhes and contorts."
	icon_state = "suffocating_bane"
	maxHealth = 50
	health = 50

	ai_controller = /datum/ai_controller/basic_controller/suffocating_bane

	mob_size = MOB_SIZE_SMALL

/datum/ai_controller/basic_controller/suffocating_bane
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk

	planning_subtrees = list(
		/datum/ai_planning_subtree/escape_captivity,
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/random_speech/suffocating_bane
	)


/datum/ai_planning_subtree/random_speech/suffocating_bane
	speech_chance = 15
	speak = list("gasps")
	sound = list(
		'sound/mobs/humanoids/human/gasp/gasp_female1.ogg',
		'sound/mobs/humanoids/human/gasp/gasp_female2.ogg',
		'sound/mobs/humanoids/human/gasp/gasp_female3.ogg',
		'sound/mobs/humanoids/human/gasp/gasp_male1.ogg',
		'sound/mobs/humanoids/human/gasp/gasp_male2.ogg',
	)

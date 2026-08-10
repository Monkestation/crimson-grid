/datum/ai_controller/basic_controller/corvid
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
	)

	ai_traits = PASSIVE_AI_FLAGS
	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk

	planning_subtrees = list(
		/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/random_speech/corvid,
		/datum/ai_planning_subtree/find_and_hunt_target/find_shiney,
	)

/datum/ai_planning_subtree/random_speech/corvid
	speech_chance = 5
	speak = list("Caw!")
	sound = list('modular_darkpack/modules/werewolf_the_apocalypse/sounds/emotes/caw.ogg')
	emote_hear = list("Caws.")

/datum/ai_planning_subtree/find_and_hunt_target/find_shiney
	target_key = BB_LOW_PRIORITY_HUNTING_TARGET
	hunting_behavior = /datum/ai_behavior/hunt_target/find_shiney
	finding_behavior = /datum/ai_behavior/find_hunt_target/find_shiney
	hunt_targets = list(/obj/item/ammo_casing, /obj/item/watch, /obj/item/vamp/keys, /obj/item/occult_artifact, /obj/item/knife)
	hunt_range = 10

/datum/ai_behavior/find_hunt_target/find_shiney

/datum/ai_behavior/find_hunt_target/find_shiney/valid_dinner(mob/living/source, obj/item/shiney, radius)
	return can_see(source, shiney, radius)

/datum/ai_behavior/hunt_target/find_shiney

/datum/ai_behavior/hunt_target/find_shiney/target_caught(mob/living/hunter, obj/item/shiney)
	hunter.start_pulling(shiney)

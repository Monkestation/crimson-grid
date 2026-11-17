/datum/ai_controller/basic_controller/corvid
	behavior_tree_json = "modular_darkpack/modules/werewolf_the_apocalypse/code/basic_mobs/corvid/corvid.bt.json"
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic/allow_items,
		BB_HOARD_LOCATION_RANGE = 12,
	)

	ai_movement = /datum/ai_movement/basic_avoidance


/datum/bt_node/ai_behavior/random_speech/corvid
	speech_chance = 5
	speak = list("Caw!")
	sound = list('modular_darkpack/modules/werewolf_the_apocalypse/sounds/emotes/caw.ogg')
	emote_hear = list("Caws.")


/// Use spawnpoint as nest, carry loot home, then go steal more.
/datum/bt_node/subtree/corvid_hoard
	behavior_tree_json = "modular_darkpack/modules/werewolf_the_apocalypse/code/basic_mobs/corvid/corvid_hoard.bt.json"

/*
/datum/bt_node/subtree/find_and_hunt_target/find_shiney
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
*/

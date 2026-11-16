/datum/ai_controller/basic_controller/beastmaster_summon
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic/beastmaster_enemies,
		BB_PET_TARGETING_STRATEGY = /datum/targeting_strategy/basic/beastmaster_enemies,
		BB_TARGET_MINIMUM_STAT = HARD_CRIT,
		BB_BEASTMASTER_ENEMIES_LIST = list(),
	)
	ai_movement = /datum/ai_movement/basic_avoidance

	behavior_tree_json = "modular_darkpack/modules/beastmaster/code/beastmaster.bt.json"

	/*
	planning_subtrees = list(
		/datum/bt_node/subtree/basic_melee_attack_subtree,
		/datum/bt_node/subtree/target_retaliate,
		/datum/bt_node/subtree/pet_planning,
	)
	*/


/datum/targeting_strategy/basic/beastmaster_enemies

//this is an exact copy of the parent without faction logic.
/datum/targeting_strategy/basic/beastmaster_enemies/is_valid_target(mob/living/living_mob, atom/the_target, vision_range, datum/ai_controller/controller = null)
	if(isturf(the_target) || isnull(the_target))
		return FALSE

	if(isobj(the_target.loc))
		var/obj/container = the_target.loc
		if(container.resistance_flags & INDESTRUCTIBLE)
			return FALSE

	if(ismob(the_target))
		if(living_mob.loc == the_target)
			return FALSE
		if(HAS_TRAIT(the_target, TRAIT_GODMODE))
			return FALSE

	if(vision_range && get_dist(living_mob, the_target) > vision_range)
		return FALSE

	if(!can_see(living_mob, the_target, vision_range))
		return FALSE

	if(living_mob.see_invisible < the_target.invisibility)
		return FALSE

	if(!isturf(living_mob.loc))
		return FALSE

	if(isturf(the_target.loc) && living_mob.z != the_target.z)
		return FALSE

	if(!isliving(the_target))
		return FALSE

	var/mob/living/living_target = the_target

	// don't attack friends
	var/list/friends = controller.blackboard[BB_FRIENDS_LIST]
	if(friends && (living_target in friends))
		return FALSE

	// check if we have a commanded the_target
	var/mob/living/commanded_target = controller.blackboard[BB_CURRENT_PET_TARGET]
	if(commanded_target)
		if(living_target == commanded_target)
			if(living_target.stat > controller.blackboard[BB_TARGET_MINIMUM_STAT])
				return FALSE
			return TRUE
		return FALSE

	// check if the_target is in our enemies list
	var/list/enemies = controller.blackboard[BB_BEASTMASTER_ENEMIES_LIST]
	if(enemies && length(enemies))
		if(living_target in enemies)
			if(living_target.stat > controller.blackboard[BB_TARGET_MINIMUM_STAT])
				return FALSE
			return TRUE

	return FALSE

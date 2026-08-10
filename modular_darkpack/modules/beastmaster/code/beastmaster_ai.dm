/datum/ai_controller/basic_controller/beastmaster_summon
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic/beastmaster_enemies,
		BB_PET_TARGETING_STRATEGY = /datum/targeting_strategy/basic/beastmaster_enemies,
		BB_TARGET_MINIMUM_STAT = HARD_CRIT,
		BB_BEASTMASTER_ENEMIES_LIST = list(),
	)
	ai_movement = /datum/ai_movement/basic_avoidance
	planning_subtrees = list(
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/pet_planning,
	)

/datum/targeting_strategy/basic/beastmaster_enemies

//this is an exact copy of the parent without faction logic.
/datum/targeting_strategy/basic/beastmaster_enemies/can_attack(mob/living/source, atom/movable/target, vision_range)
	var/datum/ai_controller/basic_controller/our_controller = source.ai_controller

	if(isnull(our_controller))
		return FALSE

	if(isturf(target) || isnull(target))
		return FALSE

	if(isobj(target.loc))
		var/obj/container = target.loc
		if(container.resistance_flags & INDESTRUCTIBLE)
			return FALSE

	if(ismob(target))
		if(source.loc == target)
			return FALSE
		if(HAS_TRAIT(target, TRAIT_GODMODE))
			return FALSE

	if(vision_range && get_dist(source, target) > vision_range)
		return FALSE

	if(!can_see(source, target, vision_range))
		return FALSE

	if(source.see_invisible < target.invisibility)
		return FALSE

	if(!isturf(source.loc))
		return FALSE

	if(isturf(target.loc) && source.z != target.z)
		return FALSE

	if(!isliving(target))
		return FALSE

	var/mob/living/living_target = target

	// don't attack friends
	var/list/friends = our_controller.blackboard[BB_FRIENDS_LIST]
	if(friends && (living_target in friends))
		return FALSE

	// check if we have a commanded target
	var/mob/living/commanded_target = our_controller.blackboard[BB_CURRENT_PET_TARGET]
	if(commanded_target)
		if(living_target == commanded_target)
			if(living_target.stat > our_controller.blackboard[BB_TARGET_MINIMUM_STAT])
				return FALSE
			return TRUE
		return FALSE

	// check if target is in our enemies list
	var/list/enemies = our_controller.blackboard[BB_BEASTMASTER_ENEMIES_LIST]
	if(enemies && length(enemies))
		if(living_target in enemies)
			if(living_target.stat > our_controller.blackboard[BB_TARGET_MINIMUM_STAT])
				return FALSE
			return TRUE

	return FALSE

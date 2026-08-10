/datum/pet_command/attack/beastmaster
	targeting_strategy_key = BB_PET_TARGETING_STRATEGY

/datum/pet_command/attack/beastmaster/on_target_set(mob/living/friend, atom/potential_target)
	var/mob/living/parent = weak_parent.resolve()
	if(!parent)
		return FALSE

	// dont attack random atoms like sand
	if(!isliving(potential_target))
		return FALSE

	var/mob/living/living_target = potential_target

	// an ai controller is necessary
	if(!parent.ai_controller)
		return FALSE

	// don't attack friends
	var/list/friends = parent.ai_controller.blackboard[BB_FRIENDS_LIST]
	if(friends && (living_target in friends))
		to_chat(friend, span_warning("[parent] refuses to attack [living_target]!"))
		return FALSE

	// don't attack the summoner
	if(living_target == friend)
		to_chat(friend, span_warning("[parent] refuses to attack you!"))
		return FALSE

	// don't attack dead things
	if(living_target.stat == DEAD)
		return FALSE

	// add to enemies list for persistent targeting
	var/list/enemies = parent.ai_controller.blackboard[BB_BEASTMASTER_ENEMIES_LIST]
	if(!islist(enemies))
		enemies = list()
		parent.ai_controller.blackboard[BB_BEASTMASTER_ENEMIES_LIST] = enemies

	if(!(living_target in enemies))
		enemies += living_target
		RegisterSignal(living_target, COMSIG_LIVING_DEATH, PROC_REF(on_enemy_death), override = TRUE)

	parent.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, living_target)
	parent.ai_controller.set_blackboard_key(BB_CURRENT_PET_TARGET, living_target)
	parent.ai_controller.set_blackboard_key(BB_ACTIVE_PET_COMMAND, src)
	parent.visible_message(span_warning("[parent] follows [friend]'s gesture towards [living_target] [pointed_reaction]!"))
	return TRUE

/datum/pet_command/attack/beastmaster/execute_action(datum/ai_controller/controller)
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	// if current target is invalid, find a new one from enemies list
	if(!target || target.stat == DEAD)
		var/list/enemies = controller.blackboard[BB_BEASTMASTER_ENEMIES_LIST]
		if(enemies && length(enemies))
			for(var/mob/living/enemy in enemies)
				if(!QDELETED(enemy) && enemy.stat != DEAD)
					target = enemy
					controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
					controller.set_blackboard_key(BB_CURRENT_PET_TARGET, target)
					break

		// no valid targets, clear everything
		if(!target)
			controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)
			controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)

			// get owner and check their follow/stay state
			var/mob/living/pawn = controller.pawn
			var/list/friends = controller.blackboard[BB_FRIENDS_LIST]
			if(friends && length(friends))
				//the master should be the first friend in the list
				var/mob/living/carbon/human/owner = friends[1]
				if(ishuman(owner))
					//check whether they were following or staying before and then return to that after all enemies are defeated
					var/datum/action/beastmaster_command_toggle_follow/toggle = locate() in owner.actions
					var/datum/component/obeys_commands/obeys = owner.minion_command_components[pawn]
					if(toggle && obeys)
						if(toggle.is_following)
							var/datum/pet_command/follow/follow_cmd = obeys.available_commands["Follow"]
							follow_cmd?.set_command_active(pawn, owner)
						else
							var/datum/pet_command/idle/stay_cmd = obeys.available_commands["Stay"]
							stay_cmd?.set_command_active(pawn, owner)

			return

	// attack the target
	controller.queue_behavior(attack_behaviour, BB_BASIC_MOB_CURRENT_TARGET, targeting_strategy_key)
	return SUBTREE_RETURN_FINISH_PLANNING

/datum/pet_command/attack/beastmaster/proc/on_enemy_death(mob/living/dead_enemy)
	SIGNAL_HANDLER
	var/mob/living/parent = weak_parent.resolve()
	if(!parent?.ai_controller)
		return

	// remove from enemies list
	var/list/enemies = parent.ai_controller.blackboard[BB_BEASTMASTER_ENEMIES_LIST]
	if(enemies)
		enemies -= dead_enemy

	UnregisterSignal(dead_enemy, COMSIG_LIVING_DEATH)

	// if this was our current target, find next target, if there is one
	if(parent.ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET] == dead_enemy)
		var/mob/living/new_target = null

		// find the next enemy
		if(enemies && length(enemies))
			for(var/mob/living/enemy in enemies)
				if(!QDELETED(enemy) && enemy.stat != DEAD)
					new_target = enemy
					break

		if(new_target)
			// theres a new target so plan your attack
			parent.ai_controller.set_blackboard_key(BB_CURRENT_PET_TARGET, new_target)
			parent.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, new_target)
			parent.ai_controller.CancelActions()
			parent.ai_controller.able_to_plan = TRUE
		else
			// no more enemies, clear and return to previous behavior
			parent.ai_controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)
			parent.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)

			var/list/friends = parent.ai_controller.blackboard[BB_FRIENDS_LIST]
			if(friends && length(friends))
				var/mob/living/carbon/human/owner = friends[1]
				if(ishuman(owner))
					var/datum/action/beastmaster_command_toggle_follow/toggle = locate() in owner.actions
					var/datum/component/obeys_commands/obeys = owner.minion_command_components[parent]
					if(toggle && obeys)
						if(toggle.is_following)
							var/datum/pet_command/follow/follow_cmd = obeys.available_commands["Follow"]
							follow_cmd?.set_command_active(parent, owner)
						else
							var/datum/pet_command/idle/stay_cmd = obeys.available_commands["Stay"]
							stay_cmd?.set_command_active(parent, owner)

/datum/pet_command/free/beastmaster

/datum/pet_command/free/beastmaster/execute_action(datum/ai_controller/controller)
	// clear all commands
	controller.clear_blackboard_key(BB_ACTIVE_PET_COMMAND)
	controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)
	controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
	controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)

	// clear enemies list and unregister signals
	var/list/enemies = controller.blackboard[BB_BEASTMASTER_ENEMIES_LIST]
	if(enemies)
		for(var/mob/living/enemy in enemies)
			UnregisterSignal(enemy, COMSIG_LIVING_DEATH)
		enemies.Cut()

	controller.CancelActions()
	return

/datum/pet_command/befriend_target
	command_name = "Befriend"
	command_desc = "Command your pet to befriend someone you click on."
	radial_icon = 'modular_darkpack/modules/beastmaster/icons/radial_beastmaster.dmi'
	radial_icon_state = "friend"
	speech_commands = list("befriend", "friend")
	command_feedback = "wags tail"

/datum/pet_command/befriend_target/set_command_active(mob/living/parent, mob/living/commander, radial_command = FALSE)
	if(!pet_able_to_respond())
		return FALSE

	if(command_feedback)
		parent.balloon_alert_to_viewers("[command_feedback]")

	if(!radial_command)
		return TRUE

	RegisterSignal(commander, COMSIG_MOB_CLICKON, PROC_REF(click_on_target))
	commander.client?.mouse_override_icon = 'icons/effects/mouse_pointers/pet_paw.dmi'
	commander.update_mouse_pointer()
	return TRUE

/datum/pet_command/befriend_target/on_target_set(mob/living/friend, atom/potential_target)
	var/mob/living/parent = weak_parent.resolve()
	if(!parent)
		return FALSE

	if(!isliving(potential_target))
		return FALSE

	var/mob/living/living_target = potential_target

	var/list/friends = parent.ai_controller.blackboard[BB_FRIENDS_LIST]
	if(friends && (living_target in friends))
		to_chat(friend, span_notice("[parent] is already friends with [living_target]!"))
		return FALSE

	parent.befriend(living_target)

	//tell all the other summons to befriend this guy too
	if(ishuman(friend))
		var/mob/living/carbon/human/H = friend
		for(var/mob/living/other_minion in H.beastmaster_minions)
			if(other_minion == parent || QDELETED(other_minion))
				continue
			other_minion.befriend(living_target)

	//remove this guy from the enemies list if we're queued up to attack them
	var/list/enemies = parent.ai_controller.blackboard[BB_BEASTMASTER_ENEMIES_LIST]
	if(enemies && (living_target in enemies))
		enemies -= living_target
		UnregisterSignal(living_target, COMSIG_LIVING_DEATH)

	//and if theyre the current target remove that too
	if(parent.ai_controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET] == living_target)
		parent.ai_controller.clear_blackboard_key(BB_CURRENT_PET_TARGET)
		parent.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		parent.ai_controller.CancelActions()

	parent.visible_message(span_notice("[parent] follows [friend]'s gesture and befriends [living_target]!"))
	return TRUE

/datum/pet_command/befriend_target/retrieve_command_text(atom/living_pet, atom/target)
	return isnull(target) ? null : "signals [living_pet] to befriend [target]!"

/datum/pet_command/befriend_target/execute_action(datum/ai_controller/controller)
	controller.clear_blackboard_key(BB_ACTIVE_PET_COMMAND)
	return SUBTREE_RETURN_FINISH_PLANNING

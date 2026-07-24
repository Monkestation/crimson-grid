//beastmaster commands list. some are from the parent, some are custom and from beastmaster_commands.dm
#define BEASTMASTER_COMMANDS list(\
	/datum/pet_command/idle,\
	/datum/pet_command/follow/start_active,\
	/datum/pet_command/attack/beastmaster,\
	/datum/pet_command/protect_owner,\
	/datum/pet_command/free/beastmaster,\
	/datum/pet_command/befriend_target,\
)

/mob/living/carbon/human/proc/add_beastmaster_minion(mob/living/minion_or_type, turf/spawn_location)
	if(!can_tame_beastmaster_minion(minion_or_type, TRUE))
		return FALSE

	if(istype(minion_or_type))
		minion_or_type.wipe_old_beastmasters()

	//does the mob exist? if not, spawn it. if its already spawned in, just reference them
	var/mob/living/minion
	if(ispath(minion_or_type))
		minion = new minion_or_type(spawn_location || get_turf(src))
	else if(istype(minion_or_type))
		minion = minion_or_type
	else
		return FALSE

	//all mobs that we want to control need an ai_controller. if they don't have it - they just cant be controlled.
	if(!minion.ai_controller)
		to_chat(src, span_warning("[minion] cannot be commanded!"))
		if(ispath(minion_or_type))
			qdel(minion)
		return FALSE

	//check if there was already a component for this
	var/datum/component/obeys_commands/old_component = minion.GetComponent(/datum/component/obeys_commands)
	if(old_component)
		qdel(old_component)

	//now we add the obeys commands component and befriend the beastmaster
	var/datum/component/obeys_commands/new_component = minion.AddComponent(/datum/component/obeys_commands, BEASTMASTER_COMMANDS)
	minion_command_components[minion] = new_component
	minion.befriend(src)

	// befriend all existing minions and share their friends
	for(var/mob/living/other_minion in beastmaster_minions)
		minion.befriend(other_minion)
		other_minion.befriend(minion)

		// share all friends from existing minions to new minion
		var/list/other_friends = other_minion.ai_controller?.blackboard[BB_FRIENDS_LIST]
		if(other_friends)
			for(var/mob/living/shared_friend in other_friends)
				if(shared_friend == minion || shared_friend == other_minion || shared_friend == src)
					continue
				minion.befriend(shared_friend)

	//if we didnt have beastmaster minions before, then register beastmaster signals.
	var/had_minions = length(beastmaster_minions)
	beastmaster_minions += minion
	RegisterSignals(minion, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_MOB_WIPE_BEASTMASTER), PROC_REF(on_wipe_beastmaster))

	if(!had_minions)
		register_beastmaster_signals()

	to_chat(src, span_notice("You bind [minion] to your will!"))
	return TRUE

//when the minion dies we need to remove them from beastmaster_minions, and if there are no more minions, remove the signals from the master.
/mob/living/carbon/human/proc/on_wipe_beastmaster(mob/living/minion)
	SIGNAL_HANDLER

	remove_beastmaster_minion(minion)

/mob/living/carbon/human/proc/remove_beastmaster_minion(mob/living/minion)
	if(!minion)
		return

	//unfriend from all other minions and the owner
	for(var/mob/living/other_minion in beastmaster_minions)
		if(other_minion == minion)
			continue
		minion.unfriend(other_minion)
		other_minion.unfriend(minion)

	minion.unfriend(src)

	//delete the obeys commands component
	var/datum/component/obeys_commands/component = minion_command_components[minion]
	if(component)
		qdel(component)

	//remove them from the owner's minion's list and unregister signals if the list is now empty
	beastmaster_minions -= minion
	minion_command_components -= minion
	UnregisterSignal(minion, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_MOB_WIPE_BEASTMASTER))

	if(!length(beastmaster_minions))
		unregister_beastmaster_signals()

/mob/living/carbon/human/proc/can_tame_beastmaster_minion(mob/living/living_minion, feedback)
	if(istype(living_minion))
		if(living_minion in beastmaster_minions)
			if(feedback)
				to_chat(src, span_warning("[living_minion] already heads your commands."))
			return FALSE

	//limit of (leadership) + 1
	var/max_minions = st_get_stat(STAT_LEADERSHIP) + 1
	if(length(beastmaster_minions) >= max_minions)
		if(feedback)
			to_chat(src, span_warning("You cannot control more than [max_minions] minion[max_minions > 1 ? "s" : ""]!"))
		return FALSE

	return TRUE

/mob/proc/wipe_old_beastmasters()
	SEND_SIGNAL(src, COMSIG_MOB_WIPE_BEASTMASTER)

#undef BEASTMASTER_COMMANDS

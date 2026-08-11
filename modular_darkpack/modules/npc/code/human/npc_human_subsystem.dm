SUBSYSTEM_DEF(humannpcpool)
	name = "Human NPC Pool"
#ifndef UNIT_TESTS
	ss_flags = SS_POST_FIRE_TIMING | SS_BACKGROUND
#else
	ss_flags = SS_NO_INIT | SS_NO_FIRE
#endif
	priority = FIRE_PRIORITY_NPC
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 0.3 SECONDS

	dependencies = list(
		/datum/controller/subsystem/mapping,
		/datum/controller/subsystem/atoms,
	)

	var/list/currentrun = list()

/datum/controller/subsystem/humannpcpool/Initialize()
	try_repopulate()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/humannpcpool/stat_entry(msg)
	var/list/activelist = GLOB.npc_list
	var/list/living_list = GLOB.alive_npc_list
	msg = "NPCS:[length(activelist)] Living: [length(living_list)]"
	return ..()

/datum/controller/subsystem/humannpcpool/fire(resumed = FALSE)
	if(!resumed)
		src.currentrun = GLOB.npc_list.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/mob/living/carbon/human/npc/NPC = currentrun[length(currentrun)]
		--currentrun.len
		NPC?.handle_automated_movement()
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/humannpcpool/proc/try_repopulate()
#ifndef UNIT_TESTS
	if (!length(GLOB.npc_spawn_points))
		return

	while (length(GLOB.alive_npc_list) < SSmapping.current_map.max_npcs)
		var/atom/chosen_spawn_point = pick(GLOB.npc_spawn_points)
		var/creating_npc = pick(
			/mob/living/carbon/human/npc/police, \
			/mob/living/carbon/human/npc/bandit, \
			/mob/living/carbon/human/npc/hobo, \
			/mob/living/carbon/human/npc/walkby, \
			/mob/living/carbon/human/npc/business \
		)
		new creating_npc(get_turf(chosen_spawn_point))
#endif

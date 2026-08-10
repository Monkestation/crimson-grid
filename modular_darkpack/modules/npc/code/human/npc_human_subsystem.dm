SUBSYSTEM_DEF(humannpcpool)
	name = "Human NPC Pool"
	ss_flags = SS_POST_FIRE_TIMING|SS_BACKGROUND
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

	if (!resumed)
		var/list/activelist = GLOB.npc_list
		src.currentrun = activelist.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/mob/living/carbon/human/npc/NPC = currentrun[currentrun.len]
		--currentrun.len

		if (QDELETED(NPC))
			GLOB.npc_list -= NPC
			stack_trace("Found a null in npc_list [NPC.type]!")
			continue

		if (MC_TICK_CHECK)
			return
		NPC.handle_automated_movement()

/datum/controller/subsystem/humannpcpool/proc/try_repopulate()
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

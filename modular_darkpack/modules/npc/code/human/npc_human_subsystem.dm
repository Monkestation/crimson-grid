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
	/// NPCs with a living client in range of their spatial grid cells
	var/list/active_npcs = list()

/datum/controller/subsystem/humannpcpool/Initialize()
	try_repopulate()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/humannpcpool/stat_entry(msg)
	msg = "NPCS:[length(GLOB.npc_list)] Living: [length(GLOB.alive_npc_list)] Active: [length(active_npcs)]"
	return ..()

/datum/controller/subsystem/humannpcpool/fire(resumed = FALSE)
	if(!resumed)
		src.currentrun = active_npcs.Copy()

	var/list/currentrun = src.currentrun
	while(length(currentrun))
		var/mob/living/carbon/human/npc/NPC = currentrun[length(currentrun)]
		--currentrun.len
		if(QDELETED(NPC) || !NPC.npc_processing)
			continue
		NPC.handle_automated_movement()
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

#define NPC_INTERESTING_DIST AI_DEFAULT_INTERESTING_DIST

/mob/living/carbon/human/npc
	/// Tracks the spatial grid cells around us
	var/datum/cell_tracker/npc_cells
	/// TRUE if we're in SShumannpcpool.active_npcs
	var/npc_processing = FALSE

/mob/living/carbon/human/npc/Initialize(mapload)
	. = ..()
	npc_cells = new(NPC_INTERESTING_DIST, NPC_INTERESTING_DIST, 1)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(npc_update_grid))
	npc_set_new_cells()

/mob/living/carbon/human/npc/Destroy()
	if(npc_cells)
		for(var/datum/spatial_grid_cell/grid as anything in npc_cells.member_cells)
			UnregisterSignal(grid, list(SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)))
	npc_cells = null
	SShumannpcpool.active_npcs -= src
	npc_processing = FALSE
	return ..()

/mob/living/carbon/human/npc/proc/npc_update_grid(datum/source)
	SIGNAL_HANDLER
	npc_set_new_cells()

/mob/living/carbon/human/npc/proc/npc_set_new_cells()
	if(isnull(npc_cells))
		return
	var/turf/our_turf = get_turf(src)
	if(isnull(our_turf))
		npc_set_processing(FALSE)
		return

	var/list/cell_collections = npc_cells.recalculate_cells(our_turf)
	for(var/datum/spatial_grid_cell/old_grid as anything in cell_collections[2])
		UnregisterSignal(old_grid, list(SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)))
	for(var/datum/spatial_grid_cell/new_grid as anything in cell_collections[1])
		RegisterSignal(new_grid, SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), PROC_REF(npc_on_client_enter))
		RegisterSignal(new_grid, SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), PROC_REF(npc_on_client_exit))
	npc_update_activity()

/mob/living/carbon/human/npc/proc/npc_on_client_enter(datum/source, list/target_list)
	SIGNAL_HANDLER
	if(npc_processing)
		return
	if(!(locate(/mob/living) in target_list))
		return
	npc_set_processing(TRUE)

/mob/living/carbon/human/npc/proc/npc_on_client_exit(datum/source, datum/exited)
	SIGNAL_HANDLER
	if(!npc_processing)
		return
	npc_update_activity()

/// Re-evaluates whether any of our cells contain a living client
/mob/living/carbon/human/npc/proc/npc_update_activity()
	var/has_client = FALSE
	if(npc_cells)
		for(var/datum/spatial_grid_cell/grid as anything in npc_cells.member_cells)
			if(locate(/mob/living) in grid.client_contents)
				has_client = TRUE
				break
	npc_set_processing(has_client)

/mob/living/carbon/human/npc/proc/npc_set_processing(should_process)
	if(npc_processing == should_process)
		return
	npc_processing = should_process
	if(should_process)
		SShumannpcpool.active_npcs += src
	else
		SShumannpcpool.active_npcs -= src

#undef NPC_INTERESTING_DIST

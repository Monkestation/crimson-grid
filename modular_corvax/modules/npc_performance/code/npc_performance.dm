GLOBAL_LIST_EMPTY(turf_fires)

/obj/effect/abstract/turf_fire/Initialize(mapload, power, fire_color)
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		GLOB.turf_fires += src

/obj/effect/abstract/turf_fire/Destroy()
	GLOB.turf_fires -= src
	return ..()

/mob/living/carbon/human/npc
	COOLDOWN_DECLARE(fire_scan_cooldown)

/mob/living/carbon/human/npc/proc/update_fire_fear()
	if(!length(GLOB.turf_fires))
		afraid_of_fire = null
		return
	if(!COOLDOWN_FINISHED(src, fire_scan_cooldown))
		return
	COOLDOWN_START(src, fire_scan_cooldown, 2 SECONDS)
	afraid_of_fire = locate(/obj/effect/abstract/turf_fire) in view(DEFAULT_SIGHT_DISTANCE, src)

/mob/living/carbon/human/npc/proc/npc_walk_to(atom/target)
	var/datum/move_loop/has_target/dist_bound/move_to/npc/current_loop = GLOB.move_manager.processing_on(src, SSmovement)
	if(istype(current_loop) && current_loop.target == target && current_loop.delay == max(cached_multiplicative_slowdown, world.tick_lag))
		return
	GLOB.move_manager.add_to_loop(src, SSmovement, /datum/move_loop/has_target/dist_bound/move_to/npc, MOVEMENT_DEFAULT_PRIORITY, NONE, null, cached_multiplicative_slowdown, INFINITY, target, 0)

/// The full path search runs only when a straight step is blocked, it costs far more than the step itself
/datum/move_loop/has_target/dist_bound/move_to/npc

/datum/move_loop/has_target/dist_bound/move_to/npc/move()
	if(!check_dist())
		return MOVELOOP_FAILURE
	var/atom/old_loc = moving.loc
	var/update_dir = !(flags & MOVEMENT_LOOP_NO_DIR_UPDATE)
	var/turf/next = get_step_towards(moving, target)
	if(next && !next.is_blocked_turf(exclude_mobs = TRUE, source_atom = moving))
		moving.Move(next, get_dir(moving, next), FALSE, update_dir)
	if(QDELETED(moving))
		return MOVELOOP_FAILURE
	if(moving.loc == old_loc)
		next = get_step_to(moving, target)
		moving.Move(next, get_dir(moving, next), FALSE, update_dir)
	return old_loc != moving?.loc ? MOVELOOP_SUCCESS : MOVELOOP_FAILURE

/mob/living/carbon/human/npc/death(gibbed)
	afraid_of_fire = null // dead NPCs stop scanning and would keep a burned out fire alive
	return ..()

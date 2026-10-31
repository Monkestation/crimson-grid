// How many recently visited activity points an NPC remembers (prevents ping-ponging between two points)
#define NPC_RECENT_TARGETS 4
// How far an NPC on asphalt will look for somewhere off the road to loiter
#define NPC_SIDEWALK_SEARCH_RANGE 8

/obj/effect/landmark/npc_spawn_point
	icon = 'modular_darkpack/modules/deprecated/icons/effects/landmarks_static.dmi'
	icon_state = "spawn"

/obj/effect/landmark/npc_spawn_point/Initialize(mapload)
	. = ..()

	GLOB.npc_spawn_points += src

/obj/effect/landmark/npc_spawn_point/Destroy()
	GLOB.npc_spawn_points -= src

	. = ..()

/obj/effect/landmark/npcbeacon
	name = "NPC beacon"
	var/directionwalk

/obj/effect/landmark/npcbeacon/directed
	name = "NPC traffic"
	icon = 'modular_darkpack/modules/deprecated/icons/effects/landmarks_static.dmi'
	icon_state = "npc"

/obj/effect/landmark/npcbeacon/directed/Initialize(mapload)
	. = ..()

	directionwalk = dir

/obj/effect/landmark/npcwall
	name = "NPC Wall"
	icon_state = "x"

/obj/effect/landmark/npcactivity
	name = "NPC Activity"
	icon = 'modular_darkpack/modules/deprecated/icons/effects/landmarks_static.dmi'
	icon_state = "bullets"

/obj/effect/landmark/npcability
	name = "NPC Ability"
	icon = 'modular_darkpack/modules/deprecated/icons/effects/landmarks_static.dmi'
	icon_state = "ability"

/obj/effect/landmark/npcactivity/Initialize(mapload)
	. = ..()

	GLOB.npc_activities += src

/obj/effect/landmark/npcactivity/Destroy()
	. = ..()

	GLOB.npc_activities -= src

/mob/living/carbon/human/npc/death()
	GLOB.alive_npc_list -= src
	SShumannpcpool.try_repopulate()
	GLOB.move_manager.stop_looping(src)

	if (!last_attacker || (get_dist(src, last_attacker) >= 10) || key || hostile)
		return ..()

	if (istype(last_attacker, /mob/living/simple_animal/hostile))
		var/mob/living/simple_animal/hostile/HS = last_attacker
		if(HS.my_creator)
			SEND_SIGNAL(HS.my_creator, COMSIG_PATH_HIT, -1, 0, FALSE, 8)
			HS.my_creator.killed_count += 1
			if(!HS.my_creator.warrant && !HS.my_creator.ignores_warrant)
				if(HS.my_creator.killed_count >= 5)
					HS.my_creator.warrant = TRUE
					SEND_SOUND(HS.my_creator, sound('modular_darkpack/modules/deprecated/sounds/suspect.ogg', volume = 75))
					to_chat(HS.my_creator, span_userdanger("<b>POLICE ASSAULT IN PROGRESS</b>"))
				else
					SEND_SOUND(HS.my_creator, sound('modular_darkpack/modules/deprecated/sounds/sus.ogg', volume = 75))
					to_chat(HS.my_creator, span_userdanger("<b>SUSPICIOUS ACTION (murder)</b>"))
	else if (ishuman(last_attacker))
		var/mob/living/carbon/human/HM = last_attacker
		SEND_SIGNAL(HM, COMSIG_PATH_HIT, -1, 0, FALSE, 8)
		HM.killed_count += 1
		if(!HM.warrant && !HM.ignores_warrant)
			if(HM.killed_count >= 5)
				HM.warrant = TRUE
				SEND_SOUND(HM, sound('modular_darkpack/modules/deprecated/sounds/suspect.ogg', volume = 75))
				to_chat(HM, span_userdanger("<b>POLICE ASSAULT IN PROGRESS</b>"))
			else
				SEND_SOUND(HM, sound('modular_darkpack/modules/deprecated/sounds/sus.ogg', volume = 75))
				to_chat(HM, span_userdanger("<b>SUSPICIOUS ACTION (murder)</b>"))

	. = ..()

/mob/living/carbon/human/npc/Life()
	// huh, NPCs don't run Life() at all if they're dead
	// this means NPCs' organs will never rot, they'll stop bleeding, their body will stay
	// the temperature it was when they died, etc. remove?
	if (stat == DEAD)
		return

	. = ..()

	if (pulledby && (prob(25) || aggressive))
		INVOKE_ASYNC(src, PROC_REF(Aggro), pulledby, TRUE)

	if (!can_npc_move())
		return
	nutrition = 400
	if (get_dist(danger_source, src) < 7)
		last_antagonised = world.time
	if (fire_stacks >= 1)
		INVOKE_ASYNC(src, PROC_REF(execute_resist))

	if (staying)
		return
	// Don't pick a new destination while loitering
	if (!walktarget && world.time >= loiter_until)
		walktarget = ChoosePath()
	if(walktarget)
		EVLOG_PATH(src, EVLOG_CATEGORY_MOVELOOPS, "Set walktarget: [walktarget]", list(loc, get_turf(walktarget)))
	// Loitering NPCs just stand around, skip the stuck detection below so they don't jitter
	if (!walktarget && world.time < loiter_until)
		return
	if (loc == tupik_loc)
		tupik_steps += 1
	else
		tupik_loc = loc
		tupik_steps = 0

	if (tupik_steps <= 3)
		return
	var/turf/T = get_step(src, pick(NORTH, SOUTH, WEST, EAST))
	face_atom(T)
	step_to(src, T, 0)

	if (!walktarget || old_movement)
		return
	if (observed_by_player())
		return
	var/turf/old_loc = loc
	var/turf/new_loc = get_turf(walktarget)
	// Land on a free turf near the target instead of stacking everyone on the exact landmark turf
	var/list/free_turfs = list()
	for(var/turf/open/free_turf in range(2, new_loc))
		if(free_turf.density)
			continue
		if(locate(/mob/living) in free_turf)
			continue
		free_turfs += free_turf
	if(length(free_turfs))
		new_loc = pick(free_turfs)
	forceMove(new_loc)
	EVLOG_PATH(src, EVLOG_CATEGORY_MOVELOOPS, "Teleported using evil russian shitcode", list(old_loc, new_loc))

/mob/living/carbon/human/npc/proc/CreateWay(direction)
	var/turf/location = get_turf(src)
	for(var/distance = 1 to 50)
		location = get_step(location, direction)
		if(iswallturf(location))
			return location
		for(var/atom/A in location)
			// DARKPACK TODO - reimplement decor
			/*
			if(A.density && !istype(A, /obj/structure/lamppost))
				return location
			*/
			if(istype(A, /obj/effect/landmark/npcwall))
				return get_step_towards(location, get_turf(src))
			if(istype(A, /obj/effect/landmark/npcbeacon) && prob(50))
				stopturf = 1
				return get_step(location, direction)

/// Remembers a destination we've just visited so ChoosePath doesn't send us straight back to it.
/mob/living/carbon/human/npc/proc/remember_target(atom/target)
	recent_targets += target
	if(length(recent_targets) > NPC_RECENT_TARGETS)
		recent_targets.Cut(1, 2)

/mob/living/carbon/human/npc/proc/ChoosePath()
	if(!old_movement)
		var/list/possible_list = list()
		for(var/obj/effect/landmark/npcactivity/N in GLOB.npc_activities)
			if(N in recent_targets)
				continue
			if(get_dist(src, N) < 64)
				var/turf/T = get_step(N, turn(get_dir(src, N), 180))
				var/obj/effect/landmark/npcability/A = locate() in T
				if(A)
					if(N.x > x-3 && N.x < x+3)
						possible_list += N
					if(N.y > y-3 && N.y < y+3)
						possible_list += N
		if(!length(possible_list))
			//any activity point that isn't right on top of us, isn't one we just visited, and isn't crowded
			var/list/candidates = list()
			for(var/obj/effect/landmark/npcactivity/N in GLOB.npc_activities)
				if(N in recent_targets)
					continue
				var/dist = get_dist(src, N)
				if(dist <= 1 || dist > 40)
					continue
				candidates += N
			if(length(candidates))
				return pick(candidates)
			if(length(GLOB.npc_activities))
				return pick(GLOB.npc_activities)
			return

		return pick(possible_list)
	else
		var/turf/north_steps = CreateWay(NORTH)
		var/turf/south_steps = CreateWay(SOUTH)
		var/turf/west_steps = CreateWay(WEST)
		var/turf/east_steps = CreateWay(EAST)

		if(dir == NORTH || dir == SOUTH)
			if(get_dist(src, west_steps) >= 7 && get_dist(src, east_steps) >= 7)
				return(pick(west_steps, east_steps))
			if(get_dist(src, west_steps) > get_dist(src, east_steps))
				if(prob(75))
					return west_steps
			else if(get_dist(src, east_steps) > get_dist(src, west_steps))
				if(prob(75))
					return east_steps
			else
				if(dir == NORTH)
					return pick(west_steps, east_steps, south_steps)
				else
					return pick(west_steps, east_steps, north_steps)

		if(dir == WEST || dir == EAST)
			if(get_dist(src, north_steps) >= 7 && get_dist(src, south_steps) >= 7)
				return pick(north_steps, south_steps)
			if(get_dist(src, north_steps) > get_dist(src, south_steps))
				if(prob(75))
					return north_steps
			else if(get_dist(src, south_steps) > get_dist(src, north_steps))
				if(prob(75))
					return south_steps
			else
				if(dir == WEST)
					return pick(north_steps, south_steps, east_steps)
				else
					return pick(north_steps, south_steps, west_steps)

/// Finds the closest free open turf that isn't asphalt, or null if there isn't one in range.
/mob/living/carbon/human/npc/proc/find_sidewalk_spot()
	var/best = INFINITY
	var/list/spots = list()
	for(var/turf/open/T in range(NPC_SIDEWALK_SEARCH_RANGE, src))
		if(T.density || istype(T, /turf/open/floor/plating/asphalt))
			continue
		if(locate(/mob/living) in T)
			continue
		var/dist = get_dist(src, T)
		if(dist > best)
			continue
		if(dist < best)
			best = dist
			spots.Cut()
		spots += T
	if(length(spots))
		return pick(spots)
	return null

/// Called when we arrive at a destination. If we're standing on asphalt, walk off it first, then idle for a while.
/mob/living/carbon/human/npc/proc/start_loitering()
	if(istype(get_turf(src), /turf/open/floor/plating/asphalt))
		var/turf/spot = find_sidewalk_spot()
		if(spot)
			// loiter_until gets set once we actually reach the spot
			loiter_spot = spot
			walktarget = spot
			stopturf = 0
			return
	loiter_until = world.time + rand(10 SECONDS, 30 SECONDS)

/mob/living/carbon/human/npc/proc/can_npc_move()
	if(stat >= HARD_CRIT)
		return FALSE
	if((last_grab + 1.5 SECONDS) > world.time)
		return FALSE
	if(mind || client)
		return FALSE
	if(IsIncapacitated())
		return FALSE
	if(HAS_TRAIT(src, TRAIT_RESTRAINED))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_IMMOBILIZED))
		return FALSE
	if(is_talking)
		return FALSE
	if(pulledby)
		if (HAS_TRAIT(pulledby, TRAIT_CHARMER))
			return FALSE
		if (prob(10))
			execute_resist()
		return FALSE

	return TRUE

/mob/living/proc/IsIncapacitated() //If we're incapacitated in any way
	return locate(/datum/status_effect/incapacitating) in status_effects || null

/mob/living/carbon/human/npc/proc/observed_by_player()
	for (var/mob/observing_mob in viewers(DEFAULT_SIGHT_DISTANCE, src))
		if (!observing_mob.client)
			continue
		return TRUE

	return FALSE

// CRIMSON GRID EDIT - NPC GRID
#define NPC_LOOP_NONE 0
#define NPC_LOOP_WALK 1
#define NPC_LOOP_REACT 2 // combat or fleeing

/mob/living/carbon/human/npc/proc/handle_automated_movement()
	if (!can_npc_move())
		return

	if(!staying)
		lifespan += 1
	if(!walktarget && !staying && world.time >= loiter_until)
		stopturf = rand(1, 2)
		walktarget = ChoosePath()
		face_atom(walktarget)

	// Can't do anything if in a container
	if (!isturf(loc))
		return

	// Checks for fire, clearing the stored fire if none is in view.
	// Skipped in combat, since the combat branch never reads it.
	afraid_of_fire = danger_source ? null : find_nearby_fire()

	// Combat behaviour
	if (danger_source)
		set_loop_mode(NPC_LOOP_REACT)
		// Stop loitering so we resume walking once the fight is over
		loiter_until = 0
		loiter_spot = null

		// Run away from the danger source if they aren't aggressive and have no weapon
		if (!has_weapon && !aggressive)
			GLOB.move_manager.move_away(src, danger_source, 10, cached_multiplicative_slowdown)
		else
			// Criminals will attack anyone, others will only attack non-police
			// DARKPACK TODO - reimplement IDs
			/*
			var/obj/item/card/id/id_card = danger_source.get_idcard(FALSE)
			if (!istype(id_card, /obj/item/card/id/police) || is_criminal)
			*/
			if(!spawned_weapon && has_weapon)
				npc_draw_weapon()
			if(spawned_weapon && get_active_held_item() != my_weapon)
				has_weapon = FALSE
			if(danger_source)
				if(danger_source == src)
					danger_source = null
				else
					ClickOn(danger_source)
					face_atom(danger_source)
					GLOB.move_manager.move_to(src, danger_source, 1, cached_multiplicative_slowdown)

		// Deaggro if the danger source has been beaten up
		if (IS_UNCONSCIOUS_OR_CRIT(danger_source))
			end_combat()

		// Deaggro if 30 second have passed since being antagonised
		if ((last_antagonised + 30 SECONDS) <= world.time)
			end_combat()

	// Running away from fire behaviour
	else if (afraid_of_fire)
		set_loop_mode(NPC_LOOP_REACT)
		GLOB.move_manager.move_away(src, afraid_of_fire, 10, cached_multiplicative_slowdown)
		if (prob(25))
			emote("scream")

	// Walking around behaviour
	else if (walktarget && !staying)
		if(get_dist(src, walktarget) <= max(stopturf, 1))
			// Arrived, let the next tick pick a new destination (after loitering)
			var/reached_loiter_spot = (walktarget == loiter_spot)
			if(!reached_loiter_spot)
				remember_target(walktarget)
			walktarget = null
			walk_stuck_ticks = 0
			set_loop_mode(NPC_LOOP_NONE)
			if(reached_loiter_spot)
				loiter_spot = null
				loiter_until = world.time + rand(10 SECONDS, 30 SECONDS)
			else
				start_loitering()
		else
			set_loop_mode(NPC_LOOP_WALK)
			// If we haven't moved for a few ticks, we're probably stuck behind someone: repath around them
			if(loc == last_walk_pos)
				walk_stuck_ticks++
			else
				walk_stuck_ticks = 0
				last_walk_pos = loc
			if(walk_stuck_ticks >= 3) // tune to your tick rate
				var/turf/ahead = get_step(src, dir)
				if(ahead && (locate(/mob/living) in ahead))
					walk_avoid = ahead
				walk_stuck_ticks = 0
				walk_loop_target = null // forces start_walk_loop to rebuild the path
			start_walk_loop()
			walk_avoid = null

	// Standing still: make sure we aren't still following an old loop
	else
		set_loop_mode(NPC_LOOP_NONE)

	if (!has_weapon || danger_source || !spawned_weapon)
		return
	if (get_active_held_item() == my_weapon)
		npc_stow_weapon()
	else
		has_weapon = FALSE

/mob/living/carbon/human/npc/proc/start_walk_loop()
	var/delay = cached_multiplicative_slowdown + 0.1 SECONDS
	if(walk_loop_target == walktarget && walk_loop_delay == delay)
		return
	walk_loop_target = walktarget
	walk_loop_delay = delay
	GLOB.move_manager.jps_move(src, walktarget, delay, \
		repath_delay = 2 SECONDS, \
		max_path_length = clamp(get_dist(src, walktarget) * 2, 40, 120), \
		minimum_distance = max(stopturf, 1), \
		simulated_only = TRUE, \
		avoid = walk_avoid, \
		skip_first = TRUE)

/// Returns the first visible turf fire in range, or null.
/mob/living/carbon/human/npc/proc/find_nearby_fire()
	if(!length(GLOB.turf_fires))
		return null
	for(var/obj/effect/abstract/turf_fire/fire as anything in GLOB.turf_fires)
		if(fire.z != z || get_dist(src, fire) > DEFAULT_SIGHT_DISTANCE)
			continue
		if(!can_see(src, fire, DEFAULT_SIGHT_DISTANCE))
			continue
		return fire
	return null

/mob/living/carbon/human/npc
	var/loop_mode = NPC_LOOP_NONE
	/// The walktarget our current jps walk loop was built for. Null means no walk loop of ours is running.
	var/walk_loop_target
	/// The delay our current jps walk loop was built with, so we can rebuild it if slowdown changes.
	var/walk_loop_delay
	/// Where we were last time the walk branch ran, used to detect being stuck.
	var/turf/last_walk_pos
	/// How many walk ticks in a row we haven't moved.
	var/walk_stuck_ticks = 0
	/// A turf the next jps path should route around (the mob blocking us), cleared right after use.
	var/turf/walk_avoid
	/// Recently visited activity points, excluded from ChoosePath so we don't ping-pong.
	var/list/recent_targets = list()
	/// world.time until which we stand around instead of picking a new destination.
	var/loiter_until = 0
	/// The off-road turf we're walking to so we can loiter there. Null if we aren't heading to one.
	var/turf/loiter_spot

/mob/living/carbon/human/npc/proc/set_loop_mode(new_mode)
	if(loop_mode == new_mode)
		return
	if(loop_mode != NPC_LOOP_NONE)
		GLOB.move_manager.stop_looping(src)
	loop_mode = new_mode
	walk_loop_target = null
	walk_loop_delay = null

#undef NPC_LOOP_NONE
#undef NPC_LOOP_WALK
#undef NPC_LOOP_REACT

// CRIMSON GRID EDIT END - NPC GRID

#undef NPC_RECENT_TARGETS
#undef NPC_SIDEWALK_SEARCH_RANGE

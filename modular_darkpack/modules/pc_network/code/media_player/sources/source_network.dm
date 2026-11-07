/// A media source with several origins (a speaker network). Each listener hears it
/// from whichever origin is closest to them, with that origin's own range/falloff.
///
/// EXAMPLE (since its kinda confusin):
///   var/datum/media_source/network/net = new(track, volume, CHANNEL_JUKEBOX)
///   net.add_emitter(speaker_a, 12)
///   net.add_emitter(speaker_b, 8)
///   net.start_time = REALTIMEOFDAY
///   net.update_for_all_listeners(TRUE)
/datum/media_source/network
	/// Every origin that plays this source.
	var/list/datum/media_emitter/emitters

/datum/media_source/network/Destroy(force)
	// Emitters first so they stop poking us, then the base Destroy drops every listener.
	QDEL_LIST(emitters)
	return ..()

/// Add an origin. Returns the emitter (or the existing one if origin was already added).
/datum/media_source/network/proc/add_emitter(atom/movable/origin, max_distance = 10, falloff_exponent = SOUND_FALLOFF_EXPONENT, falloff_distance = 3)
	if(QDELETED(src) || !ismovable(origin) || QDELING(origin))
		return null
	var/datum/media_emitter/emitter = get_emitter(origin)
	if(emitter)
		return emitter
	emitter = new(src, origin, max_distance, falloff_exponent, falloff_distance)
	LAZYADD(emitters, emitter)
	// Must happen after it is in the list, since picking up listeners asks the network.
	emitter.update_cells()
	update_for_all_listeners()
	return emitter

/// Remove the origin tied to this atom.
/datum/media_source/network/proc/remove_emitter(atom/movable/origin)
	var/datum/media_emitter/emitter = get_emitter(origin)
	if(!emitter)
		return FALSE
	remove_emitter_datum(emitter)
	return TRUE

/datum/media_source/network/proc/remove_emitter_datum(datum/media_emitter/emitter)
	LAZYREMOVE(emitters, emitter)
	qdel(emitter)
	if(!QDELETED(src))
		refresh_all()

/datum/media_source/network/proc/get_emitter(atom/movable/origin)
	for(var/datum/media_emitter/emitter as anything in emitters)
		if(emitter.source == origin)
			return emitter
	return null

/// The in-range origin closest to this mob, or null if they are out of range of all of them.
/datum/media_source/network/proc/get_closest_emitter(mob/target)
	var/datum/media_emitter/closest
	var/closest_dist
	for(var/datum/media_emitter/emitter as anything in emitters)
		var/dist = emitter.get_distance_to(target)
		if(isnull(dist))
			continue
		if(isnull(closest_dist) || dist < closest_dist)
			closest = emitter
			closest_dist = dist
	return closest

/// Make this mob a listener if any origin reaches them, otherwise drop them.
/datum/media_source/network/proc/refresh_listener(mob/target)
	if(!ismob(target) || QDELETED(src))
		return
	if(get_closest_emitter(target))
		add_listener(target)
	else
		remove_listener(target)

/// Re-evaluate every current listener, then push the new state to them.
/datum/media_source/network/proc/refresh_all()
	for(var/mob/listener as anything in listeners?.Copy())
		refresh_listener(listener)
	update_for_all_listeners()

/datum/media_source/network/get_volume(mob/target)
	. = ..()
	var/datum/media_emitter/emitter = get_closest_emitter(target)
	if(!emitter)
		return 0
	var/turf/their_turf = get_turf(target)
	var/distance = get_dist_3d(emitter.source_turf, their_turf)
	return ceil(. - CALCULATE_SOUND_VOLUME(., distance, emitter.max_distance, emitter.falloff_distance, emitter.falloff_exponent))

/datum/media_source/network/get_priority(mob/target)
	if(QDELETED(src) || volume <= 0 || !current_track?.url)
		return -1
	var/datum/media_emitter/emitter = get_closest_emitter(target)
	if(!emitter)
		return -1
	var/distance = get_dist_3d(emitter.source_turf, get_turf(target))
	var/distance_mul = 1 - (distance / (emitter.max_distance + 1))
	var/volume_mul = volume / 100
	return distance_mul * volume_mul

/datum/media_source/network/get_balance(mob/target)
	var/datum/media_emitter/emitter = get_closest_emitter(target)
	var/turf/their_turf = get_turf(target)
	if(!emitter || isnull(their_turf) || their_turf == emitter.source_turf)
		return 0
	return clamp((emitter.source_turf.x - their_turf.x) / emitter.max_distance, -1, 1)


/// One origin of a /datum/media_source/network. Tracks where its atom really is,
/// including when it is carried, and which clients are near it.
/datum/media_emitter
	var/datum/media_source/network/owner
	var/atom/movable/source
	var/turf/source_turf
	var/max_distance = 10
	var/falloff_exponent = 2
	var/falloff_distance = 3
	var/datum/cell_tracker/tracker
	var/datum/media_loc_tracker/loc_tracker

/datum/media_emitter/New(datum/media_source/network/owner, atom/movable/source, max_distance = 10, falloff_exponent = SOUND_FALLOFF_EXPONENT, falloff_distance = 3)
	. = ..()
	src.owner = owner
	src.source = source
	src.source_turf = get_turf(source)
	src.max_distance = max_distance
	src.falloff_exponent = falloff_exponent
	src.falloff_distance = min(falloff_distance, max_distance - 1)
	src.tracker = new(max_distance, max_distance, 1)
	RegisterSignal(source, COMSIG_QDELETING, PROC_REF(on_source_qdeleting))
	src.loc_tracker = new(source, CALLBACK(src, PROC_REF(on_source_moved)))

/datum/media_emitter/Destroy(force)
	for(var/datum/cell as anything in tracker?.member_cells)
		if(!isnull(cell))
			UnregisterSignal(cell, list(SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)))
	tracker = null
	QDEL_NULL(loc_tracker)
	if(!isnull(source))
		UnregisterSignal(source, COMSIG_QDELETING)
	source = null
	source_turf = null
	owner = null
	return ..()

/// Distance from this origin to the mob, or null if they are out of its range.
/datum/media_emitter/proc/get_distance_to(mob/target)
	var/turf/their_turf = get_turf(target)
	if(isnull(source_turf) || isnull(their_turf))
		return null
	var/dist = get_dist_3d(source_turf, their_turf)
	if(isnull(dist) || dist > max_distance)
		return null
	return dist

/datum/media_emitter/proc/on_source_qdeleting(datum/gone)
	SIGNAL_HANDLER
	if(owner)
		owner.remove_emitter_datum(src)
	else if(!QDELETED(src))
		qdel(src)

/datum/media_emitter/proc/on_source_moved()
	SIGNAL_HANDLER
	if(QDELETED(src) || QDELETED(source) || QDELETED(owner))
		return
	var/turf/new_turf = get_turf(source)
	if(source_turf == new_turf)
		return
	source_turf = new_turf
	update_cells()
	owner.refresh_all()

/datum/media_emitter/proc/update_cells()
	if(QDELETED(src) || QDELETED(source) || QDELETED(tracker) || QDELETED(owner))
		return
	var/turf/our_turf = get_turf(source)
	if(isnull(our_turf))
		return

	var/list/cell_collections = tracker.recalculate_cells(our_turf)
	var/list/new_cells = cell_collections[1]
	var/list/old_cells = cell_collections[2]

	for(var/datum/old_grid as anything in old_cells)
		if(!isnull(old_grid))
			UnregisterSignal(old_grid, list(SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)))

	for(var/datum/spatial_grid_cell/new_grid as anything in new_cells)
		if(QDELETED(new_grid))
			continue
		RegisterSignal(new_grid, SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), PROC_REF(on_client_enter))
		RegisterSignal(new_grid, SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), PROC_REF(on_client_exit))
		for(var/mob/listener in new_grid.client_contents)
			owner.refresh_listener(listener)

/datum/media_emitter/proc/on_client_enter(datum/source, list/target_list)
	SIGNAL_HANDLER
	for(var/mob/mob as anything in target_list)
		owner?.refresh_listener(mob)

/datum/media_emitter/proc/on_client_exit(datum/source, list/target_list)
	SIGNAL_HANDLER
	for(var/mob/mob as anything in target_list)
		owner?.refresh_listener(mob)

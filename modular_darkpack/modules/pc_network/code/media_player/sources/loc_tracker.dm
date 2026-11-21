/datum/media_loc_tracker
	/// The atom whose real-world position we care about.
	var/atom/movable/source
	/// source plus every movable it is nested in, innermost first.
	var/list/atom/movable/chain = list()
	/// Invoked (no args) after the chain has been refreshed because something moved.
	var/datum/callback/on_change

/datum/media_loc_tracker/New(atom/movable/source, datum/callback/on_change)
	. = ..()
	src.source = source
	src.on_change = on_change
	refresh_chain()

/datum/media_loc_tracker/Destroy(force)
	for(var/atom/movable/tracked as anything in chain)
		UnregisterSignal(tracked, COMSIG_MOVABLE_MOVED)
	chain = null
	source = null
	on_change = null
	return ..()

/// Rebuild the container chain and (un)register on whatever changed.
/datum/media_loc_tracker/proc/refresh_chain()
	if(isnull(source))
		return
	var/list/atom/movable/new_chain = list()
	var/atom/current = source
	while(ismovable(current))
		new_chain += current
		current = current.loc
	for(var/atom/movable/old as anything in chain - new_chain)
		UnregisterSignal(old, COMSIG_MOVABLE_MOVED)
	for(var/atom/movable/added as anything in new_chain - chain)
		RegisterSignal(added, COMSIG_MOVABLE_MOVED, PROC_REF(on_chain_moved))
	chain = new_chain

/datum/media_loc_tracker/proc/on_chain_moved(atom/movable/mover)
	SIGNAL_HANDLER
	if(QDELETED(src))
		return
	refresh_chain()
	on_change?.Invoke()

// Copypasta of get_z_move_affected
/// Returns a list of movables that should also be affected when src moves through teleporters, and src.
/atom/movable/proc/get_teleport_move_affected()
	. = list(src)
	if(buckled_mobs)
		. |= buckled_mobs
	for(var/mob/living/buckled as anything in buckled_mobs)
		if(buckled.pulling)
			. |= buckled.pulling
	if(pulling)
		. |= pulling
		if (pulling.buckled_mobs)
			. |= pulling.buckled_mobs

		if (pulling.pulling)
			. |= pulling.pulling.get_teleport_move_affected()

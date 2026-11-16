// Copypasta of get_z_move_affected
/// Returns a list of movables that should also be affected when src moves through teleporters, and src.
/atom/movable/proc/get_teleport_move_affected(list/returning_list = list())
	. = returning_list
	. |= src
	if(buckled_mobs)
		. |= buckled_mobs
	for(var/mob/living/buckled as anything in buckled_mobs)
		if(buckled.pulling)
			. |= buckled.pulling
	//we pass in the list from this proc to ensure we dont reach an infinite loop due to mobs grabbed in a loop or two mobs grabing eachother.
	if(pulling && !(pulling in .))
		. |= pulling.get_teleport_move_affected(.)

/// Occupants were only forgotten when dumped out the normal way, a mob deleted or teleported out of a car stayed referenced
/obj/darkpack_car/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == driver)
		driver = null
	passengers -= gone

// I know, you were expecting more, right?
// Nah just kidding, search "can see you!" in code/modules/mob/living/carbon/examine.dm

// Okay, you came back thinking there was more, right? no thats it.

/mob/dead/observer/get_status_tab_items()
	. = ..()
	if(!GLOB.observer_default_invisibility)
		. += "Ghosts visible to the living!"
	else if (!invisibility)
		. += "You are visible to the living!"
	else if (invisibility <= SEE_INVISIBLE_LIVING)
		. += "You are visibile to most living mobs!"

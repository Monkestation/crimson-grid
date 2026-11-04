/// Runes that fail or are never used stay on the map, holding the caster forever
/obj/ritual_rune/proc/remember_activator(mob/user)
	last_activator = user
	RegisterSignal(user, COMSIG_QDELETING, PROC_REF(forget_activator), override = TRUE)

/obj/ritual_rune/proc/forget_activator(datum/source)
	SIGNAL_HANDLER
	if(last_activator == source)
		last_activator = null

/obj/ritual_rune/thaumaturgy/curse/forget_activator(datum/source)
	. = ..()
	if(channeler == source)
		channeler = null

/obj/sabbatrune/proc/remember_activator(mob/user)
	last_activator = user
	RegisterSignal(user, COMSIG_QDELETING, PROC_REF(forget_activator), override = TRUE)

/obj/sabbatrune/proc/forget_activator(datum/source)
	SIGNAL_HANDLER
	if(last_activator == source)
		last_activator = null

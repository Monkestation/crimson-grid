/obj/ritual_rune/thaumaturgy/blood_trap
	name = "ward"
	desc = "Creates the Blood Trap to protect tremere or his domain."
	icon_state = "rune2"
	word = "DUH'K-A'U"

/obj/ritual_rune/thaumaturgy/blood_trap/complete()
	. = ..()
	if(!activated)
		activated = TRUE
		alpha = 28
		AddElement(/datum/element/connect_loc, list(COMSIG_ATOM_ENTERED = PROC_REF(on_crossed)))

/obj/ritual_rune/thaumaturgy/blood_trap/proc/on_crossed(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(isliving(arrived) && activated)
		var/mob/living/L = arrived
		L.adjust_fire_loss(50 + activator_bonus)
		playsound(loc, 'modular_darkpack/modules/powers/sounds/thaum.ogg', 50, FALSE)
		qdel(src)

/obj/ritual_rune/thaumaturgy/blood_trap/Destroy()
	if(loc)
		UnregisterSignal(loc, COMSIG_ATOM_ENTERED)
	return ..()

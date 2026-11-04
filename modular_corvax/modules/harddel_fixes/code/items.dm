/// The feed effect stayed in active_displays and vis_contents when the camera turned off without an appearance update
/obj/machinery/status_display/evac/proc/on_greenscreen_deleted(obj/effect/abstract/greenscreen_display/display)
	SIGNAL_HANDLER
	vis_contents -= display
	LAZYREMOVE(active_displays, display)
	update_appearance()

/// Corpses keep their weapon vars, a weapon taken and later deleted could only be hard deleted
/mob/living/carbon/human/npc/proc/forget_sticky_item(obj/item/item)
	SIGNAL_HANDLER
	if(my_weapon == item)
		my_weapon = null
	if(my_backup_weapon == item)
		my_backup_weapon = null
	LAZYREMOVE(drop_on_death_list, item)

/// The urn held its owner and the power held the urn, smashing it or deleting the owner left a hard delete behind
/obj/item/urn/proc/set_owner(mob/living/new_owner)
	own = new_owner
	RegisterSignal(new_owner, COMSIG_QDELETING, PROC_REF(on_owner_deleted))

/obj/item/urn/proc/on_owner_deleted(datum/source)
	SIGNAL_HANDLER
	own = null

/datum/discipline_power/serpentis/the_heart_of_darkness/proc/on_urn_deleted(datum/source)
	SIGNAL_HANDLER
	urn = null

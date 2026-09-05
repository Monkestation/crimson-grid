/mob/living/Initialize(mapload)
	. = ..()
	replace_storyteller_stats(create_new_stat_prefs(storyteller_stats))
	become_area_sensitive(ZONE_TRAIT)
	update_zone_hud(src, get_area(src)) // AREAS - (Zone hud)

/mob/living/Destroy(force)
	clear_storyteller_stats()
	beastmaster_minions = null
	minion_command_components = null
	QDEL_LAZYLIST(splats)
	return ..()

/mob/living/set_pull_offsets(mob/living/mob_to_set, grab_state = GRAB_PASSIVE, animate = TRUE)
	. = ..()
	SEND_SIGNAL(mob_to_set, COMSIG_LIVING_SET_PULL_OFFSET)

/mob/living/reset_pull_offsets(mob/living/M, override)
	. = ..()
	SEND_SIGNAL(M, COMSIG_LIVING_RESET_PULL_OFFSETS)

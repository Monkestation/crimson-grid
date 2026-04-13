/area/vtm
	name = CITY_NAME
	icon = 'modular_darkpack/modules/areas/icons/areas.dmi'
	icon_state = "sewer"
	requires_power = FALSE
	default_gravity = STANDARD_GRAVITY
	outdoors = TRUE
	var/zone_type = ZONE_MASQUERADE

	// 7 is an average city street.
	/// The rating of the gauntlet, the Gauntlet is strongest near certain types of environments
	var/gauntlet_rating = 7 // WEREWOLF

	// is this able to be classified as a domain? e.g, territorial flaw, later political implementation
	var/domain = FALSE

/area/vtm/powered(chan)
	if (!requires_power)
		return TRUE
	return FALSE

/area/vtm/proc/break_elysium()
	if (zone_type != ZONE_MASQUERADE)
		return

	zone_type = ZONE_NO_MASQUERADE
	addtimer(CALLBACK(src, PROC_REF(restore_elysium)), 3 MINUTES)

/area/vtm/proc/restore_elysium()
	if (zone_type != ZONE_NO_MASQUERADE)
		return

	zone_type = ZONE_MASQUERADE

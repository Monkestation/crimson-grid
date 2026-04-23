/mob/living/register_init_signals()
	. = ..()
	RegisterSignal(src, COMSIG_ENTER_AREA, PROC_REF(update_zone_hud))

/mob/living/proc/update_zone_hud(mob/source, area/new_area)
	SIGNAL_HANDLER

	var/atom/movable/screen/zone_hud = hud_used?.screen_objects[HUD_MOB_ZONE]
	if(zone_hud)
		if(!istype(new_area, /area/vtm))
			return
		var/area/vtm/our_area = new_area
		zone_hud.icon_state = "[our_area.zone_type]"

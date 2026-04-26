#define ui_zone_hud "TOP-0:-8,CENTER-0:-8"
/atom/movable/screen/zone_hud
	name = "zone"
	icon = 'modular_darkpack/modules/areas/icons/zone_hud.dmi'
	icon_state = "masquerade"
	alpha = 32
	screen_loc = ui_zone_hud

/mob/living/proc/update_zone_hud(mob/source, area/new_area)
	SIGNAL_HANDLER

	var/atom/movable/screen/zone_hud = hud_used?.screen_objects[HUD_MOB_ZONE]
	if(zone_hud)
		if(!istype(new_area, /area/vtm))
			return
		var/area/vtm/our_area = new_area
		zone_hud.icon_state = "[our_area.zone_type]"
#undef ui_zone_hud

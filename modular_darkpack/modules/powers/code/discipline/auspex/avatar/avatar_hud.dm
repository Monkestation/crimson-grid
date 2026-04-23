#define HUD_AVATAR_REENTER_CORPSE "avatar_reenter_corpse"
/datum/hud/avatar
	needs_health_indicator = FALSE

/datum/hud/avatar/initialize_screen_objects()
	. = ..()

	add_screen_object(/atom/movable/screen/avatar/reenter_corpse, HUD_AVATAR_REENTER_CORPSE, HUD_GROUP_STATIC)
	add_screen_object(/atom/movable/screen/combattoggle/flashy, HUD_MOB_INTENTS, HUD_GROUP_STATIC, ui_style, ui_loc = ui_ghost_dnr)
	add_screen_object(/atom/movable/screen/floor_changer/vertical, HUD_MOB_FLOOR_CHANGER, HUD_GROUP_STATIC, ui_style, ui_ghost_teleport)


/atom/movable/screen/avatar/reenter_corpse
	name = "Reenter corpse"
	icon = 'modular_darkpack/master_files/icons/hud/screen_ghost.dmi'
	icon_state = "reenter_corpse"
	screen_loc = ui_ghost_reenter_corpse

/atom/movable/screen/avatar/reenter_corpse/Click(location, control, params)
	. = ..()

	var/mob/living/basic/avatar/clicking_avatar = astype(usr)
	clicking_avatar?.reenter_corpse()

#undef HUD_AVATAR_REENTER_CORPSE

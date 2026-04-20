#define HUD_AVATAR_REENTER_CORPSE "avatar_reenter_corpse"
/datum/hud/avatar/initialize_screen_objects()
	. = ..()

	add_screen_object(/atom/movable/screen/avatar/reenter_corpse, HUD_AVATAR_REENTER_CORPSE)
	add_screen_object(/atom/movable/screen/floor_changer/vertical, HUD_MOB_FLOOR_CHANGER, HUD_GROUP_STATIC, ui_style, ui_ghost_floor_changer)


/atom/movable/screen/avatar/reenter_corpse
	name = "Reenter corpse"
	icon = 'icons/hud/screen_ghost.dmi'
	icon_state = "reenter_corpse"

/atom/movable/screen/avatar/reenter_corpse/Click(location, control, params)
	. = ..()

	var/mob/living/basic/avatar/clicking_avatar = astype(usr)
	clicking_avatar?.reenter_corpse()

#undef HUD_AVATAR_REENTER_CORPSE

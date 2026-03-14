
/datum/hud/avatar/New(mob/owner)
	..()
	var/atom/movable/screen/using

	using = new /atom/movable/screen/avatar/reenter_corpse(null, src)
	using.screen_loc = ui_ghost_reenter_corpse
	static_inventory += using

	floor_change = new /atom/movable/screen/floor_changer/vertical(null, src)
	floor_change.screen_loc = ui_ghost_floor_changer
	static_inventory += floor_change

/datum/hud/avatar/show_hud(version = 0, mob/viewmob)
	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	screenmob.client.screen += static_inventory

/atom/movable/screen/avatar/reenter_corpse
	name = "Reenter corpse"
	icon = 'icons/hud/screen_ghost.dmi'
	icon_state = "reenter_corpse"

/atom/movable/screen/avatar/reenter_corpse/Click()
	var/mob/living/basic/avatar/G = usr
	G.reenter_corpse()

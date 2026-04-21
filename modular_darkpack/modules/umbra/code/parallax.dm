/atom/movable/screen/parallax_layer/umbra
	icon_state = "umbra"
	blend_mode = BLEND_OVERLAY
	absolute = TRUE //Status of seperation
	speed = 0.6
	layer = 3

/atom/movable/screen/parallax_layer/umbra/Initialize(mapload, datum/hud/hud_owner, client/owner)
	. = ..()
	if(!owner)
		return
	var/static/list/connections = list(
		COMSIG_MOVABLE_Z_CHANGED = PROC_REF(on_z_change),
		COMSIG_MOB_LOGOUT = PROC_REF(on_mob_logout),
	)
	AddComponent(/datum/component/connect_mob_behalf, owner, connections)
	on_z_change(owner.mob)

/atom/movable/screen/parallax_layer/umbra/proc/on_mob_logout(mob/source)
	SIGNAL_HANDLER
	var/client/boss = source.canon_client
	on_z_change(boss.mob)

/atom/movable/screen/parallax_layer/umbra/proc/on_z_change(mob/source)
	SIGNAL_HANDLER
	var/client/boss = source.client
	var/turf/posobj = get_turf(boss?.eye)
	if(!posobj)
		return
	SetInvisibility(is_mining_level(posobj.z) ? INVISIBILITY_NONE : INVISIBILITY_ABSTRACT, id=type)

/*
/atom/movable/screen/parallax_layer/umbra/update_o()
	return //Shit won't move
*/

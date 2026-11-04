//Component that adds an exclamation mark to things that have caused you to breach the masquerade.
/datum/component/masquerade_hud
	dupe_mode = COMPONENT_DUPE_ALLOWED
	// CORVAX EDIT CHANGE START - a client reference outlived the disconnect and hard deleted the client. ORIGINAL: var/client/masquerade_breacher
	var/masquerade_breacher_ckey
	var/image/new_masquerade_image

/datum/component/masquerade_hud/Initialize(mob/_masquerade_breacher)
	if(!_masquerade_breacher.client)
		return COMPONENT_INCOMPATIBLE

	masquerade_breacher_ckey = _masquerade_breacher.ckey
	// CORVAX EDIT CHANGE END

	RegisterSignal(parent, COMSIG_MASQUERADE_HUD_DELETE, PROC_REF(delete_myself))

	create_masquerade_overlay()

/datum/component/masquerade_hud/proc/delete_myself(atom/source, mob/player_breacher)
	SIGNAL_HANDLER

	if((masquerade_breacher_ckey == player_breacher.ckey) || !GLOB.directory[masquerade_breacher_ckey]) // CORVAX EDIT CHANGE - ORIGINAL: if((masquerade_breacher == player_breacher.client) || !masquerade_breacher)
		qdel(src)

/datum/component/masquerade_hud/Destroy(force)
	UnregisterSignal(parent, COMSIG_MASQUERADE_HUD_DELETE)
	// CORVAX EDIT CHANGE START - ORIGINAL: worked on the stored client var
	var/client/masquerade_breacher = GLOB.directory[masquerade_breacher_ckey]
	masquerade_breacher?.images -= new_masquerade_image
	if(masquerade_breacher)
		remove_image_from_client(new_masquerade_image, masquerade_breacher)
	// CORVAX EDIT CHANGE END
	new_masquerade_image = null
	return ..()

/datum/component/masquerade_hud/proc/create_masquerade_overlay()
	SIGNAL_HANDLER

	var/atom/atom_parent = parent
	if(!new_masquerade_image)
		new_masquerade_image = image(icon = 'icons/obj/storage/closet.dmi', loc = atom_parent, icon_state = "cardboard_special", layer = ABOVE_ALL_MOB_LAYER, pixel_z = 32)
	add_image_to_client(new_masquerade_image, GLOB.directory[masquerade_breacher_ckey]) // CORVAX EDIT CHANGE - ORIGINAL: add_image_to_client(new_masquerade_image, masquerade_breacher)

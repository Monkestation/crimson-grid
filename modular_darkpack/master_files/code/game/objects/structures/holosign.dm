
/obj/structure/holosign/barrier/police_tape
	name = "police barrier tape"
	desc = "A length of fragile police tape used for crowd control and blocking crime scenes. Can only be passed by walking."
	icon = 'modular_darkpack/master_files/icons/effects/holosigns.dmi'
	icon_state = "barrier_police-0"
	base_icon_state = "barrier_police"
	smoothing_flags = SMOOTH_BITMASK_CARDINALS
	smoothing_groups = SMOOTH_GROUP_POLICE_TAPE
	canSmoothWith = SMOOTH_GROUP_POLICE_TAPE
	max_integrity = 5 // break in one hit
	openable = FALSE
	use_vis_overlay = FALSE

/obj/structure/holosign/barrier/police_tape/Initialize(mapload, source_projector)
	. = ..()
	qdel(GetComponent((/datum/component/holographic_nature)))

/obj/structure/holosign/barrier/police_tape/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	playsound(src, 'sound/items/poster/poster_ripped.ogg', 50, 1)

/obj/structure/holosign/barrier/police_tape/update_icon_state()
	SHOULD_CALL_PARENT(FALSE)
	return SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_ICON_STATE)

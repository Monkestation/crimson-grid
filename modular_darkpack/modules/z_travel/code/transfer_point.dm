GLOBAL_LIST_EMPTY(unallocted_transfer_points)

/obj/transfer_point_vamp
	icon = 'modular_darkpack/modules/z_travel/icons/z_travel.dmi'
	icon_state = "matrix_go"
	name = "transfer point"
	plane = GAME_PLANE
	layer = ABOVE_NORMAL_TURF_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	/// Sister transfer point
	var/obj/transfer_point_vamp/exit
	/// ID used for linking to other transfer points
	var/id = 1
	/// Dont allow people to take this transfer point. It can only be used as an exit
	var/one_way = FALSE
	/// Skipped by checks for allocated transfer points
	var/unit_test_exempt = FALSE

/obj/transfer_point_vamp/Initialize(mapload)
	. = ..()
	if(id && !exit)
		if(isnum(id))
			// Im considering them bad practice because you cant tell where they lead - Fallcon
			log_mapping("[src] has a ID of [id]. Numbers are bad practice")
		GLOB.unallocted_transfer_points += src
		for(var/obj/transfer_point_vamp/other_point in GLOB.unallocted_transfer_points)
			if(other_point.id == id && other_point != src)
				exit = other_point
				GLOB.unallocted_transfer_points -= other_point
				other_point.exit = src
				GLOB.unallocted_transfer_points -= src
				break

/obj/transfer_point_vamp/Destroy(force)
	GLOB.unallocted_transfer_points -= src
	if(!QDELETED(exit))
		QDEL_NULL(exit)

	return ..()

/obj/transfer_point_vamp/vv_edit_var(var_name, var_value)
	. = ..()
	if(var_name == NAMEOF(src, exit))
		if(istype(var_value, /obj/transfer_point_vamp))
			var/obj/transfer_point_vamp/new_exit = var_value
			new_exit.exit = src

/obj/transfer_point_vamp/Bumped(atom/movable/bumped_atom)
	. = ..()
	transfer_atom(bumped_atom)

/obj/transfer_point_vamp/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(Adjacent(user))
		transfer_atom(user)

// Ignore any checks or safties, including one-ways. We dont care about those for ghosts.
/obj/transfer_point_vamp/attack_ghost(mob/user)
	. = ..()
	if(.)
		return
	if(exit)
		user.forceMove(get_turf(exit))

/obj/transfer_point_vamp/proc/transfer_atom(atom/movable/arrived)
	if(!exit || one_way)
		return
	var/moved_dir = get_dir(arrived, src)
	var/turf/exit_turf
	exit_turf = get_open_turf_in_dir(exit, moved_dir)
	if(!exit_turf)
		exit_turf = get_turf(exit)

	var/atom/movable/moving_stuff = arrived.get_teleport_move_affected()
	for(var/atom/movable/moving in moving_stuff)
		moving.forceMove(exit_turf)

// Use inside the umbra. visible
/obj/transfer_point_vamp/umbral
	name = "portal"
	icon = 'modular_darkpack/modules/deprecated/icons/48x48.dmi'
	icon_state = "portal"
	plane = ABOVE_LIGHTING_PLANE
	//layer = ABOVE_LIGHTING_LAYER
	pixel_w = -8

// Use in the base map/outside the umbra. Invisible
/obj/transfer_point_vamp/umbral/exit
	name = "umbral exit"
	invisibility = INVISIBILITY_OBSERVER
	density = FALSE
	one_way = TRUE

/obj/transfer_point_vamp/umbral/Initialize(mapload)
	. = ..()
	if(!one_way)
		set_light(2, 1, "#a4a0fb")
		apply_wibbly_filters(src)

/obj/transfer_point_vamp/umbral/transfer_atom(atom/movable/arrived)
	. = ..()
	if(!.)
		return
	// dont spam from ghosts or random objects
	if(!isliving(arrived))
		return
	playsound(src, 'modular_darkpack/modules/deprecated/sounds/portal_enter.ogg', 75, FALSE)
	if(exit)
		playsound(exit, 'modular_darkpack/modules/deprecated/sounds/portal_enter.ogg', 75, FALSE)

// PLEASE PLEASE dont use this if you could just use real stairs instead or map the area sanely.
/obj/transfer_point_vamp/stairs
	name = "stairs"
	icon_state = "stairs"
	icon = 'modular_darkpack/master_files/icons/obj/stairs.dmi'

// Only subtyped here so admins can easily spawn them in the real map.
/obj/transfer_point_vamp/stairs/admin_theatre_1
	id = "admin_theatre_1"
	unit_test_exempt = TRUE // These are meant to spawn missing their sister
/obj/transfer_point_vamp/stairs/admin_theatre_2
	id = "admin_theatre_2"
	unit_test_exempt = TRUE

/obj/transfer_point_vamp/backrooms
	id = "backrooms"
	invisibility = INVISIBILITY_OBSERVER

/obj/transfer_point_vamp/backrooms/map
	density = FALSE
	one_way = TRUE

/datum/discipline/path/mind_movement
	name = "Movement of the Mind"
	desc = "todo"
	icon_state = "flames"
	power_type = /datum/discipline_power/thaumaturgy/path/mind_movement


/datum/discipline_power/thaumaturgy/path/mind_movement
	name = "Movement of the Mind Power Name"
	desc = "Movement of the Mind Power Description"

	effect_sound = 'modular_darkpack/modules/paths/sounds/fireball.ogg'

/datum/discipline_power/thaumaturgy/path/mind_movement/one
	level = 1

/datum/discipline_power/thaumaturgy/path/mind_movement/two
	level = 2

/datum/discipline_power/thaumaturgy/path/mind_movement/three
	level = 3

/datum/discipline_power/thaumaturgy/path/mind_movement/four
	level = 4

/datum/discipline_power/thaumaturgy/path/mind_movement/five
	name = "Control"
	desc = "Force a person or an object to move at your will."
	level = 5
	cooldown_length = 20 SECONDS
	violates_masquerade = TRUE
	target_type = TARGET_OBJ | TARGET_LIVING
	range = 3

/datum/discipline_power/thaumaturgy/path/mind_movement/five/activate(atom/target)
	. = ..()
	if(.)
		return
	owner.apply_status_effect(/datum/status_effect/control_grab, target)

/datum/status_effect/control_grab
	id = "control"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null

	/// Atom we grabbed with kinesis.
	var/atom/movable/grabbed_atom
	/// Our mouse movement catcher.
	var/atom/movable/screen/fullscreen/cursor_catcher/control/mouse_catcher
	/// Overlay we add to each grabbed atom.
	var/mutable_appearance/kinesis_icon

/atom/movable/screen/fullscreen/cursor_catcher/control
	icon_state = "kinesis"

/datum/status_effect/control_grab/on_creation(mob/living/new_owner, atom/movable/target)
	grabbed_atom = target
	. = ..()

/datum/status_effect/control_grab/on_apply()
	. = ..()
	grab_atom()

/datum/status_effect/control_grab/on_remove()
	. = ..()
	clear_grab()

/datum/status_effect/control_grab/proc/grab_atom()
	if(isliving(grabbed_atom))
		grabbed_atom.add_traits(list(TRAIT_IMMOBILIZED), REF(src))
	RegisterSignal(grabbed_atom, COMSIG_MOVABLE_SET_ANCHORED, PROC_REF(on_setanchored))
	kinesis_icon = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "kinesis", layer = grabbed_atom.layer - 0.1, appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART)
	kinesis_icon.overlays += emissive_appearance(icon = 'icons/effects/effects.dmi', icon_state = "kinesis", offset_spokesman = grabbed_atom)
	grabbed_atom.add_overlay(kinesis_icon)
	mouse_catcher = owner.overlay_fullscreen("kinesis", /atom/movable/screen/fullscreen/cursor_catcher/kinesis, 0)
	mouse_catcher.assign_to_mob(owner)

	RegisterSignal(mouse_catcher, COMSIG_SCREEN_ELEMENT_CLICK, PROC_REF(on_catcher_click))

/datum/status_effect/control_grab/proc/clear_grab()
	if(!grabbed_atom)
		return
	. = grabbed_atom
	UnregisterSignal(grabbed_atom, list(COMSIG_MOVABLE_SET_ANCHORED))
	mouse_catcher = null
	if(isliving(grabbed_atom))
		grabbed_atom.remove_traits(list(TRAIT_IMMOBILIZED), REF(src))
	if(!isitem(grabbed_atom))
		animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x, pixel_y = grabbed_atom.base_pixel_y)
	owner.clear_fullscreen("kinesis")
	grabbed_atom.cut_overlay(kinesis_icon)
	grabbed_atom = null
	qdel(src)


/datum/status_effect/control_grab/proc/range_check(atom/target)
	if(!isturf(owner.loc))
		return FALSE
	if(ismovable(target) && !isturf(target.loc))
		return FALSE
	if(!can_see(owner, target, 10))
		return FALSE
	return TRUE

/datum/status_effect/control_grab/proc/on_catcher_click(atom/source, location, control, params, user)
	SIGNAL_HANDLER

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		var/launched_object = grabbed_atom
		if(mouse_catcher.mouse_params)
			mouse_catcher.calculate_params()
		if(!mouse_catcher.given_turf)
			clear_grab()
			return
		var/turf/target_turf = mouse_catcher.given_turf
		clear_grab()
		launch(launched_object, target_turf)
		return

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(!grabbed_atom)
			return
		move_target()
		return

/datum/status_effect/control_grab/proc/move_target()
	if(!owner.client || INCAPACITATED_IGNORING(owner, INCAPABLE_GRAB))
		clear_grab()
		return
	if(!range_check(grabbed_atom))
		owner.balloon_alert(owner, "out of range!")
		clear_grab()
		return
	if(mouse_catcher.mouse_params)
		mouse_catcher.calculate_params()
	if(!mouse_catcher.given_turf)
		return
	owner.setDir(get_dir(owner, grabbed_atom))
	if(grabbed_atom.loc == mouse_catcher.given_turf)
		if(grabbed_atom.pixel_x == mouse_catcher.given_x - ICON_SIZE_X/2 && grabbed_atom.pixel_y == mouse_catcher.given_y - ICON_SIZE_Y/2)
			return
		animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x + mouse_catcher.given_x - ICON_SIZE_X/2, pixel_y = grabbed_atom.base_pixel_y + mouse_catcher.given_y - ICON_SIZE_Y/2)
		return
	animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x + mouse_catcher.given_x - ICON_SIZE_X/2, pixel_y = grabbed_atom.base_pixel_y + mouse_catcher.given_y - ICON_SIZE_Y/2)
	var/turf/next_turf = get_step_towards(grabbed_atom, mouse_catcher.given_turf)
	if(grabbed_atom.Move(next_turf, get_dir(grabbed_atom, next_turf), 8))
		if(isitem(grabbed_atom) && (owner in next_turf))
			var/obj/item/grabbed_item = grabbed_atom
			clear_grab()
			grabbed_item.pickup(owner)
			owner.put_in_hands(grabbed_item)
		return

	var/pixel_x_change = 0
	var/pixel_y_change = 0
	var/direction = get_dir(grabbed_atom, next_turf)
	if(direction & NORTH)
		pixel_y_change = ICON_SIZE_Y/2
	else if(direction & SOUTH)
		pixel_y_change = -ICON_SIZE_Y/2
	if(direction & EAST)
		pixel_x_change = ICON_SIZE_X/2
	else if(direction & WEST)
		pixel_x_change = -ICON_SIZE_X/2
	animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x + pixel_x_change, pixel_y = grabbed_atom.base_pixel_y + pixel_y_change)

/datum/status_effect/control_grab/proc/on_setanchored(atom/movable/grabbed_atom, anchorvalue)
	SIGNAL_HANDLER

	if(grabbed_atom.anchored)
		clear_grab()

/datum/status_effect/control_grab/proc/launch(atom/movable/launched_object, turf/launch_to)
	playsound(launched_object, 'sound/effects/magic/repulse.ogg', 100, TRUE)
	RegisterSignal(launched_object, COMSIG_MOVABLE_IMPACT, PROC_REF(launch_impact))
	launched_object.throw_at(launch_to, range = 10, speed = launched_object.density ? 3 : 4, thrower = owner, spin = isitem(launched_object))

//TODO: Rework to use rolls
/datum/status_effect/control_grab/proc/launch_impact(atom/movable/source, atom/hit_atom, datum/thrownthing/thrownthing)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_MOVABLE_IMPACT)

// lure of flames spellbooks
/obj/item/path_spellbook/movement_of_mind
	name = "Movement of the Mind spellbook"
	desc = "todo"
	icon_state = "flames_spellbook"
	path_type = /datum/discipline/path/mind_movement

/obj/item/path_spellbook/movement_of_mind/debug
	do_after_time = 1
	identified = 1

/obj/item/path_spellbook/movement_of_mind/debug/one
	path_level = 1

/obj/item/path_spellbook/movement_of_mind/debug/twp
	path_level = 2

/obj/item/path_spellbook/movement_of_mind/debug/three
	path_level = 3

/obj/item/path_spellbook/movement_of_mind/debug/four
	path_level = 4

/obj/item/path_spellbook/movement_of_mind/debug/five
	path_level = 5

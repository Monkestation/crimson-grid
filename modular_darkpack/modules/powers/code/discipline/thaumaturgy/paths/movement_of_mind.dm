/datum/discipline/path/mind_movement
	name = "Movement of the Mind"
	desc = "todo"
	icon_state = "mind"
	power_type = /datum/discipline_power/thaumaturgy/path/mind_movement

/datum/discipline_power/thaumaturgy/path/mind_movement
	name = "Movement of the Mind Power Name"
	desc = "Movement of the Mind Power Description"

	effect_sound = 'modular_darkpack/modules/paths/sounds/fireball.ogg'

/datum/discipline_power/thaumaturgy/path/mind_movement/proc/launch(atom/movable/launched_object, turf/launch_to)
	playsound(launched_object, 'sound/effects/magic/repulse.ogg', 100, TRUE)
	RegisterSignal(launched_object, COMSIG_MOVABLE_IMPACT, PROC_REF(on_impact))
	launched_object.throw_at(launch_to, range = 1 * success_count, speed = launched_object.density ? 3 : 4, thrower = owner, spin = isitem(launched_object))

//TODO: Rework to use rolls
/datum/discipline_power/thaumaturgy/path/mind_movement/proc/on_impact(atom/movable/source, atom/hit_atom, datum/thrownthing/thrownthing)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_MOVABLE_IMPACT)
	var/total_damage

	if(success_count > 0)
		total_damage = 5 * success_count

	if(!total_damage)
		return

	if(isliving(source))
		var/mob/living/living_source = source
		living_source.apply_damage(total_damage, BRUTE)

	if(isliving(hit_atom))
		var/mob/living/living_atom = hit_atom
		living_atom.apply_damage(total_damage, BRUTE)


// Force Bolt - Level 1
/datum/discipline_power/thaumaturgy/path/mind_movement/one
	name = "Force Bolt"
	desc = "Cause a target to fall down."
	level = 1
	violates_masquerade = TRUE
	target_type = TARGET_LIVING
	range = 5

/datum/discipline_power/thaumaturgy/path/mind_movement/one/activate(atom/target)
	. = ..()
	if(.)
		return
	var/mob/living/living_target = target

	to_chat(living_target, span_warning("You feel forced into the ground!"))
	launch(living_target, get_edge_target_turf(owner, get_dir(owner, get_step_away(living_target, owner))))
	living_target.Knockdown(5 SECONDS)

/datum/discipline_power/thaumaturgy/path/mind_movement/two
	name = "i forgot how its called"
	desc = "placeholder"
	level = 2
	violates_masquerade = TRUE
	target_type = NONE
	toggled = TRUE
	range = 5

/datum/discipline_power/thaumaturgy/path/mind_movement/two/activate(atom/target)
	. = ..()
	owner.dna.add_mutation(/datum/mutation/telekinesis, DISCIPLINE_TRAIT(type))

/datum/discipline_power/thaumaturgy/path/mind_movement/two/deactivate(atom/target, direct)
	. = ..()
	owner.dna.remove_mutation(/datum/mutation/telekinesis, DISCIPLINE_TRAIT(type))

/**
 * Flight - Level 3
 *
 * Simply lets the thaumaturge fly
 */
/datum/discipline_power/thaumaturgy/path/mind_movement/three
	name = "Flight"
	desc = "Hoist yourself into the air."
	level = 3
	check_flags = DISC_CHECK_CAPABLE
	cooldown_length = 5 SECONDS
	duration_length = 3 TURNS
	violates_masquerade = TRUE
	target_type = NONE
	toggled = TRUE

/datum/discipline_power/thaumaturgy/path/mind_movement/three/post_gain()
	. = ..()
	owner.AddComponent( \
		/datum/component/jetpack, \
		TRUE, \
		1 NEWTONS, \
		COMSIG_MIND_FLIGHT_ACTIVE, \
		COMSIG_MIND_FLIGHT_INACTIVE, \
		null, \
		CALLBACK(src, PROC_REF(can_fly)), \
		null, \
	)

/datum/discipline_power/thaumaturgy/path/mind_movement/three/activate(atom/target)
	. = ..()
	if(.)
		return

	SEND_SIGNAL(owner, COMSIG_MIND_FLIGHT_ACTIVE, owner)
	owner.add_traits(list(TRAIT_MOVE_FLOATING, TRAIT_IGNORING_GRAVITY, TRAIT_NOGRAV_ALWAYS_DRIFT), REF(src))
	owner.AddElement(/datum/element/forced_gravity, 0)
	owner.set_resting(FALSE, TRUE)
	owner.refresh_gravity()

/datum/discipline_power/thaumaturgy/path/mind_movement/three/deactivate(atom/target)
	. = ..()
	if(.)
		return
	SEND_SIGNAL(owner, COMSIG_MIND_FLIGHT_INACTIVE, owner)
	owner.remove_traits(list(TRAIT_MOVE_FLOATING, TRAIT_IGNORING_GRAVITY, TRAIT_NOGRAV_ALWAYS_DRIFT), REF(src))
	owner.RemoveElement(/datum/element/forced_gravity, 0)
	owner.refresh_gravity()

/// Can fly checks, we check these if we want to be unable to fly but keep ability active
/datum/discipline_power/thaumaturgy/path/mind_movement/three/proc/can_fly()
	var/mob/living/carbon/human/human = owner
	if(isnull(human.client) || human.body_position == LYING_DOWN)
		return FALSE
	return TRUE

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

	/// Atom we grabbed with kinesis.
	var/atom/movable/grabbed_atom
	/// Our mouse movement catcher.
	var/atom/movable/screen/fullscreen/cursor_catcher/control/mouse_catcher
	/// Overlay we add to each grabbed atom.
	var/mutable_appearance/kinesis_icon

/datum/discipline_power/thaumaturgy/path/mind_movement/five/activate(atom/target)
	. = ..()
	if(.)
		return
	grab_atom(target)

/atom/movable/screen/fullscreen/cursor_catcher/control
	icon_state = "kinesis"

/datum/discipline_power/thaumaturgy/path/mind_movement/five/proc/grab_atom(atom/target)
	grabbed_atom = target
	if(isliving(grabbed_atom))
		grabbed_atom.add_traits(list(TRAIT_IMMOBILIZED), REF(src))
	RegisterSignal(grabbed_atom, COMSIG_MOVABLE_SET_ANCHORED, PROC_REF(on_setanchored))
	kinesis_icon = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "kinesis", layer = grabbed_atom.layer - 0.1, appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM|KEEP_APART)
	kinesis_icon.overlays += emissive_appearance(icon = 'icons/effects/effects.dmi', icon_state = "kinesis", offset_spokesman = grabbed_atom)
	grabbed_atom.add_overlay(kinesis_icon)
	mouse_catcher = owner.overlay_fullscreen("kinesis", /atom/movable/screen/fullscreen/cursor_catcher/kinesis, 0)
	mouse_catcher.assign_to_mob(owner)

	RegisterSignal(mouse_catcher, COMSIG_SCREEN_ELEMENT_CLICK, PROC_REF(on_catcher_click))

/datum/discipline_power/thaumaturgy/path/mind_movement/five/proc/clear_grab()
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
	deactivate()

/datum/discipline_power/thaumaturgy/path/mind_movement/five/proc/range_check(atom/target)
	if(!isturf(owner.loc))
		return FALSE
	if(ismovable(target) && !isturf(target.loc))
		return FALSE
	if(!can_see(owner, target, 10))
		return FALSE
	return TRUE

/datum/discipline_power/thaumaturgy/path/mind_movement/five/proc/on_catcher_click(atom/source, location, control, params, user)
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

/datum/discipline_power/thaumaturgy/path/mind_movement/five/proc/move_target()
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

/datum/discipline_power/thaumaturgy/path/mind_movement/five/proc/on_setanchored(atom/movable/grabbed_atom, anchorvalue)
	SIGNAL_HANDLER

	if(grabbed_atom.anchored)
		clear_grab()

/**
 * Spellbooks
 *
 */
/obj/item/path_spellbook/movement_of_mind
	name = "Movement of the Mind spellbook"
	desc = "todo"
	icon = 'modular_vcg/modules/paths/icons/paths.dmi'
	icon_state = "mind_spellbook"
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

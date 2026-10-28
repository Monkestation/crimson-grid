/**
 * Movement of the Mind
 *
 * This is based on older editions of the path
 * Because it's easier to code and is just cooler
 *
 */
/datum/discipline/path/mind_movement
	name = "Movement of the Mind"
	desc = "A path of Thaumaturgy that allows user to move objects and beings telekinetically."
	icon_state = "mind"
	icon = 'modular_vcg/modules/paths/icons/paths.dmi'
	power_type = /datum/discipline_power/thaumaturgy/path/mind_movement

/datum/discipline_power/thaumaturgy/path/mind_movement
	name = "Movement of the Mind Power Name"
	desc = "Movement of the Mind Power Description"

	effect_sound = 'sound/effects/magic/repulse.ogg'

/// Handle launching the target
/datum/discipline_power/thaumaturgy/path/mind_movement/proc/launch(atom/movable/launched_object, turf/launch_to)
	RegisterSignal(launched_object, COMSIG_MOVABLE_IMPACT, PROC_REF(on_impact))

	var/throw_range = min(1 * success_count, isliving(launched_object) ? 3 : 6)

	launched_object.throw_at(launch_to, throw_range, launched_object.density ? 3 : 4, null, isitem(launched_object))

	if(isliving(launched_object))
		var/mob/living/living_target = launched_object
		living_target.Knockdown(5 SECONDS)

/// Do extra damage on impact or if the launched item hit a person, or if the launched person hit a dense object
/datum/discipline_power/thaumaturgy/path/mind_movement/proc/on_impact(atom/movable/source, atom/hit_atom, datum/thrownthing/thrownthing)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_MOVABLE_IMPACT)

	if(isliving(source) && hit_atom.density)
		var/mob/living/living_source = source
		living_source.apply_damage(1 LETHAL_TTRPG_DAMAGE, BRUTE)

	if(isliving(hit_atom))
		var/mob/living/living_atom = hit_atom
		living_atom.apply_damage(1 LETHAL_TTRPG_DAMAGE, BRUTE)

/**
 * Force Bolt - Level 1
 *
 * Knocks the person down. Very simple.
 *
 */
/datum/discipline_power/thaumaturgy/path/mind_movement/one
	name = "Force Bolt"
	desc = "Forces the target to fall."
	level = 1
	violates_masquerade = FALSE
	target_type = TARGET_LIVING
	range = 5

/datum/discipline_power/thaumaturgy/path/mind_movement/one/activate(atom/target)
	. = ..()
	if(.)
		return
	var/mob/living/living_target = target

	to_chat(living_target, span_warning("You feel forced into the ground!"))
	living_target.Knockdown(5 SECONDS)

/**
 * Manipulate - Level 2
 *
 * Works off just giving the thaumaturge telekinesis mutation.
 * You can't really check for mutation subtypes so there might be some jank with it's behavior from leftover tg code...
 *
 */
/datum/discipline_power/thaumaturgy/path/mind_movement/two
	name = "Manipulate"
	desc = "Manipulate allows the user to telekinetically control and use items."
	level = 2
	violates_masquerade = FALSE
	target_type = NONE
	toggled = TRUE

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
 *
 */
/datum/discipline_power/thaumaturgy/path/mind_movement/three
	name = "Flight"
	desc = "Allows the user to lift themselves up using telekinetic force and fly."
	level = 3
	cooldown_length = 5 SECONDS
	duration_length = 3 TURNS
	target_type = NONE
	toggled = TRUE

/datum/discipline_power/thaumaturgy/path/mind_movement/three/post_gain()
	. = ..()
	owner.AddComponent( \
		/datum/component/jetpack, \
		TRUE, \
		1.5 NEWTONS, \
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
	owner.add_traits(list(TRAIT_MOVE_FLOATING, TRAIT_PASSTABLE, TRAIT_IGNORING_GRAVITY, TRAIT_NOGRAV_ALWAYS_DRIFT), REF(src))
	owner.AddElement(/datum/element/forced_gravity, 0)
	owner.add_movespeed_modifier(/datum/movespeed_modifier/jetpack/wings)
	owner.set_resting(FALSE, TRUE)
	owner.refresh_gravity()

/datum/discipline_power/thaumaturgy/path/mind_movement/three/deactivate(atom/target)
	. = ..()
	if(.)
		return
	SEND_SIGNAL(owner, COMSIG_MIND_FLIGHT_INACTIVE, owner)
	owner.remove_traits(list(TRAIT_MOVE_FLOATING, TRAIT_PASSTABLE, TRAIT_IGNORING_GRAVITY, TRAIT_NOGRAV_ALWAYS_DRIFT), REF(src))
	owner.RemoveElement(/datum/element/forced_gravity, 0)
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/jetpack/wings)
	owner.refresh_gravity()

/// Can fly checks, we check these if we want to be unable to fly but keep ability active
/datum/discipline_power/thaumaturgy/path/mind_movement/three/proc/can_fly()
	var/mob/living/carbon/human/human = owner
	if(isnull(human.client) || human.body_position == LYING_DOWN)
		return FALSE
	return TRUE

/**
 * Repulse - Level 4
 *
 * Knocks back any item and person in the repulse range
 * While also dealing extra damage on impact
 *
 */
/datum/discipline_power/thaumaturgy/path/mind_movement/four
	name = "Repulse"
	desc = "Release a telekinetic wave, launching any living being and item away from yourself."
	level = 4
	target_type = NONE
	cooldown_length = 2 TURNS
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_TORPORED

	/// Range in which targets get repulsed
	var/repulse_range = 3

/datum/discipline_power/thaumaturgy/path/mind_movement/four/activate(atom/target)
	. = ..()
	if(.)
		return

	for(var/atom/to_throw in range(repulse_range, get_turf(owner)))
		if(to_throw == owner)
			continue
		if(!isitem(to_throw) && !isliving(to_throw))
			continue
		launch(to_throw, get_edge_target_turf(owner, get_dir(owner, get_step_away(to_throw, owner))))

/**
 * Control - Level 5
 *
 * Lets us move our target around and throw them at things
 * Can be resisted out of similar to aggressive grab
 * Code shamelessly stolen from kinesis module
 *
 */
/datum/discipline_power/thaumaturgy/path/mind_movement/five
	name = "Control"
	desc = "Force a person or an object to move at your will."
	level = 5
	cooldown_length = 2 TURNS
	violates_masquerade = TRUE
	target_type = TARGET_OBJ | TARGET_LIVING
	range = 5

	/// Atom we grabbed with kinesis.
	var/atom/movable/grabbed_atom
	/// Our mouse movement catcher.
	var/atom/movable/screen/fullscreen/cursor_catcher/control/mouse_catcher

/datum/discipline_power/thaumaturgy/path/mind_movement/five/activate(atom/target)
	. = ..()
	if(.)
		return
	grab_atom(target)

/datum/discipline_power/thaumaturgy/path/mind_movement/five/can_activate(atom/target)
	. = ..()
	if(grabbed_atom)
		to_chat("Let go of your target first!")
		return FALSE

	if(isobj(target))
		var/obj/target_obj = target
		if(target_obj.anchored)
			return FALSE

/atom/movable/screen/fullscreen/cursor_catcher/control

/// Do grab on the target, handle traits and signals
/datum/discipline_power/thaumaturgy/path/mind_movement/five/proc/grab_atom(atom/target)
	grabbed_atom = target
	if(isliving(grabbed_atom))
		to_chat(grabbed_atom, span_userdanger("You feel strange force lift you into the air!"))
		grabbed_atom.add_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), REF(src))
		RegisterSignal(grabbed_atom, COMSIG_LIVING_RESIST, PROC_REF(on_resist))

	RegisterSignal(grabbed_atom, COMSIG_MOVABLE_SET_ANCHORED, PROC_REF(on_setanchored))
	RegisterSignal(grabbed_atom, COMSIG_MOVABLE_MOVED, PROC_REF(on_target_moved))
	mouse_catcher = owner.overlay_fullscreen("control", /atom/movable/screen/fullscreen/cursor_catcher/control, 0)
	mouse_catcher.assign_to_mob(owner)

	RegisterSignal(mouse_catcher, COMSIG_SCREEN_ELEMENT_CLICK, PROC_REF(on_catcher_click))

	owner.add_traits(list(TRAIT_IMMOBILIZED), REF(src))
	RegisterSignals(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_ATOM_ATTACKBY, COMSIG_MOB_ITEM_ATTACK, COMSIG_PROJECTILE_PREHIT), PROC_REF(break_concentration))

	// Animate getting lifted up
	animate(grabbed_atom, 0.8 SECONDS, pixel_y = grabbed_atom.base_pixel_y + 10)
	owner.setDir(get_dir(owner, grabbed_atom))

	to_chat(owner, span_notice("You concentrate to lift [grabbed_atom.name] into the air! Right-click to let go of your target or launch them."))

/// Undo the grab, first clear any effects from us and then handle target
/datum/discipline_power/thaumaturgy/path/mind_movement/five/proc/clear_grab()
	UnregisterSignal(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_ATOM_ATTACKBY, COMSIG_MOB_ITEM_ATTACK, COMSIG_PROJECTILE_PREHIT))
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, REF(src))
	mouse_catcher = null
	owner.clear_fullscreen("control")
	deactivate()

	if(!grabbed_atom)
		return
	UnregisterSignal(grabbed_atom, list(COMSIG_MOVABLE_SET_ANCHORED, COMSIG_MOVABLE_MOVED, COMSIG_LIVING_RESIST))
	if(isliving(grabbed_atom))
		grabbed_atom.remove_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), REF(src))
	if(!isitem(grabbed_atom))
		animate(grabbed_atom, 0.2 SECONDS, pixel_x = grabbed_atom.base_pixel_x, pixel_y = grabbed_atom.base_pixel_y)
	grabbed_atom = null

/// If we are attacked/moved we let go of the grab
/datum/discipline_power/thaumaturgy/path/mind_movement/five/proc/break_concentration()
	SIGNAL_HANDLER

	to_chat(owner, span_warning("Being attacked breaks your concentration!"))
	clear_grab()

/datum/discipline_power/thaumaturgy/path/mind_movement/five/proc/range_check(atom/target)
	if(ismovable(target) && !isturf(target.loc))
		return FALSE
	if(!can_see(owner, target, 5))
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
			INVOKE_ASYNC(src, PROC_REF(clear_grab))
			return
		var/turf/target_turf = mouse_catcher.given_turf
		INVOKE_ASYNC(src, PROC_REF(clear_grab))
		// Don't launch if we are putting them on turf they are on
		if(!(launched_object in target_turf))
			launch(launched_object, target_turf)
		return

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		if(!grabbed_atom)
			return
		INVOKE_ASYNC(src, PROC_REF(move_target))
		return

/datum/discipline_power/thaumaturgy/path/mind_movement/five/proc/move_target()
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

/datum/discipline_power/thaumaturgy/path/mind_movement/five/proc/on_target_moved(atom/target)
	SIGNAL_HANDLER

	if(!range_check(target))
		owner.balloon_alert(owner, "out of range!")
		clear_grab()

/// Handles resisting the control grab
/datum/discipline_power/thaumaturgy/path/mind_movement/five/proc/on_resist(mob/living/resisting)
	SIGNAL_HANDLER

	var/datum/storyteller_roll/telekinesis_caster/control_roll = new()
	var/control_result = control_roll.st_roll(owner, resisting)

	var/datum/storyteller_roll/resisting_telekinesis/resist_roll = new()
	var/resist_result = resist_roll.st_roll(resisting, owner)

	if(resist_result > control_result)
		clear_grab()

/datum/storyteller_roll/telekinesis_caster
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	numerical = TRUE
	spammy_roll = TRUE

/datum/storyteller_roll/resisting_telekinesis
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	numerical = TRUE
	spammy_roll = TRUE

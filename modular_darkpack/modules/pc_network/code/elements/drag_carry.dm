/datum/element/drag_carry
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH_ON_HOST_DESTROY
	argument_hash_start_idx = 2
	/// If TRUE, the object can only be carried with two hands
	var/force_two_handed = FALSE
	/// Slowdown applied to the carrier while holding it (0 = none)
	var/carry_slowdown = 0
	/// Damage dealt to whatever it hits when thrown (0 = harmless)
	var/throw_damage = 0
	/// How long picking it up and placing it down takes (0 = instant)
	var/do_after_time = 0

/datum/element/drag_carry/Attach(datum/target, force_two_handed = FALSE, carry_slowdown = 0, throw_damage = 0, do_after_time = 0)
	. = ..()
	// Items can already be picked up, this is only for everything else.
	if(!isobj(target) || isitem(target))
		return ELEMENT_INCOMPATIBLE
	src.force_two_handed = force_two_handed
	src.carry_slowdown = carry_slowdown
	src.throw_damage = throw_damage
	src.do_after_time = do_after_time
	RegisterSignal(target, COMSIG_MOUSEDROP_ONTO, PROC_REF(on_mousedrop))

/datum/element/drag_carry/Detach(datum/source, ...)
	UnregisterSignal(source, COMSIG_MOUSEDROP_ONTO)
	return ..()

///slaps belly
/datum/element/drag_carry/proc/on_mousedrop(obj/source, atom/over, mob/user, params)
	SIGNAL_HANDLER

	if(over != user || !isliving(user))
		return NONE
	if(!isturf(source.loc))
		return NONE

	// do_after sleeps, so it can't run inside the signal handler
	INVOKE_ASYNC(src, PROC_REF(try_pickup), source, user)
	return COMPONENT_CANCEL_MOUSEDROP_ONTO

/datum/element/drag_carry/proc/can_pickup(obj/source, mob/living/carrier)
	if(QDELETED(source) || QDELETED(carrier) || !isturf(source.loc))
		return FALSE
	if(source.anchored)
		source.balloon_alert(carrier, "it's anchored!")
		return FALSE
	if(!carrier.can_perform_action(source, NEED_HANDS))
		return FALSE
	if(force_two_handed && length(carrier.get_empty_held_indexes()) < 2)
		source.balloon_alert(carrier, "need both hands free!")
		return FALSE
	return TRUE

///im so full of do_afters
/datum/element/drag_carry/proc/try_pickup(obj/source, mob/living/carrier)
	if(!can_pickup(source, carrier))
		return

	if(do_after_time)
		carrier.visible_message(
			span_notice("[carrier] starts picking up [source]."),
			span_notice("You start picking up [source]..."),
		)
		if(!do_after(carrier, do_after_time, source))
			return
		if(!can_pickup(source, carrier))
			return

	var/turf/origin = source.loc
	var/obj/item/carried_object/holder = new(origin, source, force_two_handed, carry_slowdown, throw_damage, do_after_time)
	if(!carrier.put_in_hands(holder))
		holder.release(origin)
		source.balloon_alert(carrier, "can't pick up!")
		return

	carrier.visible_message(
		span_notice("[carrier] picks up [source]."),
		span_notice("You pick up [source]."),
	)

///evil ass proxy item that kills you.
/obj/item/carried_object
	name = "carried object"
	w_class = WEIGHT_CLASS_HUGE
	force = 0
	item_flags = NOBLUDGEON | SLOWS_WHILE_IN_HAND
	/// The real object being carried
	var/obj/carried
	/// How long placing the object down takes (0 = instant)
	var/place_time = 0
	/// No sprite in the hand itself, the carried overlay on the mob replaces it
	inhand_icon_state = null
	/// Scale of the overlay shown on the carrier
	var/carry_overlay_scale = 0.75
	/// How far (in pixels) the overlay shifts sideways when the carrier faces east/west
	var/carry_overlay_side_offset = 4
	/// Layer offset relative to the carrier: in front when facing south/east/west, behind when facing north
	var/carry_overlay_layer_step = 1
	/// Who we're currently showing the overlay on
	var/mob/living/overlay_carrier
	/// The overlay currently applied to overlay_carrier
	var/mutable_appearance/carry_overlay

/obj/item/carried_object/Initialize(mapload, obj/to_carry, two_handed = FALSE, carry_slowdown = 0, throw_damage = 0, do_after_time = 0)
	. = ..()
	if(!to_carry)
		return INITIALIZE_HINT_QDEL
	carried = to_carry
	carried.forceMove(src)

	//mitosis
	appearance = carried.appearance
	name = carried.name
	desc = carried.desc
	slowdown = carry_slowdown
	throwforce = throw_damage
	place_time = do_after_time
	if(!carry_slowdown)
		item_flags &= ~SLOWS_WHILE_IN_HAND

	if(two_handed)
		AddComponent(/datum/component/two_handed, require_twohands = TRUE)

	RegisterSignal(src, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(on_item_interaction))
	RegisterSignal(src, COMSIG_MOVABLE_THROW_LANDED, PROC_REF(on_throw_landed))
	RegisterSignal(src, COMSIG_ITEM_EQUIPPED, PROC_REF(on_user_equipped))

/obj/item/carried_object/Destroy()
	remove_carry_overlay()
	drop_carried(get_turf(src))
	return ..()

/// If the real object gets deleted or otherwise leaves us like my wife, the proxy has no reason to exist.
/obj/item/carried_object/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == carried)
		carried = null
		if(!QDELETED(src))
			qdel(src)

/// Put the real object into the world at location, then delete the proxy.
/obj/item/carried_object/proc/release(atom/location)
	drop_carried(location)
	if(!QDELETED(src))
		qdel(src)

/// Move the real object out of the proxy.
/obj/item/carried_object/proc/drop_carried(atom/location)
	if(!carried)
		return
	var/obj/released = carried
	carried = null
	if(!location)
		qdel(released)
		return
	released.forceMove(location)
	released.pixel_x = released.base_pixel_x
	released.pixel_y = released.base_pixel_y

/obj/item/carried_object/proc/on_item_interaction(datum/source, mob/living/user, atom/interacting_with, list/modifiers)
	SIGNAL_HANDLER

	if(!isturf(interacting_with) || !istype(user) || !carried)
		return NONE
	if(!user.is_holding(src))
		return NONE

	var/turf/target_turf = interacting_with
	if(!user.Adjacent(target_turf))
		return NONE
	if(!can_place_on(target_turf))
		balloon_alert(user, "no room there!")
		return ITEM_INTERACT_BLOCKING

	// do_after sleeps, so it can't run inside the signal handler
	INVOKE_ASYNC(src, PROC_REF(try_place), user, target_turf)
	return ITEM_INTERACT_SUCCESS

/obj/item/carried_object/proc/try_place(mob/living/user, turf/target_turf)
	if(place_time)
		user.visible_message(
			span_notice("[user] starts placing [carried] down."),
			span_notice("You start placing [carried] down..."),
		)
		if(!do_after(user, place_time, target_turf))
			return
		if(QDELETED(src) || !carried || !user.is_holding(src))
			return
		if(!user.Adjacent(target_turf) || !can_place_on(target_turf))
			balloon_alert(user, "no room there!")
			return

	if(!user.transferItemToLoc(src, target_turf, silent = TRUE))
		return

	var/obj/placed = carried
	user.visible_message(
		span_notice("[user] places [placed] down."),
		span_notice("You place [placed] down."),
	)
	release(target_turf)

/obj/item/carried_object/proc/on_throw_landed(datum/source, datum/thrownthing/throwing)
	SIGNAL_HANDLER

	var/turf/landing = get_turf(src)
	if(!landing)
		return
	release(landing)

/obj/item/carried_object/dropped(mob/user, silent = FALSE)
	. = ..()
	remove_carry_overlay()
	addtimer(CALLBACK(src, PROC_REF(settle_dropped)), 0)

/obj/item/carried_object/proc/settle_dropped()
	if(QDELETED(src) || !carried || throwing)
		return
	if(ismob(loc)) // picked straight back up
		return
	release(get_turf(src))

/obj/item/carried_object/proc/on_user_equipped(datum/source, mob/user, slot)
	SIGNAL_HANDLER

	if(!(slot & ITEM_SLOT_HANDS) || !isliving(user))
		return
	remove_carry_overlay()
	overlay_carrier = user
	RegisterSignal(overlay_carrier, COMSIG_ATOM_DIR_CHANGE, PROC_REF(on_carrier_dir_change))
	update_carry_overlay()

/obj/item/carried_object/proc/on_carrier_dir_change(datum/source, old_dir, new_dir)
	SIGNAL_HANDLER

	update_carry_overlay(new_dir)

/obj/item/carried_object/proc/update_carry_overlay(facing)
	if(!overlay_carrier || !carried)
		return
	if(isnull(facing))
		facing = overlay_carrier.dir
	if(carry_overlay)
		overlay_carrier.cut_overlay(carry_overlay)

	var/x_offset = 0
	if(facing & EAST)
		x_offset = carry_overlay_side_offset
	else if(facing & WEST)
		x_offset = -carry_overlay_side_offset
	// Only facing straight north puts it behind the carrier
	var/behind = (facing & NORTH) && !(facing & (EAST|WEST))

	var/mutable_appearance/overlay = new(carried)
	overlay.plane = overlay_carrier.plane
	overlay.layer = overlay_carrier.layer + (behind ? -carry_overlay_layer_step : carry_overlay_layer_step)
	overlay.pixel_x = x_offset
	overlay.pixel_y = 0
	overlay.transform = matrix().Scale(carry_overlay_scale)

	carry_overlay = overlay
	overlay_carrier.add_overlay(carry_overlay)

/obj/item/carried_object/proc/remove_carry_overlay()
	if(!overlay_carrier)
		return
	UnregisterSignal(overlay_carrier, COMSIG_ATOM_DIR_CHANGE)
	if(carry_overlay)
		overlay_carrier.cut_overlay(carry_overlay)
	carry_overlay = null
	overlay_carrier = null

/obj/item/carried_object/proc/can_place_on(turf/target_turf)
	if(target_turf.density)
		return FALSE
	if(carried.density && target_turf.is_blocked_turf(exclude_mobs = TRUE, source_atom = carried))
		return FALSE
	return TRUE

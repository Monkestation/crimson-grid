// **************************************************************** CHIME OF UNSEEN SPIRITS *************************************************************
/obj/ritual_rune/thaumaturgy/chime_of_unseen_spirits
	name = "chime of unseen spirits"
	desc = "Enchant a chime to reveal the presence of nearby spirits."
	icon_state = "rune6"
	word = "Sonitus occultorum."
	level = 1

/obj/ritual_rune/thaumaturgy/chime_of_unseen_spirits/complete()
	. = ..()
	new /obj/item/spirit_chime(loc)
	qdel(src)

// The spirit chime item itself
/obj/item/spirit_chime
	name = "chime of unseen spirits"
	desc = "A mystical chime that reacts to nearby spirits."
	icon = 'modular_darkpack/modules/ritual_thaumaturgy/icons/spirit_chime.dmi'
	icon_state = "bell"
	var/datum/proximity_monitor/advanced/spirit_chime/chime_field
	var/ringing = FALSE
	var/detection_range = 10
	COOLDOWN_DECLARE(ring_cooldown)

// Picking the chime back up
/obj/item/spirit_chime/attack_hand(mob/user)
	if(!anchored)
		return ..()
	if(!do_after(user, 2 SECONDS, target = src))
		return
	user.visible_message(span_notice("[user] retrieves the chime."))
	anchored = FALSE
	icon_state = "bell"
	user.put_in_active_hand(src)

/obj/item/spirit_chime/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	// Handles wall placement
	if(iswallturf(interacting_with))
		if(!do_after(user, 2 SECONDS, interacting_with))
			return ITEM_INTERACT_BLOCKING

		user.transfer_item_to_turf(src, interacting_with)
		icon_state = "chime"

		// Grabs click parameters for placement. Totally unnecessary, but I thought it was nice.
		var/click_x = text2num(LAZYACCESS(modifiers, ICON_X))
		var/click_y = text2num(LAZYACCESS(modifiers, ICON_Y))
		if(click_x && click_y)
			pixel_x = click_x - 16
			pixel_y = click_y - 30

		user.visible_message(span_notice("[user] hangs the chime on [interacting_with]."))
		anchored = TRUE
		initial_check()
		return ITEM_INTERACT_SUCCESS

	// Handles floor or table placement
	if(isturf(interacting_with) || istype(interacting_with, /obj/structure/table))
		if(!do_after(user, 2 SECONDS, interacting_with))
			return ITEM_INTERACT_BLOCKING

		// get_turf to ensure you dont move it into a table. get_turf on turf just returns src so who gives a shit.
		user.transfer_item_to_turf(src, get_turf(interacting_with))
		icon_state = "bell"

		// Grabs click parameters for placement. Totally unnecessary, but I thought it was nice.
		var/click_x = text2num(LAZYACCESS(modifiers, ICON_X))
		var/click_y = text2num(LAZYACCESS(modifiers, ICON_Y))
		if(click_x && click_y)
			pixel_x = click_x - 16
			pixel_y = click_y - 16

		user.visible_message(span_notice("[user] places the bell on [interacting_with]."))
		anchored = TRUE
		initial_check()
		return ITEM_INTERACT_SUCCESS


/obj/item/spirit_chime/Initialize()
	. = ..()
	// Sets up a field with a range of 10
	chime_field = new /datum/proximity_monitor/advanced/spirit_chime(src, detection_range)
	chime_field.recalculate_field(full_recalc = TRUE)
	if(!ringing)
		initial_check()

/obj/item/spirit_chime/Destroy()
	QDEL_NULL(chime_field)
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/spirit_chime/process(delta_time)
	var/valid_targets = FALSE
	if(!ringing || !anchored || !chime_field)
		ringing = FALSE
		STOP_PROCESSING(SSprocessing, src)
		return
	for(var/mob/ghost in chime_field.tracked_mobs) // Check if there are still valid targets
		if(valid_target(ghost))
			valid_targets = TRUE
			break
	for(var/mob/ghost in chime_field.tracked_mobs)
		if(ghost.z != z || !valid_target(ghost) || get_dist(get_turf(src), get_turf(ghost)) > chime_field.current_range) // Check for invalid targets & out of range
			chime_field.tracked_mobs -= ghost
	if(!valid_targets) // End if no valid targets
		ringing = FALSE
		chime_field.tracked_mobs.Cut()
		STOP_PROCESSING(SSprocessing, src)
		return
	if(COOLDOWN_FINISHED(src, ring_cooldown))
		ring()
		COOLDOWN_START(src, ring_cooldown, 5 SECONDS)

/obj/item/spirit_chime/proc/start_ringing()
	if(ringing || !anchored || !chime_field)
		return
	ringing = TRUE
	START_PROCESSING(SSprocessing, src)

/obj/item/spirit_chime/proc/stop_ringing()
	ringing = FALSE
	STOP_PROCESSING(SSprocessing, src)

/obj/item/spirit_chime/proc/ring()
	playsound(src, 'modular_darkpack/modules/ritual_thaumaturgy/sounds/spirit_chime_ring.ogg', 25, FALSE)
	visible_message(span_notice("The chime rings out!"), vision_distance = detection_range)

/obj/item/spirit_chime/proc/initial_check()
	for(var/mob/creep in range(detection_range, src))
		if(valid_target(creep) && !(creep in chime_field.tracked_mobs))
			chime_field.tracked_mobs |= creep
		if(chime_field.tracked_mobs.len > 0 && !ringing)
			ringing = TRUE
			START_PROCESSING(SSprocessing, src)

/obj/item/spirit_chime/proc/valid_target(atom/movable/target)
	var/mob/target_mob = target
	if(istype(target_mob) && target_mob.mind)
		if(IS_FAKE_KEY(target_mob.key))
			return FALSE
		if(isobserver(target_mob) || isavatar(target_mob))
			return TRUE
	return FALSE


// The proimity monitor that creates the detection field
/datum/proximity_monitor/advanced/spirit_chime
	edge_is_a_field = TRUE
	var/list/tracked_mobs = list()
	var/obj/item/spirit_chime/chime

/datum/proximity_monitor/advanced/spirit_chime/New(atom/_host, range)
	. = ..()
	chime = _host

/datum/proximity_monitor/advanced/spirit_chime/field_turf_crossed(atom/movable/entered, turf/old_location, turf/new_location) // Handles when a mob enters the field
	. = ..()
	if(!chime.anchored)
		return
	if(entered.z != chime.z) // Im fairly certin all of this file's z level checks is redundent. But not 100% so they stay.
		return

	if(test_target(entered))
		return

	if(entered.orbiters)
		for(var/mob/dead/observer/ghost in entered.get_all_orbiters()) // Check for orbiting ghosts in the field
			test_target(ghost)

/datum/proximity_monitor/advanced/spirit_chime/proc/test_target(atom/movable/target)
	if(chime.valid_target(target))
		if(!(target in tracked_mobs))
			tracked_mobs |= target
			if(tracked_mobs.len == 1) // Starts ringing on the first target, continues until there are no more targets
				chime.start_ringing()
			else if(tracked_mobs.len < 1)
				chime.stop_ringing()

/datum/proximity_monitor/advanced/spirit_chime/field_turf_uncrossed(atom/movable/gone, turf/old_location, turf/new_location) // Handles when a mob leaves the field
	. = ..()
	if(!chime.anchored)
		return
	if(gone in tracked_mobs)
		tracked_mobs -= gone
	if(gone.z != chime.z || !chime.valid_target(gone))
		if(gone in tracked_mobs)
			tracked_mobs -= gone
	if(gone.orbiters)
		for(var/mob/dead/observer/ghost in gone.get_all_orbiters())
			if(ghost in tracked_mobs)
				tracked_mobs -= ghost


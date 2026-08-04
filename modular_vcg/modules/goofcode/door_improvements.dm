/obj/structure/vampdoor
	var/static/list/slots_to_check = list(
		ITEM_SLOT_BELT,
		ITEM_SLOT_ID,
		ITEM_SLOT_RPOCKET,
		ITEM_SLOT_LPOCKET,
		ITEM_SLOT_SUITSTORE,
		ITEM_SLOT_DEX_STORAGE,
		ITEM_SLOT_BACK,
	)
	var/was_locked = FALSE
	var/mob/auto_opener
	var/turf/our_turf
	var/list/adjacent_turfs = list()

/obj/structure/vampdoor/Initialize(mapload)
	. = ..()

	if(mapload)
		GLOB.city_door_lock_ids |= lock_id

	register_context()

	var/static/list/loc_connections = list(
		COMSIG_ATOM_MAGICALLY_UNLOCKED = PROC_REF(on_magic_unlock),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	RegisterSignal(src, COMSIG_ATOM_BUMPED, PROC_REF(on_bumped))
	our_turf = get_turf(src)
	adjacent_turfs = RANGE_TURFS(1, get_turf(src))
	for(var/turf in adjacent_turfs)
		RegisterSignal(turf, COMSIG_ATOM_EXITED, PROC_REF(walked_through))
		RegisterSignal(turf, COMSIG_TURF_CHANGE, PROC_REF(turf_changed))

/obj/structure/vampdoor/proc/turf_changed(turf/changed, path, list/new_baseturfs, flags, list/post_change_callbacks)
	SIGNAL_HANDLER
	UnregisterSignal(changed, COMSIG_TURF_CHANGE)
	adjacent_turfs -= changed
	post_change_callbacks += CALLBACK(src, PROC_REF(re_register_turf))

/obj/structure/vampdoor/proc/re_register_turf(turf/changed)
	RegisterSignal(changed, COMSIG_ATOM_EXITED, PROC_REF(walked_through))
	RegisterSignal(changed, COMSIG_TURF_CHANGE, PROC_REF(turf_changed))

/obj/structure/vampdoor/Destroy(force)
	UnregisterSignal(src, COMSIG_ATOM_BUMPED)
	for(var/turf in adjacent_turfs)
		UnregisterSignal(turf, COMSIG_ATOM_EXITED)
		UnregisterSignal(turf, COMSIG_TURF_CHANGE)
		adjacent_turfs -= turf
	our_turf = null
	auto_opener = null
	. = ..()


/obj/structure/vampdoor/proc/walked_through(datum/source, atom/movable/thing)
	SIGNAL_HANDLER
	if(thing != auto_opener)
		return // we don't care, didn't auto-open the door, thus is not the one holding it
	if(thing.loc in adjacent_turfs)
		return // we don't care, they're holding the door open still as they're adjacent
	if(isliving(thing))
		var/mob/living/living_passing = thing
		if(living_passing.move_intent == MOVE_INTENT_WALK) // Don't auto-close if you're walking.
			return
		if(living_passing.combat_mode) // Don't auto-close if you're in combat mode.
			return
	auto_opener = null // we have given up on auto-closing at this point, we don't want to auto-close if we walk back through it after having left it
	if(ishuman(thing))
		var/mob/living/carbon/human/passing_human = thing
		if(!HAS_PERSONALITY(passing_human, /datum/personality/slacking/lazy)) // lazy people don't close doors they walk through
			close_door(passing_human)

/obj/structure/vampdoor/proc/on_bumped(datum/source, atom/bumper)
	SIGNAL_HANDLER
	if(!closed)
		return
	if(isliving(bumper))
		var/mob/living/live_bumper = bumper
		if(live_bumper.move_intent == MOVE_INTENT_WALK)
			return
		switch(dir)
			if(NORTH)
				if(live_bumper.dir == EAST || live_bumper.dir == WEST)
					return
			if(SOUTH)
				if(live_bumper.dir == EAST || live_bumper.dir == WEST)
					return
			if(EAST)
				if(live_bumper.dir == NORTH || live_bumper.dir == SOUTH)
					return
			if(WEST)
				if(live_bumper.dir == NORTH || live_bumper.dir == SOUTH)
					return
		if(locked)
			if(got_the_key(live_bumper))
				was_locked = TRUE
				toggle_lock(live_bumper)
			else
				return // AIN'T GOT THE KEY!
		open_door(live_bumper)
		auto_opener = live_bumper
		live_bumper.Move(our_turf)

#define AINT_GOT_THE_KEY FALSE
#define GOT_THE_KEY TRUE

/obj/structure/vampdoor/proc/got_the_key(mob/living/leonard)
	var/obj/item/vamp/keys/found_keys
	for(var/obj/item/held_thing in leonard.held_items)
		if(istype(held_thing, /obj/item/vamp/keys) && check_the_key(held_thing))
			found_keys = TRUE
			break
		if(held_thing.atom_storage && !held_thing.atom_storage.locked) // no pulling keys out of lockboxes to unlock doors
			for(var/obj/item/possible_key in held_thing)
				if(istype(held_thing, /obj/item/vamp/keys) && check_the_key(held_thing))
					found_keys = TRUE
					break
			if(found_keys)
				break
	for(var/slot in slots_to_check)
		var/obj/item/possible_key = leonard.get_item_by_slot(slot)
		if(!possible_key)
			continue
		if(istype(possible_key, /obj/item/vamp/keys) && check_the_key(possible_key))
			found_keys = TRUE
			break
		if(possible_key.atom_storage && !possible_key.atom_storage.locked)
			for(var/obj/item/possible_key_two in possible_key)
				if(istype(possible_key_two, /obj/item/vamp/keys) && check_the_key(possible_key_two))
					found_keys = TRUE
					break
	if(!found_keys)
		return AINT_GOT_THE_KEY
	return GOT_THE_KEY

/obj/structure/vampdoor/proc/check_the_key(obj/item/vamp/keys/skeleton_key)
	if(skeleton_key.roundstart_fix) // this is so fucking stupid and needs reworked to not exist
		lock_id = pick(skeleton_key.accesslocks)
		skeleton_key.roundstart_fix = FALSE
		return TRUE
	if(skeleton_key.accesslocks)
		for(var/i in skeleton_key.accesslocks)
			if(i == lock_id)
				return TRUE
	return FALSE

/obj/structure/vampdoor/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(door_broken)
		balloon_alert(user, "door broken!")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/mob/living/living_user = user
	if(living_user.combat_mode)
		if(ishuman(user))
			var/mob/living/carbon/human/human_user = user
			if(!bash_roll)
				bash_roll = new()
			bash_roll.difficulty = bash_difficulty
			bash_roll.successes_needed = bash_successes_needed
			var/roll = bash_roll.st_roll(user, src)
			switch(roll)
				if(ROLL_SUCCESS)
					balloon_alert(human_user, "winding punch...")
					if(do_after(human_user, 1 TURNS, src))
						proc_unlock(50)
						Shake(rand(-1, 1), rand(-1, 1), 0.2 SECONDS, 0.1 SECONDS)
						break_door(human_user)
					else
						balloon_alert(human_user, "not adjacent!")
						return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
				if(ROLL_FAILURE)
					Shake(rand(-1, 1), rand(-1, 1), 0.2 SECONDS, 0.1 SECONDS)
					playsound(get_turf(src), 'modular_darkpack/master_files/sounds/effects/door/get_bent.ogg', 50, TRUE)
					proc_unlock(5)
					balloon_alert(human_user, "failed to breach!")
				if(ROLL_BOTCH)
					Shake(rand(-1, 1), rand(-1, 1), 0.2 SECONDS, 0.1 SECONDS)
					playsound(get_turf(src), 'modular_darkpack/master_files/sounds/effects/door/get_bent.ogg', 50, TRUE)
					proc_unlock(5)
					balloon_alert(human_user, "hurt your shoulder!")
					human_user.adjust_brute_loss(1 LETHAL_TTRPG_DAMAGE, user.get_active_hand())
	else
		if(lock_id == LOCKACCESS_ALL)
			toggle_lock(user)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		if(got_the_key(user))
			toggle_lock(user)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		else
			balloon_alert(user, "ain't got the key!")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/vampdoor/proc/toggle_lock(mob/living/user)
	playsound(src, lock_sound, 75, TRUE)
	if(!locked)
		if(user)
			balloon_alert(user, "locked")
		locked = TRUE
	else
		if(user)
			balloon_alert(user, "unlocked")
		proc_unlock("key")
		locked = FALSE
	return TRUE


#undef AINT_GOT_THE_KEY
#undef GOT_THE_KEY

/obj/item/vamp/keys
	slot_flags = ITEM_SLOT_ID | ITEM_SLOT_BELT | ITEM_SLOT_LPOCKET | ITEM_SLOT_RPOCKET | ITEM_SLOT_SUITSTORE

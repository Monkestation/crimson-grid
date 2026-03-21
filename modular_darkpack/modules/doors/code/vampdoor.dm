#define DOAFTER_SOURCE_DOOR "doafter_door"
/obj/structure/vampdoor
	name = "\improper door"
	desc = "It opens and closes."
	icon = 'modular_darkpack/modules/deprecated/icons/doors.dmi'
	icon_state = "door-1"
	base_icon_state = "door"
	layer = MAP_SWITCH(CLOSED_DOOR_LAYER, OPEN_DOOR_LAYER)
	pixel_w = -16

	anchored = TRUE
	density = TRUE
	opacity = TRUE
	flags_1 = IGNORE_TURF_PIXEL_OFFSET_1
	pass_flags_self = PASSDOORS

	max_integrity = 350
	integrity_failure = 0.5
	armor_type = /datum/armor/machinery_door
	receive_ricochet_chance_mod = 0.8
	damage_deflection = 10

	var/closed = TRUE
	var/locked = FALSE
	var/door_broken = FALSE
	var/door_layer = CLOSED_DOOR_LAYER
	var/lock_id = null
	var/lockpick_difficulty = 6

	var/open_sound = 'modular_darkpack/modules/doors/sounds/door_open.ogg'
	var/close_sound = 'modular_darkpack/modules/doors/sounds/door_close.ogg'
	var/lock_sound = 'modular_darkpack/modules/doors/sounds/door_locked.ogg'
	var/burnable = FALSE
	var/datum/storyteller_roll/lockpick/lockpick_roll
	var/datum/storyteller_roll/bash_door/bash_roll
	/// Difficulty for bashing this door down
	var/bash_difficulty = 6
	/// Number of successes needed to bash down
	var/bash_successes_needed = 1

/obj/structure/vampdoor/Initialize(mapload)
	. = ..()

	register_context()

	AddElement(/datum/element/contextual_screentip_bare_hands, rmb_text = "Try lock")

	var/static/list/loc_connections = list(
		COMSIG_ATOM_MAGICALLY_UNLOCKED = PROC_REF(on_magic_unlock),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/vampdoor/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	return !density || !locked

// DARKPACK TODO - examinetext on these doors
/* Examine text will need to be reworked but im not sure on the probailites for rolls considering botches as well.
/obj/structure/vampdoor/examine(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.is_holding_item_of_type(/obj/item/vamp/keys/hack))
		return
	var/message //So the code isn't flooded with . +=, it's just a visual thing
	var/difference = (H.st_get_stat(STAT_LARCENY) + H.st_get_stat(STAT_DEXTERITY)) - lockpick_difficulty //Lower number = higher difficulty
	switch(difference) //Because rand(1,20) always adds a minimum of 1 we take that into consideration for our theoretical roll ranges, which really makes it a random range of 19.
		if(-INFINITY to -11) //Roll can never go above 10 (-11 + 20 = 9), impossible to lockpick.
			message = span_warning("You don't have any chance of lockpicking this with your current skills!")
		if(-10 to -7)
			message = "<span class='warning'>This door looks extremely complicated. You figure you will have to be lucky to break it open."
		if(-6 to -3)
			message = "<span class='notice'>This door looks very complicated. You might need a few tries to lockpick it."
		if(-2 to 0) //Only 3 numbers here instead of 4.
			message = span_notice("This door looks mildly complicated. It shouldn't be too hard to lockpick it.")
		if(1 to 4) //Impossible to break the lockpick from here on because minimum rand(1,20) will always move the value to 2.
			message = span_nicegreen("This door is somewhat simple. It should be pretty easy for you to lockpick it.")
		if(5 to INFINITY) //Becomes guaranteed to lockpick at 9.
			message = span_nicegreen("This door is really simple to you. It should be very easy to lockpick it.")
	. += "[message]"
	if(H.st_get_stat(STAT_LARCENY) >= 5) //The difference between a 1/19 and a 4/19 is about 4x. An expert in lockpicks is more discerning.
		//Converting the difference into a number that can be divided by the max value of the rand() used in lockpicking calculations.
		var/max_rand_value = 20
		var/minimum_lockpickable_difference = -10 //Minimum value, any lower and lockpicking will always fail.
		//Add those together then reduce by 1
		var/number_difference = max_rand_value + minimum_lockpickable_difference - 1
		//max_rand_value and number_difference will output 11 currently.
		var/value = difference + max_rand_value - number_difference
		//I'm sure there has to be a better method for this because it's ugly, but it works.
		//Putting a condition here to avoid dividing 0.
		var/odds = value ? clamp((value/max_rand_value), 0, 1) : 0
		. += span_notice("As an expert in lockpicking, you estimate that you have a [round(odds*100, 1)]% chance to lockpick this door successfully.")
*/

/obj/structure/vampdoor/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(isnull(held_item) && isliving(user))
		var/mob/living/living_user = user
		context[SCREENTIP_CONTEXT_RMB] = locked ? "Unlock" : "Lock"
		if(living_user?.combat_mode)
			context[SCREENTIP_CONTEXT_LMB] = "Knock"
		else
			context[SCREENTIP_CONTEXT_LMB] = closed ? "Open" : "Close"

		return CONTEXTUAL_SCREENTIP_SET

/obj/structure/vampdoor/mouse_drop_receive(atom/dropped, mob/user, params)
	. = ..()
	LoadComponent(/datum/component/leanable, dropped)

/obj/structure/vampdoor/proc/proc_unlock(method) //I am here so that dwelling doors can call me to properly process their alarms.
	return

/obj/structure/vampdoor/atom_break(damage_flag)
	. = ..()
	if(!door_broken)
		break_door()

/obj/structure/vampdoor/atom_fix()
	. = ..()
	fix_door()

/obj/structure/vampdoor/proc/break_door(mob/user)
	playsound(get_turf(src), 'modular_darkpack/master_files/sounds/effects/door/get_bent.ogg', 100, FALSE)
	var/obj/item/shield/door/broken_door = new(get_turf(src))
	broken_door.icon_state = base_icon_state
	if(user)
		var/atom/throw_target = get_edge_target_turf(src, user.dir)
		broken_door.throw_at(throw_target, rand(2, 4), 4, user)
	name = "door frame"
	desc = "An empty door frame. Someone removed the door by force. A special door repair kit should be able to fix this."
	door_broken = TRUE
	set_density(FALSE)
	set_opacity(FALSE)
	layer = OPEN_DOOR_LAYER
	closed = FALSE
	locked = FALSE
	icon_state = "[base_icon_state]-b"
	update_icon()

/obj/structure/vampdoor/proc/fix_door()
	name = initial(name)
	desc = initial(desc)
	door_broken = FALSE
	set_density(TRUE)
	if(initial(opacity))
		set_opacity(TRUE)
	layer = ABOVE_ALL_MOB_LAYER
	closed = TRUE
	locked = FALSE
	icon_state = "[base_icon_state]-1"
	update_icon()

/obj/structure/vampdoor/proc/toggle_door(mob/user)
	if(closed)
		open_door(user)
	else
		close_door(user)

/obj/structure/vampdoor/proc/open_door(mob/user)
	playsound(src, open_sound, 75, TRUE)
	icon_state = "[base_icon_state]-0"
	set_density(FALSE)
	set_opacity(FALSE)
	layer = OPEN_DOOR_LAYER
	to_chat(user, span_notice("You open [src]."))
	closed = FALSE
	SEND_SIGNAL(src, COMSIG_AIRLOCK_OPEN)

/// Signal proc for [COMSIG_ATOM_MAGICALLY_UNLOCKED]. Unlock and open up when we get knock casted.
/obj/structure/vampdoor/proc/on_magic_unlock(datum/source, datum/action/cooldown/spell/aoe/knock/spell, atom/caster)
	SIGNAL_HANDLER

	locked = FALSE
	INVOKE_ASYNC(src, PROC_REF(open_door))

/obj/structure/vampdoor/proc/close_door(mob/user, force)
	if(!force)
		for(var/mob/living/L in src.loc)
			playsound(src, lock_sound, 75, TRUE)
			to_chat(user, span_warning("[L] is preventing you from closing [src]."))
			return
		//Mabye add an else here that throws people out of the way of the door
	playsound(src, close_sound, 75, TRUE)
	icon_state = "[base_icon_state]-1"
	set_density(TRUE)
	if(initial(opacity))
		set_opacity(TRUE)
	layer = ABOVE_ALL_MOB_LAYER
	to_chat(user, span_notice("You close [src]."))
	closed = TRUE
	SEND_SIGNAL(src, COMSIG_AIRLOCK_CLOSE, force)

/obj/structure/vampdoor/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	var/mob/living/living_user = user
	if(door_broken)
		to_chat(user, span_warning("There is no door to use here."))
		return
	if(living_user.combat_mode)
		if(ishuman(user))
			var/mob/living/carbon/human/human_user = user
			if(human_user.st_get_stat(STAT_STRENGTH) > 5)
				if(!bash_roll)
					bash_roll = new()
				bash_roll.difficulty = bash_difficulty
				bash_roll.successes_needed = bash_successes_needed
				var/roll = bash_roll.st_roll(user, src)
				switch(roll)
					if(ROLL_SUCCESS)
						to_chat(human_user, span_danger("You wind up a big punch to break down the door..."))
						if(do_after(human_user, 3 SECONDS, src))
							proc_unlock(50)
							break_door(human_user)
						else
							to_chat(human_user, span_danger("You must be standing next to the door to break it down."))
					if(ROLL_FAILURE, ROLL_BOTCH)
						pixel_z = pixel_z+rand(-1, 1)
						pixel_w = pixel_w+rand(-1, 1)
						playsound(get_turf(src), 'modular_darkpack/master_files/sounds/effects/door/get_bent.ogg', 50, TRUE)
						proc_unlock(5)
						to_chat(user, span_warning("You aren't strong enough to break it down! You hurt your shoulder by punching the door!"))
						human_user.adjust_brute_loss(1 LETHAL_TTRPG_DAMAGE)
						addtimer(CALLBACK(src, PROC_REF(reset_transform)), 2)
			else
				pixel_z = pixel_z+rand(-1, 1)
				pixel_w = pixel_w+rand(-1, 1)
				playsound(src, 'modular_darkpack/modules/doors/sounds/knock.ogg', 75, TRUE)
				addtimer(CALLBACK(src, PROC_REF(reset_transform)), 2)
	else
		if(locked)
			playsound(src, lock_sound, 75, TRUE)
			to_chat(user, span_warning("[src] is locked!"))
		else
			toggle_door(user)

/obj/structure/vampdoor/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	var/has_keys = FALSE
	for(var/obj/item/vamp/keys/found_key in user)
		// check if we already set has_keys so the first key you try and no do_after.
		if(has_keys && !do_after(user, 1 SECONDS, src, interaction_key = DOAFTER_SOURCE_DOOR))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		has_keys = TRUE
		if(try_keys(user, found_key))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(human_user.back)
			for(var/obj/item/vamp/keys/found_key in human_user.back)
				if(!do_after(human_user, 1 SECONDS, src, interaction_key = DOAFTER_SOURCE_DOOR))
					return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
				has_keys = TRUE
				if(try_keys(user, found_key))
					return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(lock_id == LOCKACCESS_ALL)
		if(try_keys(user, need_key = FALSE))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!has_keys)
		to_chat(user, span_warning("You need a key to lock/unlock this door!"))
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/vampdoor/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/door_repair_kit))
		return try_repair(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING
	if(istype(tool, /obj/item/vamp/keys/hack))
		return try_lockpick(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING
	if(istype(tool, /obj/item/vamp/keys))
		return try_keys(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING
	return NONE

/obj/structure/vampdoor/proc/try_repair(mob/living/user, obj/item/tool)
	if(!door_broken)
		to_chat(user, span_warning("This door does not seem to be broken."))
		return FALSE
	playsound(src, 'sound/items/tools/ratchet.ogg', 50)
	if(do_after(user, 10 SECONDS, src, interaction_key = DOAFTER_SOURCE_DOOR))
		if(atom_integrity >= max_integrity)
			return FALSE
		playsound(src, 'sound/items/deconstruct.ogg', 50)
		repair_damage(max_integrity)
		qdel(tool)
		return TRUE

/obj/structure/vampdoor/proc/try_lockpick(mob/living/user, obj/item/tool)
	if(door_broken)
		to_chat(user, span_warning("There is no door to pick here."))
		return
	if(CONFIG_GET(flag/punishing_zero_dots) && user.st_get_stat(STAT_LARCENY) < 1)
		to_chat(user, span_warning("How do I do this...?"))
		return
	if(locked)
		proc_unlock(5)
		playsound(src, 'modular_darkpack/modules/doors/sounds/hack.ogg', 100, TRUE)
		for(var/mob/living/carbon/human/npc/police/P in oviewers(DEFAULT_SIGHT_DISTANCE, src))
			P.Aggro(user)
		if(do_after(user, 1 TURNS, src, interaction_key = DOAFTER_SOURCE_DOOR))
			if(!locked)
				return
			if(!lockpick_roll)
				lockpick_roll = new()
			lockpick_roll.difficulty = lockpick_difficulty
			switch(lockpick_roll.st_roll(user, src))
				if(ROLL_SUCCESS)
					to_chat(user, span_notice("You pick the lock."))
					locked = FALSE
					return TRUE
				if(ROLL_FAILURE)
					to_chat(user, span_warning("You failed to pick the lock."))
				if(ROLL_BOTCH)
					to_chat(user, span_warning("Your lockpick broke!"))
					qdel(tool)
		else
			to_chat(user, span_warning("You failed to pick the lock."))
			return
	else
		if(closed && lock_id) //yes, this is a thing you can extremely easily do in real life... FOR DOORS WITH LOCKS!
			to_chat(user, span_notice("You re-lock the door with your lockpick."))
			locked = TRUE
			playsound(src, 'modular_darkpack/modules/doors/sounds/hack.ogg', 100, TRUE)
			return TRUE

/obj/structure/vampdoor/proc/try_keys(mob/living/user, obj/item/vamp/keys/key_used, need_key = TRUE)
	/*
	if(key_used != user.get_active_hand())
		if(!do_after(human_user, 0.5 SECONDS, src, interaction_key = DOAFTER_SOURCE_DOOR))
			return
	*/
	if(need_key)
		to_chat(user, span_notice("You try [key_used] against [src]"))
	else
		to_chat(user, span_notice("You try to unlock [src]"))

	if(door_broken)
		to_chat(user, span_warning("There is no door to open/close here."))
		return
	if(key_used.roundstart_fix)
		lock_id = pick(key_used.accesslocks)
		key_used.roundstart_fix = FALSE
	if(key_used.accesslocks)
		for(var/i in key_used.accesslocks)
			if(i == lock_id)
				return toggle_lock(user)
	if(!need_key)
		return toggle_lock(user)

/obj/structure/vampdoor/proc/toggle_lock(mob/living/user)
	playsound(src, lock_sound, 75, TRUE)
	if(!locked)
		to_chat(user, span_notice("[src] is now locked."))
		locked = TRUE
	else
		to_chat(user, span_notice("[src] is now unlocked."))
		proc_unlock("key")
		locked = FALSE
	return TRUE

/obj/structure/vampdoor/proc/reset_transform()
	pixel_z = initial(pixel_z)
	pixel_w = initial(pixel_w)

#undef DOAFTER_SOURCE_DOOR

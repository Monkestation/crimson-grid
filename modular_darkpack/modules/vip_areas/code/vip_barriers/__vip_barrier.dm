/obj/effect/vip_barrier
	name = "Basic Check Point"
	desc = "Not a real checkpoint."
	icon = 'modular_darkpack/modules/vip_areas/icons/barrier.dmi'
	icon_state = "camarilla_blocking"

	anchored = TRUE

	var/block_sound = "modular_darkpack/modules/deprecated/sounds/bouncer_blocked.ogg"

	//Social bypass numbers
	var/social_bypass_allowed = TRUE
	var/can_use_badge = TRUE
	var/mean_to_cops = TRUE
	var/social_roll_difficulty = 7

	//Display settings
	var/always_invisible = FALSE

	var/datum/storyteller_roll/scene_cooldown/bypass_roll


	//Assigns an ID to NPCs that guard certain doors, must match a barrier's ID
	//*********All barriers under a protected_zone_id should be of the same type!*********
	var/protected_zone_id = "test"

	var/datum/vip_barrier_perm/linked_perm = null


/obj/effect/vip_barrier/Initialize(mapload)
	. = ..()

	if(mapload && src.type == /obj/effect/vip_barrier)
		CRASH("VIP Barrier created using default type, please use a child of this type in mapping.")

	//we do this in an initialize so mappers do not have to code as much
	if(SSbouncer_barriers.vip_barrier_perms?[protected_zone_id])
		linked_perm = SSbouncer_barriers.vip_barrier_perms[protected_zone_id]
		linked_perm.add_barrier(src)
		//spessman purity means I have to register a signal with myself, pain
		RegisterSignal(src, COMSIG_BARRIER_NOTIFY_GUARD_BLOCKED, PROC_REF(playBlockSound))
		update_icon()
	else if(mapload && SSbouncer_barriers.initialized)
		CRASH("A VIP barrier was created for vip_barrier_perms that were not loaded!")

/obj/effect/vip_barrier/Destroy()
	if(linked_perm)
		linked_perm.linked_barriers -= src
		linked_perm = null
	return ..()


/obj/effect/vip_barrier/CanPass(atom/movable/mover, turf/target)
	. = ..()
	var/entry_allowed = TRUE

	if(!isliving(mover))
		return entry_allowed

	if(check_direction_always_allowed(mover))
		return entry_allowed

	var/mob/living/mover_mob = mover
	if(!mover_mob.mind)
		entry_allowed = FALSE
	else if(linked_perm.actively_guarded)
		entry_allowed = check_entry_permission_base(mover_mob)

	if(!entry_allowed && mover.pulledby && isliving(mover.pulledby))
		entry_allowed = check_entry_permission_base(mover.pulledby)

	if(entry_allowed)
		SEND_SIGNAL(src, COMSIG_BARRIER_NOTIFY_GUARD_ENTRY, mover_mob)
	else
		SEND_SIGNAL(src, COMSIG_BARRIER_NOTIFY_GUARD_BLOCKED, mover_mob)

	return entry_allowed

/obj/effect/vip_barrier/proc/check_direction_always_allowed(atom/movable/mover)
	if(src.loc == mover.loc)
		return TRUE
	var/origin_dir = get_dir(src, mover)
	return !(origin_dir & src.dir)

/obj/effect/vip_barrier/proc/playBlockSound(atom/movable/mover)
	SIGNAL_HANDLER
	playsound(mover, block_sound, vol = 10, falloff_distance = 2, vary = TRUE)


//Call this parent after any children run
/obj/effect/vip_barrier/proc/check_entry_permission_base(mob/living/carbon/human/entering_mob)
	if(LAZYFIND(linked_perm.allow_list, entering_mob.name))
		return TRUE

	if(LAZYFIND(linked_perm.block_list, entering_mob.name))
		return FALSE

	return check_entry_permission_custom(entering_mob)

//Function for providing custom blocks and allowances for entering people
/obj/effect/vip_barrier/proc/check_entry_permission_custom(mob/living/carbon/human/entering_mob)
	return TRUE

/obj/effect/vip_barrier/proc/handle_social_bypass(mob/living/carbon/human/user, mob/bouncer, used_badge = FALSE, used_stat = STAT_EMPATHY)

	if(user.get_face_name() == "Unknown")
		to_chat(user, span_notice("They won't talk to someone they can't look in the eye."))
		return

	if(check_entry_permission_base(user))
		to_chat(user, span_notice("...But you are already allowed entry."))
		return

	//handle block list babies
	if(LAZYFIND(linked_perm.block_list, user.name))
		if(identify_cop(user, used_badge))
			linked_perm.notify_guard_police_denial(user)
		else
			linked_perm.notify_guard_blocked_denial(user)
		return

	if(!do_after(user, 1 TURNS, bouncer))
		return

	var/involved_social_roll = social_roll_difficulty
	if(used_badge)
		involved_social_roll -= 1

	if((!(user.obscured_slots & HIDEFACE))&(HAS_TRAIT(user, TRAIT_DISFIGURED_APPEARANCE))) // Are we visibly disfigured?
		involved_social_roll += 2

	if(!get_kindred_splat(bouncer))// our bouncer is probably mortal, but let's check anyways.
		if(HAS_TRAIT(user, TRAIT_GRAVE_SMELL))
			involved_social_roll += 1
		if((HAS_TRAIT(user, TRAIT_GLOWING_EYES)) && (!user.is_eyes_covered()) && (used_stat == STAT_INTIMIDATION))
			involved_social_roll -= 1

	if(!bypass_roll)
		bypass_roll = new()
		bypass_roll.bumper_text = "persuade guard"

	var/verbage
	bypass_roll.difficulty = involved_social_roll
	bypass_roll.applicable_stats = list(STAT_CHARISMA)
	if(used_stat == STAT_INTIMIDATION)
		verbage = "intimidate"
		bypass_roll.applicable_stats += used_stat
	else
		verbage = "persuade"
		bypass_roll.applicable_stats += used_stat

	if(bypass_roll.st_roll(user, src) == ROLL_SUCCESS)
		to_chat(user, span_notice("You manage to [verbage] your way past the guards."))
		linked_perm.allow_list += user.get_face_name()
		return

	to_chat(user, span_notice("The guards turn you away, taking note of you as they do."))
	linked_perm.block_list += user.name
	if(identify_cop(user, used_badge))
		linked_perm.notify_guard_police_denial(user)
	else
		linked_perm.notify_guard_blocked_denial(user)


/obj/effect/vip_barrier/proc/identify_cop(mob/living/carbon/human/user, used_badge = FALSE)
	if(mean_to_cops && (used_badge || (user.wear_id && istype(user.wear_id,/obj/item/card/police))))
		return TRUE
	return FALSE



/obj/effect/vip_barrier/proc/signal_update_icon()
	SIGNAL_HANDLER
	update_icon()

/obj/effect/vip_barrier/update_icon()
	.=..()
	if(always_invisible)
		alpha = 0
		return
	if(linked_perm.actively_guarded)
		alpha = 255
	else
		alpha = 128

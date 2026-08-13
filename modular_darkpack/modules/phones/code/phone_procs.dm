// Updates the phone's contacts, for when a new contact joins the game.
/obj/item/smartphone/proc/update_contacts()
	for(var/datum/contact_network/contact_network as anything in contact_networks)
		for(var/datum/contact/our_contact in contact_network.contacts)
			if(our_contact.number == sim_card.phone_number)
				continue

			var/already_in_contact = FALSE
			for(var/datum/phonecontact/phone_contact as anything in contacts)
				if(our_contact.number == phone_contact.number)
					already_in_contact = TRUE
					break
			if(already_in_contact)
				continue

			var/contact_name = "[our_contact.name] - [our_contact.role]"
			var/new_phone_contact = new /datum/phonecontact(contact_name, our_contact.number)
			contacts |= new_phone_contact

// Gets the displayed contact's name if they are in contacts or published. If not, show the number.
/obj/item/smartphone/proc/get_number_contact_name(contact_num)
	var/output_user
	if(!contact_num)
		CRASH("Trying to get a contact number with a bad input.")

	// Default to the contact name calling the phone.
	for(var/datum/phonecontact/contact in contacts)
		if(contact.number == contact_num)
			output_user = contact.name
	// If we dont have a contact name, refer to the published listings.
	if(!output_user)
		for(var/contact in SSphones.published_phone_numbers)
			if(contact_num == SSphones.published_phone_numbers[contact])
				output_user = contact
	// Not in our contacts or published listings? Then resolve to showing the phone number.
	if(!output_user)
		output_user = "+" + contact_num
	return output_user

// Helper proc to add a history log to the phone's records.
/obj/item/smartphone/proc/add_phone_call_history(call_type, call_type_tooltip)
	var/datum/phone_history/new_contact = new()
	var/caller_num = dialed_number ? dialed_number : incoming_phone_number
	new_contact.name = get_number_contact_name(caller_num)
	new_contact.number = caller_num
	new_contact.call_type = call_type
	new_contact.call_type_tooltip = call_type_tooltip
	new_contact.time = server_timestamp("hh:mm:ss", ic_time = TRUE)
	phone_history_list += new_contact

/obj/item/smartphone/proc/set_phone_state(new_state)
	if(current_state == new_state)
		return
	current_state = new_state

	if(current_state == PHONE_AVAILABLE)
		dialed_number = null
		incoming_phone_number = null
	if(current_state == PHONE_RINGING)
		START_PROCESSING(SSprocessing, src)
		if(ringer)
			add_shared_particles(/particles/phone_ringing, particle_flags = PARTICLE_ATTACH_MOB)

	else if(current_state == PHONE_IN_CALL || current_state == PHONE_AVAILABLE)
		if(phone_ringing_timer)
			deltimer(phone_ringing_timer)
			phone_ringing_timer = null
		remove_shared_particles(/particles/phone_ringing, delete_on_empty = FALSE)
		STOP_PROCESSING(SSprocessing, src)

/obj/item/smartphone/proc/check_missing_sim_card(mob/user)
	if(QDELETED(sim_card))
		balloon_alert(user, "no SIM!")
		return TRUE
	return FALSE

/obj/item/smartphone/proc/check_phone_busy(mob/user, obj/item/smartphone/calling_smartphone)
	if(calling_smartphone.current_state > PHONE_AVAILABLE)
		balloon_alert(user, "busy!")
		return TRUE
	if(calling_smartphone.sim_card?.phone_number == sim_card?.phone_number)
		balloon_alert(user, "busy!")
		return TRUE
	return FALSE

///////////////////////////////////////////////////////////////////////////////////////////////////////////

// Used for when the calling phone starts a phone call.
/obj/item/smartphone/proc/start_phone_call(mob/user, called_phone_number)
	if(check_missing_sim_card(user))
		return

	var/obj/item/smartphone/calling_smartphone = SSphones.get_phone_from_number(called_phone_number)
	if(!calling_smartphone)
		return
	if(check_phone_busy(user, calling_smartphone))
		return
	dialed_number = called_phone_number
	calling_smartphone.incoming_phone_number = sim_card.phone_number
	calling_smartphone.receive_phone_call()
	phone_ringing_timer = addtimer(CALLBACK(src, PROC_REF(set_phone_available)), TIME_TO_RING, TIMER_STOPPABLE | TIMER_DELETE_ME)
	add_phone_call_history(PHONE_CALL_SENT, PHONE_CALL_SENT_TOOLTIP)
	set_phone_state(PHONE_CALLING)
	return TRUE // CRIMSON EDIT ADDITION - need to know if a phone call actually went through or not

// Used for when the receiving phone picks up a phone call.
/obj/item/smartphone/proc/accept_phone_call(mob/user)
	if(check_missing_sim_card(user))
		return
	add_phone_call_history(PHONE_CALL_ACCEPTED, PHONE_CALL_ACCEPTED_TOOLTIP)
	establish_call_connection(incoming_phone_number)

// Used for when the receiving phone declines a phone call.
/obj/item/smartphone/proc/decline_phone_call()
	add_phone_call_history(PHONE_CALL_DECLINED, PHONE_CALL_DECLINED_TOOLTIP)
	terminate_call_connection()

// Used for when the receiving phone or the calling phone end the phone call after it has started.
/obj/item/smartphone/proc/end_phone_call()
	add_phone_call_history(PHONE_CALL_ENDED, PHONE_CALL_ENDED_TOOLTIP)
	terminate_call_connection()

// Used for when the calling phone ends the phone call before the receiving phone picks up.
/obj/item/smartphone/proc/hang_up_phone_call(called_phone_number)
	set_phone_state(PHONE_AVAILABLE)
	var/obj/item/smartphone/calling_smartphone = SSphones.get_phone_from_number(called_phone_number)
	if(!calling_smartphone)
		return
	calling_smartphone.miss_phone_call()

// Used for when the receiving phone gets a notification that they are being called by incoming_phone_number.
/obj/item/smartphone/proc/receive_phone_call()
	set_phone_state(PHONE_RINGING)
	phone_ringing_timer = addtimer(CALLBACK(src, PROC_REF(miss_phone_call)), TIME_TO_RING, TIMER_STOPPABLE | TIMER_DELETE_ME)
	add_phone_call_history(PHONE_CALL_RECEIVED, PHONE_CALL_RECEIVED_TOOLTIP)

// Used for when the receiving phone fails to pick up the phone call in time.
/obj/item/smartphone/proc/miss_phone_call()
	add_phone_call_history(PHONE_CALL_MISSED, PHONE_CALL_MISSED_TOOLTIP)
	set_phone_state(PHONE_AVAILABLE)

// General purpose failsafe of setting it to its proper state.
/obj/item/smartphone/proc/set_phone_available()
	set_phone_state(PHONE_AVAILABLE)

#define VIBRATION_LOOP_DURATION (1 SECONDS)

// Only used to indicate to the receiving phone that they are being called.
/obj/item/smartphone/process(seconds_per_tick)
	// CRIMSON EDIT ADDITION START - Ringing tone
	if(current_state == PHONE_CALLING)
		if(!COOLDOWN_FINISHED(src, paging_cooldown))
			return
		COOLDOWN_START(src, paging_cooldown, 2.5 SECONDS)
		playsound(src, 'modular_vcg/master_files/sounds/item/smartphone/ringing.ogg', 25, FALSE, 0, 2)
	else if (current_state == PHONE_RINGING)
	// CRIMSON EDIT ADDITION END - Ringing tone
		if(!COOLDOWN_FINISHED(src, ringer_cooldown))
			return
		COOLDOWN_START(src, ringer_cooldown, 4 SECONDS)
		if(vibration)
			animate(src, pixel_w = 1, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_PARALLEL)
			for(var/i in 1 to VIBRATION_LOOP_DURATION / (0.2 SECONDS)) //desired total duration divided by the iteration duration to give the necessary iteration count
				animate(pixel_w = -2, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
				animate(pixel_w = 2, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
			animate(pixel_w = -1, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE)
			balloon_alert_to_viewers(pick("zzZz!", "ZZZT!", "zZzZ!", "Zzz...", "zzZ...", "ZzZZT!"), vision_distance = COMBAT_MESSAGE_RANGE)
		if(ringer)
			playsound(src, call_sound, 50, TRUE, 0, 2)

// App really ought to be a datum. Whateverrrrr
/obj/item/smartphone/proc/receive_notification(app, title, body)
	if(vibration)
		animate(src, pixel_w = 1, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_PARALLEL)
		for(var/i in 1 to VIBRATION_LOOP_DURATION / (0.2 SECONDS)) //desired total duration divided by the iteration duration to give the necessary iteration count
			animate(pixel_w = -2, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
			animate(pixel_w = 2, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_CONTINUE)
		animate(pixel_w = -1, time = 0.1 SECONDS, flags = ANIMATION_RELATIVE)
	if(ringer)
		// playsound(src, 'modular_darkpack/modules/phones/sounds/text_receive.ogg', 50, TRUE, 0, 2) // This could prob use a better notification // CRIMSON EDIT REMOVAL
		play_notification_sound() // CRIMSON EDIT ADDITION
	balloon_alert_to_viewers("[app]:[title]", vision_distance = SAMETILE_MESSAGE_RANGE)

#undef VIBRATION_LOOP_DURATION

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Internal only proc, used for establlishing a call connection.
/obj/item/smartphone/proc/establish_call_connection()
	PROTECTED_PROC(TRUE)

	var/obj/item/smartphone/calling_smartphone = SSphones.get_phone_from_number(incoming_phone_number)
	if(!calling_smartphone)
		return

	// Establish a secure connection.
	secure_frequency = SSphones.establish_secure_frequency()
	calling_smartphone.secure_frequency = secure_frequency

	// Set the phone radios.
	set_phone_radio(TRUE)
	calling_smartphone.set_phone_radio(TRUE)

	// Set proper phone state.
	set_phone_state(PHONE_IN_CALL)
	calling_smartphone.set_phone_state(PHONE_IN_CALL)

	phone_radio.canhear_range = 1
	calling_smartphone.phone_radio.canhear_range = 1
	muted = FALSE
	calling_smartphone.muted = FALSE

// Internal only proc, used for ending a calll connection.
/obj/item/smartphone/proc/terminate_call_connection()
	PROTECTED_PROC(TRUE)

	playsound(loc, 'modular_vcg/master_files/sounds/item/smartphone/hangup.ogg', 35, TRUE) // CRIMSON EDIT ADDITION - hangup tone
	var/obj/item/smartphone/calling_smartphone = SSphones.get_phone_from_number(incoming_phone_number)
	if(!calling_smartphone)
		calling_smartphone = SSphones.get_phone_from_number(dialed_number)
	if(!calling_smartphone)
		return
	playsound(calling_smartphone, 'modular_vcg/master_files/sounds/item/smartphone/hangup.ogg', 35, TRUE) // CRIMSON EDIT ADDITION - hangup tone

	// Free up the secure connection.
	SSphones.free_secure_frequency(secure_frequency)
	secure_frequency = null
	calling_smartphone.secure_frequency = null

	// Set the phone radios.
	set_phone_radio(FALSE)
	calling_smartphone.set_phone_radio(FALSE)

	// Set proper phone state.
	set_phone_state(PHONE_AVAILABLE)
	calling_smartphone.set_phone_state(PHONE_AVAILABLE)

// Internal only proc, used for setting a phone's internal radio.
/obj/item/smartphone/proc/set_phone_radio(enabled)
	PROTECTED_PROC(TRUE)

	if(enabled)
		phone_radio.set_frequency(secure_frequency)
		phone_radio.set_broadcasting(TRUE)
		phone_radio.set_listening(TRUE)
	else
		phone_radio.set_frequency(0)
		phone_radio.set_broadcasting(FALSE)
		phone_radio.set_listening(FALSE)
	phone_radio.recalculateChannels()


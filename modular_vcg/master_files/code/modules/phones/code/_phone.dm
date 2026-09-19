// So when i was first working on this, i thought i should just keep everything in the modular_darkpack code folders
// cause yeah, then i realized thats a bad idea because I would be writing so many modularization comments
// so i decided it wasnt worth it so we're here now. im sorry. - marisa

/obj/item/smartphone
	/// Cooldown for changing ringtone sound
	COOLDOWN_DECLARE(ringtone_set_cooldown)
	/// The sound file to play when receiving a message
	var/ringtone_sound = PDA_RINGTONE_SOUND_DEFAULT
	/// Cooldown for paging/calling sound
	COOLDOWN_DECLARE(paging_cooldown)
	/// Its for the 2 beeps you hear when the call fails to go through
	var/phone_hangupsound_timer = null
	/// Sound cooldown for screen taps
	COOLDOWN_DECLARE(tap_sound_cooldown)

/obj/item/smartphone/ui_close(mob/user)
	. = ..()
	// Lock sound!
	playsound(loc, 'modular_vcg/master_files/sounds/item/smartphone/aosp/Lock.ogg', 20, TRUE)
	opened = FALSE
	update_appearance(UPDATE_ICON_STATE)

/obj/item/smartphone/toggle_screen(mob/user)
	var/prev_opened = opened
	. = ..()
	if(!prev_opened && opened)
		playsound(loc, 'modular_vcg/master_files/sounds/item/smartphone/aosp/Unlock.ogg', 20)

/obj/item/smartphone/ui_data(mob/user)
	. = ..()
	.["notification_sound"] = ringtone_sound
	.["notification_sounds"] = list()
	for(var/sound_name in GLOB.pda_ringtone_sounds)
		.["notification_sounds"] += sound_name

/obj/item/smartphone/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("dtmf_sound")
			if(!ringer)
				return TRUE
			var/pinpad_key = params["key"]
			var/sound_to_play
			var/static/alist/sound_map = alist(
				"1" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/1.ogg',
				"2" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/2.ogg',
				"3" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/3.ogg',
				"4" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/4.ogg',
				"5" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/5.ogg',
				"6" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/6.ogg',
				"7" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/7.ogg',
				"8" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/8.ogg',
				"9" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/9.ogg',
				"0" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/0.ogg',
				"a" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/a.ogg',
				"b" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/b.ogg',
				"c" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/c.ogg',
				"d" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/d.ogg',
				"*" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/star.ogg',
				"#" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/pound.ogg',
				"_" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/a.ogg',
				"+" = 'modular_vcg/master_files/sounds/item/smartphone/dtmf/b.ogg',
			)

			if (pinpad_key in sound_map)
				sound_to_play = sound_map[pinpad_key]
			else
				sound_to_play = 'modular_vcg/master_files/sounds/item/smartphone/aosp/KeypressInvalid.ogg'

			playsound(loc, sound_to_play, 15, FALSE)
			return TRUE
		if("set_notification_sound")
			var/new_sound = params["sound"]
			if(!(new_sound in GLOB.pda_ringtone_sounds))
				return FALSE

			ringtone_sound = new_sound

			// Plays a preview of the sound selected
			if(COOLDOWN_FINISHED(src, ringtone_set_cooldown))
				playsound(loc, GLOB.pda_ringtone_sounds[new_sound], 25, TRUE, extrarange = - 4)
				COOLDOWN_START(src, ringtone_set_cooldown, 0.4 SECONDS)

			return TRUE
	return FALSE


/// A simple proc to set the ringtone sound
/obj/item/smartphone/proc/update_notification_sound(new_sound)
	if(!istext(new_sound) || !(new_sound in GLOB.pda_ringtone_sounds))
		return
	ringtone_sound = new_sound

/// Another simple proc to play the ringtone sound
/obj/item/smartphone/proc/play_notification_sound()
	var/sound_file = GLOB.pda_ringtone_sounds[ringtone_sound]
	if(!sound_file)
		sound_file = 'modular_darkpack/modules/phones/sounds/text_send.ogg'
	playsound(src, sound_file, 30, TRUE, 0, 2)

/obj/item/smartphone/start_phone_call(mob/user, called_phone_number)
	. = ..()
	if(!.)
		return
	phone_hangupsound_timer = addtimer(CALLBACK(src, GLOBAL_PROC_REF(playsound), loc, 'modular_vcg/master_files/sounds/item/smartphone/hangup.ogg', 45, TRUE), TIME_TO_RING + 0.2 SECONDS, TIMER_STOPPABLE | TIMER_DELETE_ME) // CRIMSON EDIT ADDITION - hangup tone

/obj/item/smartphone/set_phone_state(new_state)
	. = ..()
	if(current_state == PHONE_CALLING)
		START_PROCESSING(SSprocessing, src)

	if(current_state == PHONE_IN_CALL)
		if(phone_hangupsound_timer)
			deltimer(phone_hangupsound_timer)

/datum/outfit/post_equip(mob/living/carbon/human/user, visuals_only)
	. = ..()
	var/obj/item/smartphone/daphon = locate() in user
	if(!user?.client?.prefs || QDELETED(daphon)) // somehow
		return
	var/datum/preference/ringtone_pref = user.client.prefs.read_preference(/datum/preference/choiced/pda_ringtone_sound)
	daphon.update_notification_sound(ringtone_pref)


//CG Notice: Obviously, this is not in space, or space station 13, or nanotrasen and PDAs dont exist
// but I have already named so much shit PDA_RINGTONE that im just going to keep it that way, fuck you <3

// TODO: If the sound mixer is ever added, add the following to get_channel_name of code/game/sound/sound.dm
/*
	if(CHANNEL_RINGTONES)
		return "Ringtones (Modlinks/PDA/Phones)"
*/
// and of course, add CHANNEL_RINGTONES to code/game/sound/sound_channels.dm

// go to the defines file for crimson_defines and find phones.dm and throw the shit there then add a line to the pda_ringtone_sounds global

// Map ringtone names to sound files
GLOBAL_LIST_INIT(pda_ringtone_sounds, list(
	PDA_RINGTONE_ALERT1 = 'modular_vcg/master_files/sounds/item/smartphone/notifications/alert1.ogg',
	PDA_RINGTONE_ALERT2 = 'modular_vcg/master_files/sounds/item/smartphone/notifications/alert2.ogg',
	PDA_RINGTONE_ALERT3 = 'modular_vcg/master_files/sounds/item/smartphone/notifications/alert3.ogg',
	PDA_RINGTONE_ALERT4 = 'modular_vcg/master_files/sounds/item/smartphone/notifications/alert4.ogg',
	PDA_RINGTONE_BEEP = 'modular_vcg/master_files/sounds/item/smartphone/notifications/terminal_success.ogg',
	PDA_RINGTONE_BELL = 'modular_vcg/master_files/sounds/item/smartphone/notifications/bell.ogg',
	PDA_RINGTONE_BIKEHORN = 'modular_vcg/master_files/sounds/item/smartphone/notifications/bikehorn.ogg',
	PDA_RINGTONE_BYONDPAGER = 'modular_vcg/master_files/sounds/item/smartphone/notifications/byond_pager.ogg',
	PDA_RINGTONE_BYONDPAGERDOWN = 'modular_vcg/master_files/sounds/item/smartphone/notifications/byond_pager_down.ogg',
	PDA_RINGTONE_CHIME = 'modular_vcg/master_files/sounds/item/smartphone/notifications/chime.ogg',
	PDA_RINGTONE_CHORD1 = 'modular_vcg/master_files/sounds/item/smartphone/notifications/chord1.ogg',
	PDA_RINGTONE_CHORD2 = 'modular_vcg/master_files/sounds/item/smartphone/notifications/chord2.ogg',
	PDA_RINGTONE_CHORD3 = 'modular_vcg/master_files/sounds/item/smartphone/notifications/chord3.ogg',
	PDA_RINGTONE_CODEC = 'modular_vcg/master_files/sounds/item/smartphone/notifications/codec.ogg',
	PDA_RINGTONE_DING = 'modular_vcg/master_files/sounds/item/smartphone/notifications/ding.ogg',
	PDA_RINGTONE_GRANDMA = 'modular_vcg/master_files/sounds/item/smartphone/notifications/grandma.ogg',
	PDA_RINGTONE_HORN = 'modular_vcg/master_files/sounds/item/smartphone/notifications/horn.ogg',
	PDA_RINGTONE_MAUS = 'modular_vcg/master_files/sounds/item/smartphone/notifications/maus.ogg',
	PDA_RINGTONE_MEOW1 = 'modular_vcg/master_files/sounds/item/smartphone/notifications/meow1.ogg',
	PDA_RINGTONE_MEOW2 = 'modular_vcg/master_files/sounds/item/smartphone/notifications/meow2.ogg',
	PDA_RINGTONE_MEOW3 = 'modular_vcg/master_files/sounds/item/smartphone/notifications/meow3.ogg',
	PDA_RINGTONE_MEOW4 = 'modular_vcg/master_files/sounds/item/smartphone/notifications/meow4.ogg',
	PDA_RINGTONE_MEOW_ELECTRIC = 'modular_vcg/master_files/sounds/item/smartphone/notifications/meow_electric.ogg',
	PDA_RINGTONE_MORSE = 'modular_vcg/master_files/sounds/item/smartphone/notifications/morse.ogg',
	PDA_RINGTONE_OHHIMARK = 'modular_vcg/master_files/sounds/item/smartphone/notifications/oh_hi_mark.ogg',
	PDA_RINGTONE_JINGLE = 'modular_vcg/master_files/sounds/item/smartphone/notifications/jingle.ogg',
	PDA_RINGTONE_BUZZ = 'modular_vcg/master_files/sounds/item/smartphone/notifications/buzz.ogg',
	PDA_RINGTONE_NOT_ALPHYS = 'modular_vcg/master_files/sounds/item/smartphone/notifications/not_alphys.ogg',
	PDA_RINGTONE_PHONE_CHIME = 'modular_vcg/master_files/sounds/item/smartphone/notifications/phone_chime.ogg',
	PDA_RINGTONE_PIANO = 'modular_vcg/master_files/sounds/item/smartphone/notifications/piano.ogg',
	PDA_RINGTONE_PING = 'modular_vcg/master_files/sounds/item/smartphone/notifications/ping.ogg',
	PDA_RINGTONE_SPEAKING = 'modular_vcg/master_files/sounds/item/smartphone/notifications/speaking.ogg',
	PDA_RINGTONE_SPLAT = 'modular_vcg/master_files/sounds/item/smartphone/notifications/splat.ogg',
	PDA_RINGTONE_TARGET = 'modular_vcg/master_files/sounds/item/smartphone/notifications/target.ogg',
	PDA_RINGTONE_TERMINAL_NOTIF1 = 'modular_vcg/master_files/sounds/item/smartphone/notifications/terminal_notif1.ogg',
	PDA_RINGTONE_WEH = 'modular_vcg/master_files/sounds/item/smartphone/notifications/weh.ogg',
))

/datum/preference/choiced/pda_ringtone_sound
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "pda_ringtone_sound"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference_middleware/pda_ringtone_sound
	COOLDOWN_DECLARE(ringtone_cooldown)
	action_delegations = list(
		"play_ringtone_sound" = PROC_REF(play_ringtone_sound),
	)

/datum/preference_middleware/pda_ringtone_sound/proc/play_ringtone_sound(list/params, mob/user)
	if(!COOLDOWN_FINISHED(src, ringtone_cooldown))
		return TRUE
	user.playsound_local(
		turf_source = get_turf(user),
		soundin = GLOB.pda_ringtone_sounds[preferences.read_preference(/datum/preference/choiced/pda_ringtone_sound)],
		vol = 90,
		vary = TRUE,
		frequency = null,
		falloff_exponent = 7,
		pressure_affected = FALSE,
		use_reverb = FALSE,
		// mixer_channel = CHANNEL_MACHINERY
	)
	COOLDOWN_START(src, ringtone_cooldown, 0.5 SECONDS)
	return TRUE

/datum/preference/choiced/pda_ringtone_sound/init_possible_values()
	return GLOB.pda_ringtone_sounds

/datum/preference/choiced/pda_ringtone_sound/create_default_value()
	return PDA_RINGTONE_SOUND_DEFAULT

// Returning false here because this pref is handled a little differently, due to its dependency on the existence of a PDA.
/datum/preference/choiced/pda_ringtone_sound/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

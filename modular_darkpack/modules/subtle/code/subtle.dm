/* CRIMSON EDIT REMOVE - Removes ERP

#define SUBTLE_DEFAULT_DISTANCE world.view
#define SUBTLE_MESSAGE_LEN MAX_MESSAGE_LEN * 2 // 4000 at the time of writing
#define SUBTLE_ONE_TILE 1
#define SUBTLE_SAME_TILE_DISTANCE 0

#define SUBTLE_ONE_TILE_TEXT "1-Tile Range"
#define SUBTLE_SAME_TILE_TEXT "Same Tile"

/datum/emote/living/subtle
	key = "subtle"
	key_third_person = "subtle"
	message = null
	mob_type_blacklist_typecache = list(/mob/living/brain)

// DARKPACK TODO: Replace to be in line with the rest of our talking sound
/datum/preference/toggle/subtler_sound
	savefile_key = "subtler_sound"
	savefile_identifier = PREFERENCE_PLAYER
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = TRUE

/proc/log_subtle(text, list/data)
	logger.Log(LOG_CATEGORY_SUBTLE, text, data)

/datum/log_category/stats
	category = LOG_CATEGORY_STATS

/datum/log_category/subtle
	category = LOG_CATEGORY_SUBTLE

/datum/emote/living/subtle/run_emote(mob/user, params, type_override, intentional)
	if(!can_run_emote(user))
		to_chat(user, span_warning("You can't emote at this time."))
		return FALSE
	var/subtle_message
	var/subtle_emote = params
	if(SSdbcore.IsConnected() && is_banned_from(user, "Emote"))
		to_chat(user, "You cannot send subtle emotes (banned).")
		return FALSE
	else if(user.client?.prefs.muted & MUTE_IC)
		to_chat(user, "You cannot send IC messages (muted).")
		return FALSE
	else if(!params)
		subtle_emote = tgui_input_text(user, "Choose an emote to display.", "Subtle", null, max_length = SUBTLE_MESSAGE_LEN, multiline = TRUE)
		if(!subtle_emote)
			return FALSE
		subtle_message = subtle_emote
	else
		subtle_message = params

	if(!can_run_emote(user))
		to_chat(user, span_warning("You can't emote at this time."))
		return FALSE

	user.log_message(subtle_message, LOG_SUBTLE)

	var/space = should_have_space_before_emote(html_decode(subtle_emote)[1]) ? " " : ""

	subtle_message = span_subtle("<b>[user]</b>[space]<i>[user.apply_message_emphasis(subtle_message)]</i>")

	var/list/viewers = get_hearers_in_view(SUBTLE_ONE_TILE, get_turf(user))

	for(var/obj/item/dullahan_relay/dullahan in viewers)
		viewers -= dullahan
		viewers += dullahan.owner

	for(var/obj/effect/overlay/holo_pad_hologram/iterating_hologram in viewers)
		if(iterating_hologram?.Impersonation?.client)
			viewers |= iterating_hologram.Impersonation

	for(var/mob/ghost as anything in GLOB.dead_mob_list)
		if(isnull(ghost.client) || isnewplayer(ghost))
			continue
		if((ghost.client?.prefs.chat_toggles & CHAT_GHOSTSIGHT))
			to_chat(ghost, "[FOLLOW_LINK(ghost, user)] [subtle_message]")

	for(var/mob/receiver in viewers)
		receiver.show_message(subtle_message, alt_msg = subtle_message)
		// Optional sound notification
		if(!isobserver(receiver))
			if(receiver.client?.prefs.read_preference(/datum/preference/toggle/subtler_sound))
				receiver.playsound_local(get_turf(receiver), 'sound/effects/achievement/beeps_jingle.ogg', 50)

	return TRUE

/*
*	SUBTLE 2: NO GHOST BOOGALOO
*/

/datum/emote/living/subtler
	key = "subtler"
	key_third_person = "subtler"
	message = null
	mob_type_blacklist_typecache = list(/mob/living/brain)

/datum/emote/living/subtler/run_emote(mob/user, params, type_override, intentional)
	if(!can_run_emote(user))
		to_chat(user, span_warning("You can't emote at this time."))
		return FALSE
	var/subtler_message
	var/subtler_emote = params
	var/target
	var/subtler_range = SUBTLE_DEFAULT_DISTANCE

	if(SSdbcore.IsConnected() && is_banned_from(user, "Emote"))
		to_chat(user, span_warning("You cannot send subtle emotes (banned)."))
		return FALSE
	else if(user.client?.prefs.muted & MUTE_IC)
		to_chat(user, span_warning("You cannot send IC messages (muted)."))
		return FALSE
	else if(!subtler_emote)
		subtler_emote = tgui_input_text(user, "Choose an emote to display.", "Subtler" , max_length = SUBTLE_MESSAGE_LEN, multiline = TRUE)
		if(!subtler_emote)
			return FALSE

		var/list/in_view = get_hearers_in_view(subtler_range, get_turf(user))

		in_view -= GLOB.dead_mob_list
		in_view.Remove(user)

		for(var/obj/item/dullahan_relay/dullahan in in_view)
			in_view -= dullahan
			if(user != dullahan.owner)
				in_view += dullahan.owner
		for(var/mob/mob in in_view) // Filters out the AI eye and clientless mobs.
			if(!istype(mob, /mob/eye/camera/ai))
				continue
			if(mob.client)
				continue
			in_view.Remove(mob)

		var/list/targets = list(SUBTLE_ONE_TILE_TEXT, SUBTLE_SAME_TILE_TEXT) + in_view
		target = tgui_input_list(user, "Pick a target", "Target Selection", targets)
		if(!target)
			return FALSE

		switch(target)
			if(SUBTLE_ONE_TILE_TEXT)
				target = SUBTLE_ONE_TILE
			if(SUBTLE_SAME_TILE_TEXT)
				target = SUBTLE_SAME_TILE_DISTANCE
		subtler_message = subtler_emote
	else
		target = SUBTLE_ONE_TILE
		subtler_message = subtler_emote

	if(!can_run_emote(user))
		to_chat(user, span_warning("You can't emote at this time."))
		return FALSE

	user.log_message(subtler_message, LOG_SUBTLE)

	var/space = should_have_space_before_emote(html_decode(subtler_message)[1]) ? " " : ""

	subtler_message = span_subtler("<b>[user]</b>[space]<i>[user.apply_message_emphasis(subtler_message)]</i>")

	if(istype(target, /mob))
		var/mob/target_mob = target
		user.show_message(subtler_message, alt_msg = subtler_message)
		if((get_dist(user.loc, target_mob.loc) <= subtler_range))
			target_mob.show_message(subtler_message, alt_msg = subtler_message)
			if(target_mob.client?.prefs.read_preference(/datum/preference/toggle/subtler_sound))
				target_mob.playsound_local(get_turf(target_mob), 'sound/effects/achievement/glockenspiel_ping.ogg', 50)
		else
			to_chat(user, span_warning("Your emote was unable to be sent to your target: Too far away."))
	else if(istype(target, /obj/effect/overlay/holo_pad_hologram))
		var/obj/effect/overlay/holo_pad_hologram/hologram = target
		if(hologram.Impersonation?.client)
			hologram.Impersonation.show_message(subtler_message, alt_msg = subtler_message)
			if(hologram.Impersonation?.client?.prefs.read_preference(/datum/preference/toggle/subtler_sound))
				hologram.Impersonation.playsound_local(get_turf(hologram.Impersonation), 'sound/effects/achievement/glockenspiel_ping.ogg', 50)
	else
		if(isobj(target))
			return TRUE
		var/ghostless = get_hearers_in_view(target, user) - GLOB.dead_mob_list
		for(var/obj/item/dullahan_relay/dullahan in ghostless)
			ghostless -= dullahan
			ghostless += dullahan.owner

		for(var/mob/receiver in ghostless)
			receiver.show_message(subtler_message, alt_msg = subtler_message)
			if(receiver.client?.prefs.read_preference(/datum/preference/toggle/subtler_sound))
				receiver.playsound_local(get_turf(receiver), 'sound/effects/achievement/glockenspiel_ping.ogg', 50)

	return TRUE

/*
*	VERB CODE
*/
GAME_VERB(/mob/living, subtle_verb, "Subtle", "IC")
	if(GLOB.say_disabled)	// This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return
	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(emote), "subtle"))

/*
*	VERB CODE 2
*/
GAME_VERB(/mob/living, subtler_verb, "Subtler Anti-Ghost", "IC")
	if(GLOB.say_disabled)	// This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return
	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(emote), "subtler"))

#undef SUBTLE_DEFAULT_DISTANCE
#undef SUBTLE_MESSAGE_LEN
#undef SUBTLE_ONE_TILE
#undef SUBTLE_SAME_TILE_DISTANCE

#undef SUBTLE_ONE_TILE_TEXT
#undef SUBTLE_SAME_TILE_TEXT
*/ // CRIMSON EDIT REMOVE - Removes ERP

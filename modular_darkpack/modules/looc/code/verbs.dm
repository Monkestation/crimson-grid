#define LOOC_RANGE 7

GAME_VERB_DESC(/client, looc, "LOOC", "Local OOC, seen only by those in view.", "OOC", msg as text)
	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(looc_message), msg))

GAME_VERB_DESC(/client, looc_wallpierce, "LOOC (Wallpierce)", "Local OOC, seen by anyone within 7 tiles of you.", "OOC" , msg as text)
	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(looc_message), msg, TRUE))

/client/proc/looc_message(msg, wall_pierce)
	if(GLOB.say_disabled)
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(!mob)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	if(!holder)
		if(!GLOB.looc_allowed)
			to_chat(src, span_danger("LOOC is globally muted."))
			return
		if(handle_spam_prevention(msg, MUTE_OOC))
			return
		if(findtext(msg, "byond://"))
			to_chat(src, span_boldannounce("<B>Advertising other servers is not allowed.</B>"))
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			return
		if(prefs.muted & MUTE_LOOC)
			to_chat(src, span_danger("You cannot use LOOC (muted)."))
			return
		if(is_banned_from(ckey, BAN_LOOC))
			to_chat(src, span_warning("You are LOOC banned!"))
			return
		if(mob.stat == DEAD && CONFIG_GET(flag/disable_ghost_looc))
			to_chat(src, span_danger("You cannot use LOOC while dead."))
			return
		if(isdead(mob) && CONFIG_GET(flag/disable_ghost_looc))
			to_chat(src, span_danger("You cannot use LOOC while ghosting."))
			return

	msg = emoji_parse(msg)

	mob.log_talk(msg, LOG_OOC, tag = "LOOC")
	var/list/heard
	if(wall_pierce)
		heard = get_hearers_in_range(LOOC_RANGE, mob)
	else
		heard = get_hearers_in_view(LOOC_RANGE, mob)

	//so the ai can post looc text
	if(istype(mob, /mob/living/silicon/ai))
		var/mob/living/silicon/ai/ai = mob
		if(wall_pierce)
			heard = get_hearers_in_range(LOOC_RANGE, ai.eyeobj)
		else
			heard = get_hearers_in_view(LOOC_RANGE, ai.eyeobj)
	//so the ai can see looc text
	for(var/mob/living/silicon/ai/ai as anything in GLOB.ai_list)
		if(ai.client && !(ai in heard) && (ai.eyeobj in heard))
			heard += ai

	var/list/admin_seen = list()
	for(var/mob/hearing in heard)
		if(!hearing.client)
			continue
		var/client/hearing_client = hearing.client
		if(hearing_client.holder)
			admin_seen[hearing_client] = TRUE
		/* // CRIMSON REMOVAL START - no no, ghosts should be able to.
			// dont continue here, still need to show runechat

		if(isobserver(hearing))
			continue //Also handled later.
		*/ // CRIMSON REMOVAL END

		// CRIMSON EDIT ADDITION START
		// do the runetext here so admins can still get the runetext
		if(mob.runechat_prefs_check(hearing_client.mob) && hearing_client.prefs.read_preference(/datum/preference/toggle/enable_looc_runechat))
			// EMOTE is close enough. We don't want it to treat the raw message with languages.
			// I wish it didn't include the asterisk but it's modular this way.
			hearing_client.mob?.create_chat_message(mob, /datum/language/common, "\[LOOC: [msg]\]", list("looc", "italics"))
		// CRIMSON EDIT ADDITION END

		to_chat(hearing_client, span_looc(span_prefix("LOOC[wall_pierce ? " (WALL PIERCE)" : ""]:</span> <EM>[src.mob.name]:</EM> <span class='message'>[msg]")))

	for(var/client/admin_client in GLOB.admins)
		if(admin_seen[admin_client])
			to_chat(admin_client, span_looc("[ADMIN_FLW(usr)] <span class='prefix'>LOOC[wall_pierce ? " (WALL PIERCE)" : ""]:</span> <EM>[src.key]/[src.mob.name]:</EM> <span class='message'>[msg]</span>"))
		else if(admin_client.prefs.read_preference(/datum/preference/toggle/see_looc))
			to_chat(admin_client, span_rlooc("[ADMIN_FLW(usr)] <span class='prefix'>(R)LOOC[wall_pierce ? " (WALL PIERCE)" : ""]:</span> <EM>[src.key]/[src.mob.name]:</EM> <span class='message'>[msg]</span>"))

#undef LOOC_RANGE

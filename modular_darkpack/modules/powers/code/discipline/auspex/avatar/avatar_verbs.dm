GAME_VERB(/mob/living/basic/avatar, reenter_corpse, "Re-enter Corpse", null)
	exit_avatar(force = FALSE)

/mob/living/basic/avatar/say(
	message,
	bubble_type,
	list/spans = list(),
	sanitize = TRUE,
	datum/language/language,
	ignore_spam = FALSE,
	forced,
	filterproof = FALSE,
	message_range = 7,
	datum/saymode/saymode,
	list/message_mods = list(),
)
	return

/mob/living/basic/avatar/try_speak(message, ignore_spam, forced, filterproof)
	return

/mob/living/basic/avatar/emote(act, type_override, message, intentional, force_silence, forced)
	return FALSE

/mob/living/basic/avatar/grab(mob/living/target)
	return GRAB_FAILURE

/mob/living/basic/avatar/proc/exit_avatar(force = FALSE)
	if(!client)
		return
	if(!mind || QDELETED(mind.current))
		to_chat(src, span_warning("You have no body."))
		return
	if((get_turf(src) != get_turf(mind.current)) && !force)
		to_chat(src, span_warning("You must be at your body's location to re-enter it."))
		return
	if(mind.current.key && !IS_FAKE_KEY(mind.current.key)) //makes sure we don't accidentally kick any clients
		to_chat(usr, span_warning("Another consciousness is in your body...It is resisting you."))
		return
	client.view_size.resetToDefault()//Let's reset so people can't become allseeing gods
	SStgui.on_transfer(src, mind.current) // Transfer NanoUIs.
	if(mind.current.stat == DEAD)
		to_chat(src, span_warning("To leave your body again use the Ghost verb."))
	mind.current.PossessByPlayer(key)
	mind.current.client.init_verbs()
	qdel(src)
	return TRUE

/mob/living/basic/avatar/down()
	if(zMove(DOWN, z_move_flags = ZMOVE_FEEDBACK))
		to_chat(src, span_notice("You move down."))

/mob/living/basic/avatar/up()
	if(zMove(UP, z_move_flags = ZMOVE_FEEDBACK))
		to_chat(src, span_notice("You move upwards."))

/mob/living/basic/avatar/can_z_move(direction, turf/start, turf/destination, z_move_flags = NONE, mob/living/rider)
	z_move_flags |= ZMOVE_IGNORE_OBSTACLES  //avatars do not respect these FLOORS you speak so much of.
	return ..()

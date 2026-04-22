#define MASQUERADE_FILTER_CHECK(T) (SSmasquerade.masquerade_breaching_phrase_regex && findtext(T, SSmasquerade.masquerade_breaching_phrase_regex))

/mob/living/carbon/human/npc/Hear(atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, radio_freq_name, radio_freq_color, list/spans, list/message_mods = list(), message_range = 0, source)
	. = ..()
	if(stat >= SOFT_CRIT)
		return FALSE

	var/dist = get_dist(speaker, src) - message_range
	if(dist > 0 && dist <= EAVESDROP_EXTRA_RANGE && !HAS_TRAIT(src, TRAIT_GOOD_HEARING))
		raw_message = stars(raw_message)
	if(message_range != INFINITY && dist > EAVESDROP_EXTRA_RANGE && !HAS_TRAIT(src, TRAIT_GOOD_HEARING))
		return FALSE

	if(!has_language(message_language))
		return FALSE

	var/treated_message = translate_language(speaker, message_language, raw_message, spans, message_mods)
	if(lowertext(MASQUERADE_FILTER_CHECK(treated_message)))
		SEND_SIGNAL(src, COMSIG_SEEN_MASQUERADE_VIOLATION, speaker)
	return TRUE

/obj/item/smartphone/proc/handle_hearing(datum/source, list/hearing_args)
	SIGNAL_HANDLER

	if(current_state == PHONE_IN_CALL)
		if(istype(hearing_args[HEARING_SPEAKER], /atom/movable/virtualspeaker))
			return
		var/message = compose_message(hearing_args[HEARING_SPEAKER], hearing_args[HEARING_LANGUAGE], hearing_args[HEARING_RAW_MESSAGE], hearing_args[HEARING_RADIO_FREQ], hearing_args[HEARING_RADIO_FREQ_NAME], hearing_args[HEARING_RADIO_FREQ_COLOR], hearing_args[HEARING_SPANS], hearing_args[HEARING_MESSAGE_MODE], FALSE)
		SSmasquerade.log_phone_message(message, source)
		if(MASQUERADE_FILTER_CHECK(lowertext(hearing_args[HEARING_RAW_MESSAGE])))
			SEND_SIGNAL(src, COMSIG_SEEN_MASQUERADE_VIOLATION, hearing_args[HEARING_SPEAKER])

#undef MASQUERADE_FILTER_CHECK

/mob/living/carbon/human/Topic(href, href_list)
	// DARKPACK TODO - reimplement in a sane way.
	if(href_list["masquerade_violation"])
		if(!ismundane(usr))
			return
		var/mob/living/carbon/human/reporter = usr
		if(IS_UNCONSCIOUS_OR_CRIT(reporter))
			return
		if(usr == src)
			return
		var/reason = tgui_input_text(reporter, "Write a description of violation", "Spot a Masquerade violation", null, MAX_MESSAGE_LEN)
		if(!reason)
			return
		reason = sanitize(reason)
		if(!reporter.on_observed_violation(reporter, src))
			return
		message_admins("[ADMIN_LOOKUPFLW(reporter)] spotted [ADMIN_LOOKUPFLW(src)]'s Masquerade violation. Description: [reason]")
		log_game("[ADMIN_LOOKUPFLW(reporter)] spotted [ADMIN_LOOKUPFLW(src)]'s Masquerade violation. Description: [reason]")
		to_chat(src, span_danger("You were found to be violating the masquereade for: [reason]"))

	if(href_list["masquerade_reinforcement"])
		if(!ismundane(usr))
			return
		var/mob/living/carbon/human/reporter = usr
		if(IS_UNCONSCIOUS_OR_CRIT(reporter))
			return
		if(usr == src)
			return
		if(!reporter.on_masquerade_violation_reinforced(reporter, src))
			return
		message_admins("[ADMIN_LOOKUPFLW(reporter)] repaired [ADMIN_LOOKUPFLW(src)]'s Masquerade violation.")
		log_game("[ADMIN_LOOKUPFLW(reporter)] repaired [ADMIN_LOOKUPFLW(src)]'s Masquerade violation.")


	. = ..()


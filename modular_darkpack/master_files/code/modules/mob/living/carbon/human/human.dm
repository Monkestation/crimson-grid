/mob/living/carbon/human/Topic(href, href_list)
	// DARKPACK TODO - reimplement in a sane way.
	if(href_list["masquerade_violation"])
		if(!ismundane(usr))
			return
		var/mob/living/carbon/human/reporter = usr
		if(reporter.stat > UNCONSCIOUS)
			return
		if(usr == src)
			return
		var/reason = tgui_input_text(reporter, "Write a description of violation", "Spot a Masquerade violation", null, MAX_MESSAGE_LEN)
		if(!reason)
			return
		reason = sanitize(reason)
		if(!SEND_SIGNAL(reporter, COMSIG_SEEN_MASQUERADE_VIOLATION, src))
			return
		message_admins("[ADMIN_LOOKUPFLW(reporter)] spotted [ADMIN_LOOKUPFLW(src)]'s Masquerade violation. Description: [reason]")
		log_game("[ADMIN_LOOKUPFLW(reporter)] spotted [ADMIN_LOOKUPFLW(src)]'s Masquerade violation. Description: [reason]")
		to_chat(src, span_danger("You were found to be violating the masquereade for: [reason]"))

	if(href_list["masquerade_reinforcement"])
		if(!ismundane(usr))
			return
		var/mob/living/carbon/human/reporter = usr
		if(reporter.stat > UNCONSCIOUS)
			return
		if(usr == src)
			return
		if(!SEND_SIGNAL(reporter, COMSIG_MASQUERADE_REINFORCE, src))
			return
		message_admins("[ADMIN_LOOKUPFLW(reporter)] repaired [ADMIN_LOOKUPFLW(src)]'s Masquerade violation.")
		log_game("[ADMIN_LOOKUPFLW(reporter)] repaired [ADMIN_LOOKUPFLW(src)]'s Masquerade violation.")


	. = ..()

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	// clientless mobs are given a random voice
	if(!client && length(SSblooper.blooper_list))
		var/blooper_key = pick(SSblooper.blooper_list)
		blooper = SSblooper.blooper_list[blooper_key]
		blooper_speed = rand(0, 100)
		blooper_pitch = rand(0, 100)
		blooper_pitch_range = rand(0, 100)

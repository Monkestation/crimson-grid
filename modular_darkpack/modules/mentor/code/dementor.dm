GAME_VERB_PROC(/client, cmd_mentor_dementor, "Dementor", "Mentor")
	if(!is_mentor())
		return
	remove_mentor_verbs()
	GLOB.mentors -= src
	to_chat(src, span_interface("You are no longer a mentor."))
	log_mentor("MENTOR: [src] dementored.")
	add_verb(src,/client/proc/cmd_mentor_rementor)

GAME_VERB_PROC(/client, cmd_mentor_rementor, "Rementor", "Mentor")
	if(!is_mentor())
		return
	add_mentor_verbs()
	GLOB.mentors[src] = TRUE
	to_chat(src, span_interface("You are now a mentor."))
	log_mentor("MENTOR: [src] rementored.")
	remove_verb(src,/client/proc/cmd_mentor_rementor)


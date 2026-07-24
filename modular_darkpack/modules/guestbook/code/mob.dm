///Shows guestbook tgui window
GAME_VERB_DESC(/mob, guestbook, "Guestbook", "View your character's Guestbook.", "IC")
	if(!mind)
		var/fail_message = "You have no mind!"
		if(isobserver(src))
			fail_message += " You have to be in the current round at some point to have one."
		to_chat(src, span_warning(fail_message))
		return
	mind.guestbook.ui_interact(usr)

GAME_VERB_DESC(/mob/living/carbon/human, set_custom_examine_text, "Set Custom Examine Text", "Set a custom examine message to what your character is doing at the moment.", "IC")
	var/new_text = tgui_input_text(src, "Set your new custom examine text.", "Examine Text", custom_examine_message, MAX_MESSAGE_LEN, TRUE)

	custom_examine_message = new_text

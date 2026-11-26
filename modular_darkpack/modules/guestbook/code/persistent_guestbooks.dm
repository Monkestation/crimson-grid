///Saves all guestbooks for everyone's original characters
/mob/living/proc/save_guestbook(list/known_names)
	if(HAS_TRAIT(src, TRAIT_NO_CANON))
		return
	if(ishuman(src))
		var/mob/living/carbon/human/human_user = src
		if(human_user.cant_save_midround_reason())
			return
	client.prefs.guestbook_names = known_names
	client.prefs.save_character()

/mob/living/proc/load_guestbook()
	if(!mind || !mind.original_character_slot_index || !client)
		return
	var/list/known_names = client.prefs.guestbook_names
	if(!known_names)
		return
	mind.guestbook.known_names = known_names

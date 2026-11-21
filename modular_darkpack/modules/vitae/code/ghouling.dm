/mob/living/carbon/human/proc/prompt_permanent_ghouling()
	var/response = tgui_alert(src, "Do you wish to keep being a ghoul on your save slot? This is a permanent choice, and you can't go back!", "Ghouling", list("Yes", "No"))
	if(response == "Yes")
		write_preference_midround(/datum/preference/choiced/splats, SPLAT_GHOUL)
		to_chat(src, span_danger("You have chosen to permanently become a ghoul!"))


/mob/living/carbon/human/proc/ghoulificate(mob/living/carbon/human/owner)
	make_ghoul(owner)
	SEND_SIGNAL(src, COMSIG_ALL_MASQUERADE_REINFORCE)
	if(!mind)
		return
	send_ghoul_vitae_consumption_message(owner)

/mob/living/carbon/human/proc/send_ghoul_vitae_consumption_message(mob/living/carbon/human/owner)
	if(HAS_TRAIT(src, TRAIT_UNBONDABLE) || !owner)
		to_chat(src, span_warning("Precious vitae enters your mouth, an addictive drug. You feel no loyalty, though, to the source; only the substance."))
		return TRUE
	var/mob/living/master = mind.enslaved_to?.resolve()
	if(master != owner)
		mind.enslave_mind_to_creator(owner)
		apply_status_effect(/datum/status_effect/blood_bond, owner)
		to_chat(src, span_userdanger("From the first sip from the first night, you shall idolize or hate from whom you've drank deep. From the second sip upon the second night, you shall likewise hold onto their words and seek to curry their favor. Upon the third night and third drink, you are utterly theirs. Acts of defiant will are possible, but they are fleeting."))
		return TRUE



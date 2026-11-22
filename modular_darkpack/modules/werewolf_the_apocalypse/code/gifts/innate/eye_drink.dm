/datum/storyteller_roll/eye_drink
	bumper_text = "Eye-Drinking"
	applicable_stats = list(STAT_PERCEPTION, STAT_EMPATHY)
	numerical = TRUE

/datum/action/cooldown/power/gift/eye_drink
	name = "Eye-Drinking"
	desc = "Consumes the eyes of a corpse to unlock the secrets of its demise."
	button_icon_state = "eye_drink"
	cooldown_time = 1 SCENES
	innate_ability = TRUE
	click_to_activate = TRUE

/datum/action/cooldown/power/gift/eye_drink/Activate(atom/target)
	var/mob/living/carbon/human/human_target = astype(target)
	if(!human_target)
		return
	if(!(human_target in range(1, owner)))
		return
	if(human_target.stat != DEAD)
		to_chat(owner, span_warning("[target] must be a corpse."))
		return
	var/obj/item/organ/eyes/victim_eyeballs = human_target.get_organ_slot(ORGAN_SLOT_EYES)
	if(!victim_eyeballs)
		to_chat(owner, span_warning("You cannot drink the eyes of a corpse that has no eyes!"))
		return

	. = ..()

	if(!do_after(owner, 1 TURNS))
		return TRUE

	var/datum/storyteller_roll/eye_drink/roll_datum = new()
	var/successes = roll_datum.st_roll(owner, human_target)

	var/mob/prompting_mob
	if(human_target.client)
		prompting_mob = human_target
	else
		prompting_mob = human_target.get_ghost(TRUE, TRUE)

	if(prompting_mob)
		var/permission = tgui_alert(prompting_mob, "Will you allow [owner.real_name] to view your death? They received [successes] successes on their Perception + Empathy roll (Note: You are expected to tell the truth in your character's eyes!)", "Select", list("Yes","No","I don't recall") ,"Yes", 1 MINUTES)
		if(permission != "Yes")
			to_chat(owner, span_warning("The spirit seems relunctact to let you consume their eyes... so you refrain from doing so."))
			return TRUE
	else
		if(successes <= 0)
			return TRUE

	if(!istype(owner, /mob/living/basic/corvid/corvid))
		to_chat(owner, span_notice("You drink of the eyes of [human_target] and a vision fills your mind..."))
		SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	else
		to_chat(owner, span_notice("You drink of the eyes of [human_target] and a vision fills your mind..."))

	var/deathdesc
	if(prompting_mob)
		deathdesc = tgui_input_text(
			prompting_mob,
			"Eye-Drinking",
			"Describe a vision of the moments leading up to your death. [owner] received [successes] successes. Be more clear the more successes they received.",
			max_length = 300,
			multiline = TRUE,
			timeout = 5 MINUTES
		)
	else if(human_target.last_death_info)
		var/datum/death_report/death_info = human_target.last_death_info
		var/list/info_list = list()
		if(death_info.area)
			info_list += "The scene begins in [death_info.area]."
		if(death_info.last_attacker_name)
			info_list += "Someone attacks them with the apperance of [death_info.last_attacker_name]."
		if(death_info.last_words)
			info_list += "They mouth something you cannot hear."

		if(death_info.suicide)
			info_list += "A graphic scene which shows there unfortunate suicide."
		else
			info_list += "The scene ends before the specifics of there death is made clear."
		deathdesc += jointext(info_list, " ")

	if(!deathdesc)
		to_chat(owner, span_warning("The vision is hazy, you can't make out too many details..."))
	else
		to_chat(owner, "Visions flood your mind: <i>[deathdesc]</i>")

	if(isnpc(human_target)) // Dont have granuliaty for removing one eye and this shows the empty sockets
		qdel(victim_eyeballs)
	else // Fuck a real player a little less.
		victim_eyeballs.apply_scar(pick(LEFT_EYE_SCAR, RIGHT_EYE_SCAR))

	return TRUE

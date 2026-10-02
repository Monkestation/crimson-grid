/mob/living/carbon/human/proc/handle_diablerie(mob/living/victim)

	var/diablerie_prompt = tgui_alert(src, "Attempt to diablerize [victim]?", "Diablerize", list("Yes", "No"), "No")
	switch(diablerie_prompt)
		if("Yes")
			var/datum/splat/vampire/kindred/kindred = get_kindred_splat(src)
			var/generation = get_generation()
			var/victim_generation = victim.get_generation()

			if(kindred)
				SEND_SIGNAL(victim, COMSIG_PATH_HIT, -1, 0, FALSE)
			if(victim_generation >= generation)
				message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(victim)]")
				log_attack("[key_name(src)] successfully Diablerized [key_name(victim)].")
				if(victim.client)
					var/datum/brain_trauma/special/imaginary_friend/trauma = gain_trauma(/datum/brain_trauma/special/imaginary_friend)
					trauma.friend.key = victim.key
			else
				var/start_prob = 10
				if(HAS_TRAIT(src, TRAIT_DIABLERIE))
					start_prob = 30
				if(prob(min(99, start_prob+((generation-victim_generation)*10))))
					to_chat(src, span_userdanger(span_bold("[victim]'s soul overcomes yours and gains control of your body!")))
					message_admins("[ADMIN_LOOKUPFLW(src)] tried to Diablerize [ADMIN_LOOKUPFLW(victim)] and was overtaken.")
					log_attack("[key_name(src)] tried to Diablerize [key_name(victim)] and was overtaken.")
					kindred.set_generation(victim_generation)
					if(victim.mind)
						victim.mind.transfer_to(src, TRUE)
					else
						death()
					return
				message_admins("[ADMIN_LOOKUPFLW(src)] successfully Diablerized [ADMIN_LOOKUPFLW(victim)]")
				log_attack("[key_name(src)] successfully Diablerized [key_name(victim)].")
				if(victim.client)
					var/datum/brain_trauma/special/imaginary_friend/diablerie/trauma = gain_trauma(/datum/brain_trauma/special/imaginary_friend/diablerie)
					trauma.friend.key = victim.key

			steal_discipline_from(victim) // CRIMSON EDIT ADD - Diablerie progression
			make_diablerist()
			adjust_brute_loss(-50, TRUE)
			adjust_fire_loss(-50, TRUE)
			victim.death()
		if("No")	//Defaults to this if no if option not chosen to avoid issue.
			return FALSE

// CRIMSON EDIT ADD START - Diablerie progression
/mob/living/carbon/human/proc/steal_discipline_from(mob/living/carbon/human/victim)
	if(!GLOB.canon_event)
		return
	if(HAS_TRAIT(src, TRAIT_NO_CANON) || HAS_TRAIT(victim, TRAIT_NO_CANON))
		return
	var/datum/splat/vampire/kindred/victim_splat = get_kindred_splat(victim)
	if(!victim.mind || !victim_splat)
		return
	if(victim.stat == DEAD)
		return
	var/datum/preferences/prefs = client?.prefs
	if(!prefs)
		return

	var/list/stealable_levels = list()
	for(var/datum/action/discipline/discipline_action as anything in victim_splat.powers)
		var/datum/discipline/discipline = discipline_action.discipline
		if(!discipline?.selectable || ispath(discipline.type, /datum/discipline/path))
			continue
		// if its in OUR prefs, we already know it...
		if((discipline.type in prefs.discipline_levels) || ("[discipline.type]" in prefs.discipline_levels))
			continue
		stealable_levels[discipline.type] = discipline.level

	if(!length(stealable_levels))
		to_chat(src, span_warning("[victim]'s soul holds no secrets you have not already mastered."))
		return

	var/datum/discipline/stolen_type = pick(stealable_levels)
	var/points_gained = max(1, stealable_levels[stolen_type] - 1)
	var/bonus_points = min(prefs.read_preference(/datum/preference/numeric/bonus_discipline_points) + points_gained, 20)

	if(!write_preference_midround(/datum/preference/numeric/bonus_discipline_points, bonus_points))
		return

	prefs.discipline_levels["[stolen_type]"] = 0
	prefs.save_character()

	var/stolen_name = initial(stolen_type.name)
	to_chat(src, span_cult("As [victim]'s soul becomes yours, you tear the secrets of [stolen_name] from it. You may spend [points_gained] discipline point\s on your character sheet next night."))
	log_game("[key_name(src)] stole [stolen_name] and [points_gained] discipline point\s by diablerizing [key_name(victim)]. Bonus discipline points are now [bonus_points].")
// CRIMSON EDIT ADD END - Diablerie progression

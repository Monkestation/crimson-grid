//discipline stuff
GLOBAL_LIST_INIT(rare_discipline_types, list(
	/datum/discipline/quietus,
	/datum/discipline/temporis,
	/datum/discipline/serpentis,
	/datum/discipline/dementation,
	/datum/discipline/obtenebration,
	/datum/discipline/thaumaturgy,
	/datum/discipline/necromancy,
	/datum/discipline/daimoinon,
	/datum/discipline/valeren,
	// melpominee not yet implemented but will go here
))

// warns a player if they have no discipline dots assigned before joining
// returns TRUE if they want to proceed, FALSE if they want to go back and fix their disciplines
/mob/dead/new_player/proc/check_discipline_warning()
	if(!client?.prefs)
		return TRUE
	var/splat = client.prefs.read_preference(/datum/preference/choiced/splats)
	if(!ispath(splat, /datum/splat/vampire))
		return TRUE
	for(var/disc in client.prefs.discipline_levels)
		if(client.prefs.discipline_levels[disc] > 0)
			return TRUE
	var/choice = tgui_alert(src, "You have not allocated any discipline dots! As a precaution, you will automatically be assigned 1 dot in each of your clan's common disciplines when you spawn.", "Disciplines Not Configured", list("I understand", "Go Back"))
	return choice == "I understand"

// discipline weights (trusted players arent affected by these)
// 5 possible total disciplines
// no greater than 2 non-clan rare disciplines
// 1 rare in addition to non-clan means you get max 1 common additional on top of that
// no rare additionals means you get a max of 2 common additionals
/proc/validate_discipline_sheet(list/discipline_levels, list/clan_disciplines, is_trusted = FALSE)
	var/list/result = list()
	var/list/violations = list()
	var/total = 0
	var/additional = 0
	var/additional_rare = 0

	for(var/disc_path in discipline_levels)
		if(!discipline_levels[disc_path])
			continue
		total++
		if(!(disc_path in clan_disciplines))
			additional++
			if(text2path(disc_path) in GLOB.rare_discipline_types)
				additional_rare++

	if(!is_trusted)
		if(total > 5)
			violations += "Total disciplines ([total]) exceeds the limit of 5."
		if(additional_rare > 2)
			violations += "Has [additional_rare] rare additional disciplines! The maximum for non-trusted players is 2.\n"
		else if(additional_rare == 1 && additional > 2)
			violations += "With 1 rare additional discipline, only 1 common additional is permitted ([additional - 1] common found).\n"
		else if(additional_rare == 0 && additional > 2)
			violations += "Has [additional] additional common disciplines! The maximum for non-trusted players is 2 without a rare."

	result["total"] = total
	result["additional"] = additional
	result["additional_rare"] = additional_rare
	result["valid"] = !length(violations)
	result["violations"] = violations
	return result

// for validating a mob's sheet before teaching them a new one
// validated against the above criteria
/proc/validate_mob_sheet(mob/living/carbon/human/human, discipline_type_to_add = null)
	var/datum/splat/vampire/vamp_splat = get_splat_with_discipline(human)
	if(!vamp_splat)
		return null

	var/list/discipline_levels = list()
	for(var/datum/action/discipline/disc_action as anything in vamp_splat.powers)
		var/datum/discipline/disc = disc_action.discipline
		if(!disc?.selectable)
			continue
		if(ispath(disc.type, /datum/discipline/path))
			continue
		discipline_levels["[disc.type]"] = disc.level

	if(discipline_type_to_add)
		var/disc_key = "[discipline_type_to_add]"
		if(!discipline_levels[disc_key])
			discipline_levels[disc_key] = 1

	var/list/clan_disciplines = list()
	var/datum/subsplat/vampire_clan/clan = human.get_clan()
	if(clan)
		for(var/disc_type in clan.clan_disciplines)
			if(ispath(disc_type, /datum/discipline))
				clan_disciplines += "[disc_type]"

	var/is_trusted = human.client?.prefs?.discipline_trusted || FALSE

	return validate_discipline_sheet(discipline_levels, clan_disciplines, is_trusted)

/datum/preference_middleware/disciplines
	action_delegations = list(
		"set_discipline_level" = PROC_REF(set_discipline_level),
		"clear_discipline_levels" = PROC_REF(clear_discipline_levels)
	)

/datum/preference_middleware/disciplines/get_ui_data(mob/user)
	if(preferences.current_window != PREFERENCE_TAB_CHARACTER_PREFERENCES)
		return list()

	var/list/data = list()
	data["discipline_levels"] = list()
	var/points_spent = 0
	for(var/discipline in preferences.discipline_levels)
		var/level = preferences.discipline_levels[discipline]
		data["discipline_levels"]["[discipline]"] = level
		points_spent += level

	var/is_ghoul = ispath(preferences.read_preference(/datum/preference/choiced/splats), /datum/splat/vampire/ghoul)
	data["clan_disciplines"] = list()
	data["clan_name"] = null
	var/clan_value = preferences.read_preference(/datum/preference/choiced/subsplat/vampire_clan)
	if(clan_value)
		var/datum/subsplat/vampire_clan/clan_datum = get_vampire_clan(clan_value)
		if(clan_datum)
			data["clan_name"] = clan_datum.name
			for(var/disc_type in clan_datum.clan_disciplines)
				if(ispath(disc_type, /datum/discipline))
					data["clan_disciplines"] += "[disc_type]"

	var/discipline_count = 0
	var/list/counted_discs = list()
	for(var/disc in preferences.discipline_levels)
		if(preferences.discipline_levels[disc] > 0)
			discipline_count++
			counted_discs[disc] = TRUE

	if(is_ghoul && clan_value)
		var/datum/subsplat/vampire_clan/ghoul_clan_datum = get_vampire_clan(clan_value)
		if(ghoul_clan_datum)
			for(var/disc_type in ghoul_clan_datum.clan_disciplines)
				if(ispath(disc_type, /datum/discipline) && !("[disc_type]" in counted_discs))
					discipline_count++

	var/immortal_age = preferences.read_preference(/datum/preference/numeric/immortal_age)
	var/list/budget_info = is_ghoul ? get_ghoul_discipline_budget(discipline_count) : get_discipline_point_budget(immortal_age)
	data["discipline_points_available"] = budget_info["points"]
	data["discipline_points_spent"] = points_spent
	data["discipline_tier"] = budget_info["tier"]
	data["discipline_tier_details"] = budget_info["details"]
	data["is_trusted"] = preferences.discipline_trusted || FALSE
	data["max_trusted_generation"] = MAX_TRUSTED_GENERATION
	data["max_public_generation"] = MAX_PUBLIC_GENERATION
	data["highest_generation_limit"] = HIGHEST_GENERATION_LIMIT

	return data

/datum/preference_middleware/disciplines/proc/get_discipline_point_budget(immortal_age)
	if(immortal_age <= 10)
		return list(
			"points" = 12,
			"tier" = "Fledgling",
			"details" ="As a Fledgling, you are still learning how to control your new powers, and face your new problems. You are much the same person as you were prior to the embrace, for good or for bad. The phrase \"Life's sucks and then you die\" leaves out how much it sucks to be dead, but you're starting to learn that first-hand. You might be recently declared dead or reported missing, and are struggling to piece together a new unlife without the support network you had when you were alive. There are a lot of rules and customs you're unfamiliar with, and older kindred look down on you. You may be alone, hiding out after a string of murders post-embrace that put you on the radar of law enforcement and the Camarilla, or under the watchful eye of your Sire learning to control yourself under their wing. Either way, you're going to need help to navigate all of this.")
	if(immortal_age <= 100)
		return list(
			"points" = 14,
			"tier" = "Neonate",
			"details" = "As a Neonate, you're starting to get the hang of things with your unlife. You have learned to control your urges enough to be mostly left to your own devices, but older kindred can still smell your inexperience from a mile away. Friends and family you once knew are beginning to grow old and pass away due to natural causes, leaving you with the lasting emotional scars from their absence. Any who you remain in contact with but haven't told about your embrace are likely suspicious about your lack of aging and absence during the day. As a result, you've learned to remain mostly composed, and to keep things close to the vest, especially when it comes to interacting with Kine. With your Kine touchstones dwindling or gone, you'll begin to find solace in others... Or else your humanity might start to fade with them.")
	if(immortal_age <= 200)
		return list(
			"points" = 16,
			"tier" = "Ancilla",
			"details" = "As an Ancilla, you are a dignified member of kindred society. Ancient by Anarch standards, middle-aged by Camarillan. The ties you once held to your originally life have faded with the deaths of your loved ones over a century prior. You have come to find a new family along the way; either by siring childer of your own or making and keeping friendships that have lasted you through the ages. You are a composed, mature vampire that others often turn to when decisions need additional input, or important things need doing.")
	return list("points" = 18,
			"tier" = "Elder",
			"details" = "As an Elder of your clan, you are a walking history book. You have learned to keep quiet about your true age and origins, and have likely made a coterie of enemies, some alive some dead. Walking through time as the winding centipede, crawling into centuries unfamiliar as you learn and adapt to each new shifting culture. You may have emerged from torpor after a battle you may or may not remember years prior, thrust into a world you don't recognize. You likely possess a reputation for good or for bad, for something you may or may not have done hundreds of years ago. Some may take solace in your company as a familiar face, some may want to turn you to ash for a petty grievance from lifetimes prior. If your true age is discovered, the Camarilla will likely try to employ you as an enforcer due to your strength... or an aspiring lick might come along to diablerize you and take your power for themselves. To have survived this long, you're cautious, old, and cunning. Your routines are important, and you stay out of the petty squables of younger Kindred if you can help it.")

/datum/preference_middleware/disciplines/proc/get_ghoul_discipline_budget(discipline_count = 0)
	return list(
		"points" = max(3, discipline_count), // pool expands for each additional discipline they've been taught, but they can never assign more than 1 per
		"tier" = "Ghoul",
		"details" = "As a Ghoul, you are the working class of Kindred society. Not quite Kine, not quite Kindred. An outsider in both worlds. You might have a Domitor, or maybe an 'employer', a Kindred who supplies you regular donations of Kindred blood that sustains your long, ageless life and supernatural abilities. Or, more rarely, you might be a freelancing ghoul that takes Kindred blood where you can find it, a practice heavily frowned upon and could get you killed if the Camarilla ever found out. You keep your head down for the most part and do what you're told, because one wrong look and the only price a Kindred might have to pay for ending your life is a small favor to the Kindred that holds your leash. You're able to run errands for your Domitor during the day time, and use basic forms of the supernatural abilities drawn from the blood you drink.. but for as long as you continue to drink, you will continue to inherit their clan curse, too.")

/datum/preference_middleware/disciplines/get_constant_data()
	var/list/data = list()

	for(var/discipline_type in subtypesof(/datum/discipline))
		var/datum/discipline/discipline = new discipline_type

		if(!discipline.selectable) // default disciplines like bloodheal arent selectable, and dont belong here
			qdel(discipline)
			continue

		if(ispath(discipline_type, /datum/discipline/path)) // avoids giving tremere 50 different discs because thaum has like 50 subtypes
			qdel(discipline)
			continue

		var/list/disc_data = list()
		disc_data["name"] = discipline.name
		disc_data["desc"] = discipline.desc
		disc_data["max_level"] = discipline.max_selectable_level || length(discipline.all_powers)
		disc_data["icon"] = initial(discipline.icon)
		disc_data["icon_state"] = discipline.icon_state
		disc_data["rarity"] = (discipline_type in GLOB.rare_discipline_types) ? "rare" : "common"
		data["[discipline_type]"] = disc_data
		qdel(discipline)

	return data


// sets the character's level in a given discipline
// if you dont put any dots in it, aka level 0, it means you don't spawn in with that discipline
/datum/preference_middleware/disciplines/proc/set_discipline_level(list/params, mob/user)
	SHOULD_NOT_SLEEP(TRUE)

	if(!isnewplayer(user) && ("[user.client.prefs.default_slot]" in user.persistent_client.joined_as_slots))
		to_chat(user, span_warning("You may not adjust discipline dots of characters that have played in the current round.")) // so people dont mess up their saves
		return FALSE

	var/discipline = params["discipline"]
	var/new_level = text2num(params["level"])

	if(!discipline || isnull(new_level))
		return FALSE

	new_level = round(new_level)
	if(new_level < 0 || new_level > 5)
		return FALSE

	if(ispath(preferences.read_preference(/datum/preference/choiced/splats), /datum/splat/vampire/ghoul) && new_level > 1)
		var/clan_value = preferences.read_preference(/datum/preference/choiced/subsplat/vampire_clan)
		var/datum/subsplat/vampire_clan/clan_datum = clan_value ? get_vampire_clan(clan_value) : null
		if(clan_datum)
			for(var/disc_type in clan_datum.clan_disciplines)
				if("[disc_type]" == discipline)
					return FALSE

	var/immortal_age = preferences.read_preference(/datum/preference/numeric/immortal_age)
	var/list/budget_info = get_discipline_point_budget(immortal_age)
	var/point_budget = budget_info["points"]
	var/old_level = preferences.discipline_levels[discipline] || 0
	var/current_total = 0

	for(var/disc in preferences.discipline_levels)
		current_total += preferences.discipline_levels[disc]
	var/new_total = current_total - old_level + new_level

	if(new_level > old_level && new_total > point_budget) // you can go down, but not up, if you're overbudget. for when adminbus gives you more than you can chew
		return FALSE

	preferences.discipline_levels[discipline] = new_level

	preferences.save_character()
	return TRUE

/datum/preference_middleware/disciplines/proc/clear_discipline_levels(list/params, mob/user)
	SHOULD_NOT_SLEEP(TRUE)

	if(!isnewplayer(user) && ("[user.client.prefs.default_slot]" in user.persistent_client.joined_as_slots))
		to_chat(user, span_warning("You may not adjust discipline dots of characters that have played in the current round."))
		return FALSE

	preferences.discipline_levels = list()
	preferences.save_character()
	return TRUE

/datum/preferences/apply_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE, list/do_not_apply)
	if(!isnull(character))
		RegisterSignal(character, COMSIG_HUMAN_PREFS_APPLIED, PROC_REF(on_prefs_applied_disciplines), override = TRUE)
	. = ..()

/datum/preferences/proc/on_prefs_applied_disciplines(mob/living/carbon/human/character)
	SIGNAL_HANDLER
	UnregisterSignal(character, COMSIG_HUMAN_PREFS_APPLIED)

	if(isdummy(character))
		return

	var/datum/splat/vampire/vampire_splat = get_splat_with_discipline(character)

	if(!vampire_splat)
		return

	var/has_any = FALSE // does this hoe even HAVE ANY
	for(var/disc_path in discipline_levels)
		if(discipline_levels[disc_path])
			has_any = TRUE
			break

	if(!has_any)
		var/datum/subsplat/vampire_clan/clan = character.get_clan()
		if(clan)
			for(var/disc_type in clan.clan_disciplines)
				if(!ispath(disc_type, /datum/discipline))
					continue
				discipline_levels["[disc_type]"] = 1
				var/result = character.change_st_power_level(disc_type, 1)
				if(!result)
					character.give_st_power(disc_type, 1)
		save_character()
	else
		for(var/disc_path in discipline_levels)
			var/discipline = text2path(disc_path)
			if(!discipline)
				continue
			var/level = character.get_splat(/datum/splat/vampire/ghoul) ? 1 : discipline_levels[disc_path]
			if(!level)
				continue // prevent removing the disc by stopping here if they put 0 in it
			var/result = character.change_st_power_level(discipline, level)
			if(!result)
				character.give_st_power(discipline, level) // load em up

	SSticker.OnRoundend(CALLBACK(src, PROC_REF(save_disciplines), character))

/datum/preferences/proc/save_disciplines(mob/living/carbon/human/character)
	if(QDELETED(character))
		return

	var/datum/splat/vampire/vampire_splat = get_splat_with_discipline(character)
	if(!vampire_splat)
		return

	var/changed = FALSE
	for(var/datum/action/discipline/disc_action as anything in vampire_splat.powers)
		var/datum/discipline/disc = disc_action.discipline
		if(!disc?.selectable)
			continue
		if(ispath(disc.type, /datum/discipline/path))
			continue
		var/disc_key = "[disc.type]"
		var/in_game_level = disc.level
		var/prefs_level = discipline_levels[disc_key] || 0
		if(in_game_level > prefs_level)
			discipline_levels[disc_key] = in_game_level
			changed = TRUE

	if(changed)
		save_character()

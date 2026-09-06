/datum/preference/choiced/martial_arts_choice
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "martial_arts_choice"
	can_randomize = FALSE
	must_be_accessible = TRUE

/datum/preference/choiced/martial_arts_choice/init_possible_values(datum/preferences/preferences)
	return list(
		"None",
		MARTIALART_DARKPACK_CQB,
		MARTIALART_DARKPACK_KUNGFU,
		MARTIALART_DARKPACK_BOXING,
	)

/datum/preference/choiced/martial_arts_choice/create_default_value()
	return "None"

/datum/preference/choiced/martial_arts_choice/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/martial_art/learned_art
	if(!value)
		return
	if(value == "None")
		return
	if(value == MARTIALART_DARKPACK_CQB)
		learned_art = new /datum/martial_art/darkpack_cqb(target)
	if(value == MARTIALART_DARKPACK_KUNGFU)
		learned_art = new /datum/martial_art/darkpack_kungfu(target)
	if(value == MARTIALART_DARKPACK_BOXING)
		learned_art = new /datum/martial_art/darkpack_boxing(target)
	if(!learned_art)
		return
	learned_art.teach(target)
	return

/datum/preference/choiced/martial_arts_choice/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return FALSE
	var/datum/st_stat/brawl_stat = preferences.preference_storyteller_stats[STAT_BRAWL]
	var/score = brawl_stat.get_score()
	if(score >= 4)
		return TRUE
	else
		return FALSE

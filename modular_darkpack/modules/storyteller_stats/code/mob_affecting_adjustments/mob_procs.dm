/// Get a specific mob's stat from its stats list.
/mob/living/proc/st_get_stat(stat_path, include_bonus)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	return given_stat?.get_score(include_bonus)

/// Wrapper for st_get_stat to reduce copypaste. Get a specific mob's stat from its stats list.
/mob/living/proc/st_get_stats(list/stat_list, include_bonus)
	var/total_score = 0
	for(var/stat_path in stat_list)
		var/datum/st_stat/given_stat = storyteller_stats[stat_path]
		total_score += given_stat?.get_score(include_bonus)
	return total_score

/// Set a specific mob's stat from its stats list.
/mob/living/proc/st_set_stat(stat_path, amount)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	var/score = given_stat?.set_score(amount)
	update_modifiers_from_stats()
	return score

/// Changes a specific mob's stat from its stats list by the given amount.
/mob/living/proc/st_change_stat(stat_path, amount)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	var/score
	if(amount > 0)
		score = given_stat?.increase_score(amount)
	else
		score = given_stat?.decrease_score(amount)
	update_modifiers_from_stats()
	return score

/mob/living/proc/st_add_stat_mod(stat_path, amount, source)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	var/score = given_stat?.add_stat_mod(amount, source)
	update_modifiers_from_stats()
	return score

/mob/living/proc/st_remove_stat_mod(stat_path, source)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	var/score = given_stat?.remove_stat_mod(source)
	update_modifiers_from_stats()
	return score


/mob/living/proc/update_modifiers_from_stats(initial = FALSE)
	for(var/stat_typepath in storyteller_stats)
		var/datum/st_stat/stat_datum = storyteller_stats[stat_typepath]
		if(stat_datum.stat_flags & AFFECTS_HEALTH)
			recalculate_max_health(initial)
		if(stat_datum.stat_flags & AFFECTS_SPEED)
			add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/dexterity, multiplicative_slowdown = -(st_get_stat(STAT_DEXTERITY) / 20))


/datum/preferences/proc/apply_stats_from_prefs(mob/living/carbon/human/character)
	character.storyteller_stats = preference_storyteller_stats.Copy()
	character.update_modifiers_from_stats(TRUE)

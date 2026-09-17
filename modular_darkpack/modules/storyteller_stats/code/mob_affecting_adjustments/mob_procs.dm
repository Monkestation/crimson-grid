/// Get a specific mob's stat from its stats list.
/mob/living/proc/st_get_stat(stat_path, include_bonus, include_auto_successes, include_stat_clamps)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	return given_stat?.get_score(include_bonus, include_auto_successes, include_stat_clamps)

/// Wrapper for st_get_stat to reduce copypaste. Get a specific mob's stat from its stats list.
/mob/living/proc/st_get_stats(list/stat_list, include_bonus, include_auto_successes, include_stat_clamps)
	var/total_score = 0
	for(var/stat_path in stat_list)
		var/datum/st_stat/given_stat = storyteller_stats[stat_path]
		total_score += given_stat?.get_score(include_bonus, include_auto_successes, include_stat_clamps)
	return total_score

/// Set a specific mob's stat from its stats list.
/mob/living/proc/st_set_stat(stat_path, amount)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	var/score = given_stat?.set_score(amount)
	given_stat.update_mob(src)
	return score

/// Changes a specific mob's stat from its stats list by the given amount.
/mob/living/proc/st_change_stat(stat_path, amount)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	var/score
	if(amount > 0)
		score = given_stat?.increase_score(amount)
	else
		score = given_stat?.decrease_score(amount)
	given_stat.update_mob(src)
	return score

/mob/living/proc/st_add_stat_mod(stat_path, amount, source)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	var/score = given_stat?.add_stat_mod(amount, source)
	given_stat.update_mob(src)
	return score

/mob/living/proc/st_remove_stat_mod(stat_path, source)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	var/score = given_stat?.remove_stat_mod(source)
	given_stat.update_mob(src)
	return score


/mob/living/proc/st_add_auto_successes(stat_path, amount, source)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	var/score = given_stat?.add_auto_successes(amount, source)
	given_stat.update_mob(src)
	return score

/mob/living/proc/st_remove_auto_successes(stat_path, source)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	var/score = given_stat?.remove_auto_successes(source)
	given_stat.update_mob(src)
	return score


/mob/living/proc/st_add_stat_clamp(stat_path, amount, source)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	var/score = given_stat?.add_stat_clamps(amount, source)
	given_stat.update_mob(src)
	return score

/mob/living/proc/st_remove_stat_clamp(stat_path, source)
	var/datum/st_stat/given_stat = storyteller_stats[stat_path]
	var/score = given_stat?.remove_stat_clamps(source)
	given_stat.update_mob(src)
	return score

/mob/living/proc/replace_storyteller_stats(list/new_stat_list, initial = FALSE)
	if(length(storyteller_stats))
		unlink_st_stats()

	storyteller_stats = new_stat_list
	link_st_stats()
	update_modifiers_from_stats(initial)

/mob/living/proc/clear_storyteller_stats()
	unlink_st_stats()
	storyteller_stats = null

/mob/living/proc/link_st_stats()
	for(var/stat_path in storyteller_stats)
		var/datum/st_stat/given_stat = storyteller_stats[stat_path]
		given_stat.link_mob(src)

/mob/living/proc/unlink_st_stats()
	for(var/stat_path in storyteller_stats)
		var/datum/st_stat/taken_stat = storyteller_stats[stat_path]
		taken_stat.unlink_mob(src)

/mob/living/proc/update_modifiers_from_stats(initial = FALSE)
	for(var/stat_typepath in storyteller_stats)
		var/datum/st_stat/stat_datum = storyteller_stats[stat_typepath]
		stat_datum.update_mob(src, initial)

/datum/preferences/proc/apply_stats_from_prefs(mob/living/carbon/human/character)
	character.replace_storyteller_stats(preference_storyteller_stats.Copy(), TRUE)

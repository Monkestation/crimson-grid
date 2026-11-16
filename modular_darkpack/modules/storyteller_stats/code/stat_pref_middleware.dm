/datum/preference_middleware/stats
	action_delegations = list(
		"increase_stat" = PROC_REF(increase_stat),
		"decrease_stat" = PROC_REF(decrease_stat),
		"reset_stats" = PROC_REF(reset_stats)
	)

/datum/preference_middleware/stats/get_ui_data(mob/user)
	if(preferences.current_window != PREFERENCE_TAB_CHARACTER_PREFERENCES)
		return list()
	var/list/data = list()
	data["stats"] = list()
	for(var/typepath in preferences.preference_storyteller_stats)
		var/datum/st_stat/stat = preferences.preference_storyteller_stats[typepath]
		var/list/stat_data = list()
		stat_data["name"] = stat.name
		stat_data["desc"] = stat.description
		stat_data["editable"] = stat.editable
		stat_data["category"] = stat.category
		stat_data["subcategory"] = stat.subcategory
		stat_data["max_score"] = stat.max_score
		stat_data["points"] = stat.get_points()
		stat_data["score"] = stat.get_pure_score()
		stat_data["bonus_score"] = max(stat.get_bonus_score(), 0) // Dont go below 0 as this is to display bonuses and doesnt have handling for negative bonus score atm
		stat_data["abstract_type"] = "[stat.abstract_type]"
		data["stats"]["[stat.type]"] = stat_data
	return data

/datum/preference_middleware/stats/proc/increase_stat(list/params, mob/user)
	SHOULD_NOT_SLEEP(TRUE)

	if("[user.client.prefs.default_slot]" in user.persistent_client.joined_as_slots)
		to_chat(user, span_warning("You cannot be spawned in as this character to adjust its stats."))
		return FALSE

	var/datum/st_stat/stat_path = preferences.preference_storyteller_stats[text2path(params["stat"])]
	var/datum/st_stat/abstract_stat = preferences.preference_storyteller_stats[stat_path.abstract_type]
	var/datum/st_stat/freebie_point_stat = preferences.preference_storyteller_stats[STAT_FREEBIE_POINTS]
	var/old_value = stat_path.get_pure_score()


	if(!stat_path.can_increase_score(1)) // Have we reached the max_score of the stat?
		return FALSE // If we have, then return early.

	if((stat_path.get_pure_score() + 1) > stat_path.starting_score)
		if(abstract_stat.can_decrease_points(1)) // Can we spend points on this stat?
			abstract_stat.decrease_points(1) // Spend a point.
		else
			if(freebie_point_stat.can_decrease_freebie_points(stat_path.freebie_point_cost)) // Can we spend freebie points instead?
				freebie_point_stat.decrease_freebie_points(stat_path.freebie_point_cost) // If we can spend freebie points, decrease them.
			else
				return FALSE // If we can't spend freebie points, then return early.

	stat_path.increase_score(1) // By this point we know we have spend either a point, or the appropriate freebie cost for this stat, and it is not max_score. So increase it by one.

	if(stat_path.stat_flags & AFFECTS_STATS)
		update_middleware_stats(preferences.preference_storyteller_stats)


	var/new_value = stat_path.get_pure_score()
	var/real_name = user.client.prefs.read_preference(/datum/preference/name/real_name)
	user.log_message("increased stat '[stat_path.name]' from [old_value] to [new_value] on [real_name]", LOG_STATS)
	return TRUE

/datum/preference_middleware/stats/proc/decrease_stat(list/params, mob/user)
	SHOULD_NOT_SLEEP(TRUE)

	if(!isnewplayer(user))
		to_chat(user, span_warning("You have to be in the main menu to adjust your stats."))
		return FALSE

	var/datum/st_stat/stat_path = preferences.preference_storyteller_stats[text2path(params["stat"])]
	var/datum/st_stat/abstract_stat = preferences.preference_storyteller_stats[stat_path.abstract_type]
	var/datum/st_stat/freebie_point_stat = preferences.preference_storyteller_stats[STAT_FREEBIE_POINTS]
	var/old_value = stat_path.get_pure_score()

	if(!stat_path.can_decrease_score(1))
		return FALSE

	if((stat_path.get_pure_score() - 1) >= stat_path.starting_score)
		if(freebie_point_stat.can_increase_freebie_points(stat_path.freebie_point_cost)) // Can we regain freebie points?
			freebie_point_stat.increase_freebie_points(stat_path.freebie_point_cost) // Regain freebie points.
		else
			abstract_stat.increase_points(1) // Regain a score point.

	stat_path.decrease_score(1) // By this point we know we have regained either a point, or the appropriate freebie cost for this stat, and it is not min_score. So decrease it by one.

	if(stat_path.stat_flags & AFFECTS_STATS)
		update_middleware_stats(preferences.preference_storyteller_stats)

	var/new_value = stat_path.get_pure_score()
	var/real_name = user.client.prefs.read_preference(/datum/preference/name/real_name)
	user.log_message("decreased stat '[stat_path.name]' from [old_value] to [new_value] on '[real_name]'", LOG_STATS)
	return TRUE

/datum/preference_middleware/stats/proc/reset_stats(list/params, mob/user)
	SHOULD_NOT_SLEEP(TRUE)

	if(!isnewplayer(user))
		to_chat(user, span_warning("You have to be in the main menu to adjust your stats."))
		return FALSE

	var/real_name = user.client.prefs.read_preference(/datum/preference/name/real_name)
	user.log_message("reset all stats to default values on '[real_name]'", LOG_STATS)

	preferences.preference_storyteller_stats = list()
	preferences.preference_storyteller_stats = create_new_stat_prefs(preferences.preference_storyteller_stats)
	return TRUE

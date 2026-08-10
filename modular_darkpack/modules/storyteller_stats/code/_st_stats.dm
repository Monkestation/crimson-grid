/datum/st_stat
	//determines the base type for this class, so we don't add in empty types
	abstract_type = /datum/st_stat
	/// The name of the stat
	var/name = ""
	/// The description of the stat, shown when hovering over it in the UI.
	var/description = ""
	/// The category this stat belongs to. For example, "Attribute" or "Ability".
	var/category = ""
	/// The subcategory this stat belongs to. For example, "Physical" or "Social".
	var/subcategory = ""
	/// The current score of this stat.
	VAR_PROTECTED/score = 0
	/// Temporary bonus score applied to this stat from various ingame sources.
	VAR_PROTECTED/bonus_score = 0
	/// Temporary bonus score applied to this stat from various ingame sources. These are directly added to results rather then added to dice pool
	VAR_PROTECTED/auto_success_score = 0
	/// The minimum score this stat can be.
	var/min_score = 0
	/// The maximum score this stat can be.
	var/max_score = 5
	/// The amount of freebie points that are required to increase this stat by 1 point.
	var/freebie_point_cost = 0
	/// Flags for stats, such as if it affects health.
	var/stat_flags = NONE

	/// If the user can spend points on that stat.
	var/editable = TRUE
	/// A dictionary of modifiers to this attribute.
	var/list/modifiers = list()
	/// A dictionary of auto success scores to this attribute.
	var/list/auto_successes = list()
	/// What score does this stat start out with at character creation.
	var/starting_score = 0
	/// How many points are in this stat category that the player can use. Used in abstract classes only.
	VAR_PROTECTED/points = 0
	/// How many freebie points were spent on this stat. Used in abstract classes only.
	var/freebie_cost_spent = 0

// Score

/datum/st_stat/proc/get_score(include_bonus = TRUE, include_auto_sucesses = TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(include_bonus)
		if(include_auto_sucesses)
			return score + bonus_score + auto_success_score
		else
			return score + bonus_score
	else
		return score

/datum/st_stat/proc/get_bonus_score()
	SHOULD_NOT_OVERRIDE(TRUE)
	return bonus_score

/datum/st_stat/proc/get_auto_success_score()
	SHOULD_NOT_OVERRIDE(TRUE)
	return auto_success_score

/datum/st_stat/proc/can_set_score(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	if((amount < min_score) || (amount > max_score))
		return FALSE
	return TRUE

// This proc is only ever supposed to be used in stat_pref_middleware.dm for preferences regarding increasing the stat.
/datum/st_stat/proc/can_increase_score(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/new_score = score + amount
	if(new_score > max_score)
		return FALSE
	return TRUE

// This proc is only ever supposed to be used in stat_pref_middleware.dm for preferences regarding decreasing the stat.
/datum/st_stat/proc/can_decrease_score(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/new_score = score - amount
	if(new_score < min_score)
		return FALSE
	return TRUE

/datum/st_stat/proc/set_score(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!can_set_score(amount))
		return FALSE
	score = clamp(amount, min_score, max_score)
	return TRUE

/datum/st_stat/proc/increase_score(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!can_increase_score(amount))
		return FALSE
	score = clamp(score + amount, min_score, max_score)
	return TRUE

/datum/st_stat/proc/decrease_score(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!can_decrease_score(amount))
		return FALSE
	score = clamp(score - amount, min_score, max_score)
	return TRUE

// Modifiers

/datum/st_stat/proc/add_stat_mod(amount, source)
	SHOULD_NOT_OVERRIDE(TRUE)
	LAZYSET(modifiers, source, amount)
	update_modifiers()

/datum/st_stat/proc/remove_stat_mod(source)
	SHOULD_NOT_OVERRIDE(TRUE)
	LAZYREMOVE(modifiers, source)
	update_modifiers()

/datum/st_stat/proc/update_modifiers()
	SHOULD_NOT_OVERRIDE(TRUE)
	bonus_score = initial(bonus_score)
	for(var/source in modifiers)
		bonus_score += modifiers[source]
	bonus_score = clamp(bonus_score, -max_score, 10)


/datum/st_stat/proc/add_auto_successes(amount, source)
	SHOULD_NOT_OVERRIDE(TRUE)
	LAZYSET(auto_successes, source, amount)
	update_auto_successes()

/datum/st_stat/proc/remove_auto_successes(source)
	SHOULD_NOT_OVERRIDE(TRUE)
	LAZYREMOVE(auto_successes, source)
	update_auto_successes()

/datum/st_stat/proc/update_auto_successes()
	SHOULD_NOT_OVERRIDE(TRUE)
	auto_success_score = initial(auto_success_score)
	for(var/source in auto_successes)
		auto_success_score += auto_successes[source]
	auto_success_score = clamp(auto_success_score, 0, 10)

// Points

/datum/st_stat/proc/get_points()
	SHOULD_NOT_OVERRIDE(TRUE)
	return points

/datum/st_stat/proc/set_points(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	points = max(amount, 0)
	return TRUE

/datum/st_stat/proc/increase_points(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	points += amount
	return TRUE

/datum/st_stat/proc/can_decrease_points(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/new_points = points - amount
	if(new_points < 0)
		return FALSE
	return TRUE

/datum/st_stat/proc/decrease_points(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!can_decrease_points(amount))
		return FALSE
	points -= amount
	return TRUE

// Freebie Points

/datum/st_stat/proc/can_increase_freebie_points(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(freebie_cost_spent <= 0)
		return FALSE
	return TRUE

/datum/st_stat/proc/increase_freebie_points(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	points += amount
	freebie_cost_spent -= amount
	return TRUE

/datum/st_stat/proc/can_decrease_freebie_points(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/new_points = points - amount
	if(new_points < 0)
		return FALSE
	return TRUE

/datum/st_stat/proc/decrease_freebie_points(amount)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!can_decrease_freebie_points(amount))
		return FALSE
	points -= amount
	freebie_cost_spent += amount
	return TRUE

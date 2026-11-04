/// Mobs got the preference datums themselves, so in-game modifiers and clamps rewrote the saved character
/datum/st_stat/proc/copy_stat()
	var/datum/st_stat/copy = new type()
	copy.score = score
	copy.bonus_score = bonus_score
	copy.auto_success_score = auto_success_score
	copy.stat_clamp_score = stat_clamp_score
	copy.points = points
	copy.freebie_cost_spent = freebie_cost_spent
	copy.modifiers = modifiers?.Copy()
	copy.auto_successes = auto_successes?.Copy()
	copy.stat_clamps = stat_clamps?.Copy()
	return copy

/datum/st_stat/morality_path/morality/copy_stat()
	var/datum/st_stat/morality_path/morality/copy = ..()
	copy.morality_path = morality_path
	return copy

/proc/copy_stat_list(list/stats)
	. = list()
	for(var/stat_path in stats)
		var/datum/st_stat/stat = stats[stat_path]
		.[stat_path] = stat.copy_stat()

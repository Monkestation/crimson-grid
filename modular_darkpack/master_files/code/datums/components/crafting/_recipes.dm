/datum/crafting_recipe
	// STORYTELER_STATS
	/// Stat define/typepath required for this recipe. No check if null
	var/datum/st_stat/skill_required_for_use = STAT_CRAFTS
	/// You need ATLEAST this many dots in a skill to craft.
	var/skill_dots_minimum = null // Null by default means it wont even try to get stats. as if its 0 or less, it only catches people with low stats AND a debuff and i dont really care.


// STORYTELER_STATS
/datum/crafting_recipe/proc/is_recipe_available(mob/user)
	SHOULD_CALL_PARENT(TRUE)

	if(skill_required_for_use && !isnull(skill_dots_minimum))
		var/mob/living/living_user = astype(user)
		if(!living_user)
			return FALSE
		if(living_user.st_get_stat(skill_required_for_use) < skill_dots_minimum)
			return FALSE

	return TRUE

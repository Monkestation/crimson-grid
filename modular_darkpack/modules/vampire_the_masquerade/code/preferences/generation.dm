/datum/preference/numeric/generation
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "generation"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_WORLD_OF_DARKNESS
	relevant_inherent_trait = TRAIT_DRINKS_BLOOD
	minimum = MAX_TRUSTED_GENERATION
	maximum = HIGHEST_GENERATION_LIMIT

/datum/preference/numeric/generation/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	get_kindred_splat(target)?.set_generation(value)

// CORVAX EDIT START
/proc/get_player_playtime_hours(datum/preferences/prefs)
	if(!prefs?.exp)
		return 0
	return (prefs.exp[EXP_TYPE_LIVING] || 0) / 60

/proc/get_min_generation_from_playtime(datum/preferences/prefs)
	if(!CONFIG_GET(flag/use_exp_tracking))
		return LOWEST_GENERATION_LIMIT
	var/hours = get_player_playtime_hours(prefs)
	if(hours >= 100) return 6
	if(hours >= 75) return 7
	if(hours >= 50) return 8
	if(hours >= 30) return 9
	if(hours >= 20)  return 10
	if(hours >= 5)  return 11
	return 12

/proc/get_player_min_generation(datum/preferences/prefs)
	if(!prefs)
		return HIGHEST_GENERATION_LIMIT
	var/playtime_min = get_min_generation_from_playtime(prefs)
	var/wl_min = prefs.has_whitelist(WHITELIST_TRUSTED) ? MAX_TRUSTED_GENERATION : MAX_PUBLIC_GENERATION
	var/min_gen = max(playtime_min, wl_min)
	if(!isnull(prefs.admin_generation_floor))
		min_gen = min(min_gen, prefs.admin_generation_floor)
	return min_gen

/proc/get_max_immortal_age_for_generation(gen)
	switch(gen)
		if(-INFINITY to 6)  return 2999
		if(7)               return 1999
		if(8)               return 999
		if(9)               return 499
		if(10)              return 299
		if(11)              return 199
		if(12)              return 100
	return 50

/datum/preference/numeric/generation/is_valid(value, datum/preferences/preferences)
	if(!isnum(value))
		return FALSE
	if(preferences?.generation_write_bypass)
		return TRUE
	if(preferences?.is_generation_locked())
		return FALSE
	if(!length(preferences?.exp))
		return value >= LOWEST_GENERATION_LIMIT && value <= HIGHEST_GENERATION_LIMIT
	var/min = get_player_min_generation(preferences)
	return value >= min && value <= HIGHEST_GENERATION_LIMIT

/datum/preference/numeric/generation/deserialize(input, datum/preferences/preferences)
	if(istext(input))
		input = text2num(input)
	if(!isnum(input))
		input = HIGHEST_GENERATION_LIMIT
	if(preferences?.generation_write_bypass)
		return clamp(round(input), LOWEST_GENERATION_LIMIT, HIGHEST_GENERATION_LIMIT)
	if(preferences?.is_generation_locked())
		return clamp(round(input), LOWEST_GENERATION_LIMIT, HIGHEST_GENERATION_LIMIT)
	if(!length(preferences?.exp))
		return clamp(round(input), LOWEST_GENERATION_LIMIT, HIGHEST_GENERATION_LIMIT)
	var/min = get_player_min_generation(preferences)
	return clamp(round(input), min, HIGHEST_GENERATION_LIMIT)

/datum/preference/numeric/generation/post_write(value, datum/preferences/preferences)
	. = ..()
	preferences?.clamp_immortal_age_to_generation(value)

/datum/preferences
	var/clamping_immortal_age = FALSE

/datum/preferences/proc/clamp_immortal_age_to_generation(generation = null)
	if(clamping_immortal_age)
		return
	var/datum/preference/numeric/immortal_age/age_preference = GLOB.preference_entries[/datum/preference/numeric/immortal_age]
	if(!istype(age_preference))
		return
	if(!isnum(generation))
		generation = read_preference(/datum/preference/numeric/generation)
	var/max_age = min(age_preference.maximum, get_max_immortal_age_for_generation(isnum(generation) ? generation : HIGHEST_GENERATION_LIMIT))
	clamping_immortal_age = TRUE
	var/current_age = read_preference(age_preference.type)
	clamping_immortal_age = FALSE
	if(!isnum(current_age) || current_age <= max_age)
		return
	value_cache[age_preference.type] = max_age
	recently_updated_keys |= age_preference.type
// CORVAX EDIT END

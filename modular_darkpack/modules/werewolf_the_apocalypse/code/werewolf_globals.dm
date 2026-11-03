/// Current phase of the moon, randomly chosen
GLOBAL_VAR_INIT(moon_state, null)

/proc/get_moon_state()
	if(isnull(GLOB.moon_state))
		GLOB.moon_state = get_moon_phase()
	return GLOB.moon_state

/datum/config_entry/number/lunar_cycle_interval
	default = 29.530588
	min_val = 0.01

/datum/config_entry/number/lunar_cycle_type
	default = 0
	min_val = 0
	max_val = 2
// 0 = Use CONFIG_GET(number/lunar_cycle_interval)
// 1 = Moon phase based on round ID
// 2 = Moon phase random

/datum/config_entry/number/lunar_cycle_rounds
	default = 1
	min_val = 1

/proc/get_real_moon_phase()
	// First known fullmoon since the BYOND EPOCH.
	var/ref_year = 2000
	var/ref_month = 1
	var/ref_day = 20

	var/year = text2num(server_timestamp("YYYY", ic_time = TRUE))
	var/month = text2num(server_timestamp("MM", ic_time = TRUE))
	var/day = text2num(server_timestamp("DD", ic_time = TRUE))

	var/ref_days = ref_year * 365 + ref_month * 30 + ref_day
	var/current_days = year * 365 + month * 30 + day

	var/days_since_full = current_days - ref_days

	var/phase_day = days_since_full % CONFIG_GET(number/lunar_cycle_interval)
	if(phase_day < 0)
		phase_day += CONFIG_GET(number/lunar_cycle_interval)

	return moon_phase_cycle_name(phase_day)

/proc/get_persistant_moon_phase()
	if(isnull(GLOB.round_id))
		return get_random_moon_phase() // abort if we don't have a round ID
	var/offset_days = CONFIG_GET(number/lunar_cycle_rounds)
	var/phase_day = GLOB.round_id % (8*offset_days) || 1 // GLOB.round_id
	return moon_phase_name(floor(phase_day/offset_days))

/proc/get_random_moon_phase()
	return pick(MOON_NEW, MOON_WAXING_CRESENT, MOON_FIRST_QUARTER, MOON_WAXING_GIBBOUS, MOON_FULL, MOON_WANING_GIBBOUS, MOON_LAST_QUARTER, MOON_WANING_CRESCENT)

/proc/get_moon_phase()
	switch(CONFIG_GET(number/lunar_cycle_type))
		if(0)
			return get_real_moon_phase()
		if(1)
			return get_persistant_moon_phase()
		if(2)
			return get_random_moon_phase()
	return moon_phase_name(0)

/proc/moon_phase_name(phase_day)
	switch(phase_day)
		if(0)
			return MOON_NEW
		if(1)
			return MOON_WAXING_CRESENT
		if(2)
			return MOON_FIRST_QUARTER
		if(3)
			return MOON_WAXING_GIBBOUS
		if(4)
			return MOON_FULL
		if(5)
			return MOON_WANING_GIBBOUS
		if(6)
			return MOON_LAST_QUARTER
		if(7)
			return MOON_WANING_CRESCENT
		if(8)
			moon_phase_name(0)
	return MOON_NEW

/proc/moon_phase_cycle_name(phase_day)
	if(phase_day < 1.84566)
		return MOON_NEW
	if(phase_day < 5.53699)
		return MOON_WAXING_CRESENT
	if(phase_day < 9.22831)
		return MOON_FIRST_QUARTER
	if(phase_day < 12.91963)
		return MOON_WAXING_GIBBOUS
	if(phase_day < 16.61096)
		return MOON_FULL
	if(phase_day < 20.30228)
		return MOON_WANING_GIBBOUS
	if(phase_day < 23.99361)
		return MOON_LAST_QUARTER
	if(phase_day < 27.68493)
		return MOON_WANING_CRESCENT
	return MOON_FULL

/// List of all Tribe totems
GLOBAL_LIST_EMPTY(totems)


/// Associative list of auspice names to typepaths
GLOBAL_LIST_INIT(auspices_list, init_subsplat_list(/datum/subsplat/werewolf/auspice))
/// Associative list of auspice typepaths to singletons
GLOBAL_LIST_INIT_TYPED(auspices, /datum/subsplat/werewolf/auspice, init_subtypes_w_path_keys(/datum/subsplat/werewolf/auspice, list()))

/// Associative list of tribe names to typepaths
GLOBAL_LIST_INIT(tribes_list, init_subsplat_list(/datum/subsplat/werewolf/tribe))
/// Associative list of tribe typepaths to singletons
GLOBAL_LIST_INIT_TYPED(fera_tribes, /datum/subsplat/werewolf/tribe, init_subtypes_w_path_keys(/datum/subsplat/werewolf/tribe, list()))

/// Associative list of breed form names to typepaths
GLOBAL_LIST_INIT(breed_forms_list, init_subsplat_list(/datum/subsplat/werewolf/breed_form))
/// Associative list of breed_form typepaths to singletons
GLOBAL_LIST_INIT_TYPED(breed_forms, /datum/subsplat/werewolf/breed_form, init_subtypes_w_path_keys(/datum/subsplat/werewolf/breed_form, list()))

GLOBAL_LIST_INIT(glyph_list, init_glyphs())

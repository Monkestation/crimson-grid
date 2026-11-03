/// List of roundstart splats' their splat_id's
GLOBAL_LIST_EMPTY(roundstart_splats)
GLOBAL_LIST_EMPTY(whitelisted_splats)
GLOBAL_LIST_EMPTY(default_player_whitelists)

/datum/config_entry/keyed_list/roundstart_splats //splats you can play as from the get go.
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/keyed_list/roundstart_splats/ValidateListEntry(key_name, key_value)
	if(key_name in GLOB.splat_list)
		return TRUE

	log_config("ERROR: [key_name] is not a valid splat ID.")
	return FALSE


/datum/config_entry/keyed_list/whitelisted_splats //splats you can play as from the get go.
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/keyed_list/whitelisted_splats/ValidateListEntry(key_name, key_value)
	if(key_name in GLOB.splat_list)
		return TRUE

	log_config("ERROR: [key_name] is not a valid splat ID.")
	return FALSE


/**
 * Checks if a splat is eligible to be picked at roundstart.
 *
 * Checks the config to see if this splat is allowed to be picked in the character setup menu.
 * Used by [/proc/generate_selectable_splat_and_languages].
 */
/datum/splat/proc/check_roundstart_eligible()
	if(id in (CONFIG_GET(keyed_list/roundstart_splats)))
		return TRUE
	return FALSE

/datum/splat/proc/requires_whitelist()
	if(id in (CONFIG_GET(keyed_list/whitelisted_splats)))
		return TRUE
	return FALSE


/**
 * Generates splat available to choose in character setup at roundstart
 *
 * This proc generates which splat are available to pick from in character setup.
 * If there are no available roundstart splat, defaults to human.
 */
/proc/generate_selectable_splats()
	var/list/selectable_splat = list()

	for(var/splat_type in valid_subtypesof(/datum/splat))
		var/datum/splat/splat = GLOB.splat_prototypes[splat_type]
		if(splat.check_roundstart_eligible())
			selectable_splat += splat.id

	return selectable_splat

/// Gets a list of all splat id's available to choose in roundstart.
/proc/get_selectable_splats()
	RETURN_TYPE(/list)

	if (!GLOB.roundstart_splats.len)
		GLOB.roundstart_splats = generate_selectable_splats()

	return GLOB.roundstart_splats


/proc/get_default_player_whitelists()
	RETURN_TYPE(/alist)

	if (!GLOB.default_player_whitelists.len)
		var/alist/defs = alist(
			WHITELIST_TRUSTED = TRUE, // CRIMSON EDIT CHANGE - Original: WHITELIST_TRUSTED = FALSE
			WHITELIST_TIMELIMITS = TRUE, // CRIMSON EDIT CHANGE - Original: WHITELIST_TIMELIMITS = FALSE
			SPLAT_NONE = TRUE,
		)

		for(var/splat_id in get_selectable_splats())
			var/splat_type = GLOB.splat_list[splat_id]
			var/datum/splat/splat = GLOB.splat_prototypes[splat_type]

			defs[splat_id] = !splat.requires_whitelist()

		var/list/clan_whitelist_values = CONFIG_GET(keyed_list/whitelisted_clans)
		for(var/clan_name in GLOB.vampire_clan_list)
			var/datum/subsplat/vampire_clan/clan = get_vampire_clan(clan_name)
			if(!clan)
				continue

			if(clan.id in clan_whitelist_values)
				defs[clan.id] = FALSE
			else
				defs[clan.id] = TRUE

		GLOB.default_player_whitelists = defs

	return GLOB.default_player_whitelists

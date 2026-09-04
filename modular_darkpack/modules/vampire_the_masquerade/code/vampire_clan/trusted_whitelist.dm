/datum/config_entry/keyed_list/whitelisted_clans //splats you can play as from the get go.
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_FLAG

/datum/config_entry/keyed_list/whitelisted_clans/ValidateListEntry(key_name, key_value)
	for(var/clan_name in GLOB.vampire_clan_list)
		var/datum/subsplat/vampire_clan/clan = get_vampire_clan(clan_name)
		if(!clan)
			continue
		if(clan.id == key_name)
			return TRUE

	log_config("ERROR: [key_name] is not a valid clan ID.")
	return FALSE


// remember kids, you should always obtain enthusiastic informed values before proceeding
/datum/preference/choiced/subsplat/vampire_clan/create_informed_default_value(datum/preferences/preferences)
	if(preferences && !preferences.has_whitelist(WHITELIST_TRUSTED))
		var/list/safe_choices = list()
		for(var/choice in get_choices())
			var/datum/subsplat/vampire_clan/clan = get_vampire_clan(choice)
			if(!clan || !(clan.id in CONFIG_GET(keyed_list/whitelisted_clans)))
				safe_choices += choice
			else if(preferences.has_whitelist(clan.id))
				safe_choices += choice
		if(length(safe_choices))
			return pick(safe_choices)
	return ..()

/datum/preference/choiced/subsplat/vampire_clan/is_valid(value, datum/preferences/preferences)
	if(preferences && !preferences.has_whitelist(WHITELIST_TRUSTED))
		var/datum/subsplat/vampire_clan/clan = get_vampire_clan(value)
		if(clan?.id in CONFIG_GET(keyed_list/whitelisted_clans))
			if(!preferences.has_whitelist(clan.id))
				to_chat(preferences.parent, span_warning("The [clan.name] clan requires a special whitelisting process. Feel free to apply for it on Discord!"))
				return FALSE
	return ..()

// helper procs to make absolutely sure unwhitelisted people cannot join with whitelisted splats
// useful in-case a regime member removes a trusted player from the whitelist
// so they cant continue to play on the trusted character with that clan selected
/proc/get_restricted_clan(mob/dead/new_player/new_player)
	var/client/C = new_player.client
	if(!C?.prefs)
		return null
	if(C.prefs.has_whitelist(WHITELIST_TRUSTED))
		return null

	var/datum/preference/preference_entry = GLOB.preference_entries[/datum/preference/choiced/subsplat/vampire_clan]
	if(preference_entry.is_accessible(C.prefs))
		return null

	var/selected = C.prefs.read_preference(/datum/preference/choiced/subsplat/vampire_clan)
	var/datum/subsplat/vampire_clan/clan = get_vampire_clan(selected)
	if(clan?.id in CONFIG_GET(keyed_list/whitelisted_clans))
		if(!C.prefs.has_whitelist(clan.id))
			return clan
	return null

/atom/movable/screen/lobby/button/ready/Click(location, control, params)
	var/mob/dead/new_player/new_player = hud.mymob
	if(new_player.ready == PLAYER_NOT_READY)
		var/datum/subsplat/vampire_clan/clan = get_restricted_clan(new_player)
		if(clan)
			to_chat(new_player, span_warning("[clan.name] requires a special whitelisting process. Feel free to apply for it on Discord!"))
			return
	return ..()

/atom/movable/screen/lobby/button/join/Click(location, control, params)
	var/mob/dead/new_player/new_player = hud.mymob
	var/datum/subsplat/vampire_clan/clan = get_restricted_clan(new_player)
	if(clan)
		to_chat(new_player, span_warning("[clan.name] requires a special whitelisting process. Feel free to apply for it on Discord!"))
		return
	return ..()

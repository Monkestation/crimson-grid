/datum/preferences
	var/list/player_whitelists

/// Assoc list of id by whitelist state.
/datum/preferences/proc/get_player_whitelists()
	RETURN_TYPE(/alist)
	if(isnull(player_whitelists))
		player_whitelists = get_default_player_whitelists().Copy()
	return player_whitelists


/// returns a flat list of true entires.
/datum/preferences/proc/get_all_whitelisted_entries()
	RETURN_TYPE(/list)
	var/list/flat_list = list()
	var/list/alist/pref_whitelist = get_player_whitelists()
	for(var/key, bool in pref_whitelist)
		if(bool)
			flat_list += key
	return flat_list

/datum/preferences/proc/has_whitelist(whitelist_id)
	return get_player_whitelists()[whitelist_id]

/datum/preferences/proc/grant_whitelist(whitelist_id)
	var/list/wl = get_player_whitelists()
	if(wl[whitelist_id])
		return
	wl[whitelist_id] = TRUE
	if(whitelist_id == WHITELIST_TRUSTED)
		discipline_trusted = TRUE

/datum/preferences/proc/revoke_whitelist(whitelist_id)
	if(whitelist_id == SPLAT_NONE) // as funny as it would be, this should probably be protected
		return
	var/list/wl = get_player_whitelists()
	if(!wl[whitelist_id])
		return
	wl[whitelist_id] = FALSE
	if(whitelist_id == WHITELIST_TRUSTED)
		discipline_trusted = FALSE

/datum/preference_middleware/disciplines/get_ui_data(mob/user)
	var/list/data = ..()
	var/datum/preferences/prefs = user?.client?.prefs
	var/list/player_wl
	if(prefs)
		player_wl = prefs.get_all_whitelisted_entries()
	data["player_whitelists"] = player_wl ? player_wl.Copy() : list()
	return data

/datum/admin_preference_editor/proc/get_whitelist_definitions()
	var/alist/defaults = get_default_player_whitelists()
	var/list/defs = list()

	defs[SPLAT_NONE] = list(
		"name" = "Human",
		"description" = "Access to play as a human.",
		"category" = "splat",
		"is_default" = defaults[SPLAT_NONE],
	)
	for(var/splat_id in get_selectable_splats())
		var/splat_type = GLOB.splat_list[splat_id]
		var/datum/splat/splat = GLOB.splat_prototypes[splat_type]

		defs[splat_id] = list(
			"name" = splat.name,
			"description" = "Access to play as a [splat.name].",
			"category" = "splat",
			"is_default" = defaults[splat_id],
		)

	defs[WHITELIST_TRUSTED] = list(
		"name" = "Trusted",
		"description" = "Bypasses discipline sheet limits, and allows them to be a lower generation kindred.",
		"category" = "access",
		"is_default" = defaults[WHITELIST_TRUSTED],
	)
	defs[WHITELIST_TIMELIMITS] = list(
		"name" = "Bypass Time Requirements",
		"description" = "Bypasses time requierments for jobs.",
		"category" = "access",
		"is_default" = defaults[WHITELIST_TIMELIMITS],
	)


	for(var/clan_name in GLOB.vampire_clan_list)
		var/datum/subsplat/vampire_clan/clan = get_vampire_clan(clan_name)
		if(!clan)
			continue
		defs[clan.id] = list(
			"name" = clan.name,
			"description" = "Access to play [clan.name] without requiring trusted whitelist",
			"category" = "clan",
			"is_default" = defaults[clan.id]
		)

	return defs

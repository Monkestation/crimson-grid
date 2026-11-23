/datum/preferences
	// List of known guestbook names we have saved
	var/list/guestbook_names = list()

	var/list/preference_storyteller_stats = list()
	// Associative list of disciplines and their current level. like: list("/datum/discipline/animalism" = 2)
	var/list/discipline_levels = list()
	// Alternative job titles stored in preferences. Assoc list, ie. alt_job_titles["Scientist"] = "Cytologist"
	var/list/alt_job_titles = list()
	/// Whether this player is whitelisted to bypass discipline sheet validation limits /// LEGACY
	var/discipline_trusted = FALSE


/datum/preferences/load_preferences()
	discipline_trusted = savefile.get_entry("discipline_trusted", FALSE) // deserialization and its consequences

	// WHITELIST
	var/list/saved = savefile.get_entry("player_whitelists")
	if(isnull(saved) || !islist(saved) || !length(saved))
		player_whitelists = get_default_player_whitelists().Copy()
	else
		player_whitelists = saved

	var/alist/defaults = get_default_player_whitelists()
	for(var/key, bool in defaults)
		if(!(key in player_whitelists))
			to_chat(parent, span_boldnotice("New whitelist key added to whitelists: [key] [bool ? "TRUE": "FALSE"]."))
			player_whitelists[key] = bool

	for(var/key in saved)
		if(!(key in defaults))
			to_chat(parent, span_boldnotice("Bad whitelist key has been removed from whitelists"))
			player_whitelists[key] = null

	if(discipline_trusted && !player_whitelists[WHITELIST_TRUSTED]) // backwards compatibility
		player_whitelists[WHITELIST_TRUSTED] = TRUE
		if(!isnull(parent))
			to_chat(parent, span_boldnotice("Great news! Your existing trusted status was successfully migrated to the new splat whitelist system."))

	discipline_trusted = player_whitelists[WHITELIST_TRUSTED]
	// WHITELIST

	. = ..()

/datum/preferences/save_preferences()
	savefile.set_entry("discipline_trusted", discipline_trusted) // since existing load/save is per character, save and load it from a level above that

	// WHITELIST
	if(!isnull(player_whitelists))
		savefile.set_entry("player_whitelists", player_whitelists)
	// WHITELIST

	. = ..()

/datum/preferences/load_character(slot)
	. = ..()
	var/tree_key = "character[default_slot]"
	var/list/save_data = savefile.get_entry(tree_key)

	// We don't really need to do any validation since that's all done in the parent proc.

	guestbook_names = save_data?["guestbook_names"]
	guestbook_names = SANITIZE_LIST(guestbook_names)
	alt_job_titles = save_data?["alt_job_titles"] // ALTERNATIVE_JOB_TITLES
	// discipline_levels is loaded in the parent proc, since validate_quirks() there depends on it.

/// Returns the ids of every discipline this character will spawn with.
/datum/preferences/proc/get_discipline_ids()
	var/list/discipline_ids = list()
	for(var/discipline_key in discipline_levels)
		if(!discipline_levels[discipline_key])
			continue
		var/datum/discipline/discipline_path = ispath(discipline_key) ? discipline_key : text2path(discipline_key)
		if(discipline_path)
			discipline_ids |= initial(discipline_path.id)
	if(length(discipline_ids))
		return discipline_ids

	// No dots allocated means they spawn with 1 dot in each clan discipline, see on_prefs_applied_disciplines()
	var/clan_value = read_preference(/datum/preference/choiced/subsplat/vampire_clan)
	var/datum/subsplat/vampire_clan/clan = clan_value ? get_vampire_clan(clan_value) : null
	for(var/datum/discipline/discipline_path as anything in clan?.clan_disciplines)
		if(ispath(discipline_path, /datum/discipline))
			discipline_ids |= initial(discipline_path.id)
	return discipline_ids

/datum/preferences/save_character()
	. = ..()
	var/tree_key = "character[default_slot]"
	if(!(tree_key in savefile.get_entry()))
		savefile.set_entry(tree_key, list())
	var/save_data = savefile.get_entry(tree_key)

	save_data["guestbook_names"] = guestbook_names
	save_data["alt_job_titles"] = alt_job_titles // ALTERNATIVE_JOB_TITLES
	save_data["discipline_levels"] = discipline_levels
	savefile.save()

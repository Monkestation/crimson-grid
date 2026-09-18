/datum/preferences
	// List of known guestbook names we have saved
	var/list/guestbook_names = list()

	var/list/preference_storyteller_stats = list()
	// Associative list of disciplines and their current level. like: list("/datum/discipline/animalism" = 2)
	var/list/discipline_levels = list()
	// Alternative job titles stored in preferences. Assoc list, ie. alt_job_titles["Scientist"] = "Cytologist"
	var/list/alt_job_titles = list()
	/// Whether this player is whitelisted to bypass discipline sheet validation limits /// LEGACY
	var/discipline_trusted = TRUE // CRIMSON EDIT CHANGE - Original: var/discipline_trusted = FALSE


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
	discipline_levels = SANITIZE_LIST(save_data?["discipline_levels"]) || list()

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

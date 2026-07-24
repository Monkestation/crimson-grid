/datum/preferences
	// List of known guestbook names we have saved
	var/list/guestbook_names = list()

	var/list/preference_storyteller_stats = list()
	// Associative list of disciplines and their current level. like: list("/datum/discipline/animalism" = 2)
	var/list/discipline_levels = list()
	// Alternative job titles stored in preferences. Assoc list, ie. alt_job_titles["Scientist"] = "Cytologist"
	var/list/alt_job_titles = list()
	/// Whether this player is whitelisted to bypass discipline sheet validation limits
	var/discipline_trusted = FALSE


/datum/preferences/load_preferences()
	discipline_trusted = savefile.get_entry("discipline_trusted", FALSE) // deserialization and its consequences
	. = ..()

/datum/preferences/save_preferences()
	savefile.set_entry("discipline_trusted", discipline_trusted) // since existing load/save is per character, save and load it from a level above that
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

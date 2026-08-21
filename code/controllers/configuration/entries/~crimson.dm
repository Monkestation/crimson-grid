// ------------- config.txt -------------
/datum/config_entry/string/discord_link
	config_entry_value = "We forgot to set the server's discord link in config.txt"

/datum/config_entry/string/patreon_link

/datum/config_entry/string/twitch_link

/datum/config_entry/number/extra_save_slots_donator
	default = 10


// ------------- dbconfig.txt -------------

/// Cross DB if its enabled.
/datum/config_entry/flag/sql_enabled_cross // for sql switching
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/feedback_database_cross
	default = "crimsongrid"
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN


/datum/config_entry/flag/whitelist_allow_donators

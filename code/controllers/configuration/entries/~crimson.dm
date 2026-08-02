
// dbconfig

/// Cross DB if its enabled.
/datum/config_entry/flag/sql_enabled_cross // for sql switching
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/feedback_database_cross
	default = "monkestation"
	protection = CONFIG_ENTRY_LOCKED | CONFIG_ENTRY_HIDDEN


/// Defines whether or not mentors can see ckeys alongside mobnames.
/datum/config_entry/flag/mentors_mobname_only

/// Defines whether the server uses the legacy mentor system with mentors.txt or the SQL system.
/datum/config_entry/flag/mentor_legacy_system
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/passive_bp_drain
	default = FALSE

/datum/config_entry/number/passive_bp_drain_timer
	default = 20 MINUTES
	min_val = 1 MINUTES

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

/datum/config_entry/flag/artifact_stacking
	default = FALSE

/// Determines if a player can teach another player a discipline
/// 0 / DISCIPLINE_TEACHING_FULL - Full discipline teaching with no restrictions
/// 1 / DISCIPLINE_TEACHING_RARES_DISABLED - Discipline teaching, but rare disciplines like Thaumaturgy and Temporis cannot be taught
/// 2 / DISCIPLINE_TEACHING_IN_CLANS_ONLY - Discipline teaching allowed, but you can only teach disciplines inherent to your clan (A Gangrel can teach Protean, but not Thaumaturgy)
/// 3 / DISCIPLINE_TEACHING_DISABLED - Discipline teaching completely disabled
/datum/config_entry/number/discipline_teaching
	default = DISCIPLINE_TEACHING_FULL
	integer = TRUE
	min_val = DISCIPLINE_TEACHING_FULL
	max_val = DISCIPLINE_TEACHING_DISABLED

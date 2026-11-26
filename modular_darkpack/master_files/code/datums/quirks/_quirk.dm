/datum/quirk
	var/darkpack_allowed = FALSE // MERITS/FLAWS
	// I would like to highlight these to admins or players but for now it lets them be controlled via config
	/// If the quirk has 0 mechnaical effect.
	var/roleplay_only = FALSE

/// Whether this quirk can be taken alongside everything else selected in these preferences. Serverside check for selection and savefile validation.
/datum/quirk/proc/is_prefs_appropriate(datum/preferences/prefs)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

	if(!is_species_appropriate(prefs.read_preference(/datum/preference/choiced/species)))
		return FALSE
	if(!is_splat_appropriate(prefs.read_preference(/datum/preference/choiced/splats)))
		return FALSE
	return TRUE

/datum/preference/toggle/show_identity_when_masked
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "show_flavor_text_when_masked"
	savefile_identifier = PREFERENCE_CHARACTER
	default_value = FALSE

/datum/preference/toggle/show_identity_when_masked/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/// Whether others can't tell who we are by looking at us. The pref only sees through clothing, never through Mask of Shadows or a missing face.
/mob/living/carbon/human/proc/is_identity_hidden()
	if(!is_face_obscured())
		return FALSE
	if(is_face_obscured(ignore_clothing = TRUE))
		return TRUE
	return !client?.prefs.read_preference(/datum/preference/toggle/show_identity_when_masked)

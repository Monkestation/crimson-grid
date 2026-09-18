/datum/preference/toggle/show_identity_when_masked
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "show_flavor_text_when_masked"
	savefile_identifier = PREFERENCE_CHARACTER
	default_value = FALSE

/datum/preference/toggle/show_identity_when_masked/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

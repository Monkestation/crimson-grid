// All of these are handled in datacore, so we dont apply it to the human.
/datum/preference/text/medical
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "medical_record"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/medical/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/////////////////////////////////////////////////////////////////////////////////////////////

/datum/preference/text/criminal
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "criminal_record"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/criminal/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/////////////////////////////////////////////////////////////////////////////////////////////

/datum/preference/text/exploitable
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "exploitable_info"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/exploitable/create_default_value()
	return EXPLOITABLE_DEFAULT_TEXT

/datum/preference/text/exploitable/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

/////////////////////////////////////////////////////////////////////////////////////////////

/datum/preference/text/background
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "background_info"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/background/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

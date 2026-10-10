/datum/preference/text/phone_published_name
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "published_phone_name"
	maximum_value_length = MAX_FLAVOR_LEN

/datum/preference/text/phone_published_name/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE

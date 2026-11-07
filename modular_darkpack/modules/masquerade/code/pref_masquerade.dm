/datum/config_entry/flag/persistent_masquerade
	default = FALSE

/datum/preference/numeric/masquerade
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED // DARKPACK TODO - Render this somewhere
	savefile_key = "masquerade"
	savefile_identifier = PREFERENCE_CHARACTER
	minimum = 1
	maximum = 5

/datum/preference/numeric/masquerade/create_default_value()
	return 5

/datum/preference/numeric/masquerade/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!CONFIG_GET(flag/persistent_masquerade))
		return
	target.masquerade_score = value
	if(!isdummy(target))
		SSmasquerade.masquerade_breacher_check(target)

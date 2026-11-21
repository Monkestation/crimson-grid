/datum/preference/toggle/masquerade_knower
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "masquerade_knower"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_WORLD_OF_DARKNESS
	default_value = FALSE

/datum/preference/toggle/masquerade_knower/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/preference/toggle/masquerade_knower/is_accessible(datum/preferences/preferences)
	. = ..()
	var/splat_pref = preferences.read_preference(/datum/preference/choiced/splats)
	if(splat_pref != SPLAT_NONE)
		return FALSE

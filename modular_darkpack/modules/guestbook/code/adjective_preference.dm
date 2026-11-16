/datum/preference/choiced/adjective_preference
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	priority = PREFERENCE_PRIORITY_TABLETOP
	savefile_key = "adjective_preference"
	savefile_identifier = PREFERENCE_CHARACTER
	main_feature_name = "Adjective"
	can_randomize = TRUE

/datum/preference/choiced/adjective_preference/init_possible_values()
	return assoc_to_keys(GLOB.preference_adjectives)

/datum/preference/choiced/adjective_preference/create_default_value()
	return pick(assoc_to_keys(GLOB.preference_adjectives))

/datum/preference/choiced/adjective_preference/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.visible_adjective = value
	target.update_visible_name()

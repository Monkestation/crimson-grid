/datum/preference/numeric/immortal_age
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "immortal_age"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_TABLETOP
	relevant_inherent_trait = TRAIT_UNAGING
	must_have_relevant_trait = TRUE

	minimum = 0
	maximum = 1000

/datum/preference/numeric/immortal_age/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.chronological_age += value

/datum/preference/numeric/immortal_age/create_informed_default_value(datum/preferences/preferences)
	return rand(minimum, maximum * 0.1)

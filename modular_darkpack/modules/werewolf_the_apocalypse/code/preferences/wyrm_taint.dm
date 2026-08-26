/datum/preference/toggle/wyrm_tainted
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "wyrm_tainted"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_WORLD_OF_DARKNESS
	relevant_inherent_trait = TRAIT_POSSIBLE_WYRM
	default_value = FALSE

/datum/preference/toggle/wyrm_tainted/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(value)
		ADD_TRAIT(target, TRAIT_WYRMTAINTED_SPRITE, TRAIT_WYRMTAINTED_SPRITE)

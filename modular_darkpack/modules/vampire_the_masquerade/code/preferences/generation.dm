/datum/preference/numeric/generation
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "generation"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_WORLD_OF_DARKNESS
	relevant_inherent_trait = TRAIT_DRINKS_BLOOD
	minimum = MAX_TRUSTED_GENERATION
	maximum = HIGHEST_GENERATION_LIMIT

/datum/preference/numeric/generation/is_valid(value, datum/preferences/preferences)
	var/min = preferences?.discipline_trusted ? MAX_TRUSTED_GENERATION : MAX_PUBLIC_GENERATION
	return isnum(value) && value >= min && value <= HIGHEST_GENERATION_LIMIT

/datum/preference/numeric/generation/deserialize(input, datum/preferences/preferences)
	if(istext(input))
		input = text2num(input)
	var/min = preferences?.discipline_trusted ? MAX_TRUSTED_GENERATION : MAX_PUBLIC_GENERATION
	return sanitize_float(input, min, HIGHEST_GENERATION_LIMIT, 1, rand(min, HIGHEST_GENERATION_LIMIT))

/datum/preference/numeric/generation/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	get_kindred_splat(target)?.set_generation(value)

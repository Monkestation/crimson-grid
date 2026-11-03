/datum/preference/numeric/immortal_age
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_key = "immortal_age"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_TABLETOP
	relevant_inherent_trait = TRAIT_UNAGING
	must_have_relevant_trait = TRUE

	minimum = 0
	maximum = 3000

/datum/preference/numeric/immortal_age/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	// CORVAX EDIT START
	var/gen = preferences?.read_preference(/datum/preference/numeric/generation)
	var/max_age = min(maximum, get_max_immortal_age_for_generation(isnum(gen) ? gen : HIGHEST_GENERATION_LIMIT))
	value = clamp(value, minimum, max_age)
	// CORVAX EDIT END
	target.chronological_age += value

/datum/preference/numeric/immortal_age/create_informed_default_value(datum/preferences/preferences)
	// CORVAX EDIT START
	var/gen = preferences?.read_preference(/datum/preference/numeric/generation)
	var/max_age = min(maximum, get_max_immortal_age_for_generation(isnum(gen) ? gen : HIGHEST_GENERATION_LIMIT))
	return rand(minimum, max_age * 0.1)
	// CORVAX EDIT END

// CORVAX EDIT START
/datum/preference/numeric/immortal_age/is_valid(value, datum/preferences/preferences)
	if(!isnum(value) || value < minimum)
		return FALSE
	var/gen = preferences?.read_preference(/datum/preference/numeric/generation)
	var/max_age = min(maximum, get_max_immortal_age_for_generation(isnum(gen) ? gen : HIGHEST_GENERATION_LIMIT))
	return value <= max_age

/datum/preference/numeric/immortal_age/deserialize(input, datum/preferences/preferences)
	if(istext(input))
		input = text2num(input)
	if(!isnum(input))
		input = minimum
	if(!length(preferences?.exp))
		return clamp(round(input), minimum, maximum)
	var/gen = preferences?.read_preference(/datum/preference/numeric/generation)
	var/max_age = min(maximum, get_max_immortal_age_for_generation(isnum(gen) ? gen : HIGHEST_GENERATION_LIMIT))
	return clamp(round(input), minimum, max_age)
// CORVAX EDIT END

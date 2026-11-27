
/datum/preference/toggle/organ_donor
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_identifier = PREFERENCE_CHARACTER
	should_update_preview = FALSE
	savefile_key = "organ_donor"
	can_randomize = TRUE

/datum/preference/toggle/organ_donor/create_default_value()
	return pick(list(TRUE, FALSE))

/datum/preference/toggle/organ_donor/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.organ_donor = value
	return

/*
**  Used for "Fake Documents" Quirk in illegal_identity.dm
*/
/datum/preference/text/illegal_identity
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	should_update_preview = FALSE
	savefile_key = "illegal_identity"
	can_randomize = TRUE

/datum/preference/text/illegal_identity/create_informed_default_value(datum/preferences/preferences)
	return generate_random_name(preferences.read_preference(/datum/preference/choiced/gender))

/datum/preference/text/illegal_identity/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.fake_name_identity = value
	return

/datum/preference/choiced/fake_gender
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	should_update_preview = FALSE
	savefile_key = "fake_gender"
	can_randomize = TRUE

/datum/preference/choiced/fake_gender/init_possible_values()
	return list("M", "F", "X")

/datum/preference/choiced/fake_gender/create_default_value()
	return pick(list("M", "F", "X"))

/datum/preference/choiced/fake_gender/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.fake_gender = value
	return

/datum/preference/numeric/fake_age
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	should_update_preview = FALSE
	savefile_key = "fake_age"
	can_randomize = TRUE
	minimum = 18
	maximum = 1000

/datum/preference/numeric/fake_age/create_default_value()
	return rand(18, 85)

/datum/preference/numeric/fake_age/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.fake_age = value
	return

/datum/preference/toggle/fake_organ_donor
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_identifier = PREFERENCE_CHARACTER
	should_update_preview = FALSE
	savefile_key = "fake_organ_donor"
	can_randomize = TRUE

/datum/preference/toggle/fake_organ_donor/create_default_value()
	return pick(list(TRUE, FALSE))

/datum/preference/toggle/fake_organ_donor/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.fake_organ_donor = value
	return

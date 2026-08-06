// Homebrew?
/datum/quirk/darkpack/illegal_identity
	name = "Fake Documents"
	desc = "Your documents and paperwork are forged! Any IDs you're carrying are bullshit, and have whatever details you want."
	ttrpg_sources = list(/datum/source_book/homebrew = WE_MADE_IT_UP)
	value = 0
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_HIDE_FROM_SCAN
	icon = FA_ICON_FILE_CIRCLE_XMARK
	mob_trait = TRAIT_ILLEGAL_IDENTITY
	gain_text = span_warning("You feel legally unprepared.")
	lose_text = span_notice("You feel bureaucratically legitimate.")
	medical_record_text = "Patient is not checked in with valid identification."
	//excluded_clans = list(VAMPIRE_CLAN_RAVNOS) // They are forced to take this
	failure_message = "Oh, there's my actual ID, looks like I misplaced it..."

/datum/quirk_constant_data/illegal_identity
	associated_typepath = /datum/quirk/darkpack/illegal_identity
	customization_options = list(
		/datum/preference/text/illegal_identity,
		/datum/preference/choiced/fake_gender,
		/datum/preference/toggle/fake_organ_donor,
		/datum/preference/numeric/fake_age
	)

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

/datum/quirk/darkpack/illegal_identity/add()
	. = ..()
	var/mob/living/carbon/human/criminal = astype(quirk_holder)
	if(!criminal)
		return
	for(var/item in criminal.gather_belongings()) // prolly a faster way to do this
		if(istype(item, /obj/item/passport))
			var/obj/item/passport/passport = item
			passport.link_human(criminal)
			continue
		if(istype(item, /obj/item/card/drivers_license))
			var/obj/item/card/drivers_license/license = item
			license.link_human(criminal)
			continue


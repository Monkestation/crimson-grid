// W20 p. 474
/datum/quirk/darkpack/one_armed
	name = "One Arm"
	desc = "You're missing your an arm. That just ain't right."
	icon = FA_ICON_HAND
	ttrpg_sources = list(/datum/source_book/wta20 = 474)
	value = -3
	gain_text = span_warning("You can't feel your arm!")
	lose_text = span_notice("Huh? Your arm is back...")
	quirk_flags = QUIRK_CHANGES_APPEARANCE

	var/arm_missing

/datum/quirk/darkpack/one_armed/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder

	// add runs before add_unqiue so we rely on it to decide
	if(!arm_missing)
		arm_missing = client_source?.prefs.read_preference(/datum/preference/choiced/missing_arm)

	if(arm_missing == "right")
		human_holder.gain_trauma(/datum/brain_trauma/severe/paralysis/right_arm, TRAUMA_RESILIENCE_ABSOLUTE)
	else
		human_holder.gain_trauma(/datum/brain_trauma/severe/paralysis/left_arm, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/quirk/darkpack/one_armed/add_unique(client/client_source)
	var/mob/living/carbon/human/our_holder = quirk_holder


	if(arm_missing == "right")
		qdel(our_holder.get_bodypart(BODY_ZONE_R_ARM))
	else
		qdel(our_holder.get_bodypart(BODY_ZONE_L_ARM))

/datum/quirk/darkpack/one_armed/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder

	// Just to make sure we catch the right one...
	human_holder.cure_trauma_type(/datum/brain_trauma/severe/paralysis/right_arm, TRAUMA_RESILIENCE_ABSOLUTE)
	human_holder.cure_trauma_type(/datum/brain_trauma/severe/paralysis/left_arm, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/brain_trauma/severe/paralysis/right_arm
	random_gain = FALSE
	known_trauma = FALSE
	paralysis_type = "r_arm"
	resilience = TRAUMA_RESILIENCE_ABSOLUTE

/datum/brain_trauma/severe/paralysis/left_arm
	random_gain = FALSE
	known_trauma = FALSE
	paralysis_type = "l_arm"
	resilience = TRAUMA_RESILIENCE_ABSOLUTE


/datum/quirk_constant_data/missing_arm_choice
	associated_typepath = /datum/quirk/darkpack/one_armed
	customization_options = list(/datum/preference/choiced/missing_arm)


/datum/preference/choiced/missing_arm
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "missing_arm"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/missing_arm/init_possible_values()
	return list("left", "right")

/datum/preference/choiced/missing_arm/create_default_value()
	return "right"

/datum/preference/choiced/missing_arm/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE

	return /datum/quirk/darkpack/one_armed::name in preferences.all_quirks

/datum/preference/choiced/missing_arm/apply_to_human(mob/living/carbon/human/target, value)
	return

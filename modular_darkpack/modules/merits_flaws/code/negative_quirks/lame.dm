// VTM pg. 482
/datum/quirk/darkpack/lame
	name = "Lame"
	desc = {"One or both of your legs are damaged, which prevents you from running or walking easily.
You are forced to walk with a crutch or possibly leg braces, and you have a pronounced limp to your stride."} // we give them one leg trait to select, since using both will make them unable to walk entirely.
	icon = FA_ICON_CRUTCH
	value = -3
	gain_text = span_notice("Your legs ache!")
	lose_text = span_notice("Your legs no longer hurt.")
	failure_message = span_notice("Your legs no longer hurt.")
	var/lame_leg // Which leg are we not using?

/*Your legs are damaged, which prevents you from running or walking easily.
You are forced to walk with a cane or possibly leg braces, and you have a pronounced limp to your stride.
Your walking speed is one-quarter that of a normal human, and running is impossible.*/

/datum/quirk/darkpack/lame/add(client/client_source)
	. = ..()
	if(!lame_leg)
		lame_leg = client_source?.prefs.read_preference(/datum/preference/choiced/lame_leg)
	if(lame_leg == "right")
		ADD_TRAIT(quirk_holder, TRAIT_PARALYSIS_R_LEG, QUIRK_TRAIT)
	else
		ADD_TRAIT(quirk_holder, TRAIT_PARALYSIS_L_LEG, QUIRK_TRAIT)

/datum/quirk/darkpack/lame/remove()
	. = ..()
	REMOVE_TRAIT(quirk_holder, TRAIT_PARALYSIS_R_LEG, QUIRK_TRAIT)
	REMOVE_TRAIT(quirk_holder, TRAIT_PARALYSIS_L_LEG, QUIRK_TRAIT)

/datum/quirk_constant_data/lame_leg
	associated_typepath = /datum/quirk/darkpack/lame
	customization_options = list(/datum/preference/choiced/lame_leg)

/datum/preference/choiced/lame_leg
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "lame_leg"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/lame_leg/init_possible_values()
	return list("right", "left")

/datum/preference/choiced/lame_leg/create_default_value()
	return "right"

/datum/preference/choiced/lame_leg/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE

	return /datum/quirk/darkpack/lame::name in preferences.all_quirks

/datum/preference/choiced/lame_leg/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/quirk/darkpack/acute_sense
	name = "Acute Sense"
	desc = "One of your senses is exceptionally sharp, be it sight, hearing, smell, touch, or taste."
	value = 1
	icon = FA_ICON_EYE
	ttrpg_sources = list(
		/datum/source_book/vtm20 = 479,
		/datum/source_book/wta20 = 472,
		/datum/source_book/ctd20 = 176,
		/datum/source_book/mta20 = 642,
		)
	var/sense

/*One of your senses is exceptionally sharp, be it sight,
hearing, smell, touch, or taste. The difficulties for all
tasks involving the use of this particular sense are re
duced by two. This Merit can be combined with the
Discipline of Auspex to produce superhuman sensory
acuity.*/

/datum/quirk/darkpack/acute_sense/add(client/client_source)
	. = ..()
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return
	sense = client_source?.prefs.read_preference(/datum/preference/choiced/acute_sense)
	switch(sense)
		if("hearing")
			ADD_TRAIT(quirk_holder, TRAIT_ACUTE_HEARING, QUIRK_TRAIT) // Used to hear more.
			var/obj/item/organ/ears/good_ears = human_holder.get_organ_slot(ORGAN_SLOT_EARS)
			if(good_ears)
				good_ears.damage_multiplier = good_ears.damage_multiplier + 1
		if("smell")
			ADD_TRAIT(quirk_holder, TRAIT_KEEN_NOSE, QUIRK_TRAIT)
		if("sight")
			ADD_TRAIT(quirk_holder, TRAIT_NIGHT_VISION, QUIRK_TRAIT)
			human_holder.update_sight()
			var/obj/item/organ/eyes/good_eyes = human_holder.get_organ_by_type(/obj/item/organ/eyes)
			if(good_eyes)
				good_eyes.flash_protect = max(good_eyes.flash_protect -= 1)
		if("taste")
			ADD_TRAIT(quirk_holder, TRAIT_DETECTIVES_TASTE, QUIRK_TRAIT)
		if("touch")
			ADD_TRAIT(quirk_holder, TRAIT_SELF_AWARE, QUIRK_TRAIT) // Iffy on this, consider if something else fits better.

/datum/quirk/darkpack/acute_sense/remove()
	. = ..()
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return
	switch(sense)
		if("hearing")
			REMOVE_TRAIT(quirk_holder, TRAIT_ACUTE_HEARING, QUIRK_TRAIT)
			var/obj/item/organ/ears/good_ears = human_holder.get_organ_slot(ORGAN_SLOT_EARS)
			if(good_ears)
				good_ears.damage_multiplier = initial(good_ears.damage_multiplier)
		if("smell")
			REMOVE_TRAIT(quirk_holder, TRAIT_KEEN_NOSE, QUIRK_TRAIT)
		if("sight")
			REMOVE_TRAIT(quirk_holder, TRAIT_NIGHT_VISION, QUIRK_TRAIT)
			human_holder.update_sight()
			var/obj/item/organ/eyes/good_eyes = human_holder.get_organ_slot(ORGAN_SLOT_EYES)
			if(good_eyes)
				good_eyes.flash_protect = initial(good_eyes.flash_protect)
		if("taste")
			REMOVE_TRAIT(quirk_holder, TRAIT_DETECTIVES_TASTE, QUIRK_TRAIT)
		if("touch")
			REMOVE_TRAIT(quirk_holder, TRAIT_SELF_AWARE, QUIRK_TRAIT)

/datum/quirk_constant_data/acute_sense
	associated_typepath = /datum/quirk/darkpack/acute_sense
	customization_options = list(/datum/preference/choiced/acute_sense)

/datum/preference/choiced/acute_sense
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "acute_sense"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/acute_sense/init_possible_values()
	return list("hearing", "smell", "sight", "taste", "touch")

/datum/preference/choiced/acute_sense/create_default_value()
	return "hearing"

/datum/preference/choiced/acute_sense/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE

	return /datum/quirk/darkpack/acute_sense::name in preferences.all_quirks

/datum/preference/choiced/acute_sense/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

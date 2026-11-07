/datum/preference/toggle/diablerist
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "diablerist"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_WORLD_OF_DARKNESS
	relevant_inherent_trait = TRAIT_DRINKS_BLOOD
	default_value = FALSE

/datum/preference/toggle/diablerist/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(value)
		ADD_TRAIT(target, TRAIT_DIABLERIE, TRAIT_DIABLERIE)

// CRIMSON EDIT ADD START - Diablerie progression
// wipe bonus points when diablerist is turned off
/datum/preference/toggle/diablerist/post_set_preference(mob/user, value)
	// if TRUE then just early return - we only want to wipe on false
	if(value)
		return
	var/datum/preferences/prefs = user?.client?.prefs
	if(!prefs)
		return
	prefs.write_preference(GLOB.preference_entries[/datum/preference/numeric/bonus_discipline_points], 0)
// CRIMSON EDIT ADD END - Diablerie progression


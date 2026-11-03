/datum/preference/toggle/admin_generation_lock_forever
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "admin_generation_lock_forever"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_WORLD_OF_DARKNESS
	default_value = FALSE
	can_randomize = FALSE

/datum/preference/toggle/admin_generation_lock_forever/visible_in_page(datum/preferences/preferences)
	return FALSE

/datum/preference/toggle/admin_generation_lock_forever/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/preference/toggle/diablerie_locked
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "diablerie_locked"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_WORLD_OF_DARKNESS
	default_value = FALSE
	can_randomize = FALSE

/datum/preference/toggle/diablerie_locked/visible_in_page(datum/preferences/preferences)
	return FALSE

/datum/preference/toggle/diablerie_locked/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

/datum/preference/toggle/diablerie_generation_locked
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	savefile_key = "diablerie_generation_locked"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_WORLD_OF_DARKNESS
	default_value = FALSE
	can_randomize = FALSE

/datum/preference/toggle/diablerie_generation_locked/visible_in_page(datum/preferences/preferences)
	return FALSE

/datum/preference/toggle/diablerie_generation_locked/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

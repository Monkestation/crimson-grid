/datum/preference/choiced/vtm_morality
	savefile_key = "morality_path"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_TABLETOP
	main_feature_name = "Path"
	relevant_inherent_trait = TRAIT_VTM_MORALITY
	must_have_relevant_trait = TRUE
	can_randomize = FALSE

/datum/preference/choiced/vtm_morality/create_default_value()
	return /datum/morality/humanity

/datum/preference/choiced/vtm_morality/init_possible_values()
	var/list/values = list()
	for(var/morality_type in subtypesof(/datum/morality))
		var/datum/morality/M = morality_type
		values[initial(M.name)] = morality_type
	return values

/datum/preference/choiced/vtm_morality/is_valid(value)
	return ispath(value, /datum/morality)

/datum/preference/choiced/vtm_morality/serialize(input)
	if(ispath(input))
		var/datum/morality/input_morality = input
		return input_morality::name
	return input

/datum/preference/choiced/vtm_morality/deserialize(input, datum/preferences/preferences)
	var/list/choices = get_choices()
	if(input in choices)
		return choices[input]
	return choices[serialize(create_default_value())]

/datum/preference/choiced/vtm_morality/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/datum/st_stat/morality_path/morality/stat_morality = target.storyteller_stats[STAT_MORALITY]
	if(!stat_morality)
		return

	stat_morality.morality_path = new value(target)

/datum/preference/choiced/vtm_morality/post_set_preference(mob/user, value)
	. = ..()
	if(!user)
		return

	var/datum/morality/morality_path = GLOB.morality_paths[value]
	if(!morality_path)
		return

	morality_path.show_lore(user)

/mob/living/proc/is_enlightenment()
	var/datum/st_stat/morality_path/morality/stat_morality = storyteller_stats[STAT_MORALITY]
	if(!stat_morality?.morality_path)
		return FALSE

	if(stat_morality.morality_path.alignment == MORALITY_ENLIGHTENMENT)
		return TRUE
	return FALSE

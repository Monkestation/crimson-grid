/datum/preference/choiced/fera_fur_color
	abstract_type = /datum/preference/choiced/fera_fur_color
	savefile_key = "fur_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_WORLD_OF_DARKNESS
	main_feature_name = "Fera Fur Color"
	relevant_inherent_trait = TRAIT_FERA_FUR
	must_have_relevant_trait = TRUE
	must_be_accessible = TRUE
	var/splat_id

/datum/preference/choiced/fera_fur_color/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target.dna.features[FEATURE_FUR_COLOR] = value

/datum/preference/choiced/fera_fur_color/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/splat/splat_path = preferences.read_preference(/datum/preference/choiced/splats)
	if(!ispath(splat_path) || splat_path::id != splat_id)
		return FALSE


/datum/preference/choiced/fera_fur_color/garou
	savefile_key = "garou_fur_color"
	splat_id = SPLAT_GAROU

/datum/preference/choiced/fera_fur_color/garou/init_possible_values()
	return assoc_to_keys(GLOB.garou_fur_colors)

/datum/preference/choiced/fera_fur_color/corax
	savefile_key = "corax_fur_color"
	splat_id = SPLAT_CORAX

/datum/preference/choiced/fera_fur_color/corax/init_possible_values()
	return assoc_to_keys(GLOB.corax_fur_colors)

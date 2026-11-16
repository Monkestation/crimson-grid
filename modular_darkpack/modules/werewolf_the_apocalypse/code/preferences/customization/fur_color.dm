/datum/preference/choiced/fera_fur_color
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_WORLD_OF_DARKNESS
	must_have_relevant_trait = TRUE
	must_be_accessible = TRUE

	abstract_type = /datum/preference/choiced/fera_fur_color
	savefile_key = "fur_color"

	main_feature_name = "Fera Fur Color"
	relevant_inherent_trait = TRAIT_FERA_FUR
	var/splat_id

/datum/preference/choiced/fera_fur_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features[FEATURE_FERA_FUR_COLOR] = value

/datum/preference/choiced/fera_fur_color/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/splat/splat_path = preferences.read_preference(/datum/preference/choiced/splats)
	if(!ispath(splat_path) || splat_path::id != splat_id)
		return FALSE

/datum/preference/choiced/fera_fur_color/init_possible_values()
	return assoc_to_keys(GLOB.fera_fur_colors[splat_id])


/datum/preference/choiced/fera_fur_color/garou
	savefile_key = "garou_fur_color"
	splat_id = SPLAT_GAROU


/datum/preference/choiced/fera_fur_color/corax
	savefile_key = "corax_fur_color"
	splat_id = SPLAT_CORAX


/datum/dna_block/feature/fera_fur_color
	feature_key = FEATURE_FERA_FUR_COLOR

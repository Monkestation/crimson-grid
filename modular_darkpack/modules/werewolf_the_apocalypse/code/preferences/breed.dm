/datum/preference/choiced/subsplat/fera_breed
	abstract_type = /datum/preference/choiced/subsplat/fera_breed
	main_feature_name = "Breed"
	must_be_accessible = TRUE
	var/splat_id

/datum/preference/choiced/subsplat/fera_breed/init_possible_values()
	var/list/pref_list = list()
	// Key is type path not singleton
	for(var/datum/subsplat/werewolf/breed_form/key as anything in GLOB.breed_forms)
		if(key::fera_restriction != splat_id)
			continue
		UNTYPED_LIST_ADD(pref_list, key::name)
	return pref_list

/datum/preference/choiced/subsplat/fera_breed/icon_for(value)
	var/datum/universal_icon/breed_icon = uni_icon('icons/effects/effects.dmi', "nothing")

	var/datum/subsplat/werewolf/breed_form/breed_form = get_fera_breed_form(value)
	breed_form.generation_pref_icon(breed_icon)

	return breed_icon

/datum/preference/choiced/subsplat/fera_breed/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/joining_round = !isdummy(target)
	target.set_breed_form(value, joining_round)

/datum/preference/choiced/subsplat/fera_breed/post_set_preference(mob/user, value)
	var/datum/subsplat/werewolf/breed_form/breed = get_fera_breed_form(value)
	breed?.show_lore(user)

/datum/preference/choiced/subsplat/fera_breed/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/splat/splat_path = preferences.read_preference(/datum/preference/choiced/splats)
	if(!ispath(splat_path) || splat_path::id != splat_id)
		return FALSE


/datum/preference/choiced/subsplat/fera_breed/garou
	savefile_key = "garou_breed"
	splat_id = SPLAT_GAROU


/datum/preference/choiced/subsplat/fera_breed/coeax
	savefile_key = "corax_breed"
	splat_id = SPLAT_CORAX

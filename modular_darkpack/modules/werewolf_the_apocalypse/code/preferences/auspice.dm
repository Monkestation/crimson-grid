/datum/preference/choiced/subsplat/fera_auspice
	abstract_type = /datum/preference/choiced/subsplat/fera_auspice
	main_feature_name = "Auspice"
	must_be_accessible = TRUE
	var/splat_id

/datum/preference/choiced/subsplat/fera_auspice/init_possible_values()
	var/list/pref_list = list()
	// Key is type path not singleton
	for(var/datum/subsplat/werewolf/auspice/key as anything in GLOB.auspices)
		if(key::fera_restriction != splat_id)
			continue
		UNTYPED_LIST_ADD(pref_list, key::name)
	return pref_list

/datum/preference/choiced/subsplat/fera_auspice/icon_for(value)
	var/datum/universal_icon/auspice_icon = uni_icon('icons/effects/effects.dmi', "nothing")
	auspice_icon.blend_icon(uni_icon('modular_darkpack/modules/werewolf_the_apocalypse/icons/auspices.dmi', replacetext(LOWER_TEXT(value), " ", "_")), ICON_OVERLAY)
	return auspice_icon

/datum/preference/choiced/subsplat/fera_auspice/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/joining_round = !isdummy(target)
	target.set_auspice(value, joining_round)

/datum/preference/choiced/subsplat/fera_auspice/post_set_preference(mob/user, value)
	var/datum/subsplat/werewolf/auspice/auspice = get_fera_auspice(value)
	auspice?.show_lore(user)

/datum/preference/choiced/subsplat/fera_auspice/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/splat/splat_path = preferences.read_preference(/datum/preference/choiced/splats)
	if(!ispath(splat_path) || splat_path::id != splat_id)
		return FALSE


/datum/preference/choiced/subsplat/fera_auspice/garou
	savefile_key = "garou_auspice"
	splat_id = SPLAT_GAROU

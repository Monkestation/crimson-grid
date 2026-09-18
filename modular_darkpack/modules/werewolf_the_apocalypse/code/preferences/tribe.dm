/datum/preference/choiced/subsplat/fera_tribe
	abstract_type = /datum/preference/choiced/subsplat/fera_tribe
	main_feature_name = "Tribe"
	must_be_accessible = TRUE
	var/splat_id

/datum/preference/choiced/subsplat/fera_tribe/init_possible_values()
	var/list/pref_list = list()
	// Key is type path not singleton
	for(var/datum/subsplat/werewolf/tribe/key as anything in GLOB.fera_tribes)
		if(key::fera_restriction != splat_id)
			continue
		UNTYPED_LIST_ADD(pref_list, key::name)
	return pref_list

/datum/preference/choiced/subsplat/fera_tribe/icon_for(value)
	var/datum/universal_icon/tribe_icon = uni_icon('icons/effects/effects.dmi', "nothing")
	tribe_icon.blend_icon(uni_icon('modular_darkpack/modules/werewolf_the_apocalypse/icons/tribes.dmi', replacetext(LOWER_TEXT(value), " ", "_")), ICON_OVERLAY)
	return tribe_icon

/datum/preference/choiced/subsplat/fera_tribe/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/joining_round = !isdummy(target)
	target.set_fera_tribe(value, joining_round)

/datum/preference/choiced/subsplat/fera_tribe/post_set_preference(mob/user, value)
	var/datum/subsplat/werewolf/tribe/tribe = get_fera_tribe(value)
	tribe?.show_lore(user)

/datum/preference/choiced/subsplat/fera_tribe/is_accessible(datum/preferences/preferences)
	. = ..()
	var/datum/splat/splat_path = preferences.read_preference(/datum/preference/choiced/splats)
	if(!ispath(splat_path) || splat_path::id != splat_id)
		return FALSE


/datum/preference/choiced/subsplat/fera_tribe/garou
	splat_id = SPLAT_GAROU
	savefile_key = "garou_tribe"

/* // Exist in the changing breeds book.
/datum/preference/choiced/subsplat/fera_tribe/corax
	splat_id = SPLAT_CORAX
	savefile_key = "corax_tribe"
*/

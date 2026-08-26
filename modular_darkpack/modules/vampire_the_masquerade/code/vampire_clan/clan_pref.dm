/datum/preference/choiced/subsplat/vampire_clan
	savefile_key = "vampire_clan"
	main_feature_name = "Clan"
	relevant_inherent_trait = TRAIT_VTM_CLANS

/datum/preference/choiced/subsplat/vampire_clan/init_possible_values()
	// DARKPACK TODO - implement whitelisting
	return assoc_to_keys(GLOB.vampire_clan_list)

/datum/preference/choiced/subsplat/vampire_clan/icon_for(value)
	return uni_icon('modular_darkpack/modules/vampire_the_masquerade/icons/vampire_clans.dmi', get_vampire_clan(value).icon)

/datum/preference/choiced/subsplat/vampire_clan/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/joining_round = !isdummy(target)
	target.set_clan(value, joining_round)

/datum/preference/choiced/subsplat/vampire_clan/post_set_preference(mob/user, value)
	var/datum/subsplat/vampire_clan/clan = get_vampire_clan(value)
	clan?.show_lore(user)

/datum/preference_middleware/feature_bans/get_ui_static_data(mob/user)
	var/list/data = list(
		"banned_features" = list()
	)
	var/list/features = alist(
		"auspice" = GLOB.auspices_list,
		"tribe" = GLOB.tribes_list,
		"vampire_clan" = GLOB.vampire_clan_list,
	)
	for(var/feature in features)
		for(var/creature in features[feature])
			if(is_banned_from(user.ckey, creature))
				LAZYADD(data["banned_features"][feature], creature)

	return data

/datum/preferences/update_preference(datum/preference/preference, preference_value)
	if(istype(preference, /datum/preference/choiced/subsplat))
		// NO, THIS IS BAD DO NOT DO THIS, i cant think of another way though because `splat_id` is defined SEPERATELY on 3 subtypes, except for one
		// so i have no other choice but to check if the splat_id exists.
		// by checking for splat_id this does exclude checking for a splat ban
		if(preference.vars["splat_id"] && is_banned_from(usr.ckey, preference_value))
			to_chat(usr, span_warning("You are banned from selecting [preference_value] for [astype(preference, /datum/preference/choiced/subsplat).main_feature_name]."))
			return FALSE
	return ..()

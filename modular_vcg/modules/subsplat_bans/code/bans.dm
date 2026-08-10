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
	// some subsplats do not have names and only have splat_ids so we cant represent the name in the ban message.
	if(istype(preference, /datum/preference/choiced/subsplat) && (is_banned_from(parent.ckey, preference_value)))
			to_chat(parent, span_warning("You are banned from selecting [preference_value] for [astype(preference, /datum/preference/choiced/subsplat).main_feature_name]."))
			return FALSE
	return ..()

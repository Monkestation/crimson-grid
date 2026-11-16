/// Middleware to handle quirks
/datum/preference_middleware/quirks
	/// Used to track whether or not we need to update changes in ui_data
	var/tainted = TRUE
	/// Remember what the last species we chose was, to avoid having to validate quirks again
	var/previous_species_value
	/// The current selected quirks, saved so we can cheaply resend them in ui_data only when necessary, without having to use expensive update_static_data() calls
	var/list/cached_selected_quirks
	/// The current species compatibility, saved so we can cheaply resend them in ui_data only when necessary, without having to use expensive update_static_data() calls
	var/list/cached_species_compatibility

	action_delegations = list(
		"give_quirk" = PROC_REF(give_quirk),
		"remove_quirk" = PROC_REF(remove_quirk),
	)
/datum/preference_middleware/quirks/pre_set_preference(mob/user, preference, value)
	if(preference != "species")
		return
	var/list/incompatible_quirks
	var/selected_species_type = GLOB.species_list[value]
	for(var/quirk_name in preferences.all_quirks)
		var/quirk_path = SSquirks.quirks[quirk_name]
		var/datum/quirk/quirk_prototype = SSquirks.quirk_prototypes[quirk_path]
		if(!quirk_prototype.is_species_appropriate(selected_species_type))
			LAZYADD(incompatible_quirks, quirk_name)
	if(!LAZYLEN(incompatible_quirks))
		return
	var/list/message = list("The following quirks are incompatible with your selected species and will be removed: [incompatible_quirks.Join(", ")].")
	if(!SSquirks.points_enabled)
		message += "Would you like to continue?"
	else
		message += "If you do not have enough points to cover the removed quirks, your quirks will be reset. Would you like to continue?"
	var/response = tgui_alert(user, message.Join(" "), "Quirks Incompatible", list("Yes", "No"))
	if(response != "Yes")
		return TRUE

/datum/preference_middleware/quirks/post_set_preference(mob/user, preference, value)
	if(preference != "species" || value == previous_species_value)
		return

	tainted = TRUE
	previous_species_value = value
	preferences.validate_quirks()

/datum/preference_middleware/quirks/proc/get_species_compatibility()
	var/list/species_blacklist = list()
	var/datum/species/mob_species = preferences.read_preference(/datum/preference/choiced/species)
	for(var/datum/quirk/quirk_type as anything in SSquirks.quirk_prototypes)
		if(!SSquirks.quirk_prototypes[quirk_type].is_species_appropriate(mob_species))
			species_blacklist += quirk_type::name
	return species_blacklist

// DARKPACK EDIT ADD START - SPLATS
/datum/preference_middleware/quirks/proc/get_splat_compatibility()
	var/list/splat_blacklist = list()
	var/datum/splat/mob_splat = preferences.read_preference(/datum/preference/choiced/splats)
	for(var/datum/quirk/quirk_type as anything in SSquirks.quirk_prototypes)
		if(!SSquirks.quirk_prototypes[quirk_type].is_splat_appropriate(mob_splat))
			splat_blacklist += quirk_type::name
	return splat_blacklist
// DARKPACK EDIT ADD END


/datum/preference_middleware/quirks/get_ui_static_data(mob/user)
	if (preferences.current_window != PREFERENCE_TAB_CHARACTER_PREFERENCES)
		return list()

	var/list/data = list()

	data["default_quirk_balance"] = SSquirks.default_quirk_points

	return data

/datum/preference_middleware/quirks/get_ui_data(mob/user)
	var/list/data = list()

	if (tainted || isnull(cached_selected_quirks)) // if one of these is null, both are null
		tainted = FALSE
		cached_selected_quirks = get_selected_quirks()
		cached_species_compatibility = get_species_compatibility()
		cached_splats_compatibility = get_splat_compatibility() // DARKPACK EDIT ADD - SPLATS
		cached_clans_compatibility = get_clan_compatibility() // DARKPACK EDIT ADD - MERITS_FLAWS

	data["selected_quirks"] = cached_selected_quirks
	data["species_disallowed_quirks"] = cached_species_compatibility
	data["splat_disallowed_quirks"] = cached_splats_compatibility // DARKPACK EDIT ADD - SPLATS
	data["clan_disallowed_quirks"] = cached_clans_compatibility // DARKPACK EDIT ADD - MERITS_FLAWS
	data["quirk_balance"] = get_quirk_balance() // DARKPACK EDIT ADD - MERITS_FLAWS
	data["freebie_points"] = get_freebie_points() // DARKPACK EDIT ADD - MERITS_FLAWS

	return data

/datum/preference_middleware/quirks/get_constant_data()
	var/list/quirk_info = list()

	var/list/quirks = SSquirks.get_quirks()

	var/max_positive_quirks = SSquirks.max_positive_quirks
	var/positive_quirks_disabled = max_positive_quirks == 0
	for (var/quirk_name in quirks)
		var/datum/quirk/quirk = quirks[quirk_name]
		if(positive_quirks_disabled && initial(quirk.value) > 0)
			continue

		var/datum/quirk_constant_data/constant_data = GLOB.all_quirk_constant_data[quirk]
		var/list/datum/preference/customization_options = constant_data?.get_customization_data()

		quirk_info[sanitize_css_class_name(quirk_name)] = list(
			"description" = initial(quirk.desc),
			"icon" = initial(quirk.icon),
			"name" = quirk_name,
			"value" = initial(quirk.value),
			"customizable" = constant_data?.is_customizable(),
			"customization_options" = customization_options,
		)

	return list(
		"max_positive_quirks" = max_positive_quirks,
		"quirk_info" = quirk_info,
		"quirk_blacklist" = GLOB.quirk_string_blacklist,
		"points_enabled" = SSquirks.points_enabled,
	)

/datum/preference_middleware/quirks/on_new_character(mob/user)
	tainted = TRUE
	previous_species_value = null

/datum/preference_middleware/quirks/proc/give_quirk(list/params, mob/user)
	var/quirk_name = params["quirk"]
	// DARKPACK EDIT ADD - MERITS_FLAWS
	var/datum/st_stat/freebie/freebie_points = preferences.preference_storyteller_stats[STAT_FREEBIE_POINTS]
	var/datum/quirk/quirk_type = SSquirks.quirks[quirk_name]
	freebie_points.decrease_points(quirk_type.value)
	// DARKPACK EDIT END - MERITS_FLAWS
	preferences.validate_quirks()
	var/list/new_quirks = preferences.all_quirks | quirk_name
	if (SSquirks.filter_invalid_quirks(new_quirks) != new_quirks)
		// If the client is sending an invalid give_quirk, that means that
		// something went wrong with the client prediction, so we should
		// catch it back up to speed.
		tainted = TRUE
		preferences.update_static_data(user, always_instant = TRUE)
		return TRUE

	preferences.all_quirks = new_quirks
	tainted = TRUE
	preferences.character_preview_view?.update_body()

	return TRUE

/datum/preference_middleware/quirks/proc/remove_quirk(list/params, mob/user)
	var/quirk_name = params["quirk"]
	// DARKPACK EDIT ADD - MERITS_FLAWS
	var/datum/st_stat/freebie/freebie_points = preferences.preference_storyteller_stats[STAT_FREEBIE_POINTS]
	var/datum/quirk/quirk_type = SSquirks.quirks[quirk_name]
	freebie_points.increase_points(quirk_type.value)
	// DARKPACK EDIT END - MERITS_FLAWS
	var/list/new_quirks = preferences.all_quirks - quirk_name
	if ( \
		!(quirk_name in preferences.all_quirks) \
		|| SSquirks.filter_invalid_quirks(new_quirks) != new_quirks \
	)
		// If the client is sending an invalid remove_quirk, that means that
		// something went wrong with the client prediction, so we should
		// catch it back up to speed.
		tainted = TRUE
		preferences.update_static_data(user, always_instant = TRUE)
		return TRUE

	preferences.all_quirks = new_quirks
	tainted = TRUE
	preferences.character_preview_view?.update_body()

	return TRUE

/datum/preference_middleware/quirks/proc/get_selected_quirks()
	var/list/selected_quirks = list()

	for (var/quirk in preferences.all_quirks)
		selected_quirks += sanitize_css_class_name(quirk)

	return selected_quirks

// DARKPACK EDIT ADD - MERITS_FLAWS

/datum/preference_middleware/quirks/proc/get_freebie_points()
	var/datum/st_stat/freebie/freebie_stat = preferences.preference_storyteller_stats[STAT_FREEBIE_POINTS]
	if(!freebie_stat)
		return null

	var/base_points = 15
	var/spent_on_stats = freebie_stat.freebie_cost_spent
	var/quirk_balance = get_quirk_balance()

	return base_points - spent_on_stats + quirk_balance

/datum/preference_middleware/quirks/proc/get_quirk_balance()
	var/total_cost = 0
	for(var/quirk_name in preferences.all_quirks)
		var/datum/quirk/quirk_type = SSquirks.quirks[quirk_name]
		total_cost -= quirk_type.value
	return total_cost

/datum/preference_middleware/quirks/proc/get_clan_compatibility()
	var/list/clan_blacklist = list()
	var/clan_name = preferences.read_preference(/datum/preference/choiced/subsplat/vampire_clan)

	if(!clan_name)
		return clan_blacklist

	//clan_name is clan.name which is "Brujah" vampire clan list is "name" ("Brujah") = typepath, vampire_clans is typepath = datum. we need the datum for the id, which is... just a lowercase name...
	var/datum/subsplat/vampire_clan/clan = GLOB.vampire_clans[GLOB.vampire_clan_list[clan_name]]
	for(var/quirk_path in SSquirks.quirk_prototypes)
		var/datum/quirk/quirk_prototype = SSquirks.quirk_prototypes[quirk_path]

		// clan exclusion is only going to reasonably appear on darkpack quirks
		if(!istype(quirk_prototype, /datum/quirk/darkpack))
			continue

		var/datum/quirk/darkpack/darkpack_quirk = quirk_prototype
		if(!darkpack_quirk.is_clan_appropriate(clan))
			clan_blacklist += quirk_prototype.name

	return clan_blacklist

// DARKPACK EDIT END - MERITS_FLAWS

/// Returns a list of strings representing features this splat has.
/// Used by the preferences UI to know what buttons to show.
/datum/splat/proc/get_features()
	var/cached_features = GLOB.features_by_splats[type]
	if (!isnull(cached_features))
		return cached_features

	var/list/features = list()
	// var/list/mut_organs = get_organs()

	for (var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference = GLOB.preference_entries[preference_type]
		/*
		if ( \
			(preference.relevant_inherent_trait in inherent_traits) \
			|| (preference.relevant_organ in mut_organs) \
			|| (preference.relevant_head_flag && check_head_flags(preference.relevant_head_flag)) \
			|| (preference.relevant_body_markings in body_markings) \
		)
		*/
		if(preference.relevant_inherent_trait in splat_traits)
			features += preference.savefile_key

	GLOB.features_by_splats[type] = features

	return features

/// Splats preference
/datum/preference/choiced/splats
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "splats"
	priority = PREFERENCE_PRIORITY_SPECIES
	randomize_by_default = FALSE

/datum/preference/choiced/splats/deserialize(input, datum/preferences/preferences)
	if(input == SPLAT_NONE)
		return SPLAT_NONE
	return GLOB.splat_list[sanitize_inlist(input, get_choices_serialized(), SPLAT_NONE)]

/datum/preference/choiced/splats/serialize(input)
	if(!ispath(input))
		return SPLAT_NONE
	var/datum/splat/splats = input
	return initial(splats.id)

/datum/preference/choiced/splats/create_default_value()
	return SPLAT_NONE

/datum/preference/choiced/splats/create_random_value(datum/preferences/preferences)
	return pick(get_choices())

/datum/preference/choiced/splats/init_possible_values()
	var/list/values = list()

	for (var/splats_id in get_selectable_splats())
		values += GLOB.splat_list[splats_id]
	values += SPLAT_NONE

	return values

/datum/preference/choiced/splats/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	if(!value)
		return
	if(length(target.splats))
		QDEL_LAZYLIST(target.splats) // Unfortuantly we dont support multiple splats via prefs yet.
	if(ispath(value))
		target.add_splat(value)
		// target.add_splat(value, icon_update = FALSE, pref_load = TRUE)

/datum/preference/choiced/splats/compile_constant_data()
	var/list/data = list()

	data[SPLAT_NONE] = list()
	data[SPLAT_NONE]["name"] = "Nothing"
	data[SPLAT_NONE]["desc"] = "A normal human..."
	data[SPLAT_NONE]["lore"] = list("You know this one...")
	data[SPLAT_NONE]["icon"] = SPLAT_NONE
	data[SPLAT_NONE]["perks"] = list(
		SPECIES_POSITIVE_PERK = list(),
		SPECIES_NEUTRAL_PERK = list(),
		SPECIES_NEGATIVE_PERK = list(),
	)

	for (var/splats_id in get_selectable_splats())
		var/splats_type = GLOB.splat_list[splats_id]
		var/datum/splat/splats = GLOB.splat_prototypes[splats_type]

		data[splats_id] = list()
		data[splats_id]["name"] = splats.name
		data[splats_id]["desc"] = splats.get_splat_description()
		data[splats_id]["lore"] = splats.get_splat_lore()
		data[splats_id]["icon"] = sanitize_css_class_name(splats.name)
		// data[splats_id]["use_skintones"] = (TRAIT_USES_SKINTONES in splats.inherent_traits)
		// data[splats_id]["sexes"] = splats.sexes
		// data[splats_id]["enabled_features"] = splats.get_features()
		data[splats_id]["perks"] = splats.get_splats_perks()
		// data[splats_id]["diet"] = splats.get_splats_diet()

	return data

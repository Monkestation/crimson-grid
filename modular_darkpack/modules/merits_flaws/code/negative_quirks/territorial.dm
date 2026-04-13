GLOBAL_LIST_INIT(territorial_type_choices, init_territorial_type_choices())

/proc/init_territorial_type_choices()
	var/list/choices = list()
	for(var/area/vtm/area_type as anything in subtypesof(/area/vtm))
		var/area/vtm/typed = area_type
		var/area/vtm/parent = type2parent(area_type)
		if(initial(typed.domain) && !initial(parent.domain))
			choices[initial(typed.name)] = area_type
	return choices

/datum/preference/choiced/territorial
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "territorial"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/territorial/init_possible_values()
	return GLOB.territorial_type_choices

/datum/preference/choiced/territorial/create_default_value()
	return /area/vtm/outside/financialdistrict::name

/datum/preference/choiced/territorial/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE
	return /datum/quirk/darkpack/territorial::name in preferences.all_quirks

/datum/preference/choiced/territorial/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/quirk/darkpack/territorial/terr = target.get_quirk(/datum/quirk/darkpack/territorial)
	if(!terr)
		return
	terr.territory = GLOB.territorial_type_choices[value] || /area/vtm/outside/financialdistrict

/datum/quirk/darkpack/territorial
	name = "Territorial"
	desc = "You are extremely territorial, and can only feed in one particular area. You react with hostility if another vampire enters your territory without your notice - and if they feed without your permission, violence is sure to break out, as they're taking your food and resources. You are reluctant to leave your territory unless necessary. Your territory is the only area where you may feed."
	value = -2
	mob_trait = TRAIT_VAMPIRE_TERRITORIAL
	gain_text = span_notice("You need to protect your hunting grounds, your herd, your territory.")
	lose_text = span_notice("Who cares where anyone feeds, anyways?")
	allowed_splats = list(SPLAT_KINDRED)
	icon = FA_ICON_MAP_LOCATION_DOT
	failure_message = "Who cares where anyone feeds, anyways?"
	var/territory

/datum/quirk_constant_data/territorial
	associated_typepath = /datum/quirk/darkpack/territorial
	customization_options = list(/datum/preference/choiced/territorial)

/datum/quirk/darkpack/territorial/add(client/client_source)
	territory = GLOB.territorial_type_choices[client_source?.prefs.read_preference(/datum/preference/choiced/territorial)] || /area/vtm/outside/financialdistrict

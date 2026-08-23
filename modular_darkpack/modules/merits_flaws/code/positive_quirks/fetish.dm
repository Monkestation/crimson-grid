GLOBAL_LIST_INIT(fetish_merit_choice, generate_merit_fetishes())

/proc/generate_merit_fetishes()
	var/list/choices = list()
	for(var/obj/item/occult_artifact/werewolf/fetish as anything in valid_subtypesof(/obj/item/occult_artifact/werewolf))
		if(fetish::rank != 1)
			continue
		choices[fetish::true_name] = fetish
	return choices

// W20 p. 383 for the kinfolk fetish
// W20 p. 137 for the garou background rather then the kinfolk merit.
/datum/quirk/darkpack/item_quirk/fetish
	name = "Fetish"
	desc = "You own a weak fetish. You may have inherited this item, received it as a gift, it should have an important value to you."
	value = 3 // Middle ground price between the kinfolk merit or garou background
	// Acctually a kinfolk merit in the books.
	allowed_splats = list(SPLAT_KINFOLK, SPLAT_GAROU, SPLAT_CORAX)
	icon = FA_ICON_MAGIC

/datum/quirk/darkpack/item_quirk/fetish/add_unique(client/client_source)
	var/mob/living/carbon/human/fetish_owner = astype(quirk_holder)
	if(!fetish_owner)
		return

	var/fetish_type = GLOB.fetish_merit_choice[client_source?.prefs?.read_preference(/datum/preference/choiced/fetish_merit)] || /obj/item/occult_artifact/werewolf/nyxs_bangle
	if(isnull(fetish_type))
		fetish_type = GLOB.fetish_merit_choice[pick(GLOB.fetish_merit_choice)]
	var/obj/item/occult_artifact/werewolf/new_heirloom = new fetish_type(get_turf(fetish_owner))

	give_item_to_holder(
		new_heirloom,
		list(
			LOCATION_LPOCKET,
			LOCATION_RPOCKET,
			LOCATION_BACKPACK,
			LOCATION_HANDS,
		),
		flavour_text = "This is your precious fetish!",
		notify_player = TRUE,
	)

	new_heirloom.identify(fetish_owner)


/datum/quirk_constant_data/blindfoldcolor
	associated_typepath = /datum/quirk/darkpack/item_quirk/fetish
	customization_options = list(/datum/preference/choiced/fetish_merit)


/datum/preference/choiced/fetish_merit
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "fetish_merit"
	savefile_identifier = PREFERENCE_CHARACTER

/datum/preference/choiced/fetish_merit/init_possible_values()
	return list("Random") + GLOB.fetish_merit_choice

/datum/preference/choiced/fetish_merit/create_default_value()
	return "Random"

/datum/preference/choiced/fetish_merit/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!.)
		return FALSE
	return /datum/quirk/darkpack/item_quirk/fetish::name in preferences.all_quirks

/datum/preference/choiced/fetish_merit/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return

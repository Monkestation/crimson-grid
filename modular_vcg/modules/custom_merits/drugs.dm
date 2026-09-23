///Options for the Junkie quirk to choose from
GLOBAL_LIST_INIT(darkpack_junkie_addictions, list(
	"Meth" = list("item" = /obj/item/reagent_containers/cup/glass/baggie/meth, "reagent" = /datum/reagent/drug/methamphetamine),
	"Cocaine" = list("item" = /obj/item/reagent_containers/cup/glass/baggie/meth/cocaine, "reagent" = /datum/reagent/drug/methamphetamine/cocaine),
	"LSD" = list("item" = /obj/item/storage/pill_bottle/lsd, "reagent" = /datum/reagent/drug/mushroomhallucinogen),
	"Morphine" = list("item" = /obj/item/reagent_containers/syringe/contraband/morphine, "reagent" = /datum/reagent/medicine/morphine),
))

///Options for the Smoker quirk to choose from, for cigs that actually exist and can be bought
GLOBAL_LIST_INIT(darkpack_smoker_addictions, setup_smoker_addictions(list(
	/obj/item/storage/fancy/cigarettes/cigpack_robust,
	/obj/item/storage/fancy/cigarettes/cigpack_robustgold,
	/obj/item/storage/fancy/cigarettes/cigpack_xeno,
	/obj/item/storage/fancy/cigarettes/dromedaryco,
	/obj/item/storage/fancy/cigarettes/cigars,
	/obj/item/storage/fancy/cigarettes/cigars/cohiba,
	/obj/item/storage/fancy/cigarettes/cigars/havana,
)))

/datum/preference/choiced/junkie/init_possible_values()
	return list("Random") + assoc_to_keys(GLOB.darkpack_junkie_addictions)

/datum/preference/choiced/smoker/init_possible_values()
	return list("Random") + assoc_to_keys(GLOB.darkpack_smoker_addictions)

/datum/quirk/darkpack/item_quirk/addict
	name = "Addict"
	desc = "You are addicted to something that doesn't exist. Suffer."
	abstract_type = /datum/quirk/darkpack/item_quirk/addict
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES
	no_process_traits = list(TRAIT_LIVERLESS_METABOLISM)
	forbidden_splats = list(SPLAT_KINDRED)
	/// Preference the player picks their addiction with, read from the list in get_addiction_options()
	var/datum/preference/choiced/addiction_preference
	/// The reagent we're addicted to
	var/datum/reagent/reagent_type
	/// Instanced version of reagent_type, used to read its addiction types
	var/datum/reagent/reagent_instance
	/// The item holding our fix, given on spawn
	var/obj/item/drug_container_type
	/// Extra item given on spawn, if any
	var/obj/item/accessory_type
	var/drug_flavour_text = "Better hope you don't run out..."
	var/process_interval = 30 SECONDS //! how frequently the quirk processes
	COOLDOWN_DECLARE(next_process) //! ticker for processing

/datum/quirk/darkpack/item_quirk/addict/add_to_holder(mob/living/new_holder, quirk_transfer = FALSE, client/client_source, unique = TRUE, announce = TRUE)
	if(!quirk_transfer)
		var/list/options = get_addiction_options()
		var/choice = client_source?.prefs.read_preference(addiction_preference)
		if(!(choice in options))
			choice = pick(options)
		set_addiction(options[choice])
	return ..()

/datum/quirk/darkpack/item_quirk/addict/proc/get_addiction_options()
	return

/datum/quirk/darkpack/item_quirk/addict/proc/set_addiction(addiction)
	return

/datum/quirk/darkpack/item_quirk/addict/add(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	reagent_instance = new reagent_type()
	for(var/addiction in reagent_instance.addiction_types)
		human_holder.last_mind?.add_addiction_points(addiction, 1000)

/datum/quirk/darkpack/item_quirk/addict/add_unique(client/client_source)
	var/list/slots = list(
		LOCATION_LPOCKET,
		LOCATION_RPOCKET,
		LOCATION_BACKPACK,
		LOCATION_HANDS,
	)
	give_item_to_holder(drug_container_type, slots, flavour_text = drug_flavour_text, notify_player = TRUE)
	if(accessory_type)
		give_item_to_holder(accessory_type, slots)

/datum/quirk/darkpack/item_quirk/addict/process(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, next_process))
		return
	COOLDOWN_START(src, next_process, process_interval)
	var/mob/living/carbon/human/human_holder = quirk_holder
	var/deleted = QDELETED(reagent_instance)
	if(deleted)
		reagent_instance = new reagent_type()
	var/missing_addiction = FALSE
	for(var/addiction_type in reagent_instance.addiction_types)
		if(!LAZYACCESS(human_holder.last_mind?.active_addictions, addiction_type))
			missing_addiction = TRUE
	if(deleted || missing_addiction)
		to_chat(quirk_holder, span_danger("You thought you kicked it, but you feel like you're falling back onto bad habits.."))
		for(var/addiction in reagent_instance.addiction_types)
			human_holder.last_mind?.add_addiction_points(addiction, 1000) ///Max that shit out

/datum/quirk/darkpack/item_quirk/addict/remove()
	if(!QDELETED(quirk_holder) && reagent_instance)
		for(var/addiction_type in GLOB.addictions)
			quirk_holder.mind.remove_addiction_points(addiction_type, MAX_ADDICTION_POINTS)

/datum/quirk/darkpack/item_quirk/addict/junkie
	name = "Junkie"
	desc = "You can't get enough of hard drugs."
	icon = FA_ICON_PILLS
	value = -2
	gain_text = span_danger("You suddenly feel the craving for drugs.")
	medical_record_text = "Patient has a history of hard drugs."
	addiction_preference = /datum/preference/choiced/junkie

/datum/quirk_constant_data/darkpack_junkie
	associated_typepath = /datum/quirk/darkpack/item_quirk/addict/junkie
	customization_options = list(/datum/preference/choiced/junkie)

/datum/quirk/darkpack/item_quirk/addict/junkie/get_addiction_options()
	return GLOB.darkpack_junkie_addictions

/datum/quirk/darkpack/item_quirk/addict/junkie/set_addiction(list/addiction)
	drug_container_type = addiction["item"]
	reagent_type = addiction["reagent"]

/datum/quirk/darkpack/item_quirk/addict/smoker
	name = "Smoker"
	desc = "Sometimes you just really want a smoke. Probably not great for your lungs."
	icon = FA_ICON_SMOKING
	value = -1
	gain_text = span_danger("You could really go for a smoke right about now.")
	lose_text = span_notice("You don't feel nearly as hooked to nicotine anymore.")
	medical_record_text = "Patient is a current smoker."
	addiction_preference = /datum/preference/choiced/smoker
	reagent_type = /datum/reagent/drug/nicotine
	accessory_type = /obj/item/lighter/greyscale
	mob_trait = TRAIT_SMOKER
	drug_flavour_text = "Make sure you get your favorite brand when you run out."

/datum/quirk_constant_data/darkpack_smoker
	associated_typepath = /datum/quirk/darkpack/item_quirk/addict/smoker
	customization_options = list(/datum/preference/choiced/smoker)

/datum/quirk/darkpack/item_quirk/addict/smoker/get_addiction_options()
	return GLOB.darkpack_smoker_addictions

/datum/quirk/darkpack/item_quirk/addict/smoker/set_addiction(obj/item/storage/fancy/cigarettes/brand)
	drug_container_type = brand

/datum/quirk/darkpack/item_quirk/addict/smoker/post_add()
	. = ..()
	quirk_holder.add_mob_memory(/datum/memory/key/quirk_smoker, protagonist = quirk_holder, preferred_brand = initial(drug_container_type.name))

/datum/quirk/darkpack/item_quirk/addict/alcoholic
	name = "Alcoholic"
	desc = "You just can't live without alcohol. Your liver is a machine that turns ethanol into acetaldehyde."
	icon = FA_ICON_WINE_GLASS
	value = -1
	gain_text = span_danger("You really need a drink.")
	lose_text = span_notice("Alcohol doesn't seem nearly as enticing anymore.")
	medical_record_text = "Patient is an alcoholic."
	addiction_preference = /datum/preference/choiced/alcoholic
	reagent_type = /datum/reagent/consumable/ethanol
	mob_trait = TRAIT_HEAVY_DRINKER
	drug_flavour_text = "Make sure you get your favorite type of drink when you run out."

/datum/quirk_constant_data/darkpack_alcoholic
	associated_typepath = /datum/quirk/darkpack/item_quirk/addict/alcoholic
	customization_options = list(/datum/preference/choiced/alcoholic)

/datum/quirk/darkpack/item_quirk/addict/alcoholic/get_addiction_options()
	return GLOB.possible_alcoholic_addictions

/datum/quirk/darkpack/item_quirk/addict/alcoholic/set_addiction(list/addiction)
	drug_container_type = addiction["bottlepath"]

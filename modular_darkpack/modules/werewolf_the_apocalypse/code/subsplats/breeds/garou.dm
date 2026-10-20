/datum/subsplat/werewolf/breed_form/garou
	abstract_type = /datum/subsplat/werewolf/breed_form/garou
	fera_restriction = SPLAT_GAROU


/datum/subsplat/werewolf/breed_form/garou/homid
	name = BREED_GAROU_HOMID
	gifts_provided = list(
		/datum/action/cooldown/power/gift/apecrafts_blessings,
		/datum/action/cooldown/power/gift/city_running,
		/datum/action/cooldown/power/gift/master_of_fire,
	)
	start_gnosis = 1
	breed_species = /datum/species/human/shifter/homid


/datum/subsplat/werewolf/breed_form/garou/crinos
	name = BREED_CRINOS
	gifts_provided = list(
		/datum/action/cooldown/power/gift/primal_anger,
		// /datum/action/cooldown/power/gift/sense_wyrm, // DARKPACK TODO - (Selectable Gifts)
		/datum/action/cooldown/power/gift/shed,
	)
	start_gnosis = 3
	breed_species = /datum/species/human/shifter/war

/datum/subsplat/werewolf/breed_form/garou/crinos/generation_pref_icon(datum/universal_icon/main_icon)
	var/datum/universal_icon/breed_lupus = uni_icon('modular_darkpack/modules/werewolf_the_apocalypse/icons/garou_forms/crinos.dmi', "black")
	breed_lupus.scale(32, 32)
	main_icon.blend_icon(breed_lupus, ICON_OVERLAY)


/datum/subsplat/werewolf/breed_form/garou/lupus
	name = BREED_LUPUS
	gifts_provided = list(
		/datum/action/cooldown/power/gift/hares_leap,
		/datum/action/cooldown/power/gift/heightened_senses,
		/datum/action/cooldown/power/gift/predators_arsenal,
	)
	start_gnosis = 5
	breed_species = /datum/species/human/shifter/feral

/datum/subsplat/werewolf/breed_form/garou/lupus/generation_pref_icon(datum/universal_icon/main_icon)
	var/datum/universal_icon/breed_crinos = uni_icon('modular_darkpack/modules/werewolf_the_apocalypse/icons/garou_forms/lupus.dmi', "black")
	breed_crinos.scale(32, 32)
	main_icon.blend_icon(breed_crinos, ICON_OVERLAY)

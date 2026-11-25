/datum/subsplat/werewolf/breed_form/corax
	abstract_type = /datum/subsplat/werewolf/breed_form/corax
	fera_restriction = SPLAT_CORAX

/datum/subsplat/werewolf/breed_form/corax/homid
	name = BREED_CORAX_HOMID
	start_gnosis = 6
	breed_species = /datum/species/human/shifter/homid
	gifts_provided = list(
		/datum/action/cooldown/power/gift/enemy_ways,
		/datum/action/cooldown/power/gift/open_seal,
		/datum/action/cooldown/power/gift/spirit_speech,
		/datum/action/cooldown/power/gift/truth_of_gaia, // ACTUALLY A CORVID starting gift so this is inaccurate. Remove if you fix/add gifts.
	)

/datum/subsplat/werewolf/breed_form/corax/corvid
	name = BREED_CORVID
	start_gnosis = 6
	breed_species = /datum/species/human/shifter/feral
	gifts_provided = list(
		/datum/action/cooldown/power/gift/enemy_ways,
		/datum/action/cooldown/power/gift/scent_of_the_true_form,
		/datum/action/cooldown/power/gift/spirit_speech,
		/datum/action/cooldown/power/gift/truth_of_gaia,
	)

/datum/subsplat/werewolf/breed_form/corax/corvid/generation_pref_icon(datum/universal_icon/main_icon)
	var/datum/universal_icon/breed_crinos = uni_icon('modular_darkpack/modules/werewolf_the_apocalypse/icons/corax_forms/corvid.dmi', "black")
	breed_crinos.scale(32, 32)
	main_icon.blend_icon(breed_crinos, ICON_OVERLAY)

/datum/preference/numeric/renown
	abstract_type = /datum/preference/numeric/renown
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	priority = PREFERENCE_PRIORITY_REQUIRES_SUBSPLAT
	relevant_inherent_trait = TRAIT_FERA_RENOWN
	must_have_relevant_trait = TRUE
	savefile_identifier = PREFERENCE_CHARACTER

	minimum = 1
	maximum = 10

/datum/preference/numeric/renown/create_default_value()
	return 1

/datum/preference/numeric/renown/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/datum/splat/werewolf/splat = get_werewolf_splat(target)
	if(!splat)
		return

	splat.renown[savefile_key] = value
	splat.renown_rank = splat.auspice_rank_check() // This only works because auspice loads before renown.

/datum/preference/numeric/renown/honor
	savefile_key = RENOWN_HONOR

/datum/preference/numeric/renown/glory
	savefile_key = RENOWN_GLORY

/datum/preference/numeric/renown/wisdom
	savefile_key = RENOWN_WISDOM

/* Not acctually used ANYWHERE rn. Its super easy to just calculate it from our renown anyway.
/datum/preference/numeric/fera_rank
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED // DARKPACK TODO - Render this somewhere
	priority = PREFERENCE_PRIORITY_REQUIRES_SUBSPLAT
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "fera_rank"

	minimum = 0
	maximum = 5

/datum/preference/numeric/fera_rank/create_default_value()
	return 0

/datum/preference/numeric/fera_rank/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	var/datum/splat/werewolf/splat = get_werewolf_splat(target)
	if(!splat)
		return

	splat.renown_rank = value
*/

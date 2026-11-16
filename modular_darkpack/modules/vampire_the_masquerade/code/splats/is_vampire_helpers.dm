/**
 * If the character is any kind of vampiric creature, named after the game line
 */
/proc/get_vampire_splat(mob/character)
	RETURN_TYPE(/datum/splat/vampire)

	return character.get_splat(/datum/splat/vampire)

/**
 * If the character has Vitae, readable wrapper for get_vampire_splat() for checking Vitae
 */
/proc/get_splat_with_vitae(mob/character)
	RETURN_TYPE(/datum/splat/vampire)

	return get_vampire_splat(character)

/**
 * If the character can learn and use Disciplines, readable wrapper for get_vampire_splat() for Discipline uses
 */
/proc/get_splat_with_discipline(mob/character)
	RETURN_TYPE(/datum/splat/vampire)

	return get_vampire_splat(character)

/proc/get_kindred_splat(mob/character)
	RETURN_TYPE(/datum/splat/vampire/kindred)

	return character.get_splat(/datum/splat/vampire/kindred)

/proc/get_ghoul_splat(mob/character)
	RETURN_TYPE(/datum/splat/vampire/ghoul)

	return character.get_splat(/datum/splat/vampire/ghoul)

/proc/get_morality_path(mob/character)
	RETURN_TYPE(/datum/morality)
	var/mob/living/living_character = astype(character)


	if(!living_character) // no storyteller stats on anything thats not mob/living, check prefs
		var/datum/st_stat/morality_path/morality/morality_stat_datum = character.client?.prefs.preference_storyteller_stats[STAT_MORALITY]
		var/datum/morality/morality_path = morality_stat_datum.morality_path
		if(!morality_path)
			return null
		return morality_path


	if(!get_vampire_splat(living_character))
		return
	var/datum/st_stat/morality_path/morality/morality_stat_datum = living_character.storyteller_stats[STAT_MORALITY]
	var/datum/morality/morality_path = morality_stat_datum.morality_path
	if(!morality_path)
		return null

	return morality_path

/datum/splat/vampire/ghoul
	name = "Ghoul"
	ru_name = "Гуль"
	desc = "Смертные, которых питает и держит на привязи сверхъестественная кровь Сородичей. \
		Гули слабее настоящих Сородичей, зато сохраняют человеческую природу \
		и не страдают от вампирских слабостей, а потому служат своим домиторам \
		идеальными слугами."
	id = SPLAT_GHOUL

	splat_priority = SPLAT_PRIO_GHOUL
	half_splat = TRUE

	splat_traits = list(
		TRAIT_VTM_CLANS,
	)

	splat_actions = list(
		/datum/action/cooldown/blood_power,
	)

	/// The Kindred this ghoul is blood bonded to
	var/datum/weakref/domitor // CORVAX EDIT CHANGE - a hard reference hard deleted the domitor. ORIGINAL: var/mob/living/domitor

/datum/splat/vampire/ghoul/New(mob/living/domitor)
	src.domitor = WEAKREF(domitor) // CORVAX EDIT CHANGE - ORIGINAL: src.domitor = domitor

/datum/splat/vampire/ghoul/on_gain()
	owner.give_st_power(/datum/discipline/bloodheal, 1)
	owner.give_st_power(/datum/discipline/potence, 1)

	// the below only runs if they have just been ghouled and domitor isnt null
	// ghouls who join from the menu have their discs handled by the disc pref middleware
	var/mob/living/domitor_mob = domitor?.resolve() // CORVAX EDIT ADD
	var/list/clan_disciplines = domitor_mob?.get_clan()?.clan_disciplines // CORVAX EDIT CHANGE - ORIGINAL: var/list/clan_disciplines = domitor?.get_clan()?.clan_disciplines
	if(length(clan_disciplines))
		for(var/i in 1 to 3)
			var/discipline = clan_disciplines[i]
			if(!discipline)
				continue
			owner.give_st_power(discipline, 1)

/datum/splat/vampire/ghoul/on_lose_or_destroy()
	owner.remove_st_power(/datum/discipline/bloodheal)
	owner.remove_st_power(/datum/discipline/potence)

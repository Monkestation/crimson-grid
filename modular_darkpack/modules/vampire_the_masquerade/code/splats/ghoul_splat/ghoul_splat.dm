/datum/splat/vampire/ghoul
	name = "Ghoul"
	desc = "Mortals empowered by and addicted to the supernatural blood of \
			Kindred. While not as powerful as true Kindred, they retain their \
			humanity and suffer none of the weaknesses of the Kindred, making \
			them ideal servants to their domitors."
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
	var/mob/living/domitor

/datum/splat/vampire/ghoul/New(mob/living/domitor)
	src.domitor = domitor

/datum/splat/vampire/ghoul/on_gain()
	owner.give_st_power(/datum/discipline/bloodheal, 1)

	// the below only runs if they have just been ghouled and domitor isnt null
	// ghouls who join from the menu have their discs handled by the disc pref middleware
	var/list/clan_disciplines = domitor?.get_clan()?.clan_disciplines
	if(length(clan_disciplines))
		for(var/i in 1 to 3)
			var/discipline = clan_disciplines[i]
			if(!discipline)
				continue
			owner.give_st_power(discipline, 1)
			if(ispath(discipline, /datum/discipline/dementation))
				owner.add_quirk(/datum/quirk/darkpack/derangement)

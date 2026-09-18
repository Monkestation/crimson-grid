/datum/quirk/csl/language_barrier
	name = "Language Barrier"
	desc = {"Your character cannot speak English.
In order to communicate with locals, your character must
find a translator or rely on written word."}
	value = -2
	darkpack_allowed = TRUE
	ttrpg_sources = list(/datum/source_book/htr3/pg = 121)

/datum/quirk/csl/language_barrier/add(client/client_source) //Ugly copypasta to avoid being assigned Uncommon
	quirk_holder.remove_language(/datum/language/common, UNDERSTOOD_LANGUAGE, LANGUAGE_SPECIES)
	quirk_holder.remove_language(/datum/language/common, UNDERSTOOD_LANGUAGE, LANGUAGE_ATOM)

	quirk_holder.grant_partial_language(/datum/language/common, 50, type)

/datum/quirk/csl/language_barrier/remove()
	UnregisterSignal(quirk_holder, COMSIG_SPECIES_GAIN)
	UnregisterSignal(quirk_holder, COMSIG_MOB_SAY)

	if(QDELING(quirk_holder))
		return

	quirk_holder.remove_partial_language(/datum/language/common, type)
	var/mob/living/carbon/carbon_quirk_holder = quirk_holder
	if(istype(carbon_quirk_holder) && carbon_quirk_holder.dna.species)
		// only give back common if they're a species that should speak it
		var/datum/language_holder/species_holder = GLOB.prototype_language_holders[carbon_quirk_holder.dna.species.species_language_holder]
		if(LAZYACCESS(species_holder.spoken_languages, /datum/language/common))
			quirk_holder.grant_language(/datum/language/common, UNDERSTOOD_LANGUAGE, LANGUAGE_SPECIES)
	else
		quirk_holder.grant_language(/datum/language/common, UNDERSTOOD_LANGUAGE, LANGUAGE_ATOM)

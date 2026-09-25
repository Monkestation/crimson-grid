/datum/quirk/darkpack/pain_tolerance
	name = "Pain Tolerance"
	desc = "Maybe you are a badass or shut off your nerves through Vicissitude. Maybe your sire put you through so many intricate hells that it would be tough for anyone else to compete. Maybe it just turns you on. Regardless, pains from injuries do not slow you down."
	ttrpg_sources = list(/datum/source_book/vtm20/lotc = 238)
	value = 2
	gain_text = span_notice("You feel like you could tolerate more pain")
	lose_text = span_notice("You feel like your tolerance for pain is back to average")
	icon = FA_ICON_SKULL
	allowed_splats = list(SPLAT_KINDRED, SPLAT_GHOUL)
	included_clans = list(VAMPIRE_CLAN_TZIMISCE)
	failure_message = "You feel like your tolerance for pain is back to average"

/datum/quirk/darkpack/pain_tolerance/add(client/client_source)
	quirk_holder.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	quirk_holder.add_traits(list(TRAIT_ANALGESIA, TRAIT_NO_DAMAGE_OVERLAY), QUIRK_TRAIT)

/datum/quirk/darkpack/pain_tolerance/remove(client/client_source)
	quirk_holder.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	quirk_holder.remove_traits(list(TRAIT_ANALGESIA, TRAIT_NO_DAMAGE_OVERLAY), QUIRK_TRAIT)

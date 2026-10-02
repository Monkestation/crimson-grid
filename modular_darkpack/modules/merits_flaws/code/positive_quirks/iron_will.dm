/datum/quirk/darkpack/iron_will
	name = "Iron Will"
	desc = "When you are determined and your mind is set, nothing can thwart you from your goals. Dementation, Dominate, and any mind altering discipline is at +3 difficulty against you, Presence doesn't fall under this." // TODO: no check exists for characters under 8 wp
	ttrpg_sources = list(/datum/source_book/vtm20 = 485)
	value = 3
	mob_trait = TRAIT_IRON_WILL
	gain_text = span_notice("Your will is iron.")
	lose_text = span_notice("Your will isn't iron anymore.")
	icon = FA_ICON_USER_SHIELD
	failure_message = "Your will isn't iron anymore."
	allowed_splats = list(SPLAT_KINDRED)

/datum/quirk/darkpack/iron_will/human
	name = "Iron Will (Non-Vampire)"
	ttrpg_sources = list(/datum/source_book/huntershunted1 = 60) // Hunters Hunted 1st edition
	value = 4
	allowed_splats = null
	forbidden_splats = list(SPLAT_KINDRED)

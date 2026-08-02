/datum/quirk/darkpack/calm_heart
	name = "Calm Heart"
	desc = {"You are naturally calm and do not easily fly off the
handle. You receive two extra dice when attempting to
resist a frenzy. Brujah may not take this Merit."}
	ttrpg_sources = list(/datum/source_book/vtm20 = 485)
	value = 3
	mob_trait = TRAIT_CALM_HEART
	icon = FA_ICON_HEART
	allowed_splats = list(SPLAT_KINDRED)
	excluded_clans = list(VAMPIRE_CLAN_BRUJAH)

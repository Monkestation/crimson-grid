/datum/quirk/darkpack/unbondable
	name = "Unbondable"
	desc = "You are immune to being blood bound. Tremere cannot take this Merit."
	ttrpg_sources = list(/datum/source_book/vtm20 = 494)
	value = 5
	mob_trait = TRAIT_UNBONDABLE
	icon = FA_ICON_CHAIN_BROKEN
	allowed_splats = list(SPLAT_KINDRED)
	excluded_clans = list(VAMPIRE_CLAN_TREMERE)


/datum/quirk/darkpack/unbondable/ghoul
	name = "Unbondable (Ghoul)"
	desc = "You are immune to being blood bound.."
	value = 6
	allowed_splats = list(SPLAT_GHOUL)

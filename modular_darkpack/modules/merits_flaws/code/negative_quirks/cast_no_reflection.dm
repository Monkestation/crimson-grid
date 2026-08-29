/datum/quirk/darkpack/cast_no_reflection
	name = "Cast No Reflection"
	desc = "You actually cast no reflection, just like the vampires of legend. This can have a detrimental effect when trying to pass as a human."
	ttrpg_sources = list(
		/datum/source_book/vtm20 = 494,
		/datum/source_book/mta20/bos = 82,
		)
	value = -1
	mob_trait = TRAIT_NO_MIRROR_REFLECTION
	icon = FA_ICON_PERSON_THROUGH_WINDOW
	allowed_splats = list(SPLAT_KINDRED)
	excluded_clans = list(VAMPIRE_CLAN_LASOMBRA)

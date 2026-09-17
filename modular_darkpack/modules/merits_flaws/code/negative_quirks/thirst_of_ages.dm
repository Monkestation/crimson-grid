/datum/quirk/darkpack/thirst_of_ages
	name = "Methuselah's Thirst"
	desc = "Some particularly old vampires find themselves unable to subsist off of mortal blood. You are only capable of feeding off of supernaturals."
	ttrpg_sources = list(/datum/source_book/gt_tmr = 177)
	value = -7
	mob_trait = TRAIT_THIRST_OF_AGES
	allowed_splats = list(SPLAT_KINDRED)
	excluded_clans = list(VAMPIRE_CLAN_NAGARAJA)	//Eating organs for vitae would bypass this downside.
	icon = FA_ICON_TEETH
	quirk_flags = QUIRK_HIDE_FROM_SCAN //CRIMSON GRID EDIT ADD | PR: MAKE MEDICAL RECORDS NOT MASQ BREACHY | CHANGE: ADDED THIS TO PREVENT IT FROM BEING SEEN IN COMS


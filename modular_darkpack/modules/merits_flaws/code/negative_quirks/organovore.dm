/datum/quirk/darkpack/organovore
	name = "Organovore"
	desc = "You can only regain bloodpoints by consuming human flesh. Nagaraja cannot take this trait, as they are already organovores."
	value = -5
	mob_trait = TRAIT_ORGANOVORE
	gain_text = span_notice("You feel an insatiable taste for flesh.")
	lose_text = span_notice("You feel that you can once again feed normally.")
	allowed_splats = list(SPLAT_KINDRED)
	excluded_clans = list(VAMPIRE_CLAN_NAGARAJA)
	icon = FA_ICON_TEETH
	failure_message = "You feel that you can once again feed normally."

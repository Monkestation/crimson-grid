/datum/quirk/darkpack/anthropic_taste
	name = "Anthropic Taste"
	ru_name = "Вкус к людской крови"
	desc = "Вы не можете пить кровь низших существ: кошек, оленей или шляхты."
	value = -2
	mob_trait = TRAIT_ANTHROPIC_TASTE
	gain_text = span_notice("Кровь низших существ становится для вас невыносимой.")
	lose_text = span_notice("Кажется, вы снова могли бы питаться кровью низших существ.")
	allowed_splats = list(SPLAT_KINDRED)
	icon = FA_ICON_CAT
	failure_message = "Вы чувствуете, что снова можете питаться кровью низших существ."
	quirk_flags = QUIRK_HIDE_FROM_SCAN //CRIMSON GRID EDIT ADD | PR: MAKE MEDICAL RECORDS NOT MASQ BREACHY | CHANGE: ADDED THIS TO PREVENT IT FROM BEING SEEN IN COMS

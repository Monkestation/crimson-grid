/datum/quirk/darkpack/anthropic_taste
	name = "Anthropic Taste"
	desc = "You cannot drink the blood of simple creatures, such as cats, deer, or szlachta."
	value = -2
	mob_trait = TRAIT_ANTHROPIC_TASTE
	gain_text = span_notice("You find the blood of simple creatures unbearable.")
	lose_text = span_notice("You think you could feed off of simple creatures again.")
	allowed_splats = list(SPLAT_KINDRED)
	icon = FA_ICON_CAT
	failure_message = "You feel that you can once again feed off simple creatures."

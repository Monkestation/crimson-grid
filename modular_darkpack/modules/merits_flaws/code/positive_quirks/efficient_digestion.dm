/datum/quirk/darkpack/efficient_digestion
	name = "Efficient Digestion"
	desc = "You are able to draw more than the usual amount of nourishment from blood. When feeding, you gain an additional point to your blood pool for every two points of blood you consume."
	value = 3
	mob_trait = TRAIT_EFFICIENT_DIGESTION
	gain_text = span_notice("You feel as if you'll be satiated with ease.")
	lose_text = span_notice("You feel empty, as though it'll take more to fill the void...")
	allowed_splats = list(SPLAT_KINDRED)
	icon = FA_ICON_FILL_DRIP
	failure_message = "You feel empty, as though it'll take more to fill the void..."

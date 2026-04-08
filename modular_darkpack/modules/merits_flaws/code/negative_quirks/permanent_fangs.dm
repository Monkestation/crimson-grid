// V20 p. 482
/datum/quirk/darkpack/permafangs
	name = "Permanent Fangs"
	desc = "Your fangs do not retract, making it impossible for you to hide your true nature. While some mortals may think you've had your teeth filed or are wearing prosthetics, sooner or later you're going to run into someone who knows what you truly are."
	// TTRPG accurate would be -3? But this is also missing the max Appearance lock..
	value = -1
	mob_trait = TRAIT_PERMAFANGS
	gain_text = span_notice("Your fangs become stuck.")
	lose_text = span_notice("You feel your fangs retract again.")
	allowed_splats = list(SPLAT_KINDRED)
	icon = FA_ICON_TEETH
	failure_message = "You feel your fangs retract."

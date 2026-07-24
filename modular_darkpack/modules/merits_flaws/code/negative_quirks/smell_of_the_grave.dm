// V20 p. 481
/datum/quirk/darkpack/smell_of_the_grave
	name = "Smell Of The Grave"
	desc = {"You exude an odor of dampness and newly turned earth, which no amount of scents or perfumes will cover.
Mortals in your immediate presence become uncomfortable, so the difficulties of all Social rolls to affect mortals increase by one."}
	value = -1
	mob_trait = TRAIT_GRAVE_SMELL
	gain_text = span_notice("You smell awful.")
	lose_text = span_notice("You feel like you smell a lot better.")
	allowed_splats = list(SPLAT_KINDRED)
	icon = FA_ICON_SPRAY_CAN
	failure_message = span_notice("You feel like you smell a lot better.")

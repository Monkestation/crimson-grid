/datum/quirk/darkpack/banned_transformation
	name = "Banned Transformation"
	//For the sake of actually being able to implement, only the 3-point version from the book.
	desc = {"Some circumstance, event, or situation inhibits your
	ability to change forms, except to return to your breed
	form. To transform without spending a rage point requires the
	expenditure of a Willpower point and a successful
	Willpower roll (difficulty 8)."}
	ttrpg_sources = list(/datum/source_book/wta20 = 483)
	value = -3
	mob_trait = TRAIT_BANNED_TRANSFORMATION
	icon = FA_ICON_PERSON
	allowed_splats = SPLAT_SHIFTERS

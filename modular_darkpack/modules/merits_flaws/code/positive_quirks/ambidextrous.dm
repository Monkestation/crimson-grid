/datum/quirk/darkpack/ambidextrous
	name = "Ambidextrous"
	desc = {"You have a high degree of off-hand dexterity and can perform tasks with the "wrong" hand at no penalty. Penalties from dual wielding firearms are negated."}
	ttrpg_sources = list(/datum/source_book/vtm20 = 480)
	value = 1
	mob_trait = TRAIT_AMBIDEXTROUS
	gain_text = span_notice("Both of your hands feel capable.")
	lose_text = span_notice("Your off hand dosen't have the same precise control as your main hand anymore")
	icon = FA_ICON_HANDS
	failure_message = "Your off hand dosen't have the same precise control as your main hand anymore"

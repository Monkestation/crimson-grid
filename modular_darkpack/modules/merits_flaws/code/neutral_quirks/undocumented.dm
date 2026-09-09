
/datum/quirk/darkpack/undocumented
	name = "Undocumented"
	desc = "For one reason or another, you just don't have valid identification! The cops might take issue with this."
	ttrpg_sources = list(/datum/source_book/homebrew = WE_MADE_IT_UP)
	value = 0
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_HIDE_FROM_SCAN
	icon = FA_ICON_FILE_CIRCLE_QUESTION
	mob_trait = TRAIT_UNDOCUMENTED
	gain_text = span_warning("You feel poorly documented.")
	lose_text = span_notice("You feel well documented.")
	failure_message = "I can't believe I forgot to look for my ID there!"

/datum/quirk/darkpack/undocumented/add()
	. = ..()
	var/mob/living/carbon/human/undocumented = astype(quirk_holder)
	if(!undocumented)
		return

	for(var/item in undocumented.gather_belongings()) // prolly a faster way to do this
		if(istype(item, /obj/item/passport) || istype(item, /obj/item/card/drivers_license))
			qdel(item)

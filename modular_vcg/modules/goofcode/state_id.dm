/obj/item/card/drivers_license/state_issued_id
	name = "state issued identification"
	desc = "An identification card issued by the state to serve as a valid form of identification. <b>Does NOT qualify as a license to drive!</b>"
	icon = 'modular_vcg/modules/goofcode/icons/docs.dmi'
	icon_state = "state_id"
	slot_flags = NONE
	ONFLOOR_ICON_HELPER('modular_vcg/modules/goofcode/icons/docsonfloor.dmi')


/obj/item/card/drivers_license/international
	name = "international driver's license"
	desc = "An identification card issued by the state of California to serve as temporary driver's license during the holder's stay in the United States."

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
	medical_record_text = "Patient chronically misplaces critical documents."
	failure_message = "I can't believe I forgot to look for my ID there!"

/datum/quirk/darkpack/undocumented/add()
	. = ..()
	var/mob/living/carbon/human/undocumented = astype(quirk_holder)
	if(!undocumented)
		return

	for(var/item in undocumented.gather_belongings()) // prolly a faster way to do this
		if(istype(item, /obj/item/passport) || istype(item, /obj/item/card/drivers_license))
			qdel(item)

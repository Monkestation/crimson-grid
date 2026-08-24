/datum/quirk/darkpack/no_sense_of_taste
	name = "No Sense of Taste"
	desc = {"Your character's taste buds simply do not function.
You cannot appreciate a fine meal, and you have
trouble gauging the difference between good and bad
food and drink."}
	value = -1
	icon = FA_ICON_GRIN_TONGUE_SQUINT
	forbidden_splats = list(SPLAT_KINDRED)
	ttrpg_sources = list(/datum/source_book/htr3/pg = 118)

/datum/quirk/darkpack/no_sense_of_taste/add(client/client_source)
	var/obj/item/organ/tongue/tongue = quirk_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	tongue.sense_of_taste = FALSE

/datum/quirk/darkpack/no_sense_of_taste/remove()
	var/obj/item/organ/tongue/tongue = quirk_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	tongue.sense_of_taste = initial(tongue.sense_of_taste)

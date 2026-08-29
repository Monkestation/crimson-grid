/datum/quirk/darkpack/monochrome_vision
	name = "Monochrome Vision"
	desc = {"You cannot distinguish between colors, but see the world in varying shades of black and white and gray. This is not true color-blindness,
	which usually refers to the inability to distinguish between certain colors (such as red and green).  This Flaw occurs quite frequently among lupus Garou."}
	ttrpg_sources = list(/datum/source_book/wta20 = 473)
	icon = FA_ICON_ADJUST
	allowed_splats = list(SPLAT_GAROU)
	value = -1
	medical_record_text = "Patient is afflicted with almost complete color blindness."

/datum/quirk/darkpack/monochrome_vision/add(client/client_source)
	quirk_holder.add_client_colour(/datum/client_colour/monochrome, QUIRK_TRAIT)

/datum/quirk/darkpack/monochrome_vision/remove()
	quirk_holder.remove_client_colour(QUIRK_TRAIT)

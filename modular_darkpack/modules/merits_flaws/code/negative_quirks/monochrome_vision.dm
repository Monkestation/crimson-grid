/datum/quirk/darkpack/monochrome_vision
	name = "Monochrome Vision"
	desc = {"You cannot distinguish between colors, but see the world in varying shades of black and white and gray. This is not true color-blindness,
	which usually refers to the inability to distinguish between certain colors (such as red and green).  This Flaw occurs quite frequently among lupus Garou."}
	ttrpg_sources = list(/datum/source_book/wta20 = 473)
	icon = FA_ICON_ADJUST
	allowed_splats = list(SPLAT_GAROU)
	value = -1
	medical_record_text = "Patient is afflicted with almost complete color blindness."

//CRIMSON GRID ADDITION - adds a softer filter on the werewolves' eyes to reduce eye strain
/datum/client_colour/monochrome/werewolf
	// Wolves have dichromatic vision: reds and greens converge, while blues remain distinct.
	color = list(0.51,0.39,0,0, 0.50,0.40,0,0, 0,0.22,0.68,0, 0,0,0,1, 0,0,0,0)

/datum/quirk/darkpack/monochrome_vision/add(client/client_source)
	quirk_holder.add_client_colour(/datum/client_colour/monochrome/werewolf, QUIRK_TRAIT)
//CRIMSON GRID ADDITION END

/datum/quirk/darkpack/monochrome_vision/remove()
	quirk_holder.remove_client_colour(QUIRK_TRAIT)

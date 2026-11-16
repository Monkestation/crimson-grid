/datum/quirk/darkpack/wolf_sight
	name = "Wolf Sight"
	desc = {"In all your forms, you see colors and intensities of light as a wolf does.
		Your color vision is slightly less distinct than that of humans, though you embrace the full spectrum of colors.
		Your night vision, however, far surpasses human nocturnal vision."}
		// Perception is not real yet.
		// You also notice movement more readily. You gain an extra die to all visually-based Perception rolls that involve movement or take place at night."}
	ttrpg_sources = list(/datum/source_book/wta20 = 472)
	value = 1
	mob_trait = TRAIT_TRUE_NIGHT_VISION
	icon = FA_ICON_DOG
	allowed_splats = list(SPLAT_GAROU)

/datum/quirk/darkpack/wolf_sight/add(client/client_source)
	quirk_holder.add_client_colour(/datum/client_colour/wolf_sight, REF(src))
	quirk_holder.update_sight()

/datum/quirk/darkpack/wolf_sight/remove()
	quirk_holder.remove_client_colour(REF(src))
	quirk_holder.update_sight()

/datum/client_colour/wolf_sight
	color = "#e6e6e6"

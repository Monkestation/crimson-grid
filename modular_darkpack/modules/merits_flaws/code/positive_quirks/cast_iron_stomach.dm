/datum/quirk/darkpack/cast_iron_stomach
	name = "Cast-Iron Stomach"
	desc = {"You can eat anything remotely similar to food and
			gain nourishment from it. Carrion, straw, bones; it's all dinner.
			As for the smell, well, you get used to it... "}
	value = 1
	icon = FA_ICON_FACE_GRIN_BEAM_SWEAT
	gain_text = span_notice("You feel like you could eat anything!")
	lose_text = span_danger("Looking at food on the ground makes you feel a little queasy.")
	forbidden_splats = list(SPLAT_KINDRED)
	ttrpg_sources = list(/datum/source_book/mta20/bos = 36)

/datum/quirk/darkpack/cast_iron_stomach/add(client/client_source)
	var/obj/item/organ/tongue/tongue = quirk_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	tongue.disliked_foodtypes = CLOTH

/datum/quirk/darkpack/cast_iron_stomach/remove()
	var/obj/item/organ/tongue/tongue = quirk_holder.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	tongue.disliked_foodtypes = initial(tongue.disliked_foodtypes)

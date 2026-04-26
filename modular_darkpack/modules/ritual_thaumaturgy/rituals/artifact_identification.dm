/obj/ritual_rune/thaumaturgy/identification
	name = "occult artifact identification"
	desc = "Identifies a single occult item."
	icon_state = "rune4"
	word = "IN'DAR"

/obj/ritual_rune/thaumaturgy/identification/complete()
	. = ..()
	for(var/obj/item/vtm_artifact/VA in loc)
		var/mob/living/carbon/human/identifier = usr
		if(VA.identified)
			to_chat(identifier, span_warning("You have already identified this artifact."))
			return
		VA.identify()
		identifier.research_points += VA.research_value
		qdel(src)
		return


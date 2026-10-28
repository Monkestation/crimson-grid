/obj/item/organ/eyes/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 25, "organ", TRUE, -1, 0) // CRIMSON EDIT CHANGE - Original: AddComponent(/datum/component/selling/organ, 100, "organ", TRUE, -1, 0)

/obj/item/organ/heart/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 100, "organ", TRUE, -1, 0) // CRIMSON EDIT CHANGE - Original: AddComponent(/datum/component/selling/organ, 400, "organ", TRUE, -1, 0)

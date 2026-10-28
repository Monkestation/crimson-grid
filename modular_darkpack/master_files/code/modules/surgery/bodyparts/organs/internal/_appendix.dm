/obj/item/organ/appendix/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 13, "organ", TRUE, -1, 0) // CRIMSON EDIT CHANGE - Original: AddComponent(/datum/component/selling/organ, 50, "organ", TRUE, -1, 0)

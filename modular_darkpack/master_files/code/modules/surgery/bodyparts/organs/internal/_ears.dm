/obj/item/organ/ears/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 100, "organ", TRUE, -1, 0)

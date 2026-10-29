/obj/item/organ/heart/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 400, "organ", TRUE, -1, 0)

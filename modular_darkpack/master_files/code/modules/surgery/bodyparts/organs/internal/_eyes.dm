/obj/item/organ/eyes/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 100, "organ", TRUE, -1, 0)

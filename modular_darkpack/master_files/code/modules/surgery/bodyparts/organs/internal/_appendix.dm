/obj/item/organ/appendix/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 50, "organ", TRUE, -1, 0)

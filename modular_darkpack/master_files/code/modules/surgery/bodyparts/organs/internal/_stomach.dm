/obj/item/organ/stomach/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 200, "organ", TRUE, -1, 0)

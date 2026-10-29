/obj/item/organ/lungs/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 250, "organ", TRUE, -1, 0)

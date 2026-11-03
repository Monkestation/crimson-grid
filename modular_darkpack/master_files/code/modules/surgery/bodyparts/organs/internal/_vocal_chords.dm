/obj/item/organ/vocal_cords/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 200, "organ", TRUE, -1, 0)

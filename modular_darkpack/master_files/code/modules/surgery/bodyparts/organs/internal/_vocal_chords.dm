/obj/item/organ/vocal_cords/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 50, "organ", TRUE, -1, 0) // CRIMSON EDIT CHANGE - Original: AddComponent(/datum/component/selling/organ, 200, "organ", TRUE, -1, 0)

/obj/item/organ/eyes/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 10, "organ", TRUE, -1, 0)
//CRIMSON GRID EDIT dropped the selling price by one digit

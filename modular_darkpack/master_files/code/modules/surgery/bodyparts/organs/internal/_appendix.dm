/obj/item/organ/appendix/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 5, "organ", TRUE, -1, 0)
//CRIMSON GRID EDIT dropped the selling price by one digit

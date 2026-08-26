/obj/item/organ/lungs/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 25, "organ", TRUE, -1, 0)
//CRIMSON GRID EDIT dropped the selling price by one digit

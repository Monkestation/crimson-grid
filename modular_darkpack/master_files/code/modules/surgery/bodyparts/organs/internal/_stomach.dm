/obj/item/organ/stomach/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 20, "organ", TRUE, -1, 0)
//CRIMSON GRID EDIT dropped the selling price by one digit

/obj/item/organ/heart/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 500, "organ", TRUE, -1, 0)
//CRIMSON GRID EDIT made it 500 instead of 400 to account for every other organs being nerfed

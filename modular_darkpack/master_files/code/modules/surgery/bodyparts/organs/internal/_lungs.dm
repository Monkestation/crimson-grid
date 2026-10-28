/obj/item/organ/lungs/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/selling/organ, 63, "organ", TRUE, -1, 0) // CRIMSON EDIT CHANGE - Original: AddComponent(/datum/component/selling/organ, 250, "organ", TRUE, -1, 0)

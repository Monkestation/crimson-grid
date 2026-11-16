/mob/living/carbon/human/npc/police_armory_guy
	staying = TRUE

/mob/living/carbon/human/npc/police_armory_guy/Initialize(mapload)
	. = ..()

	AssignSocialRole(/datum/socialrole/shop/police_armory_guy)

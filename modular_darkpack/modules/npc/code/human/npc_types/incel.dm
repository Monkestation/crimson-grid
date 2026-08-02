/mob/living/carbon/human/npc/incel
	staying = TRUE
	drug_price = 0.75

/mob/living/carbon/human/npc/incel/Initialize(mapload)
	. = ..()

	AssignSocialRole(/datum/socialrole/usualmale)

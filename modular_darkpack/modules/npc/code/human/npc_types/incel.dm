/mob/living/carbon/human/npc/incel
	staying = TRUE
	// CRIMSON EDIT ADDITION START - drug dealing
	drug_price = 0.75
	// CRIMSON EDIT ADDITION END - drug dealing

/mob/living/carbon/human/npc/incel/Initialize(mapload)
	. = ..()

	AssignSocialRole(/datum/socialrole/usualmale)

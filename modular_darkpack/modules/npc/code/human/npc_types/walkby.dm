/mob/living/carbon/human/npc/walkby
	// CRIMSON EDIT ADDITION START - drug dealing
	drug_price = 0.75
	// CRIMSON EDIT ADDITION END - drug dealing

/mob/living/carbon/human/npc/walkby/Initialize(mapload)
	. = ..()

	var/datum/socialrole/assign_role = pick(/datum/socialrole/usualmale, /datum/socialrole/usualfemale)
	AssignSocialRole(assign_role)

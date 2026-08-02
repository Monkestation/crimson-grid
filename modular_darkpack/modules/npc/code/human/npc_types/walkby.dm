/mob/living/carbon/human/npc/walkby
	drug_price = 0.75

/mob/living/carbon/human/npc/walkby/Initialize(mapload)
	. = ..()

	var/datum/socialrole/assign_role = pick(/datum/socialrole/usualmale, /datum/socialrole/usualfemale)
	AssignSocialRole(assign_role)

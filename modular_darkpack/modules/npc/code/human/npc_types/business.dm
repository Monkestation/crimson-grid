/mob/living/carbon/human/npc/business
	bloodquality = BLOOD_QUALITY_HIGH
	drug_price = 2 // the golden goose
	drug_purchase_limit = 4

/mob/living/carbon/human/npc/business/Initialize(mapload)
	. = ..()

	var/datum/socialrole/assign_role = pick(/datum/socialrole/richmale, /datum/socialrole/richfemale)
	AssignSocialRole(assign_role)

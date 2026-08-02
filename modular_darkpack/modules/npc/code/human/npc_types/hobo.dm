/mob/living/carbon/human/npc/hobo
	bloodquality = BLOOD_QUALITY_LOW
	old_movement = TRUE
	drug_price = 0.5
	drug_purchase_limit = 1

/mob/living/carbon/human/npc/hobo/Initialize(mapload)
	. = ..()

	var/datum/socialrole/assign_role = pick(/datum/socialrole/poormale, /datum/socialrole/poorfemale)
	AssignSocialRole(assign_role)

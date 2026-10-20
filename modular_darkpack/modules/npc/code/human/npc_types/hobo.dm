/mob/living/carbon/human/npc/hobo
	bloodquality = BLOOD_QUALITY_LOW
	old_movement = TRUE
	// CRIMSON EDIT ADDITION START - drug dealing
	drug_price = 0.5
	drug_purchase_limit = 1
	// CRIMSON EDIT ADDITION END - drug dealing

/mob/living/carbon/human/npc/hobo/Initialize(mapload)
	. = ..()

	var/datum/socialrole/assign_role = pick(/datum/socialrole/poormale, /datum/socialrole/poorfemale)
	AssignSocialRole(assign_role)

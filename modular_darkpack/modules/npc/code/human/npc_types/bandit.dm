/mob/living/carbon/human/npc/bandit
	my_backup_weapon_type = /obj/item/knife/vamp
	// CRIMSON EDIT ADDITION START - drug dealing
	drug_price = 0.5
	drug_purchase_limit = 2
	// CRIMSON EDIT ADDITION END - drug dealing

/mob/living/carbon/human/npc/bandit/Initialize(mapload)
	. = ..()

	AssignSocialRole(/datum/socialrole/bandit)

/mob/living/carbon/human/npc/bandit
	max_stat = HARD_CRIT
	my_backup_weapon_type = /obj/item/knife/vamp
	drug_price = 0.5
	drug_purchase_limit = 2

/mob/living/carbon/human/npc/bandit/Initialize(mapload)
	. = ..()

	AssignSocialRole(/datum/socialrole/bandit)

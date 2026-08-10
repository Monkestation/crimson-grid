/mob/living/carbon/human/npc/bandit
	max_stat = HARD_CRIT
	my_backup_weapon_type = /obj/item/knife/vamp

/mob/living/carbon/human/npc/bandit/Initialize(mapload)
	. = ..()

	AssignSocialRole(/datum/socialrole/bandit)

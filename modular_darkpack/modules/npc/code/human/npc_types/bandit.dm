/mob/living/carbon/human/npc/bandit
	my_backup_weapon_type = /obj/item/knife/vamp

/mob/living/carbon/human/npc/bandit/Initialize(mapload)
	. = ..()

	AssignSocialRole(/datum/socialrole/bandit)

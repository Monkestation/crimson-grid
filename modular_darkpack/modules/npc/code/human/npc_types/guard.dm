/mob/living/carbon/human/npc/guard
	staying = TRUE
	aggressive = TRUE
	max_stat = DEAD
	my_weapon_type = /obj/item/gun/ballistic/automatic/pistol/darkpack/m1911
	my_backup_weapon_type = /obj/item/melee/baton/vamp

/mob/living/carbon/human/npc/guard/Initialize(mapload)
	. = ..()

	AssignSocialRole(/datum/socialrole/guard)

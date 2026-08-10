/mob/living/carbon/human/npc/endronsecurity
	staying = TRUE
	max_stat = 4
	my_weapon_type = /obj/item/gun/ballistic/automatic/darkpack/mp5
	my_backup_weapon_type = /obj/item/melee/baton/vamp

/mob/living/carbon/human/npc/endronsecurity/Initialize(mapload)
	. = ..()
	AssignSocialRole(/datum/socialrole/endronsecurity)

/mob/living/carbon/human/npc/endronlabsecurity
	staying = TRUE

	max_stat = 4
	my_weapon_type = /obj/item/gun/ballistic/automatic/darkpack/mp5
	my_backup_weapon_type = /obj/item/melee/baton/vamp

/mob/living/carbon/human/npc/endronlabsecurity/Initialize(mapload)
	. = ..()
	AssignSocialRole(/datum/socialrole/endronlabsecurity)

/mob/living/carbon/human/npc/endronexecsecurity
	staying = TRUE

	max_stat = 4
	my_weapon_type = /obj/item/gun/ballistic/automatic/pistol/darkpack/deagle
	my_backup_weapon_type = /obj/item/melee/baton/vamp

/mob/living/carbon/human/npc/endronexecsecurity/Initialize(mapload)
	. = ..()
	AssignSocialRole(/datum/socialrole/endronexecsecurity)

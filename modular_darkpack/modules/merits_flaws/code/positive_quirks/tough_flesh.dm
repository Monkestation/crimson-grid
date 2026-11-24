/datum/quirk/darkpack/tough_flesh
	name = "Tough Flesh"
	desc = {"You flesh is incredibly tough and is more resistant to forces or trauma that would knock you down.
		You take half the damage from car crashes as well as having a slight increased resistance to stuns.
		This merit does not provide physical damage resistance."}
	ttrpg_sources = list(/datum/source_book/homebrew)
	value = 3
	mob_trait = TRAIT_TOUGH_FLESH
	icon = FA_ICON_DUMBBELL

/datum/quirk/darkpack/tough_flesh/add(client/client_source)
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return
	MODIFY_PHYSIOLOGY(human_holder, PHYS_COEFF_STUN, 0.8)
	MODIFY_PHYSIOLOGY(human_holder, STAMINA, 0.8)

/datum/quirk/darkpack/tough_flesh/remove(client/client_source)
	var/mob/living/carbon/human/human_holder = astype(quirk_holder)
	if(!human_holder)
		return
	MODIFY_PHYSIOLOGY(human_holder, PHYS_COEFF_STUN, 1.25)
	MODIFY_PHYSIOLOGY(human_holder, STAMINA, 1.25)

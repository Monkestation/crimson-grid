/datum/discipline_power/dementation/total_insanity/remove_dementation_overlay(mob/living/carbon/human/target)
	. = ..()
	if(attack_target == target)
		attack_target = null

// Generic helpers to simulate the healing of the TTRPG

/// Returns amount of dots healed
/mob/living/proc/heal_storyteller_health(dots_to_heal, heal_aggravated = FALSE, heal_scars = FALSE, heal_blood = FALSE, heal_burn = FALSE)
	if(dots_to_heal <= 0)
		return 0

	var/healed_dots = 0

	if(heal_blood)
		adjust_blood_volume(dots_to_heal * 2, maximum = BLOOD_VOLUME_NORMAL)

	if(heal_scars && dots_to_heal > 0)
		healed_dots += heal_storyteller_scars(dots_to_heal)

	if(heal_burn)
		while(dots_to_heal > 0 && get_fire_loss() > 0)
			heal_ordered_damage(1 TTRPG_DAMAGE, list(BURN))
			dots_to_heal--
			healed_dots++

	if(heal_aggravated)
		while(dots_to_heal > 0 && get_agg_loss()+get_fire_loss() > 0)
			heal_ordered_damage(1 TTRPG_DAMAGE, list(BURN, AGGRAVATED))
			dots_to_heal--
			healed_dots++

	while(dots_to_heal > 0 && get_brute_loss()+get_tox_loss()+get_oxy_loss() > 0)
		heal_ordered_damage(1 TTRPG_DAMAGE, list(BRUTE, TOX, OXY))
		dots_to_heal--
		healed_dots++

	if(healed_dots)
		updatehealth()

	return healed_dots

/mob/living/proc/heal_storyteller_scars(dots_to_heal)
	return

/mob/living/carbon/heal_storyteller_scars(dots_to_heal)
	var/healed_dots = 0

	for(var/datum/wound/our_wound in all_wounds)
		if(dots_to_heal <= 0)
			break
		our_wound.remove_wound()
		dots_to_heal--
		healed_dots++

	// W20 p. 259: describes "battle scars" to be inclusive of stuff like organ damage, brain damage or lost limbs.
	for(var/obj/item/organ/target_organ as anything in organs)
		if(!target_organ.damage)
			continue
		if(target_organ.apply_organ_damage(-dots_to_heal TTRPG_DAMAGE, required_organ_flag = ORGAN_ORGANIC))
			dots_to_heal--
			healed_dots++

	return healed_dots


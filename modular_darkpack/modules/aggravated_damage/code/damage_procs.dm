/mob/living/proc/get_agg_loss()
	return aggloss

/mob/living/carbon/get_agg_loss()
	var/amount = 0
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		amount += bodypart.aggravated_dam
	return round(amount, DAMAGE_PRECISION)

/mob/living/proc/can_adjust_agg_loss(amount, forced, required_bodytype)
	if(!forced && HAS_TRAIT(src, TRAIT_GODMODE))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_LIVING_ADJUST_AGGRAVATED_DAMAGE, AGGRAVATED, amount, forced) & COMPONENT_IGNORE_CHANGE)
		return FALSE
	return TRUE

/mob/living/proc/adjust_agg_loss(amount, updating_health = TRUE, forced = FALSE, required_bodytype = ALL)
	if(amount > 0 && !forced) //carbon mobs override this proc, so the damage modifier check is also performed on [limb/receive_damage()]
		amount *= GET_PHYSIOLOGY(src, AGGRAVATED)

	if (!amount || !can_adjust_agg_loss(amount, forced, required_bodytype))
		return 0
	var/difference = aggloss
	aggloss = clamp((aggloss + (amount * CONFIG_GET(number/damage_multiplier))), 0, maxHealth * 2)
	difference -= aggloss

	return on_damage_loss(amount, updating_health, forced, AGGRAVATED, difference)


/mob/living/proc/set_agg_loss(amount, updating_health = TRUE, forced = FALSE, required_bodytype = ALL)
	if(!forced && HAS_TRAIT(src, TRAIT_GODMODE))
		return 0
	var/difference = aggloss
	aggloss = amount
	difference -= aggloss

	return on_damage_loss(-difference, updating_health, forced, AGGRAVATED, difference)

/mob/living/carbon/adjust_agg_loss(amount, updating_health = TRUE, forced = FALSE, required_bodytype = ALL)
	if(!can_adjust_agg_loss(amount, forced, required_bodytype))
		return 0
	if(amount > 0)
		. = take_overall_damage(aggravated = amount, updating_health = updating_health, forced = forced, required_bodytype = required_bodytype)
	else
		. = heal_overall_damage(aggravated = abs(amount), required_bodytype = required_bodytype, updating_health = updating_health, forced = forced)

/mob/living/simple_animal/adjust_agg_loss(amount, updating_health = TRUE, forced = FALSE, required_bodytype = ALL)
	if(!can_adjust_agg_loss(amount, forced, required_bodytype))
		return 0
	var/damage_modifier = GET_PHYSIOLOGY(src, AGGRAVATED)
	if(forced)
		. = adjust_brute_loss(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else if(damage_modifier)
		. = adjust_brute_loss(amount * damage_modifier * CONFIG_GET(number/damage_multiplier), updating_health, forced)

/mob/living/basic/adjust_agg_loss(amount, updating_health = TRUE, forced = FALSE, required_bodytype = ALL)
	if(!can_adjust_agg_loss(amount, forced, required_bodytype))
		return 0
	var/damage_modifier = GET_PHYSIOLOGY(src, AGGRAVATED)
	if(forced)
		. = adjust_brute_loss(amount * CONFIG_GET(number/damage_multiplier), updating_health, forced)
	else if(damage_modifier)
		. = adjust_brute_loss(amount * damage_modifier * CONFIG_GET(number/damage_multiplier), updating_health, forced)


/mob/living/carbon/set_agg_loss(amount, updating_health = TRUE, forced = FALSE, required_bodytype = ALL)
	if(!forced && HAS_TRAIT(src, TRAIT_GODMODE))
		return FALSE
	var/current = get_agg_loss()
	var/diff = amount - current
	if(!diff)
		return FALSE
	return adjust_agg_loss(diff, updating_health, forced, required_bodytype)

///Proc to hook behavior associated to the change of the aggravated_dam variable's value.
/obj/item/bodypart/proc/set_aggravated_dam(new_value)
	PROTECTED_PROC(TRUE)

	if(aggravated_dam == new_value)
		return
	. = aggravated_dam
	aggravated_dam = new_value

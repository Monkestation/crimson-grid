/datum/action/cooldown/power/gift/rage_heal
	name = "Rage heal"
	desc = "This Gift allows the Garou to heal severe aggravated damage with their rage."
	button_icon_state = "rage_heal"
	innate_ability = TRUE
	cooldown_time = 2 MINUTES
	rage_cost = 2
	check_flags = null
	var/datum/storyteller_roll/rage_heal/rage_heal_roll = new /datum/storyteller_roll/rage_heal

/datum/storyteller_roll/rage_heal
	bumper_text = "Rage heal"
	difficulty = 8
	applicable_stats = list(STAT_STAMINA)
	roll_output_type = ROLL_PRIVATE

/datum/action/cooldown/power/gift/rage_heal/Activate(atom/target)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/human/BD = owner
	if(!istype(BD) || BD.stat == DEAD)
		return FALSE

	if(!do_after(BD, 1 TURNS, timed_action_flags = DO_AFTER_CHECK_NEXT_MOVE | IGNORE_INCAPACITATED))
		return FALSE

	var/roll_result = rage_heal_roll.st_roll(BD, src)
	if(roll_result != ROLL_SUCCESS)
		to_chat(BD, span_warning("And fail to harness your Rage."))
		return FALSE

	to_chat(BD, span_notice("But your rage helps mend your wounds."))
	SEND_SOUND(BD, sound('modular_darkpack/modules/werewolf_the_apocalypse/sounds/rage_heal.ogg', volume = 50))
	BD.heal_storyteller_health(100, heal_aggravated = TRUE)
	BD.adjust_agg_loss(-50)
	BD.update_damage_overlays()
	return TRUE

	if(!uses_rage)
		return FALSE
/datum/action/cooldown/power/gift/rage_heal/proc/pre_activation_checks(atom/target)
	. = ..()
	if(do_after(owner, 1 TURNS, timed_action_flags = DO_AFTER_CHECK_NEXT_MOVE | IGNORE_INCAPACITATED))
		return TRUE
	if(!rage_heal_roll)
		rage_heal_roll = new()
	var/roll_result = rage_heal_roll.st_roll(owner, src)
	to_chat(owner, span_warning("You break your concentration..."))
	switch(roll_result)
		if(ROLL_SUCCESS)
			to_chat(owner, span_notice("But you succeed in mending your wounds."))
			return TRUE
		if(ROLL_FAILURE)
			to_chat(owner, span_warning("And fail to harness your blood."))
			return FALSE
		if(ROLL_BOTCH)
			to_chat(owner, span_danger("And worsen your wounds."))
			/datum/splat/werewolf/adjust_rage(-2)
			owner.apply_damage(1 TTRPG_DAMAGE, BRUTE)
			return FALSE

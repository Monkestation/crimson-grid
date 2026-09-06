#define HEAL_AGGRAVATED_DAMAGE 50

/datum/action/cooldown/power/gift/rage_heal
	name = "Rage heal"
	desc = "This Gift allows the Garou to heal severe aggravated damage with their Rage."
	button_icon_state = "rage_heal"
	innate_ability = TRUE
	cooldown_time = 30 SECONDS
	rage_cost = 2

	var/datum/storyteller_roll/rage_heal/rage_heal_roll = new /datum/storyteller_roll/rage_heal
	var/heal_amount = 50

/datum/action/cooldown/power/gift/rage_heal/New()
	. = ..()
	check_flags = NONE

/datum/storyteller_roll/rage_heal
	bumper_text = "Rage heal"
	difficulty = 8
	applicable_stats = list(STAT_STAMINA, STAT_SURVIVAL)
	roll_output_type = ROLL_PRIVATE

/datum/action/cooldown/power/gift/rage_heal/IsAvailable(feedback = FALSE)
	. = ..()
	if(!.)
		return FALSE
	if(owner.stat == DEAD)
		if(feedback)
			owner.balloon_alert(owner, "You cannot mend your flesh of aggravated damage while dead!")
		return FALSE
	return TRUE

/datum/action/cooldown/power/gift/rage_heal/Activate(atom/target)
	var/mob/living/carbon/human/W = owner
	. = ..()
	var/channel_success = do_after(W,2 SECONDS,timed_action_flags = DO_AFTER_CHECK_NEXT_MOVE)
	if(!channel_success)
		to_chat(W, span_warning("Your concentration breaks as you fail to harness your rage to mend yourself!"))
		return FALSE
	to_chat(W, span_warning("Your rage surges outwards and rips through your flesh, attempting to mend your wounds!"))
	if(!rage_heal_roll)
		rage_heal_roll = new /datum/storyteller_roll/rage_heal
	var/roll_result = rage_heal_roll.st_roll(W, src)
	if(roll_result == ROLL_BOTCH)
		W.emote("scream", forced = TRUE)
		W.apply_damage(4 TTRPG_DAMAGE, BRUTE)
		to_chat(W, span_warning("Your rage inside your soul spirals out of your control as the wolf lashes back at you!"))
		return FALSE
	if(roll_result == ROLL_FAILURE)
		W.emote("sigh", forced = TRUE)
		to_chat(owner, span_warning("You fail to harness your rage to heal your wounds!"))
		return FALSE
	W.emote("howl", forced = TRUE)
	var/agg_before = W.get_agg_loss()
	if(agg_before <= 0)
		to_chat(W, span_warning("Your body has no aggravated damage to mend."))
		return FALSE
	var/successes = rage_heal_roll.last_sucess_amount
	var/heal_amount = HEAL_AGGRAVATED_DAMAGE + (max(successes - 4, 0) * 30)
	heal_amount = min(heal_amount, agg_before)
	to_chat(W, span_warning("Your supernatural rage tears through your aggravated wounds and heals you..."))
	var/healed_amount = W.adjust_agg_loss(-heal_amount,TRUE,TRUE)
	if(healed_amount <= 0)
		to_chat(W, span_warning("The rage rises within you, but it fails to find any aggravated damage to mend."))
		return FALSE
	owner.visible_message(span_warning("[owner]'s festering wounds are closing at a terrifingly rapid pace!"))
	W.update_damage_overlays()
	return TRUE

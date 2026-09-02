#define HEAL_AGGRAVATED_DAMAGE 100

/datum/action/cooldown/power/gift/rage_heal
	name = "Rage heal"
	desc = "This Gift allows the Garou to heal severe aggravated damage with their Rage."
	button_icon_state = "rage_heal"
	innate_ability = TRUE
	cooldown_time = 30 SECONDS
	rage_cost = 2
	check_flags = null

	var/datum/storyteller_roll/rage_heal/rage_heal_roll = new /datum/storyteller_roll/rage_heal
	var/heal_amount = 100

/datum/storyteller_roll/rage_heal
	bumper_text = "Rage heal"
	difficulty = 8
	applicable_stats = list(STAT_STAMINA, STAT_SURVIVAL)
	roll_output_type = ROLL_PRIVATE

/datum/action/cooldown/power/gift/rage_heal/Activate(atom/target)
	var/mob/living/carbon/human/W = owner
	. = ..()
	var/channel_success = do_after(
		W,
		1 SECONDS,
		timed_action_flags = DO_AFTER_CHECK_NEXT_MOVE
	)
	if(!channel_success)
		to_chat(W, span_warning("You fail to channel your rage through your body to mend your wounds!"))
		return FALSE

	to_chat(W, span_warning("Your rage rips through your flesh rapidly mending and closing your aggravated wounds!"))

	if(!rage_heal_roll)
		rage_heal_roll = new /datum/storyteller_roll/rage_heal


	var/roll_result = rage_heal_roll.st_roll(W, src)

	if(roll_result == ROLL_BOTCH)

		to_chat(W, span_warning("The rage inside of you spirals out your control. Your wounds remain!"))
		return FALSE


	var/agg_before = W.get_agg_loss()
	if(agg_before <= 0)
		to_chat(W, span_warning("Your body has no aggravated damage to mend."))
		return FALSE

	var/successes = rage_heal_roll.last_sucess_amount

	var/heal_amount = HEAL_AGGRAVATED_DAMAGE + (max(successes - 1, 0) * 50)
	heal_amount = min(heal_amount, HEAL_AGGRAVATED_DAMAGE)
	heal_amount = min(heal_amount, agg_before)

	to_chat(W, span_warning("Your supernatural rage tears through your wounds..."))

	var/healed_amount = W.adjust_agg_loss(
		-heal_amount,
		TRUE,
		TRUE
	)
	if(healed_amount <= 0)
		to_chat(W, span_warning("Your rage rises within you, but you failed to use it to close your wounds."))
		return FALSE

	to_chat(W, span_danger("Your Rage surges through your body! Your Flesh rips rapidly together as your serious injuries close."))

	W.update_damage_overlays()

	return TRUE

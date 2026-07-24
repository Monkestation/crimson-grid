/datum/storyteller_roll
	var/bumper_text = "roll"

	var/difficulty = 6
	var/successes_needed = 1

	// By default uses the highest attribute and ability // Not acctually true yet, it just used all of them. But it should be that.
	var/list/applicable_stats = list()
	var/numerical = FALSE

	var/roll_output_type = ROLL_PUBLIC
	/// This is a roll that can proc multiple times in rapid sucession and thus has weaker or less notible outputs (forced runechat and quieter dice rolls)
	var/spammy_roll = FALSE
	/// If set, a character or unicode appended to the front of balloon alerts to help convey what the roll is for.
	var/alert_prefix
	var/alert_delay

	/// A lazy list of roll results indexed by a weakref to a mob. list(OLD_ROLL_TIME, OLD_ROLL_OUTPUT)
	var/list/mobs_last_rolled
	var/reroll_cooldown
	/// If the roll as a reroll_cooldown, return the mobs stored result if it has one.
	var/roll_use_last_result = TRUE

	// Mutable vars to store the outputs of any given roll. Expect everything past here to be mutated between each roll.
	var/last_sucess_amount
	var/list/last_output_text = list()


/**
 * Rolls a number of dice according to Storyteller system rules to find
 * success or number of successes.
 *
 * Rolls a number of 10-sided dice, counting them as a "success" if
 * they land on a number equal to or greater than the difficulty. Dice
 * that land on 1 subtract a success from the total, and the minimum
 * difficulty is 2. The number of successes is returned if numerical
 * is true, or the roll outcome (botch, failure, success) as a defined
 * number if false.
 *
 * Arguments:

 * * roller - the mob who is making the role and owns the dice
 * * target - who this dice is being rolled against, can be the roller, determines if its considered "important" to the mob to display.
 * * dice - bonus dice that are added to the roll.
 *
 * Returns: The sucess of the roll, either a define or the raw amount of sucesses if `numerical = TRUE`
 */
/datum/storyteller_roll/proc/st_roll(mob/living/roller, atom/target, bonus = 0)
	if(reroll_cooldown && roll_use_last_result)
		var/list/old_roll = get_old_roll(roller)
		if(old_roll)
			return old_roll[OLD_ROLL_OUTPUT]

	last_sucess_amount = 0
	last_output_text = list()

	if(!can_roll(roller))
		return ROLL_COOLDOWN

	var/dice_amount = calculate_used_dice(roller, bonus)
	var/auto_success_amount = calculate_auto_successes(roller)
	var/used_difficulty = calculate_used_difficulty(roller)

	bonus += SEND_SIGNAL(roller, COMSIG_LIVING_PRE_DICE_ROLLED, src, target)

	var/list/rolled_dice = roll_dice(dice_amount, auto_success_amount)

	var/dice_used_text = "[dice_amount] dice"
	if(auto_success_amount)
		dice_used_text += " + [auto_success_amount] auto successes"
	var/first_line = "[span_tooltip(show_rolling_with(roller, bonus), dice_used_text)] vs. difficulty [used_difficulty]."
	if(successes_needed > 1)
		first_line += " [successes_needed] successes needed."
	last_output_text += span_notice(first_line)

	last_sucess_amount = count_success(rolled_dice, used_difficulty, last_output_text)
	var/output = roll_result(last_sucess_amount)

	var/title
	if(roll_output_type in list(ROLL_PRIVATE_ADMIN, ROLL_ADMIN))
		title = "[ADMIN_LOOKUPFLW(roller)]"
	else
		title = "[roller]"
	title += " - [bumper_text] [span_tinynoticeital(roll_output_type)]"

	var/output_combined = fieldset_block(title, jointext(last_output_text, "<br>"), "boxed_message")
	for(var/mob/player_mob in get_mobs_to_show(roller, target))
		var/roll_important_to_me = FALSE
		if(!spammy_roll && (player_mob == roller || target))
			roll_important_to_me = TRUE

		if(!spammy_roll)
			to_chat(player_mob, output_combined, MESSAGE_TYPE_INFO, trailing_newline = FALSE)
			SEND_SOUND(player_mob, sound('sound/items/dice_roll.ogg', volume = roll_important_to_me ? 5 : 20))
		else
			if(alert_delay)
				var/using_number = last_sucess_amount
				spawn(alert_delay)
					create_balloon_alert(roller, player_mob, using_number)
			else
				create_balloon_alert(roller, player_mob, last_sucess_amount)


	LAZYADDASSOC(mobs_last_rolled, WEAKREF(roller), list(world.time, output))

	SEND_SIGNAL(roller, COMSIG_LIVING_DICE_ROLLED, src, target, output)
	return output

/datum/storyteller_roll/proc/create_balloon_alert(mob/living/roller, mob/player_mob, number)
	if(QDELETED(roller) || QDELETED(player_mob))
		return

	if(number > 0)
		roller.balloon_alert(player_mob, "<span style='color: #14a833;'>[alert_prefix][number]</span>", TRUE)
	else
		roller.balloon_alert(player_mob, "<span style='color: #ff0000;'>[alert_prefix][number]</span>", TRUE)

/datum/storyteller_roll/proc/get_mobs_to_show(mob/living/roller, atom/target)
	switch(roll_output_type)
		if(ROLL_PUBLIC)
			return viewers(DEFAULT_SIGHT_DISTANCE, roller)
		if(ROLL_PRIVATE)
			return list(roller)
		if(ROLL_PRIVATE_AND_TARGET)
			if(roller == target || !isliving(target))
				return list(roller)
			else
				return list(roller, target)
		if(ROLL_PRIVATE_ADMIN)
			return admin_mobs() + roller
		if(ROLL_ADMIN)
			return admin_mobs()
		if(ROLL_NONE)
			return // Not even important enough to be admin visible.

/datum/storyteller_roll/proc/admin_mobs()
	var/list/admin_mobs = list()
	for(var/client/staff in GLOB.admins)
		if(staff.mob)
			admin_mobs += staff.mob
	return admin_mobs

/datum/storyteller_roll/proc/calculate_used_dice(mob/living/roller, bonus = 0)
	var/dice_amount = 0
	for(var/stat_type in using_stats(roller))
		dice_amount += roller.st_get_stat(stat_type, include_auto_successes = FALSE)
	return dice_amount + bonus

/datum/storyteller_roll/proc/calculate_auto_successes(mob/living/roller)
	var/dice_amount = 0
	for(var/stat_type in using_stats(roller))
		var/datum/st_stat/given_stat = roller?.storyteller_stats[stat_type]
		dice_amount += given_stat?.get_auto_success_score()
	return dice_amount

// Unused rn but can be used for overides of `using_stats()`
/datum/storyteller_roll/proc/return_higher_stat(mob/living/roller, list/stats)
	var/stat_to_use
	var/highest_stat
	for(var/stat in stats)
		var/stat_dots = roller.st_get_stat(stat)
		if(isnull(highest_stat) || stat_dots > highest_stat)
			stat_to_use = stat
			highest_stat = stat_dots
	return stat_to_use

/datum/storyteller_roll/proc/using_stats(mob/living/roller)
	return applicable_stats

/datum/storyteller_roll/proc/calculate_used_difficulty(mob/living/roller)
	return difficulty

/datum/storyteller_roll/proc/show_rolling_with(mob/living/roller, bonus = 0)
	var/output = ""
	var/stuff = list()
	for(var/datum/st_stat/stat_type as anything in using_stats(roller))
		stuff += "[LOWER_TEXT(stat_type::name)]:[roller.st_get_stat(stat_type)]"
	output += jointext(stuff, "+")
	if(bonus)
		output += "+[bonus]"
	return "Rolling [output]"

/datum/storyteller_roll/proc/roll_dice(dice, auto_successes, sides = 10)
	dice = max(dice, 1)
	var/list/rolled_dice = list()
	for(var/i in 1 to dice)
		rolled_dice += rand(1, sides)
	if(SSroll.on_crit_extra_die_enabled)
		var/extra_dice = 0
		for(var/roll in rolled_dice)
			if(roll == 10)
				extra_dice++
		for(var/i in 1 to extra_dice)
			rolled_dice += rand(1, sides)
	for(var/i in 1 to auto_successes)
		rolled_dice += 11
	return rolled_dice

//Count the number of successes.
/datum/storyteller_roll/proc/count_success(list/rolled_dice, difficulty = 6, last_output_text)
	var/sucess_amount = 0
	var/dice_text = ""
	for(var/roll in rolled_dice)
		if(roll >= difficulty)
			dice_text += span_nicegreen("[get_dice_char(roll)]")
			sucess_amount++
			if(SSroll.on_crit_extra_success_enabled && roll == 10)
				sucess_amount++
		else if(roll == 1)
			dice_text += span_bold(span_danger("[get_dice_char(roll)]"))
			sucess_amount--
		else
			dice_text += span_danger("[get_dice_char(roll)]")
	last_output_text += "[roll_result_text(roll_result(sucess_amount))] [span_slightly_larger(dice_text)]"
	return sucess_amount

/datum/storyteller_roll/proc/roll_result(sucess_amount)
	if(numerical)
		return sucess_amount
	else
		if(sucess_amount < 0)
			return ROLL_BOTCH
		else if(sucess_amount < successes_needed)
			return ROLL_FAILURE
		else
			return ROLL_SUCCESS

/datum/storyteller_roll/proc/roll_result_text(success_result)
	if(numerical)
		return "[success_result] successes -"
	else
		switch(success_result)
			if(ROLL_SUCCESS)
				return span_nicegreen("Success -")
			if(ROLL_FAILURE)
				return span_danger("Failure -")
			if(ROLL_BOTCH)
				return span_bold(span_danger(("Botch -")))

/datum/storyteller_roll/proc/get_dice_char(input)
	// "11" represents automatic successes
	var/static/list/dice_output = list("❶", "❷", "❸", "❹", "❺", "❻", "❼", "❽", "❾", "❿", "☥")
	return dice_output[input]
	/* // This would require making it an assoc list and we dont every expect outside our given range.
	// So if someone faces a runtime because of this just make it an actual assoc and deal with the micro preformace hit
	var/static/alist/dice_output = alist(1 = "❶", 2 = "❷", 3 = "❸" ,4 = "❹", 5 = "❺", 6 = "❻", 7 = "❼", 8 = "❽", 9 = "❾", 10 = "❿")
	if(!dice_output[input])
		return "⓿"
	else
		return dice_output[input]
	*/


/datum/storyteller_roll/proc/get_old_roll(mob/living/roller)
	if(reroll_cooldown && mobs_last_rolled)
		for(var/datum/weakref/guy_ref, roll_info in mobs_last_rolled)
			var/mob/living/guy = guy_ref.resolve()
			if(!guy)
				mobs_last_rolled.Remove(guy_ref)
				continue
			if(guy != roller)
				continue
			if(roll_info[OLD_ROLL_TIME] + reroll_cooldown > world.time)
				return roll_info
			else
				mobs_last_rolled.Remove(guy_ref) // Clear rolls that expired

/datum/storyteller_roll/proc/can_roll(mob/living/roller, feedback = TRUE)
	var/list/old_mob_roll = get_old_roll(roller)
	if(!old_mob_roll)
		return TRUE

	if(feedback)
		to_chat(roller, span_warning("You cannot reroll [bumper_text] yet. [round((old_mob_roll[OLD_ROLL_TIME] + reroll_cooldown - world.time)/10)]s left."))

	return FALSE

/datum/storyteller_roll
	var/bumper_text = "roll"

	/**
	 * The difficulty of a roll.
	 * As a reference, three is trivial, six is standard, nine is extremely difficult.
	 */
	var/difficulty = 6
	var/bonus = 0

	/**
	 * The amount of successes required to pass.
	 * As a reference,
	 * 	one is marginal, eg: keep a broken refrigerator running until the repairman arrives
	 *	five is p h e n o m e n a l, eg: creating a masterwork
	 */
	var/successes_needed = 1

	// By default uses the highest attribute and ability // Not acctually true yet, it just used all of them. But it should be that.
	var/list/applicable_stats = list()
	var/numerical = FALSE

	var/roll_output_type = ROLL_PUBLIC
	/**
	 * For showing a diffrent result on a botch/fail. e.g
	 *
	 *	/datum/storyteller_roll/investigation
	 *		roll_output_type = ROLL_FLAG_ROLLER
	 *		roll_output_type_on_fail = ROLL_FLAG_NEARBY
	 */
	var/roll_output_type_on_fail
	var/hide_result = FALSE
	/// This is a roll that can proc multiple times in rapid succession and thus has weaker or less notible outputs (forced runechat and quieter dice rolls)
	var/spammy_roll = FALSE
	/// If set, a character or unicode appended to the front of balloon alerts to help convey what the roll is for.
	var/alert_prefix
	var/alert_delay

	/// A lazy list of roll results indexed by a weakref to a mob. list(OLD_ROLL_TIME, OLD_ROLL_OUTPUT)
	var/list/mobs_last_rolled
	var/reroll_cooldown
	/// If the roll as a reroll_cooldown, return the mobs stored result if it has one.
	var/roll_use_last_result = TRUE

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
 * * bonus_added - bonus dice that are added to the roll.
 * * using_item - optional arg for an item employed for the roll.
 *
 * Returns: The success of the roll, either a define or the raw amount of successes if `numerical = TRUE`
 */
/datum/storyteller_roll/proc/st_roll(mob/living/roller, atom/target, bonus_added = 0, atom/using_item)
	if(reroll_cooldown && roll_use_last_result)
		var/list/old_roll = get_old_roll(roller)
		if(old_roll)
			return old_roll[OLD_ROLL_OUTPUT]

	if(!can_roll(roller))
		return ROLL_COOLDOWN

	var/bonus_amount = using_bonus(roller, target, bonus_added)
	var/dice_amount = using_dice(roller, target)
	var/auto_success_amount = using_auto_successes(roller)
	var/difficulty_amount = using_difficulty(roller)

	SEND_SIGNAL(roller, COMSIG_LIVING_PRE_DICE_ROLLED, src, target, using_item, &bonus_amount, &difficulty_amount)

	dice_amount += bonus_amount
	difficulty_amount = clamp(difficulty_amount, ROLL_DIFFICULTY_MIN, ROLL_DIFFICULTY_MAX) // WTA pg. 234

	var/list/rolled_dice = roll_dice(dice_amount, auto_success_amount)

	var/success_amount = count_success(rolled_dice, difficulty_amount)
	var/output = roll_result(success_amount)
	var/using_output_type = roll_output_type
	if(!isnull(roll_output_type_on_fail))
		if(numerical)
			if(output < 1)
				using_output_type = roll_output_type_on_fail
		else
			if(output < ROLL_SUCCESS)
				using_output_type = roll_output_type_on_fail

	for(var/mob/player_mob in get_mobs_to_show(roller, target, using_output_type))
		var/roll_important_to_me = FALSE
		if(!spammy_roll && (player_mob == roller || target))
			roll_important_to_me = TRUE

		if(!spammy_roll)
			var/message = build_output_message(
				roller,
				player_mob,
				dice_amount,
				bonus_amount,
				auto_success_amount,
				difficulty_amount,
				success_amount,
				rolled_dice,
				hide_result,
				using_output_type
			)
			to_chat(player_mob, message, MESSAGE_TYPE_INFO, trailing_newline = FALSE)
			var/roll_sound = 'sound/items/dice_roll.ogg'
			if(dice_amount + rand(-1, 1) > 3) // Create some nice variation.
				roll_sound = 'modular_darkpack/modules/storyteller_dice/sounds/lots_of_dice.ogg'
			SEND_SOUND(player_mob, sound(roll_sound, volume = roll_important_to_me ? 5 : 20))
		else
			if(alert_delay)
				var/using_number = success_amount
				spawn(alert_delay)
					create_balloon_alert(roller, player_mob, using_number)
			else
				create_balloon_alert(roller, player_mob, success_amount)

	LAZYADDASSOC(mobs_last_rolled, WEAKREF(roller), list(world.time, output))

	SEND_SIGNAL(roller, COMSIG_LIVING_DICE_ROLLED, src, target, using_item, output)
	return output

/datum/storyteller_roll/proc/build_output_message(
	mob/living/roller,
	mob/displayed_to,
	dice_amount,
	bonus_amount,
	auto_success_amount,
	difficulty_amount,
	success_amount,
	list/rolled_dice,
	hide_result,
	using_output_type
)
	var/output_text = list()
	var/dice_used_text = "[dice_amount] dice"
	if(auto_success_amount)
		dice_used_text += " + [auto_success_amount] auto successes"
	var/first_line = "[span_tooltip(show_rolling_with(roller, bonus_amount), dice_used_text)][hide_result ? "" : " vs. difficulty [difficulty_amount]"]."
	output_text += span_notice(first_line)

	output_text += get_dice_display(rolled_dice, difficulty_amount, success_amount, hide_result)

	var/roll_output_string
	if(using_output_type == ROLL_PUBLIC) // A common combination of the bitfields, give it its own display.
		roll_output_string = "public"
	else
		roll_output_string = jointext(bitfield_to_list(using_output_type, ROLL_OUTPUT_IC), "+")

	var/title
	if(using_output_type & ROLL_FLAG_ADMIN && (displayed_to.client in GLOB.admins))
		title = "[ADMIN_LOOKUPFLW(roller)]"
	else
		title = GET_GUESTBOOK_NAME_TRUE(displayed_to, roller)
	title += " - [bumper_text] [span_tinynoticeital(roll_output_string)]"

	var/output_combined = fieldset_block(title, jointext(output_text, "<br>"), "boxed_message")

	return output_combined

/datum/storyteller_roll/proc/create_balloon_alert(mob/living/roller, mob/player_mob, number)
	if(QDELETED(roller) || QDELETED(player_mob))
		return

	if(number > 0)
		roller.balloon_alert(player_mob, "<span style='color: #14a833;'>[alert_prefix][number]</span>", TRUE)
	else
		roller.balloon_alert(player_mob, "<span style='color: #ff0000;'>[alert_prefix][number]</span>", TRUE)

/datum/storyteller_roll/proc/get_mobs_to_show(mob/living/roller, atom/target, using_output_type)
	var/list/shown_targets = list()
	if(using_output_type & ROLL_FLAG_NEARBY)
		shown_targets |= viewers(DEFAULT_SIGHT_DISTANCE, roller)
	if(using_output_type & ROLL_FLAG_ROLLER)
		shown_targets |= roller
	if(using_output_type & ROLL_FLAG_TARGET)
		if(isliving(target))
			shown_targets |= target
	if(using_output_type & ROLL_FLAG_ADMIN)
		shown_targets |= admin_mobs()

	return shown_targets

/datum/storyteller_roll/proc/admin_mobs()
	var/list/admin_mobs = list()
	for(var/client/staff in GLOB.admins)
		if(staff.mob)
			admin_mobs += staff.mob
	return admin_mobs

/datum/storyteller_roll/proc/using_dice(mob/living/roller, atom/target)
	var/dice_amount = 0
	for(var/stat_type in using_stats(roller))
		dice_amount += roller.st_get_stat(stat_type, include_auto_successes = FALSE)
	return dice_amount

/datum/storyteller_roll/proc/using_auto_successes(mob/living/roller)
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

/datum/storyteller_roll/proc/using_bonus(mob/living/roller, atom/target, bonus_added)
	return bonus + bonus_added

/datum/storyteller_roll/proc/using_stats(mob/living/roller)
	return applicable_stats

/datum/storyteller_roll/proc/using_difficulty(mob/living/roller, atom/target)
	return difficulty

/datum/storyteller_roll/proc/show_rolling_with(mob/living/roller, bonus_amount = 0)
	var/output = ""
	var/stuff = list()
	for(var/datum/st_stat/stat_type as anything in using_stats(roller))
		stuff += "[LOWER_TEXT(stat_type::name)]:[roller.st_get_stat(stat_type)]"
	output += jointext(stuff, "+")
	if(bonus_amount)
		output += "+[bonus_amount]"
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
/datum/storyteller_roll/proc/count_success(list/rolled_dice, difficulty)
	var/success_amount = 0
	for(var/roll in rolled_dice)
		switch(dice_face_success_type(roll, difficulty))
			if(2)
				success_amount += 2
			if(1)
				success_amount++
			if(-1)
				success_amount--
	return success_amount

//Count the number of successes.
/datum/storyteller_roll/proc/get_dice_display(list/rolled_dice, difficulty, success_amount, hide_result)
	var/dice_text = ""
	for(var/roll in rolled_dice)
		if(hide_result)
			dice_text += span_notice("[get_dice_char(roll)]")
			continue

		switch(dice_face_success_type(roll, difficulty))
			if(2)
				dice_text += span_green("[get_dice_char(roll)]")
			if(1)
				dice_text += span_nicegreen("[get_dice_char(roll)]")
			if(-1)
				dice_text += span_bold(span_danger("[get_dice_char(roll)]"))
			else
				dice_text += span_danger("[get_dice_char(roll)]")

	if(hide_result)
		return "[span_slightly_larger(dice_text)]"

	return "[roll_result_text(roll_result(success_amount))] [span_slightly_larger(dice_text)]"

/datum/storyteller_roll/proc/dice_face_success_type(dice_face, difficulty)
	if(dice_face >= difficulty)
		if(SSroll.on_crit_extra_success_enabled && dice_face == 10)
			return 2
		return 1
	else if(dice_face == 1)
		return -1
	else
		return 0


/datum/storyteller_roll/proc/roll_result(success_amount)
	if(numerical)
		return success_amount
	else
		if(success_amount < 0)
			return ROLL_BOTCH
		else if(success_amount < successes_needed)
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

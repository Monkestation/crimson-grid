/datum/splat/vampire/kindred/proc/adjust_morality(mob/living/carbon/human/owner, value, limit, forced, difficulty = 6)
	SIGNAL_HANDLER

	// "Enlightenment" is essentially the Path of Pure Evil. Inverts Humanity changes and limits.
	var/is_enlightenment = owner.is_enlightenment()
	var/path = is_enlightenment ? "Enlightenment" : "Humanity"
	if (is_enlightenment && !forced)
		value = -value
		limit = 10 - limit

	// Work out actual change in Humanity
	var/new_humanity
	var/humanity_change
	if (value > 0)
		new_humanity = clamp(owner.st_get_stat(STAT_MORALITY) + value, 0, limit)
		humanity_change = new_humanity - owner.st_get_stat(STAT_MORALITY)

		// Hit the limit for increase, no change
		if (humanity_change <= 0)
			return
	else if (value < 0)
		var/loss_modifier = HAS_TRAIT(owner, TRAIT_SENSITIVE_HUMANITY) ? 2 : 1
		value *= loss_modifier

		new_humanity = clamp(owner.st_get_stat(STAT_MORALITY) + value, limit, 10)
		humanity_change = new_humanity - owner.st_get_stat(STAT_MORALITY)

		// Hit the limit for decrease, no change
		if (humanity_change >= 0)
			return
	else
		return

	//before going any further, roll either conscience or conviction to determine if we actually lose path/humanity
	if(humanity_change < 0)
		var/stat_to_roll = is_enlightenment ? STAT_CONVICTION : STAT_CONSCIENCE
		var/datum/storyteller_roll/degeneration_roll = new()
		degeneration_roll.applicable_stats = list(stat_to_roll)
		degeneration_roll.difficulty = difficulty
		degeneration_roll.roll_output_type = ROLL_FLAG_ROLLER|ROLL_FLAG_ADMIN
		var/roll_result = degeneration_roll.st_roll(owner)

		if(roll_result == ROLL_SUCCESS)
			to_chat(owner, span_green("Your [is_enlightenment ? "conviction" : "conscience"] prevents you from losing [path] as you successfully justify your actions!"))
			return
		else
			to_chat(owner, span_danger("You fail to justify your actions as the Beast within awakens..."))

	var/signal_return = SEND_SIGNAL(owner, COMSIG_LIVING_CHANGING_HUMANITY, humanity_change)
	if (signal_return & BLOCK_HUMANITY_CHANGE)
		return

	// Change morality according to calculated values
	owner.st_set_stat(STAT_MORALITY, owner.st_get_stat(STAT_MORALITY) + humanity_change)
	if (humanity_change > 0)
		SEND_SOUND(owner, sound('modular_darkpack/modules/deprecated/sounds/humanity_gain.ogg', volume = 75))
		to_chat(owner, span_boldnicegreen("[uppertext(path)] INCREASED!"))

		// Gaining Path flavour text
		switch (owner.st_get_stat(STAT_MORALITY))
			if (10)
				to_chat(owner, span_green("As your [path] reaches its peak, you feel the Beast [is_enlightenment ? "reaching perfect harmony with you" : "falling into a deep slumber, waiting"]."))
	else if (humanity_change < 0)
		SEND_SOUND(owner, sound('modular_darkpack/modules/deprecated/sounds/humanity_loss.ogg', volume = 75))
		to_chat(owner, span_userdanger(span_bold("[uppertext(path)] DECREASED!")))

		// Losing Path flavour text
		switch (owner.st_get_stat(STAT_MORALITY))
			if (1)
				to_chat(owner, span_userdanger(span_bold("BLOOD. FEED. HUNGER.")))
			if (2)
				to_chat(owner, span_userdanger("You are losing your mind. The [span_bold("BEAST")] commands you."))
			if (3)
				to_chat(owner, span_danger("Your higher reason is eroding. The Beast is gaining control..."))
			if (4)
				to_chat(owner, span_danger("You feel the Beast gnawing at the edges of your mind..."))
			if (9)
				to_chat(owner, span_warning("As you fall from your perfect [path], you feel the Beast [is_enlightenment ? "taking power over" : "reawakening in"] a dark corner of your soul."))

	SEND_SIGNAL(owner, COMSIG_LIVING_CHANGED_HUMANITY, humanity_change)

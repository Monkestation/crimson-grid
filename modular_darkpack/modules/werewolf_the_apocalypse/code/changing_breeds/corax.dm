/datum/storyteller_roll/gift/enemy_ways
	applicable_stats = list(STAT_PERCEPTION)
	difficulty = 7
	numerical = TRUE // More successes can give more information but i didnt have any good ideas for rn.

/datum/action/cooldown/power/gift/enemy_ways
	name = "Enemy Ways"
	desc = "The Corax gains an acute and accurate danger sense"
	button_icon_state = "enemy_ways"
	cooldown_time = 1 SCENES // TTRPG accurate is 1 TURNS but no cost or prevention of spamming
	rank = 1
	// Put up here so the codeblock can interact with them
	var/waiting_clients = 0
	var/hostiles = 0

	/// A assoc list of answers indexed by weakrefs to the answerer. Used to cache old answers to not spam them.
	var/list/datum/weakref/old_answers = list()

/datum/action/cooldown/power/gift/enemy_ways/Activate(atom/target)
	. = ..()
	waiting_clients = 0
	hostiles = 0

	var/datum/storyteller_roll/gift/enemy_ways/roll_datum = new()
	// More successes normally grants geater information.
	var/roll_result = roll_datum.st_roll(owner, bonus = PRIMAL_URGE_PLACEHOLDER)
	if(roll_result <= 0)
		return TRUE

	var/datum/splat/werewolf/wolp_splat = get_werewolf_splat(owner)
	// Should be 20 yards (tiles) per Wisdom according to W20 Changing Breeds p. 99, scaled down to 5 instead because that would be absurd
	var/range = (wolp_splat?.renown[RENOWN_WISDOM] ? wolp_splat.renown[RENOWN_WISDOM] : 1) * 5

	var/list/old_answers_resolved = list()
	for(var/datum/weakref/guy_ref, old_choice in old_answers)
		var/mob/living/resolved_guy = guy_ref.resolve()
		if(!resolved_guy)
			old_answers[guy_ref] = null
			continue
		old_answers_resolved[resolved_guy] = old_choice

	for(var/mob/living/guy in oview(range, owner))
		if(guy.stat == DEAD)
			continue

		if(old_answers_resolved[guy])
			if(old_answers_resolved[guy] == "Yes")
				hostiles++
		else if(guy.client)
			waiting_clients++
			ASYNC
				var/choice = tgui_alert(
					guy,
					"Answer truthfully wether or not your character would consider [GET_GUESTBOOK_NAME(guy, owner)][(GET_GUESTBOOK_NAME(guy, owner) != owner.real_name) ? " ([owner.real_name])" : ""] an enemy.",
					"Is [GET_GUESTBOOK_NAME(guy, owner)] an Enemy?",
					list("Yes", "No", "Unsure"),
					10 SECONDS
				)

				// Cache diffenitive answers so that we dont spam them upon recasting
				switch(choice)
					if("Yes")
						hostiles++
						old_answers[WEAKREF(guy)] = choice
					if("No")
						old_answers[WEAKREF(guy)] = choice

				guy.log_message("Answered [choice ? choice : "Nothing"] when asked if [owner] was hostile via Enemy's Ways.", LOG_GAME)
				waiting_clients--
		else
			if(!guy.faction_check_atom(owner) && !guy.has_ally(owner))
				if(guy.maxHealth < 10) // Filter out fake mobs like cockroaches
					continue
				if(guy.has_faction(FACTION_HOSTILE))
					hostiles++

	if(waiting_clients > 0)
		ASYNC
			#define TIME_FOR_SLEEPS 0.5 SECONDS
			var/time_waited = 0
			while(waiting_clients > 0)
				if(time_waited >= 10 SECONDS)
					break
				time_waited += TIME_FOR_SLEEPS
				sleep(TIME_FOR_SLEEPS)
			#undef TIME_FOR_SLEEPS
			to_chat(owner, span_notice("The Grandfather Thunder's Stormcrow returns you its information. There are [hostiles] within [range] tiles."))
	else
		to_chat(owner, span_notice("The Grandfather Thunder's Stormcrow returns you its information. There are [hostiles] within [range] tiles."))

	return TRUE

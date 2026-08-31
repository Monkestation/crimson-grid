/datum/storyteller_roll/gift/mothers_touch
	applicable_stats = list(STAT_INTELLIGENCE, STAT_EMPATHY)
	numerical = TRUE
	roll_output_type = ROLL_PRIVATE_AND_TARGET

/*
From W20 p. 164
Mother's Touch
System: The player spends one Gnosis point and rolls
Intelligence + Empathy (difficulty is the target’s current
Rage, or 5 for those with no Rage). Each success heals one
level of lethal, bashing, or aggravated damage. The healer
may even heal fresh Battle Scars (see p. 259) in this man-
ner, if the Gift is applied during the same scene in which
the scar is received and an extra Gnosis point is spent.
*/
/datum/action/cooldown/power/gift/mothers_touch
	name = "Mother's Touch"
	desc = "The Garou is able to heal the wounds of any living creature, aggravated or otherwise, simply by laying hands over the afflicted area."
	button_icon_state = "mothers_touch"
	click_to_activate = TRUE
	rank = 1

	rage_cost = 1 // CRIMSON EDIT CHANGE - Healer Buff PR (Salubri and Theurges) - Original: //rage_cost = 1
	//gnosis_cost = 1 // CRIMSON EDIT CHANGE - Healer Buff PR (Salubri and Theurges) - Original: gnosis_cost = 1


/datum/action/cooldown/power/gift/mothers_touch/Activate(atom/target)
	if(!isliving(target))
		return FALSE
	if(!(target in range(1, owner)))
		return FALSE

// CRIMSON GRID EDIT START- Healer Buff PR (Salubri and Theurges) - (Made it so you can't heal yourself and vampires that aren't Humanity 7+)
	var/mob/living/living_target = target

	if(living_target == owner)
		return FALSE
	if(get_kindred_splat(living_target))
		var/datum/st_stat/morality_path/morality/stat_morality = living_target.st_get_stat(STAT_MORALITY)
		if((stat_morality?.morality_path?.alignment != MORALITY_HUMANITY || stat_morality?.get_score() < 7) || HAS_TRAIT(src, TRAIT_HIDDEN_WYRMTAINT))
			return FALSE
// CRIMSON GRID EDIT END
	. = ..()
// CRIMSON GRID EDIT START- Healer Buff PR (Salubri and Theurges) -- Refactored the algorithim that determines rage.
	var/difficulty = 0

	if(get_shifter_splat(living_target))
		var/datum/splat/werewolf/werewolf_splat = get_werewolf_splat(owner)
		difficulty = werewolf_splat.uses_rage ? werewolf_splat.rage : 5
	else //tldr any other splat you use diff 5 cause no rage
		difficulty = 5
// CRIMSON GRID EDIT END- Healer Buff PR (Salubri and Theurges)
	var/successes = SSroll.storyteller_roll_datum(owner, target, /datum/storyteller_roll/gift/mothers_touch, difficulty = difficulty)
	living_target.heal_storyteller_health(successes * 2 , TRUE, TRUE, TRUE, TRUE) // CRIMSON EDIT CHANGE - Healer Buff PR (Salubri and Theurges) - Original: var/successes = SSroll.storyteller_roll_datum(owner, target, /datum/storyteller_roll/gift/mothers_touch, difficulty = difficulty)

	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)
	return TRUE

/datum/action/cooldown/power/gift/sense_wyrm
	name = "Sense Wyrm"
	desc = "This Gift allows the werewolf to trace the location of all wyrm-tainted entities within the area."
	button_icon_state = "sense_wyrm"
	rank = 1
	var/list/navigation_images = list()

/datum/action/cooldown/power/gift/sense_wyrm/Activate(atom/target)
	. = ..()
	cut_navigation()

	var/lowest_difficulty = 0
	var/list/wyrm_targets_in_range = list()
	for(var/mob/living/target_guy in orange(owner, 30))
		var/difficulty = get_sense_difficulty(target_guy)
		if(difficulty)
			if(!lowest_difficulty || (difficulty < lowest_difficulty))
				lowest_difficulty = difficulty
			wyrm_targets_in_range[target_guy] = difficulty

	if(!lowest_difficulty)
		return

	var/datum/storyteller_roll/roll_datum = new()
	roll_datum.applicable_stats = list(STAT_PERCEPTION, STAT_OCCULT)
	roll_datum.difficulty = lowest_difficulty
	var/roll_result = roll_datum.st_roll(owner)

	if(roll_result != ROLL_SUCCESS)
		return

	for(var/mob/living/target_guy, difficulty in wyrm_targets_in_range)
		var/list/path = get_path_to(owner, target_guy, 50, access = owner.get_access(), skip_first = FALSE)
		for(var/i in 1 to length(path))
			var/turf/current_turf = path[i]
			var/image/path_image = image(icon = 'icons/effects/effects.dmi', icon_state = "smoke", layer = HIGH_PIPE_LAYER, loc = current_turf)
			SET_PLANE(path_image, GAME_PLANE, current_turf)
			if(i == length(path))
				path_image.color = COLOR_PURPLE_GRAY
			else
				path_image.color = COLOR_PALE_PURPLE_GRAY
				path_image.alpha = rand(5, path_image.alpha/2)
			owner.client?.images += path_image
			navigation_images += path_image

	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(cut_navigation))

/datum/action/cooldown/power/gift/sense_wyrm/proc/cut_navigation()
	SIGNAL_HANDLER
	for(var/image/navigation_path in navigation_images)
		owner.client?.images -= navigation_path
	navigation_images.Cut()
	UnregisterSignal(owner, COMSIG_LIVING_DEATH)

/datum/action/cooldown/power/gift/sense_wyrm/proc/get_sense_difficulty(mob/living/target)
	if(HAS_TRAIT(target, TRAIT_HIDDEN_WYRMTAINT))
		return

	// To be used for stuff like banes.
	if(HAS_TRAIT(target, TRAIT_WYRMTAINTED))
		. = 6

	if(HAS_TRAIT(target, TRAIT_WYRMTAINTED_SPRITE))
		. = 5

	var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(target)
	if(kindred_splat)
		if(!target.is_enlightenment() && target.st_get_stat(STAT_MORALITY) >= 7)
			return
		. = 6

/datum/action/cooldown/power/gift/spirit_speech
	name = "Spirit Speech"
	desc = "This Gift allows the Garou to communicate with encountered spirits."
	button_icon_state = "spirit_speech"
	rank = 1

/datum/action/cooldown/power/gift/spirit_speech/Grant(mob/granted_to)
	. = ..()
	ADD_TRAIT(granted_to, TRAIT_LOCAL_SIXTHSENSE, GIFT_TRAIT)

/datum/action/cooldown/power/gift/spirit_speech/Activate(atom/target)
	. = ..()

	if(HAS_TRAIT_FROM(owner, TRAIT_LOCAL_SIXTHSENSE, GIFT_TRAIT))
		REMOVE_TRAIT(owner, TRAIT_LOCAL_SIXTHSENSE, GIFT_TRAIT)
		to_chat(owner, span_notice("You deactivate [name]."))
	else
		ADD_TRAIT(owner, TRAIT_LOCAL_SIXTHSENSE, GIFT_TRAIT)
		to_chat(owner, span_notice("You activate [name]."))

/datum/action/cooldown/power/gift/spirit_speech/Remove(mob/removed_from)
	. = ..()
	REMOVE_TRAIT(removed_from, TRAIT_LOCAL_SIXTHSENSE, GIFT_TRAIT)

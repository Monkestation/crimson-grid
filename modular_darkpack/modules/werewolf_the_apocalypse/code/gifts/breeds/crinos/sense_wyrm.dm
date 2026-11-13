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

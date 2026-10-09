/datum/action/cooldown/power/gift/heightened_senses
	name = "Heightened Senses"
	desc = "The player gains an uncanncy sense of perception and tracking ability"
	button_icon_state = "heightened_senses"
	rank = 1
	gnosis_cost = 1

/datum/action/cooldown/power/gift/heightened_senses/Activate(atom/target)
	var/mob/living/living_owner = astype(target)
	if(!living_owner)
		return

	. = ..()

	living_owner.apply_status_effect(/datum/status_effect/heightened_senses)


/datum/status_effect/heightened_senses
	id = "heightened_senses"
	duration = 1 SCENES
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/gift/heightened_senses
	var/datum/action/cooldown/uncanny_tracking/tracking_action

/datum/status_effect/heightened_senses/on_apply()
	RegisterSignal(owner, COMSIG_LIVING_PRE_DICE_ROLLED, PROC_REF(on_dice_rolled))

	tracking_action = new(owner)
	tracking_action.Grant(owner)

	// This is missing primal urge bonus.

	return TRUE

/datum/status_effect/heightened_senses/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_PRE_DICE_ROLLED)

	if(owner)
		tracking_action.Remove(owner)
	QDEL_NULL(tracking_action)

/datum/status_effect/heightened_senses/proc/on_dice_rolled(mob/living/roller, datum/storyteller_roll/roll_datum, atom/target, atom/using_item, bonus, difficulty)
	SIGNAL_HANDLER

	if(STAT_PERCEPTION in roll_datum.applicable_stats)
		if(iscrinos(roller) || ishispo(roller) || islupus(roller))
			*difficulty -= 3
			// In theory:
			// "this is not cumulative with the ordinary Lupus-form Perception bonuses"
			// But IDK what those are.
		else
			*difficulty -= 2


/atom/movable/screen/alert/status_effect/gift/heightened_senses
	name = /datum/action/cooldown/power/gift/heightened_senses::name
	desc = /datum/action/cooldown/power/gift/heightened_senses::desc
	overlay_state = /datum/action/cooldown/power/gift/heightened_senses::button_icon_state


/datum/action/cooldown/uncanny_tracking
	name = "Uncanny Tracking"
	desc = "Sense the location."
	button_icon = /datum/action/cooldown/power/gift/heightened_senses::button_icon
	button_icon_state = /datum/action/cooldown/power/gift/heightened_senses::button_icon_state
	check_flags = AB_CHECK_CONSCIOUS
	cooldown_time = 1 SCENES

	var/datum/storyteller_roll/gift/uncanny_tracking/roll_datum

/datum/action/cooldown/uncanny_tracking/Activate(atom/target)
	var/mob/living/living_owner = astype(owner)
	if(!living_owner)
		return

	var/mob/living/living_target = owner?.mind?.guestbook.pick_known_guy(owner)
	if(!istype(living_target))
		return

	. = ..()

	if(!roll_datum)
		roll_datum = new()
	var/roll_result = roll_datum.st_roll(living_owner, bonus_added = PRIMAL_URGE_PLACEHOLDER)

	if(roll_result != ROLL_SUCCESS)
		return

	living_owner.create_navigation_line(living_target)

/datum/storyteller_roll/gift/uncanny_tracking
	applicable_stats = list(STAT_PERCEPTION)
	difficulty = 8

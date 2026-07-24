/datum/action/cooldown/power/gift/aura_of_confidence
	name = "Aura of Confidence"
	desc = "The werewolf projects an aura of superiority, preventing attempts to find flaws or read auras."
	button_icon_state = "aura_of_confidence"
	rank = 1

// Effect is permenent
/datum/action/cooldown/power/gift/aura_of_confidence/Grant(mob/granted_to)
	. = ..()
	ADD_TRAIT(granted_to, TRAIT_AURA_OF_CONFIDENCE, GIFT_TRAIT)
	SEND_SIGNAL(granted_to, COMSIG_MOB_UPDATE_AURA)

/datum/action/cooldown/power/gift/aura_of_confidence/Remove(mob/removed_from)
	. = ..()
	REMOVE_TRAIT(removed_from, TRAIT_AURA_OF_CONFIDENCE, GIFT_TRAIT)
	SEND_SIGNAL(removed_from, COMSIG_MOB_UPDATE_AURA)



/datum/storyteller_roll/gift/fatal_flaw
	bumper_text = "Fatal Flaw"
	applicable_stats = list(STAT_PERCEPTION, STAT_EMPATHY)
	numerical = TRUE


/datum/action/cooldown/power/gift/fatal_flaw
	name = "Fatal Flaw"
	desc = "The Shadow Lord can spy a target's weakness, gaining an advantage in combat."
	button_icon_state = "fatal_flaw"
	rank = 1
	click_to_activate = TRUE

/datum/action/cooldown/power/gift/fatal_flaw/Activate(atom/target)
	var/mob/living/living_owner = astype(owner)
	var/mob/living/living_target = astype(target)
	if(!living_target || (living_target == owner))
		return FALSE
	if(!(target in range(DEFAULT_SIGHT_DISTANCE, owner)))
		return FALSE

	. = ..()

	if(!do_after(owner, 1 TURNS, timed_action_flags = (IGNORE_USER_LOC_CHANGE|IGNORE_HELD_ITEM)))
		return TRUE

	var/datum/storyteller_roll/gift/fatal_flaw/roll_datum = new()
	roll_datum.difficulty = living_target.st_get_stats(list(STAT_WITS, STAT_SUBTERFUGE))
	var/roll_result = roll_datum.st_roll(owner, target)

	if(roll_result <= 0)
		return TRUE

	living_owner?.apply_status_effect(/datum/status_effect/fatal_flaw, target)
	to_chat(owner, span_notice("You study [target] and discover a weakness granting you a bonus dice to attacks."))

	return TRUE


/datum/status_effect/fatal_flaw
	id = "fatal_flaw"
	duration = 1 SCENES

	status_type = STATUS_EFFECT_REPLACE

	alert_type = /atom/movable/screen/alert/status_effect/gift/fatal_flaw

	var/datum/weakref/target_ref
	var/image/highlight

/datum/status_effect/fatal_flaw/on_creation(mob/living/new_owner, mob/living/target)
	target_ref = WEAKREF(target)
	. = ..()

/datum/status_effect/fatal_flaw/on_apply()
	RegisterSignal(owner, COMSIG_LIVING_PRE_DICE_ROLLED, PROC_REF(on_dice_rolled))

	if(!owner?.client)
		return

	var/mob/living/target = target_ref?.resolve()
	if(QDELETED(target))
		return

	highlight = image(loc = target)
	highlight.appearance = target.appearance
	highlight.layer = target.layer - 0.01
	highlight.pixel_y = 0
	highlight.pixel_x = 0
	highlight.pixel_w = 0
	highlight.pixel_z = 0

	apply_wibbly_filters(highlight)

	highlight.add_filter("fatal_flaw", 1, outline_filter(size = 1, color = COLOR_PALE_GREEN_GRAY))

	owner.client.images += highlight

	return TRUE

/datum/status_effect/fatal_flaw/on_remove()
	owner.client?.images -= highlight
	QDEL_NULL(highlight)

	UnregisterSignal(owner, COMSIG_LIVING_PRE_DICE_ROLLED)

/datum/status_effect/fatal_flaw/proc/on_dice_rolled(mob/living/roller, datum/storyteller_roll/roll_datum, atom/target)
	SIGNAL_HANDLER

	if(!istype(roll_datum, /datum/storyteller_roll/damage))
		return

	if(!target || (target != target_ref?.resolve()))
		return

	. += 1 // One extra dice


/atom/movable/screen/alert/status_effect/gift/fatal_flaw
	name = /datum/action/cooldown/power/gift/fatal_flaw::name
	desc = /datum/action/cooldown/power/gift/fatal_flaw::desc
	overlay_state = /datum/action/cooldown/power/gift/fatal_flaw::button_icon_state

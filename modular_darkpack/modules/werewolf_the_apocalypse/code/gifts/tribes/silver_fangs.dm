/**
 * The werewolf’s hands or jaws tighten in a mighty death-grip, making it nearly
 * impossible to escape. A falcon-spirit teaches this Gift.
 *
 * System: The player spends one Rage point. For the rest of the scene,
 * the Garou’s grip (with both hands and jaws) is much stronger — her Strength
 * is considered three points higher for grappling or maneuvers such as the jaw
 * lock (see Special Maneuvers, p. 299).
 * This extra Strength does not apply to damage rolls.
 **/
/datum/action/cooldown/power/gift/falcons_grasp
	name = "Falcon's Grasp"
	desc = "The Garou's hands or jaws tighten in a mighty death-grip, making it nearly impossible to escape."
	button_icon_state = "falcons_grasp"
	cooldown_time = 1 SCENES
	rank = 1
	rage_cost = 1

/datum/action/cooldown/power/gift/falcons_grasp/Activate(atom/target)
	var/mob/living/owner = astype(src.owner)
	if(isnull(owner))
		return FALSE

	. = ..()
	owner.apply_status_effect(/datum/status_effect/falcons_grasp)


/datum/status_effect/falcons_grasp
	id = "falcons_grasp"
	duration = 1 SCENES

	status_type = STATUS_EFFECT_UNIQUE

	alert_type = /atom/movable/screen/alert/status_effect/gift/falcons_grasp

/datum/status_effect/falcons_grasp/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_PRE_DICE_ROLLED, PROC_REF(apply_grapple_mod))
	RegisterSignal(owner, COMSIG_LIVING_GRAB, PROC_REF(aggro_grab_hack))

/datum/status_effect/falcons_grasp/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_PRE_DICE_ROLLED)
	return ..()

/datum/status_effect/falcons_grasp/proc/aggro_grab_hack(mob/living/source, mob/living/target)
	// SIGNAL_HANDLER // it screams about an (unreachable) sleep otherwise

	if(source.pulling || source == target)
		return NONE // run the default grab code

	. = COMPONENT_SKIP_ATTACK // lets assume that if it doafters we should skip
	if(source.start_pulling(target, null, MOVE_FORCE_OVERPOWERING, TRUE)) // state arg does nothing :)
		target.drop_all_held_items()
		source.setGrabState(GRAB_NECK) //Instant aggressive grab if on grab intent
		playsound(source.loc, 'sound/items/weapons/thudswoosh.ogg', 50, TRUE, -1)
		target.visible_message(span_warning("[source] clamp-grabs [target] by [target.p_their()] neck!"), span_warning("[source] clamp-grabs you by your neck!"), null, null, src)
		to_chat(src, span_notice("You clamp-grab [target] by [target.p_their()] neck!"))
		return COMPONENT_SKIP_ATTACK
	return NONE // meh

/datum/status_effect/falcons_grasp/proc/apply_grapple_mod(mob/living/roller, datum/storyteller_roll/roll_datum, atom/target, atom/using_item, bonus, difficulty)
	SIGNAL_HANDLER

	if(istype(roll_datum, /datum/storyteller_roll/grappling))
		*bonus += 3


/atom/movable/screen/alert/status_effect/gift/falcons_grasp
	name = /datum/action/cooldown/power/gift/falcons_grasp::name
	desc = "For the rest of the scene, you gain a +3 bonus to grappling rolls, and your grabs instantly escalate to neck grabs."
	overlay_state = /datum/action/cooldown/power/gift/falcons_grasp::button_icon_state

/datum/action/cooldown/power
	abstract_type = /datum/action/cooldown/power
	cooldown_time = 1 TURNS // Good default.

	/// The level/rank at which this power is taken or can be taken at.
	var/rank = 0
	// Not used presently but good future proofing incase behavoirs care.
	/// Means that this action is not a real power, but some sort of innate ability we represent as a power/disc/gift mechnaicly.
	var/innate_ability = FALSE

	/// If the power manually calls `StartCooldown`, otherwise handled by Activate
	var/handles_cooldown = FALSE
	/// If the power manually calls `spend_resources` itself, otherwise handled by Activate
	var/handles_spend_resources = FALSE

	/// How much temporary willpower is required to use this ability
	var/willpower_cost = 0

/datum/action/cooldown/power/IsAvailable(feedback)
	. = ..()

	if(!can_afford(feedback))
		return FALSE

/datum/action/cooldown/power/Activate(atom/target)
	if(!handles_cooldown)
		. = ..()

	if(!handles_spend_resources)
		spend_resources()


/**
 * Returns a boolean of if the caster can afford
 * this power's cost cost.
 */
/datum/action/cooldown/power/proc/can_afford(feedback)
	if(willpower_cost && isliving(owner))
		var/mob/living/living_owner = owner
		if(willpower_cost > living_owner.st_get_stat(STAT_TEMPORARY_WILLPOWER))
			if(feedback)
				to_chat(owner, span_warning("You don't have enough willpower to do that!"))
			return FALSE
	return TRUE

/**
 * Overridable proc handling the spending of resources (willpower/vitae/rage/etc)
 * when casting the power.
 */
/datum/action/cooldown/power/proc/spend_resources()
	SHOULD_CALL_PARENT(TRUE)

	if(willpower_cost && isliving(owner))
		var/mob/living/living_owner = owner
		living_owner.st_change_stat(STAT_TEMPORARY_WILLPOWER, -willpower_cost)
		to_chat(owner, span_warning("You burn [willpower_cost] willpower."))

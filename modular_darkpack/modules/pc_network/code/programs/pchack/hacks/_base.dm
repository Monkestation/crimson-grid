/datum/pc_hack
	var/name = "Hack"
	var/desc = "Does something nasty."
	/// Added to the roll difficulty on top of the network's difficulty
	var/difficulty_mod = 0

/// Return a string explaining why this can't be used on the target, or null if it can.
/// Checked before the roll, so an invalid target doesn't burn the cooldown.
/datum/pc_hack/proc/can_target(atom/target)
	return null

/// Runs on a successful roll. Returns the text shown to the hacker.
/datum/pc_hack/proc/execute(datum/pc_program/hacking/source, atom/target, mob/user)
	return "Done."

/// Whether this hack is offered for the target at all. PC hacks are the default.
/datum/pc_hack/proc/applies_to(atom/target)
	return istype(target, /obj/machinery/computer/pc)

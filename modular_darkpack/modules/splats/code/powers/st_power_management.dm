/**
 * Standardize this all when the power system is made universal, the procs
 * have to be implemented on every subtype because powers are currently
 * completely unrelated datums.
 */

/datum/splat/proc/get_power(power_type)
	RETURN_TYPE(/datum/action)

	CRASH("get_power() not implemented for [type]!")

/datum/splat/proc/add_power(power_type, level)
	CRASH("add_power() not implemented for [type]!")

/datum/splat/proc/remove_power(power_type)
	CRASH("remove_power() not implemented for [type]!")

/datum/splat/proc/change_power_level(power_type, new_level)
	CRASH("change_power_level() not implemented for [type]!")

/datum/splat/proc/get_selected_power()
	CRASH("get_selected_power() not implemented for [type]!")

/datum/splat/proc/set_selected_power(datum/action/selected_power)
	CRASH("set_selected_power() not implemented for [type]!")

/**
 * Internal proc to clean up all power instances owned by this splat. Called by
 * unassign() on losing the splat.
 */
/datum/splat/proc/clear_powers()
	PRIVATE_PROC(TRUE)

	QDEL_LAZYLIST(powers)

/**
 * Add a list of powers with certain levels to the mob.
 *
 * Defaults to level 1 if no corresponding level is given for a power. Adds the
 * power to a splat that can support it, fails if no splats compatible with
 * the power are found.
 *
 * Arguments:
 * * power_types - List of powers to add to the mob.
 * * levels - List of power levels to apply to the power of the same index.
 */
/mob/living/carbon/human/proc/give_st_powers(list/power_types, list/levels)
	for (var/index in 1 to length(power_types))
		var/power_type = power_types[index]

		var/datum/splat/found_splat = get_splat_with_power_type(power_type)
		if (!found_splat)
			continue

		// Default to level 1 if none is supplied
		var/level = length(levels) >= index ? levels[index] : 1

		give_st_power(power_type, level)

/**
 * Add a power with a certain level to the mob. Fails if no splat compatible
 * with the power is found
 */
/mob/living/carbon/human/proc/give_st_power(power_type, level = 1)
	var/datum/splat/found_splat = get_splat_with_power_type(power_type)
	if (!found_splat)
		return FALSE

	return found_splat.add_power(power_type, level)

/**
 * Remove a power from the mob.
 */
/mob/living/carbon/human/proc/remove_st_power(power_type)
	var/datum/splat/found_splat = get_splat_with_power_type(power_type)
	if (!found_splat)
		return FALSE

	return found_splat.remove_power(power_type)

/**
 * Change the level of a power the mob possesses.
 */
/mob/living/carbon/human/proc/change_st_power_level(power_type, new_level)
	var/datum/splat/found_splat = get_splat_with_power_type(power_type)
	if (!found_splat)
		return FALSE

	return found_splat.change_power_level(power_type, new_level)

/**
 * Returns a splat the mob possesses that can use the given power type. Null if
 * none found.
 */
/mob/living/proc/get_splat_with_power_type(power_type)
	RETURN_TYPE(/datum/splat)

	for (var/datum/splat/checking_splat as anything in splats)
		if (!ispath(power_type, checking_splat.power_type))
			continue

		return checking_splat

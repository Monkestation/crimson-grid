/**
 * Returns the instance of the given splat type possessed by the mob, or null
 * if not found.
 */
/mob/proc/get_splat(splat_type)
	RETURN_TYPE(/datum/splat)

	return

/mob/living/get_splat(splat_type)
	RETURN_TYPE(/datum/splat)

	return locate(splat_type) in splats

/**
 * Creates a new splat of the given type with the given arguments and assigns it
 * to the mob.
 */
/mob/living/proc/add_splat(splat_type, ...)
	RETURN_TYPE(/datum/splat)

	var/datum/splat/adding_splat
	if (length(args) > 1)
		adding_splat = new splat_type(arglist(args.Copy(2)))
	else
		adding_splat = new splat_type()

	return adding_splat.assign(src)

/**
 * Deletes the splat of the given type possessed by the mob. Returns TRUE if
 * found and deleted, or false if not.
 */
/mob/living/proc/remove_splat(splat_type)
	var/datum/splat/removing_splat = get_splat(splat_type)
	if (removing_splat)
		qdel(removing_splat)
		return TRUE

	return FALSE

/**
 * Clears all the splats from the mob/living
 * Mostly used in unit tests
 */
/mob/living/proc/clear_splats()
	if(splats)
		for(var/datum/splat/splat_in_list in splats)
			remove_splat(splat_in_list)

/**
 * Returns if the given splat type can be added to the mob or not.
 * Incompatibilities are due to an existing splat clashing with it or the given
 * splat type already being present.
 */
/mob/living/proc/is_splat_compatible(splat_type)
	for (var/datum/splat/splat as anything in splats)
		if (is_type_in_list(splat_type, splat.incompatible_splats))
			return FALSE
		if (splat.type == splat_type)
			return FALSE

	return TRUE

/// Returns the splat with the highest priority, with a preference for ones first assigned.
/mob/living/proc/get_primary_splat(splat_type, count_splat = TRUE, count_halfsplat = TRUE)
	RETURN_TYPE(/datum/splat)

	var/datum/splat/returning_splat
	for(var/datum/splat/our_splat in splats)
		if(!count_halfsplat && our_splat::half_splat)
			continue
		if(!count_splat && !our_splat::half_splat)
			continue

		if(!returning_splat || our_splat.splat_priority > returning_splat.splat_priority)
			returning_splat = our_splat
	return returning_splat

/// Returns the first splat in our list that is a full real spalt
/mob/living/proc/get_full_splat(splat_type)
	RETURN_TYPE(/datum/splat)

	return get_primary_splat(splat_type, count_halfsplat = FALSE)

/// Returns the first splat in our list that is a half splat, which also SOMETIMES still means they are considered human if no other splats.
/mob/living/proc/get_half_splat(splat_type)
	RETURN_TYPE(/datum/splat)

	return get_primary_splat(splat_type, count_splat = FALSE)

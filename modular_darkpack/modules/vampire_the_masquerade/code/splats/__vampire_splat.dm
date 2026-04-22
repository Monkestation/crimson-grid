/datum/splat/vampire
	abstract_type = /datum/splat/vampire

	power_type = /datum/discipline

/datum/splat/vampire/proc/get_discipline_power(datum/discipline_power/discipline_power_type)
	RETURN_TYPE(/datum/discipline_power)

	return get_discipline(discipline_power_type::discipline)?.get_power(discipline_power_type)

/datum/splat/vampire/proc/get_discipline(discipline_type)
	RETURN_TYPE(/datum/discipline)

	return get_power(discipline_type)?.discipline

/mob/living/proc/get_discipline(discipline_type)
	RETURN_TYPE(/datum/discipline)

	var/datum/splat/vampire/vampire = get_splat_with_discipline(src)
	return vampire?.get_discipline(discipline_type)

/datum/splat/vampire/get_power(power_type)
	RETURN_TYPE(/datum/action/discipline)

	for (var/datum/action/discipline/found_action as anything in powers)
		if (!istype(found_action.discipline, power_type))
			continue

		return found_action

/datum/splat/vampire/add_power(power_type, level)
	// Prevent duplicates
	if (get_power(power_type))
		return FALSE
	var/datum/discipline/new_discipline = new power_type(level)
	var/datum/action/discipline/adding_action = new new_discipline.action_type(owner, new_discipline)
	adding_action.Grant(owner)
	LAZYADD(powers, adding_action)
	return TRUE

/datum/splat/vampire/remove_power(power_type)
	var/datum/action/discipline/found_action = get_power(power_type)
	if (!found_action)
		return FALSE

	LAZYREMOVE(powers, found_action)
	qdel(found_action)
	return TRUE

/datum/splat/vampire/change_power_level(power_type, new_level)
	var/datum/action/discipline/found_action = get_power(power_type)
	if (!found_action)
		return FALSE

	found_action.discipline.set_level(new_level)
	return TRUE

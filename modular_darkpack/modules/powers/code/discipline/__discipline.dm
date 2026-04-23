/datum/discipline
	/* CUSTOMIZABLE */
	///Name of this Discipline.
	var/name = "Discipline name"
	///Text description of this Discipline.
	var/desc = "Discipline description"
	///Icon file for this Discipline
	var/icon = 'modular_darkpack/modules/powers/icons/actions.dmi'
	///Icon state for this Discipline
	var/icon_state
	///If this Discipline is unique to a certain Clan.
	var/clan_restricted = FALSE
	///The root type of the powers this Discipline uses.
	var/power_type = /datum/discipline_power
	///What action type this Discipline is connected to
	var/action_type = /datum/action/discipline
	///If this Discipline can be selected at all, or has special handling.
	var/selectable = TRUE
	///Override for the number of selectable levels shown in UI. 0 = derive from all_powers length. this exists because of Thaumaturgy.
	var/max_selectable_level = 0

	/* BACKEND */
	///What rank, or how many dots the caster has in this Discipline.
	var/level = 1
	///What rank of this Discipline is currently being casted.
	var/level_casting = 1
	///The power that is currently in use.
	var/datum/discipline_power/current_power
	///All Discipline powers under this Discipline that the owner knows. Derived from all_powers.
	var/list/datum/discipline_power/known_powers = list()
	///The typepaths of possible powers for every rank in this Discipline.
	var/list/all_powers = list()
	///The mob that owns and is using this Discipline.
	var/mob/living/carbon/human/owner
	///If this Discipline has been assigned before and post_gain effects have already been applied.
	var/post_gain_applied
	/// Signature clan that "owns" the discipline.
	var/signature_clan

/datum/discipline/New(level)
	all_powers = subtypesof(power_type)
	if (!level)
		return

	src.level = level
	var/amount = level // how many levels are we giving them
	if(level > length(all_powers)) // the amount of disc levels we are trying to give is greater than the amount of subtypes that exist for it
		amount = length(all_powers) // so only give what exists
	for (var/i in 1 to amount)
		var/type_to_create = all_powers[i]
		var/datum/discipline_power/new_power = new type_to_create(src)
		known_powers += new_power
	current_power = known_powers[1]

/datum/discipline/Destroy(force)
	action_type = null
	QDEL_NULL(current_power)
	QDEL_LIST(known_powers)
	all_powers = null
	owner = null
	return ..()

/**
 * Modifies a Discipline's level, updating its available powers
 * to conform to the new level. This proc will be removed when
 * power loadouts are implemented, but for now it's useful for dynamically
 * adding and removing powers.
 *
 * Arguments:
 * * level - the level to set the Discipline as, powers included
 */
/datum/discipline/proc/set_level(level)
	if (level == src.level)
		return

	var/list/datum/discipline_power/new_known_powers = list()
	for (var/i in 1 to level)
		if (length(known_powers) >= level)
			new_known_powers.Add(known_powers[i])
		else
			var/adding_power_type = all_powers[i]
			var/datum/discipline_power/new_power = new adding_power_type(src)
			new_known_powers.Add(new_power)
			new_power.post_gain()

	//delete orphaned powers
	var/list/datum/discipline_power/leftover_powers = known_powers - new_known_powers
	if (length(leftover_powers))
		QDEL_LIST(leftover_powers)

	known_powers = new_known_powers
	src.level = level

/**
 * Assigns the Discipline to a mob, setting its owner and applying
 * post_gain effects while also setting up reference cleaning when
 * the owner is destroyed.
 *
 * Arguments:
 * * owner - the mob to assign the Discipline to
 */
/datum/discipline/proc/assign(mob/owner)
	src.owner = owner
	for (var/datum/discipline_power/power in known_powers)
		power.owner = owner

	if (!post_gain_applied)
		post_gain()
	post_gain_applied = TRUE

/**
 * Returns a known Discipline power in this Discipline
 * searching by type.
 *
 * Arguments:
 * * power - the power type to search for
 */
/datum/discipline/proc/get_power(power)
	if (!ispath(power))
		return
	for (var/datum/discipline_power/found_power in known_powers)
		if (found_power.type == power)
			return found_power

/**
 * Applies effects specific to the Discipline to
 * its owner. Also triggers post_gain effects of all
 * known (possessed) powers. Meant to be overridden
 * for modular code.
 */
/datum/discipline/proc/post_gain()
	SHOULD_CALL_PARENT(TRUE)

	for (var/datum/discipline_power/power in known_powers)
		power.post_gain()


/**
* Removes effects from it's owner upon loss.
*/
/datum/discipline/proc/post_loss()
	SHOULD_CALL_PARENT(TRUE)

	for (var/datum/discipline_power/power in known_powers)
		power.post_loss()

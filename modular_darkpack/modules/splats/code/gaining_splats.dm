/**
 * Effects on gaining the splat.
 *
 * Overridable proc that handles all splat-specific behavior when the splat is
 * gained. Called in assign() after the owner gained the splat and its traits,
 * actions, and biotypes were added.
 */
/datum/splat/proc/on_gain()
	return

/**
 * Assign this splat to a new owner.
 *
 * Fails if the new owner cannot be given the splat or a signal return cancels
 * it. Proceeds to give the splat to the owner and add its traits, actions, and
 * biotypes before applying on_gain() effects. Returns the splat on success.
 *
 * Arguments:
 * * owner - Mob gaining the splat.
 */
/datum/splat/proc/assign(mob/living/owner)
	SHOULD_NOT_OVERRIDE(TRUE)

	// Cannot add this splat, return null and let the calling proc handle it
	if (!owner.is_splat_compatible(type))
		return

	// Allow for splat gain to also be prevented by a signal response
	var/signal_return = SEND_SIGNAL(owner, COMSIG_LIVING_GAINING_SPLAT, src)
	if (signal_return & SPLAT_PREVENT_GAIN)
		return

	src.owner = owner
	LAZYADD(owner.splats, src)

	add_splat_traits()
	add_actions()
	add_biotypes()

	on_gain()

	if(owner.hud_used)
		add_relevent_huds(owner.hud_used)

	SEND_SIGNAL(owner, COMSIG_LIVING_GAINED_SPLAT, src)
	return src

/**
 * Internal proc to add all of the splat's traits to the new owner on gain.
 */
/datum/splat/proc/add_splat_traits()
	PRIVATE_PROC(TRUE)

	LAZYINITLIST(splat_traits)
	owner.add_traits(splat_traits, id)

/**
 * Internal proc to add all of the splat's actions to the new owner on gain.
 */
/datum/splat/proc/add_actions()
	PRIVATE_PROC(TRUE)

	for (var/adding_action in splat_actions)
		var/datum/action/new_action = new adding_action
		new_action.Grant(owner)

/**
 * Internal proc to add all of the splat's biotypes to the new owner on gain.
 */
/datum/splat/proc/add_biotypes()
	PRIVATE_PROC(TRUE)

	for (var/adding_biotype in splat_biotypes)
		owner.mob_biotypes |= adding_biotype

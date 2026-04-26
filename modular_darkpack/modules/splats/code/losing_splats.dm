/**
 * Effects on losing the splat normally.
 *
 * Overridable proc that handles most splat-specific behavior when the splat is
 * lost. Called in unassign() before any part of the splat is removed from the
 * owner. Not called if the owner is being deleted.
 */
/datum/splat/proc/on_lose()
	return

/**
 * Effects on losing the splat if the owner isn't null.
 *
 * Overridable proc that handles splat-specific behavior when the splat is lost.
 * Called in unassign() before anything else whether or not the owner is being
 * deleted. Should be used only for cleanup like removing the owner from a
 * splat-specific global list.
 */
/datum/splat/proc/on_lose_or_destroy()
	return

/**
 * Remove this splat from its owner.
 *
 * Fails if the owner is null, or cleans up the splat if the owner is being
 * deleted. First applies on_lose() effects then removes all of the splat's
 * traits, actions, and biotypes that were added in assign() before removing
 * the splat entirely.
 */
/datum/splat/proc/unassign()
	SHOULD_NOT_OVERRIDE(TRUE)

	if (owner)
		on_lose_or_destroy()

	if (QDELETED(owner))
		owner = null
		clear_powers()
		return


	on_lose()

	clear_powers()

	remove_splat_traits()
	remove_actions()
	remove_biotypes()

	LAZYREMOVE(owner.splats, src)
	SEND_SIGNAL(owner, COMSIG_LIVING_LOSE_SPLAT, src)
	owner = null

/datum/splat/Destroy()
	SHOULD_CALL_PARENT(TRUE)

	unassign()

	return ..()

/**
 * Internal proc to remove all of the traits added by this splat on lose.
 */
/datum/splat/proc/remove_splat_traits()
	PRIVATE_PROC(TRUE)

	REMOVE_TRAITS_IN(owner, id)

/**
 * Internal proc to remove all of the actions added by this splat on lose.
 * Checks for and skips actions that also belong to another splat.
 */
/datum/splat/proc/remove_actions()
	PRIVATE_PROC(TRUE)

	// to make sure we don't remove another splat's actions
	var/list/other_splat_actions = list()
	for (var/datum/splat/splat in (owner.splats - src))
		other_splat_actions |= splat.splat_actions

	// actually remove the actions
	for (var/removing_action in splat_actions)
		if (removing_action in other_splat_actions)
			continue

		for (var/datum/action/action in owner.actions)
			if (!istype(action, removing_action))
				continue

			action.Remove(owner)

/**
 * Internal proc to remove all of the biotypes added by this splat on lose.
 * Checks for and skips biotypes added by the owner's species or other splats.
 */
/datum/splat/proc/remove_biotypes()
	PRIVATE_PROC(TRUE)

	// Make sure we don't remove biotypes they should have without the splat
	var/skip_biotypes = NONE
	for (var/datum/splat/splat in (owner.splats - src))
		skip_biotypes |= splat.splat_biotypes
	if (ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		skip_biotypes |= human_owner.dna?.species?.inherent_biotypes

	// Remove the biotypes
	for (var/biotype in splat_biotypes)
		if (skip_biotypes & biotype)
			continue

		owner.mob_biotypes &= ~biotype

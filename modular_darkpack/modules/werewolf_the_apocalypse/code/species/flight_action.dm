/datum/action/innate/toggle_fera_flight // this action handles fera forms toggle their flight, and swaps their sprite to be of the relevant type.
	name = "Toggle Flight"
	desc = "Unfurl or withdraw your wings, toggling your ability to fly"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_IMMOBILE
	button_icon = 'modular_darkpack/master_files/icons/hud/actions.dmi'
	button_icon_state = "fly"

/datum/action/innate/toggle_fera_flight/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/fera_mob = owner
	if(!istype(fera_mob))
		return
	if (!(HAS_TRAIT(fera_mob, TRAIT_MOVE_FLYING)))
		to_chat(fera_mob, span_notice("You beat your wings and begin to hover gently above the ground..."))
		fera_mob.add_traits(list(TRAIT_MOVE_FLYING, TRAIT_NO_FLOATING_ANIM), ACTION_TRAIT)
	else
		to_chat(fera_mob, span_notice("You settle gently back onto the ground..."))
		fera_mob.remove_traits(list(TRAIT_MOVE_FLYING, TRAIT_NO_FLOATING_ANIM), ACTION_TRAIT)

	fera_mob.update_body_parts()
	// fera_mob.update_icon(UPDATE_ICON)

/datum/action/innate/toggle_fera_flight/Remove(mob/removed_from)
	var/mob/living/carbon/human/fera_mob = owner
	if(!istype(fera_mob))
		return
	to_chat(fera_mob, span_notice("You settle gently back onto the ground..."))
	fera_mob.remove_traits(list(TRAIT_MOVE_FLYING, TRAIT_NO_FLOATING_ANIM), ACTION_TRAIT)

	fera_mob.update_body_parts()

	return ..()

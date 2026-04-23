/obj/item/vtm_artifact/bloodstone
	true_name = "bloodstone"
	true_desc = "A pulsing crimson stone that creates a mystical bond with its identifier."
	icon = 'modular_darkpack/modules/paths/icons/bloodstone_artifact.dmi'
	onflooricon = 'modular_darkpack/modules/paths/icons/bloodstone_artifact.dmi'
	icon_state = "bloodstone"
	can_be_identified_without_ritual = FALSE // the bloodstone is a tremere-specific creation, its actually technically created via ritual.
	var/datum/weakref/bound_identifier // Who identified it first
	var/datum/action/bloodstone_track/tracking_action
	research_value = 15

/obj/item/vtm_artifact/bloodstone/identify()
	. = ..()
	if(identified && !bound_identifier)
		var/mob/living/carbon/human/user = usr
		if(ishuman(user))
			bound_identifier = WEAKREF(user)
			to_chat(user, span_warning("The bloodstone pulses with dark energy as it bonds to your essence. You will always know its location."))

			tracking_action = new /datum/action/bloodstone_track(user, src)
			tracking_action.Grant(user)

/obj/item/vtm_artifact/bloodstone/Destroy()
	if(tracking_action)
		var/mob/living/carbon/human/user = bound_identifier.resolve()
		if(user)
			tracking_action.Remove(user)
		QDEL_NULL(tracking_action)
	bound_identifier = null
	return ..()

/datum/action/bloodstone_track
	name = "Track Bloodstone"
	desc = "Sense the location of your bound bloodstone."
	button_icon = 'modular_darkpack/modules/paths/icons/bloodstone_artifact.dmi'
	button_icon_state = "bloodstone_track"
	check_flags = AB_CHECK_CONSCIOUS
	var/datum/weakref/tracked_stone

/datum/action/bloodstone_track/New(Target, obj/item/vtm_artifact/bloodstone/stone)
	. = ..()
	tracked_stone = WEAKREF(stone)

/datum/action/bloodstone_track/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return

	var/obj/item/vtm_artifact/bloodstone/bloodstone = tracked_stone.resolve()
	if(!bloodstone)
		to_chat(owner, span_warning("The bloodstone bond has been severed."))
		Remove(owner)
		qdel(src)
		return FALSE

	var/turf/stone_turf = get_turf(bloodstone)
	if(!stone_turf)
		to_chat(owner, span_warning("You cannot sense the bloodstone's location."))
		return FALSE

	var/area/stone_area = get_area(bloodstone)
	to_chat(owner, span_notice("The bloodstone whispers its location: [stone_area.name] ([stone_turf.x], [stone_turf.y])"))
	return TRUE

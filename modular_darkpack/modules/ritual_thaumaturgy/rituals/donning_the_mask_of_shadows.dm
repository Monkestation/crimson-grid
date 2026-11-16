// v20 core rulebook page 233
/obj/ritual_rune/thaumaturgy/donning_the_mask_of_shadows
	name = "donning the mask of shadows"
	desc = "Renders the caster's visage smoky and footsteps muffled. Requires a glass shard."
	icon_state = "rune1"
	word = ""
	level = 2
	sacrifices = list(/obj/item/shard)

/obj/ritual_rune/thaumaturgy/donning_the_mask_of_shadows/complete()
	. = ..()
	last_activator.apply_status_effect(/datum/status_effect/mask_of_shadows, last_sucess_amount MINUTES)
	qdel(src)

/datum/status_effect/mask_of_shadows
	id = "mask_of_shadows"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/mask_of_shadows
	var/datum/action/remove_mask_of_shadows_action/mask_action

/datum/status_effect/mask_of_shadows/on_creation(mob/living/new_owner, duration)
	src.duration = duration
	return ..()

/datum/status_effect/mask_of_shadows/on_apply()
	. = ..()
	owner.alpha = 50
	owner.color = "#5f5f5f"
	mask_action = new(owner)
	mask_action.Grant(owner)
	ADD_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, TRAIT_STATUS_EFFECT(id))
	ADD_TRAIT(owner, TRAIT_UNKNOWN_APPEARANCE, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/mask_of_shadows/on_remove()
	owner.alpha = 255
	owner.color = null
	if(mask_action)
		mask_action.Remove(owner)
		qdel(mask_action)
	REMOVE_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, TRAIT_STATUS_EFFECT(id))
	REMOVE_TRAIT(owner, TRAIT_UNKNOWN_APPEARANCE, TRAIT_STATUS_EFFECT(id))
	return ..()

/datum/action/remove_mask_of_shadows_action
	name = "Become Visible"
	desc = "Lower the Mask of Shadows and become visible."
	button_icon = 'modular_darkpack/modules/powers/icons/actions.dmi'
	button_icon_state = "thaumaturgy"

/datum/action/remove_mask_of_shadows_action/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!isliving(owner))
		return
	var/mob/living/living_owner = owner
	living_owner.remove_status_effect(/datum/status_effect/mask_of_shadows)

/atom/movable/screen/alert/status_effect/mask_of_shadows
	name = "Mask of Shadows"
	desc = "Your visage is obscured by shadows."
	overlay_icon = 'modular_darkpack/modules/powers/icons/actions.dmi'
	overlay_state = "thaumaturgy"

/datum/status_effect/grouped/static_look
	id = "static look"
	duration = STATUS_EFFECT_PERMANENT

/datum/status_effect/grouped/static_look/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_CLIENT_LOGIN, PROC_REF(show_unconscious_hud))
	if(GET_CLIENT(owner)) // let's not waste time giving the hud to non-player characters
		show_unconscious_hud(owner)

/datum/status_effect/grouped/static_look/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_CLIENT_LOGIN))
	if(GET_CLIENT(owner))
		hide_unconscious_hud(owner)
	return ..()

/// Global list of images that correspond to a mob's unconscious appearance
GLOBAL_LIST_EMPTY(unconscious_appearances)

/datum/status_effect/grouped/static_look/proc/show_unconscious_hud(mob/living/source)
	SIGNAL_HANDLER

	source.client?.images += (GLOB.unconscious_appearances - source.unconscious_appearance)

/datum/status_effect/grouped/static_look/proc/hide_unconscious_hud(mob/living/source)
	SIGNAL_HANDLER

	source.client?.images -= GLOB.unconscious_appearances

/datum/status_effect/close_the_ways
	id = "close_the_ways"
	status_type = STATUS_EFFECT_REPLACE
	duration = 15 MINUTES

/datum/status_effect/close_the_ways/on_creation(mob/living/new_owner, duration = 15 MINUTES)
	src.duration = duration
	return ..()

/datum/status_effect/curse_of_oedipus
	id = "curse_of_oedipus"
	status_type = STATUS_EFFECT_REPLACE
	duration = 1 SCENES
	alert_type = /atom/movable/screen/alert/status_effect/curse_of_oedipus

/datum/status_effect/curse_of_oedipus/on_creation(mob/living/new_owner, duration = 1 SCENES)
	src.duration = duration
	return ..()

/datum/status_effect/curse_of_oedipus/on_apply()
	. = ..()
	owner.become_blind(id)
	to_chat(owner, span_warning("You feel dark energy tearing at your eyes!"))
	return TRUE

/datum/status_effect/curse_of_oedipus/on_remove()
	owner.cure_blind(id)
	to_chat(owner, span_notice("Your vision returns."))
	return ..()

/atom/movable/screen/alert/status_effect/curse_of_oedipus
	name = "Curse of Oedipus"
	desc = "The dark energies stole your vision and you can no longer see."
	icon_state = "blooddrunk"

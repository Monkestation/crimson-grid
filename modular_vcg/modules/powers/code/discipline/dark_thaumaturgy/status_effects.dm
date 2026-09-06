/datum/status_effect/pain_botch
    id = "pain_botch"
    duration = -1
    status_type = STATUS_EFFECT_REFRESH
    alert_type = /atom/movable/screen/alert/status_effect/pain_botch

/atom/movable/screen/alert/status_effect/pain_botch
	name = "Path of Pain Botch"
	desc = "You scratch your own skin, thirsting for pain."
	icon_state = "blooddrunk"

/datum/status_effect/pain_botch/on_creation(mob/living/carbon/new_owner)
    . = ..()
    ADD_TRAIT(owner, TRAIT_PAIN_BOTCH, MAGIC_TRAIT)

/datum/status_effect/pain_botch/on_remove()
    . = ..()
    REMOVE_TRAIT(owner, TRAIT_PAIN_BOTCH, MAGIC_TRAIT)

/datum/discipline_power/dark_thaumaturgy/path/pain/proc/pain_botch_effect()
	if(!owner.has_status_effect(/datum/status_effect/pain_botch))
		owner.apply_status_effect(/datum/status_effect/pain_botch)
		use_counter = 0
	to_chat(owner, span_warning("You scratch your own skin, thirsting for pain."))
	owner.Stun(3 SECONDS, TRUE)
	owner.do_jitter_animation(3 SECONDS)


// HUNDRED DEATHS STATUS EFFECT
/datum/status_effect/hundred_deaths
	id = "hundred_deaths"
	duration = 2 SCENES //~six minutes
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/hundred_deaths

/atom/movable/screen/alert/status_effect/hundred_deaths
	name = "One Hundred Deaths"
	desc = "You feel the weight of one hundred deaths crushing your body and soul."
	icon_state = "blooddrunk"

/datum/status_effect/hundred_deaths/on_creation(mob/living/carbon/new_owner)
    . = ..()

/datum/status_effect/hundred_deaths/on_remove()
	. = ..()
	owner.maxHealth = owner.maxHealth + 50

/datum/discipline_power/dark_thaumaturgy/path/pain/proc/hundred_deaths_effect()  // Yes. this is very powerful. You need to sacrafice at LEAST 8 eighth-generation vampires at MIMIMUM to even HAVE access to it.
	if(!owner.has_status_effect(/datum/status_effect/hundred_deaths))
		owner.apply_status_effect(/datum/status_effect/hundred_deaths)
		use_counter = 0
	to_chat(owner, span_danger("You feel the weight of a hundred deaths overwhelm your spirit. Its as if your life is slipping away in the roil of pressure."))
	owner.Stun(7 SECONDS, TRUE)
	owner.do_jitter_animation(7 SECONDS)
	owner.maxHealth = owner.maxHealth - 50

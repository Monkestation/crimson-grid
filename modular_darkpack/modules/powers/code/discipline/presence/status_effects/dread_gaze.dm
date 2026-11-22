/datum/status_effect/dread_gaze //Used for extended effect of dreadgaze
	id = "dread_gaze"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 5 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/dread_gaze

/datum/status_effect/dread_gaze/on_creation(mob/living/new_owner, generation, time)
	. = ..()
	if(time)
		duration = time
	//owner.st_add_stat_mod(STAT_DEXTERITY, -4)	//Nukes your dex temporarily CRIMSON EDIT REMOVAL 

/atom/movable/screen/alert/status_effect/dread_gaze
	name = "Overwhelming Dread"
	desc = "That person- that THING is a monster! I don't stand a chance!"
	icon_state = "hypnosis"

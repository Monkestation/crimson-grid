/* Stimulant Colour */

#define STIM_PHASE_HIGH 1
#define STIM_PHASE_FADING 2
#define STIM_PHASE_HOLDING 3
#define STIM_PHASE_RECOVERING 4
#define STIM_FADE_TIME (15 SECONDS)
#define STIM_RECOVER_TIME (15 SECONDS)
#define STIM_FLOOR_SATURATION 0.33

/proc/stimulant_saturation_matrix(saturation)
	var/r = 0.33
	var/g = 0.59
	var/b = 0.11
	return list(
		r + saturation * (1 - r), r * (1 - saturation), r * (1 - saturation), 0,
		g * (1 - saturation), g + saturation * (1 - g), g * (1 - saturation), 0,
		b * (1 - saturation), b * (1 - saturation), b + saturation * (1 - b), 0,
		0, 0, 0, 1,
		0, 0, 0, 0)

/datum/client_colour/stimulant
	priority = CLIENT_COLOR_ORGAN_PRIORITY

/datum/status_effect/stimulant_colour
	id = "stimulant_colour"
	duration = -1
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	var/phase = STIM_PHASE_HIGH
	var/phase_time_left = 0
	var/hold_time = 0
	var/peak = 0
	var/datum/client_colour/stimulant/our_colour

/datum/status_effect/stimulant_colour/on_apply()
	our_colour = owner.add_client_colour(/datum/client_colour/stimulant, id)
	return TRUE

/datum/status_effect/stimulant_colour/on_remove()
	owner.remove_client_colour(id)
	our_colour = null

/datum/status_effect/stimulant_colour/proc/animate_to(saturation, over)
	our_colour?.update_color(stimulant_saturation_matrix(saturation), over)

/datum/status_effect/stimulant_colour/proc/take_dose(new_peak, recovery_minutes)
	hold_time = max(hold_time, recovery_minutes MINUTES)
	if(phase == STIM_PHASE_HIGH && new_peak <= peak)
		return
	peak = max(peak, new_peak)
	phase = STIM_PHASE_HIGH
	phase_time_left = 0
	animate_to(1 + (0.5 * peak), 1 SECONDS)

/datum/status_effect/stimulant_colour/tick(seconds_between_ticks)
	if(owner.stat == DEAD)
		qdel(src)
		return
	if(still_dosed())
		return

	switch(phase)
		if(STIM_PHASE_HIGH)
			phase = STIM_PHASE_FADING
			phase_time_left = STIM_FADE_TIME
			peak = 0
			animate_to(STIM_FLOOR_SATURATION, STIM_FADE_TIME)

		if(STIM_PHASE_FADING)
			phase_time_left -= tick_interval
			if(phase_time_left <= 0)
				phase = STIM_PHASE_HOLDING
				phase_time_left = hold_time

		if(STIM_PHASE_HOLDING)
			if(in_withdrawal())
				return
			phase_time_left -= tick_interval
			if(phase_time_left <= 0)
				phase = STIM_PHASE_RECOVERING
				phase_time_left = STIM_RECOVER_TIME
				hold_time = 0
				animate_to(1, STIM_RECOVER_TIME)

		if(STIM_PHASE_RECOVERING)
			phase_time_left -= tick_interval
			if(phase_time_left <= 0)
				qdel(src)

/datum/status_effect/stimulant_colour/proc/still_dosed()
	if(owner.reagents?.has_reagent(/datum/reagent/drug/cocaine))
		return TRUE
	return owner.reagents?.has_reagent(/datum/reagent/drug/methamphetamine)

/datum/status_effect/stimulant_colour/proc/in_withdrawal()
	return LAZYACCESS(owner.mind?.active_addictions, /datum/addiction/stimulants)

/mob/living/proc/take_stimulant_dose(peak, recovery_minutes)
	var/datum/status_effect/stimulant_colour/effect = has_status_effect(/datum/status_effect/stimulant_colour)
	if(!effect)
		effect = apply_status_effect(/datum/status_effect/stimulant_colour)
	if(istype(effect))
		effect.take_dose(peak, recovery_minutes)

#undef STIM_PHASE_HIGH
#undef STIM_PHASE_FADING
#undef STIM_PHASE_HOLDING
#undef STIM_PHASE_RECOVERING
#undef STIM_FADE_TIME
#undef STIM_RECOVER_TIME
#undef STIM_FLOOR_SATURATION

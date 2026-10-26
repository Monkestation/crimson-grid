#define STAMINA_LOSS_PER_TICK 7 // 105 Total

/datum/status_effect/daimonion_dread
	id = "daimonion_dread"
	status_type = STATUS_EFFECT_REFRESH
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/daimonion_dread

/datum/status_effect/daimonion_dread/tick(seconds_between_ticks)
	. = ..()
	owner.do_jitter_animation(1 SECONDS)
	owner.adjust_stamina_loss(STAMINA_LOSS_PER_TICK, TRUE)

/atom/movable/screen/alert/status_effect/daimonion_dread
	name = "Unnatural Tremors"
	desc = "Even after it passed you still find yourself shaking!"
	icon_state = "hypnosis"

#undef STAMINA_LOSS_PER_TICK

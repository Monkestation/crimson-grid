//Old cocaine copy pasted all the meth procs while still being subtyped under it. With parent calls and everything
/* // CRIMSON EDIT REMOVAL START - Drug Fixes And Rework
/datum/reagent/drug/methamphetamine/cocaine
	name = "Cocaine"
	color = "#ffffff"
	taste_description = "bitter numbness" // CRIMSON EDIT ADD - Drug Fixes And Rework
*/ // CRIMSON EDIT REMOVAL END - Drug Fixes And Rework

// CRIMSON EDIT ADD START - Drug Fixes And Rework
/datum/actionspeed_modifier/cocaine
	multiplicative_slowdown = -0.25

/datum/reagent/drug/cocaine
	name = "Cocaine"
	description = "A stimulant refined from the coca leaf. Sharpens the hands and wears out the heart."
	color = "#ffffff"
	taste_description = "bitter numbness"
	overdose_threshold = 20
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	ph = 8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	addiction_types = list(/datum/addiction/stimulants = 75)
	metabolized_traits = list(TRAIT_STIMULATED, TRAIT_BLOWN_PUPILS)

/datum/reagent/drug/cocaine/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.add_actionspeed_modifier(/datum/actionspeed_modifier/cocaine)
	SEND_SOUND(affected_mob, sound('sound/effects/health/fastbeat.ogg', repeat = TRUE, channel = CHANNEL_HEARTBEAT, volume = 30))

/datum/reagent/drug/cocaine/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.remove_actionspeed_modifier(/datum/actionspeed_modifier/cocaine)
	if(!IS_UNCONSCIOUS_OR_CRIT(affected_mob))
		affected_mob.stop_sound_channel(CHANNEL_HEARTBEAT)

/datum/reagent/drug/cocaine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(2.5, seconds_per_tick))
		to_chat(affected_mob, span_notice(pick("Everything looks sharp.", "You could do this all night.", "Your jaw aches.", "You are certain. About all of it.", "Your heart is working hard for you.", "The colours are louder.", "You keep swallowing. Your throat is numb.", "Your chest is warm and busy.")))
	affected_mob.add_mood_event("tweaking", /datum/mood_event/stimulant_medium)
	affected_mob.take_stimulant_dose(peak = 1, recovery_minutes = 5)
	affected_mob.set_jitter_if_lower(1.33 SECONDS * metabolization_ratio * seconds_per_tick)
	if(affected_mob.adjust_organ_loss(ORGAN_SLOT_HEART, 0.33 * (0.1 + 0.04 * volume) * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags))
		. = UPDATE_MOB_HEALTH

/datum/reagent/drug/cocaine/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(10, seconds_per_tick))
		to_chat(affected_mob, span_userdanger("Your chest goes tight and your heart will not slow down!"))
		playsound(affected_mob, 'sound/effects/singlebeat.ogg', 100, TRUE)
	if(SPT_PROB(15, seconds_per_tick))
		to_chat(affected_mob, span_danger(pick("Your ears are ringing.", "Your left arm has gone heavy.", "You cannot get a full breath.")))
	if(affected_mob.adjust_organ_loss(ORGAN_SLOT_HEART, 0.33 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags))
		return UPDATE_MOB_HEALTH
// CRIMSON EDIT ADD END - Drug Fixes And Rework

/datum/mood_event/mdma_high
	description = "I love everyone. Everything is warm and golden."
	mood_change = 8

/datum/mood_event/mdma_comedown
	description = "Everything is grey and quiet. I miss the warmth."
	mood_change = -6
	timeout = 10 MINUTES

/datum/reagent/drug/mdma
	name = "MDMA"
	description = "A euphoric party drug that makes everything feel warm and connected. Restores stamina and lifts mood, but raises body temperature, and the comedown is rough. Overdoses overheat the user."
	color = "#e8d9ff"
	taste_description = "bitter chalk"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30
	chemical_flags = NONE
	randomized_spawns = REAGENT_SPAWN_NO_RANDOM
	addiction_types = list(/datum/addiction/hallucinogens = 20)
	var/list/high_messages = list(
		"You feel warm and connected.",
		"Everything feels wonderful.",
		"You want to hug someone.",
		"The music sounds incredible.",
		"Your jaw is clenching.",
	)

/datum/reagent/drug/mdma/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(5, seconds_per_tick))
		to_chat(affected_mob, span_notice(pick(high_messages)))
	affected_mob.add_mood_event("[type]_high", /datum/mood_event/mdma_high)
	affected_mob.adjust_disgust(-1 * metabolization_ratio * seconds_per_tick)
	affected_mob.set_jitter_if_lower(1.5 SECONDS * metabolization_ratio * seconds_per_tick)
	affected_mob.adjust_bodytemperature((0.5 + volume * 0.05) * metabolization_ratio * seconds_per_tick, max_temp = BODYTEMP_NORMAL + 12)
	if(affected_mob.adjust_stamina_loss(-1.5 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/mdma/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	if(current_cycle > 10)
		affected_mob.add_mood_event("[type]_comedown", /datum/mood_event/mdma_comedown)

/datum/reagent/drug/mdma/overdose_start(mob/living/affected_mob, metabolization_ratio)
	. = ..()
	to_chat(affected_mob, span_userdanger("Your heart is hammering and you feel like you're burning up!"))

/datum/reagent/drug/mdma/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(4 * metabolization_ratio * seconds_per_tick, max_temp = BODYTEMP_NORMAL + 40)
	affected_mob.set_jitter_if_lower(8 SECONDS * metabolization_ratio * seconds_per_tick)
	if(SPT_PROB(8, seconds_per_tick))
		affected_mob.set_dizzy_if_lower(20 SECONDS)
	if(SPT_PROB(5, seconds_per_tick))
		affected_mob.adjust_hallucinations_up_to(10 SECONDS * metabolization_ratio * seconds_per_tick, 30 SECONDS)
	var/need_mob_update
	need_mob_update = affected_mob.adjust_tox_loss(0.4 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 0.3 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

///this is a drug type because I want custom everything not the weird toxic shit
/datum/reagent/drug/fentanyl
	name = "Fentanyl"
	description = "A synthetic opioid far stronger than anything pressed from a poppy. Numbs pain and sedates, but the gap between a dose and an overdose is thin. Overdoses suppress breathing."
	color = "#d8d8e0"
	taste_description = "faint bitterness"
	overdose_threshold = 12
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	ph = 7
	chemical_flags = NONE
	randomized_spawns = REAGENT_SPAWN_NO_RANDOM
	addiction_types = list(/datum/addiction/opioids = 80)
	metabolized_traits = list(TRAIT_ANALGESIA)

/datum/reagent/drug/fentanyl/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(2.5, seconds_per_tick))
		to_chat(affected_mob, span_notice(pick("You feel warm and heavy.", "The pain is gone.", "Everything is very far away.")))
	affected_mob.add_mood_event("[type]_high", /datum/mood_event/narcotic_heavy)
	affected_mob.adjust_drowsiness(2 SECONDS * metabolization_ratio * seconds_per_tick)
	// Sluggish: you're sedated, not rested
	if(affected_mob.adjust_stamina_loss(0.8 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

/datum/reagent/drug/fentanyl/overdose_start(mob/living/affected_mob, metabolization_ratio)
	. = ..()
	to_chat(affected_mob, span_userdanger("Your chest feels heavy and every breath is a struggle..."))

/datum/reagent/drug/fentanyl/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(15, seconds_per_tick))
		affected_mob.losebreath++
	if(SPT_PROB(6, seconds_per_tick))
		affected_mob.visible_message(span_danger("[affected_mob] nods off mid-breath."), span_userdanger("You can't keep your eyes open..."))
		affected_mob.Sleeping(8 SECONDS)
	var/need_mob_update
	need_mob_update = affected_mob.adjust_oxy_loss(1.5 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, 0.3 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

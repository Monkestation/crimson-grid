/datum/reagent/wyrmtaint
	name = "sludge"
	description = "unidentified sludge"
	color = "#000000"
	taste_mult = 0
	chemical_flags = REAGENT_INVISIBLE
	metabolization_rate = 0.01 * REAGENTS_METABOLISM
	self_consuming = TRUE
	purge_multiplier = 0
	var/taint_cycles = 40

/datum/reagent/wyrmtaint/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(current_cycle >= taint_cycles )
		ADD_TRAIT(affected_mob, TRAIT_WYRMTAINTED, type)

/datum/reagent/wyrmtaint/on_mob_delete(mob/living/affected_mob)
	. = ..()
	REMOVE_TRAIT(affected_mob, TRAIT_WYRMTAINTED, type)

/datum/reagent/medicine/modafinil/magafinil
	name = "magafinil"

/datum/reagent/medicine/modafinil/magafinil/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.st_add_stat_mod(STAT_ALERTNESS, 1, type)
	affected_mob.st_add_stat_mod(STAT_PERCEPTION, 1, type)

/datum/reagent/medicine/modafinil/magafinil/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.st_remove_stat_mod(STAT_ALERTNESS, type)
	affected_mob.st_remove_stat_mod(STAT_PERCEPTION, type)

/datum/reagent/medicine/modafinil/magafinil/on_mob_life(mob/living/carbon/metabolizer, seconds_per_tick, metabolization_ratio)
	. = ..()
	holder.add_reagent(/datum/reagent/wyrmtaint, 0.1 * metabolization_ratio * seconds_per_tick)

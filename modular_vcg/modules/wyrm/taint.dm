/datum/reagent/wyrmtaint
	name = "sludge"
	description = "unidentified sludge"
	color = "#000000"
	taste_mult = 0
	chemical_flags = REAGENT_INVISIBLE
	metabolization_rate = 0.02 * REAGENTS_METABOLISM
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
	name = "Magafinil"

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

/datum/reagent/drug/happiness/magaloft
	name = "Magaloft"

/datum/reagent/drug/happiness/magaloft/on_mob_life(mob/living/carbon/metabolizer, seconds_per_tick, metabolization_ratio)
	. = ..()
	holder.add_reagent(/datum/reagent/wyrmtaint, 0.1 * metabolization_ratio * seconds_per_tick)

/obj/item/reagent_containers/applicator/pill/magaloft
	name = "magaloft pill"
	desc = "Used to alleviate anxiety and depression, proven to have no side effects*."
	list_reagents = list(/datum/reagent/drug/happiness/magaloft = 5)
	icon_state = "pill_happy"
	rename_with_volume = TRUE

/obj/item/storage/pill_bottle/magaloft
	name = "magaloft antidepressants"
	desc = "Antidepressants with no proven side effects*."
	spawn_count = 5
	spawn_type = /obj/item/reagent_containers/applicator/pill/magaloft

/obj/item/reagent_containers/applicator/pill/magafinil
	name = "magafinil pill"
	desc = "Used to treat symptoms of drowsiness and sudden loss of consciousness."
	list_reagents = list(/datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/synaptizine = 5, /datum/reagent/medicine/modafinil/magafinil = 3)
	icon_state = "pill15"

/obj/item/storage/pill_bottle/magafinil
	name = "bottle of magafinil pills"
	desc = "A bottle of magafinil pills used to help prevent drowsiness and increase alertness."
	spawn_count = 7
	spawn_type = /obj/item/reagent_containers/applicator/pill/magafinil

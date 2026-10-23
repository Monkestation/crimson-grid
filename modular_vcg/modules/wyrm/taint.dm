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
	affected_mob.st_add_stat_mod(STAT_DEXTERITY, 1, type)
	affected_mob.st_add_stat_mod(STAT_PERCEPTION, 1, type)

/datum/reagent/medicine/modafinil/magafinil/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.st_remove_stat_mod(STAT_ALERTNESS, type)
	affected_mob.st_remove_stat_mod(STAT_DEXTERITY, type)
	affected_mob.st_remove_stat_mod(STAT_PERCEPTION, type)

/datum/reagent/medicine/modafinil/magafinil/on_mob_life(mob/living/carbon/metabolizer, seconds_per_tick, metabolization_ratio)
	. = ..()
	holder.add_reagent(/datum/reagent/wyrmtaint, 0.1 * metabolization_ratio * seconds_per_tick)

/datum/reagent/drug/happiness/magaloft
	name = "Magaloft"

/datum/reagent/drug/happiness/magaloft/on_mob_life(mob/living/carbon/metabolizer, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(10, seconds_per_tick))
		holder.add_reagent(/datum/reagent/wyrmtaint, 0.1 * metabolization_ratio * seconds_per_tick)

/datum/reagent/medicine/neurine/magaversidin
	name = "magaversidin"
	overdose_threshold = 15
	var/forgot = FALSE

/datum/reagent/medicine/neurine/magaversidin/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if (!forgot)
		forgot = TRUE
		SEND_SIGNAL(affected_mob, COMSIG_ALL_MASQUERADE_REINFORCE)
		affected_mob.visible_message(span_danger("[affected_mob] looks around and is confused at where they are"))
		to_chat(affected_mob, span_warning("You can't seem to recall the last 20 minutes!"))
	if(prob(10))
		affected_mob.adjust_drowsiness(5 SECONDS)
	if(prob(35))
		affected_mob.adjust_dizzy_up_to(15 SECONDS, 100 SECONDS)

/obj/item/reagent_containers/applicator/pill/magaloft
	name = "magaloft pill"
	desc = "Used to alleviate anxiety and depression, proven to have no side effects*."
	list_reagents = list(/datum/reagent/drug/happiness/magaloft = 5)
	icon_state = "pill_happy"
	rename_with_volume = TRUE

/obj/item/reagent_containers/applicator/pill/magafinil
	name = "magafinil pill"
	desc = "Used to treat symptoms of drowsiness and sudden loss of consciousness."
	list_reagents = list(/datum/reagent/consumable/sugar = 5, /datum/reagent/medicine/synaptizine = 5, /datum/reagent/medicine/modafinil/magafinil = 3)
	icon_state = "pill15"

/obj/item/reagent_containers/applicator/pill/magaversidin
	name = "magaversidin pill"
	desc = "Used to treat symptoms of Alzheimer's."
	list_reagents = list(/datum/reagent/medicine/neurine/magaversidin = 3)
	icon_state = "pill17"

/obj/item/reagent_containers/hypospray/medipen/flubuster
	name = "flubuster"
	desc = "Very effective cold and flu relief product containing a broad and wide spectrum of all medicine and drugs from cold medicine to stimulants to painkillers."
	list_reagents = list(/datum/reagent/medicine/stimulants = 20, /datum/reagent/medicine/omnizine = 10, /datum/reagent/wyrmtaint = 10, /datum/reagent/medicine/morphine = 5, /datum/reagent/drug/happiness/magaloft = 5)
	volume = 50

/obj/item/reagent_containers/hypospray/medipen/amnestics
	name = "amnestics"
	desc = "This medipen dosen't have any labels or anything."
	list_reagents = list(/datum/reagent/medicine/neurine/magaversidin = 20)
	volume = 20

/obj/item/storage/pill_bottle/magaloft
	name = "bottle of magaloft antidepressants"
	desc = "Antidepressants with no proven side effects*."
	spawn_count = 7
	spawn_type = /obj/item/reagent_containers/applicator/pill/magaloft

/obj/item/storage/pill_bottle/magafinil
	name = "bottle of magafinil pills"
	desc = "A bottle of magafinil pills used to help prevent drowsiness and increase alertness."
	spawn_count = 7
	spawn_type = /obj/item/reagent_containers/applicator/pill/magafinil

/obj/item/storage/pill_bottle/magaversidin
	name = "bottle of magaversidin pills"
	desc = "A bottle of magaversidin pills used to treat Alzheimer's. There is a back with a small and tiny fine print."
	spawn_count = 7
	spawn_type = /obj/item/reagent_containers/applicator/pill/magaversidin

/obj/item/storage/box/amnestics
	name = "box of amnestics"
	desc = "A box full of amnestics MediPens."
	illustration = "epipen"

/obj/item/storage/box/medipens/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/hypospray/medipen/amnestics(src)

/obj/item/storage/box/flubuster
	name = "box of flubusters"
	desc = "A box full of flubusters MediPens."
	illustration = "epipen"

/obj/item/storage/box/medipens/PopulateContents()
	for(var/i in 1 to 7)
		new /obj/item/reagent_containers/hypospray/medipen/flubuster(src)

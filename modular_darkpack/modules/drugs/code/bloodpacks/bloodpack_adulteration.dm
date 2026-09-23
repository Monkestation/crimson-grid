/obj/item/reagent_containers/blood/random/drug_filled
	start_blood_amount = 180 // Leave room for the drugs.

/obj/item/reagent_containers/blood/random/drug_filled/meth
	list_reagents = list(/datum/reagent/drug/methamphetamine = 15)
	start_blood_amount = 185

/obj/item/reagent_containers/blood/random/drug_filled/coke
	list_reagents = list(/datum/reagent/drug/cocaine = 15) // CRIMSON EDIT - Drug Fixes And Rework - Original: /datum/reagent/drug/methamphetamine/cocaine
	start_blood_amount = 185

/obj/item/reagent_containers/blood/random/drug_filled/morphine
	list_reagents = list(/datum/reagent/toxin/chloralhydrate = 10, /datum/reagent/medicine/morphine = 10)

/// Rebuilds an item's contents from a purity: the product reagent, with the rest cut with sugar.
/proc/fill_with_purity(obj/item/item, reagent_type, purity, total = 10)
	if(!item.reagents)
		return
	item.reagents.clear_reagents()
	if(reagent_type)
		item.reagents.add_reagent(reagent_type, total * purity / 100)
	item.reagents.add_reagent(/datum/reagent/consumable/sugar, total * (100 - purity) / 100)

/// Lab output whose contents are built from a purity (the rest is cut with sugar).
/obj/item/food/drug/lab_product
	abstract_type = /obj/item/food/drug/lab_product
	/// 0-100, how pure this is. Customers pay more for higher purity.
	var/purity = 100
	/// What the purity is a share of
	var/product_reagent
	/// Total units in the item, product plus cut
	var/reagent_total = 10

/obj/item/food/drug/lab_product/Initialize(mapload, new_purity = 100)
	. = ..()
	purity = clamp(new_purity, 0, 100)
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)
	fill_with_purity(src, product_reagent, purity, reagent_total)

/obj/item/food/drug/lab_product/examine(mob/user)
	. = ..()
	switch(purity)
		if(90 to 100)
			. += span_notice("Flawless. A buyer would pay extra for this.")
		if(60 to 89)
			. += span_notice("Good quality, with a few impurities.")
		if(30 to 59)
			. += span_notice("Uneven and cut. A buyer will notice.")
		else
			. += span_warning("Badly cut garbage.")

/obj/item/food/drug/lab_product/mdma
	name = "pressed pill"
	desc = "A small stamped pill."
	icon_state = "pill_canister"
	icon = 'modular_darkpack/modules/drugs/icons/items.dmi'
	product_reagent = /datum/reagent/drug/mdma
	tastes = list("bitter chalk" = 1)

/obj/item/food/drug/lab_product/yayo
	name = "bag of yayo"
	desc = "A small baggie of fine white powder."
	icon_state = "package_cocaine"
	icon = 'modular_darkpack/modules/drugs/icons/items.dmi'
	product_reagent = /datum/reagent/drug/cocaine
	tastes = list("numbing bitterness" = 1)

/// Potent, so each pill holds far less than the others. Two pure pills is already an overdose.
/obj/item/food/drug/lab_product/fentanyl
	name = "counterfeit pill"
	desc = "A stamped pill, a little too perfect. It could pass for something off a pharmacy shelf."
	icon_state = "pill_canister"
	icon = 'modular_darkpack/modules/drugs/icons/items.dmi'
	product_reagent = /datum/reagent/drug/fentanyl
	reagent_total = 5
	tastes = list("faint bitterness" = 1)

/obj/item/food/drug/meth_crystal/batch
	/// 0-100, how pure this crystal is. Customers pay more for higher purity.
	var/purity = 100

/obj/item/food/drug/meth_crystal/batch/Initialize(mapload, new_purity = 100)
	. = ..()
	purity = clamp(new_purity, 0, 100)
	// meth_crystal's Initialize adds a flat 10u of meth, rebuild it from purity (the rest is cut)
	fill_with_purity(src, /datum/reagent/drug/methamphetamine, purity)

/obj/item/food/drug/meth_crystal/batch/examine(mob/user)
	. = ..()
	switch(purity)
		if(90 to 100)
			. += span_notice("These are flawless, glass-clear shards.")
		if(60 to 89)
			. += span_notice("Mostly clear, with a few cloudy flecks.")
		if(30 to 59)
			. += span_notice("Cloudy and uneven. A buyer will notice.")
		else
			. += span_warning("Chalky, yellowed garbage.")

/// Being an opium subtype means the existing opium product matches it with no changes.
/obj/item/food/drug/opium/batch
	/// 0-100, how pure this is. Customers pay more for higher purity.
	var/purity = 100

/obj/item/food/drug/opium/batch/Initialize(mapload, new_purity = 100)
	. = ..()
	purity = clamp(new_purity, 0, 100)
	// Rebuild whatever opium starts with from purity (the rest is cut)
	fill_with_purity(src, /datum/reagent/medicine/morphine, purity)

/obj/item/food/drug/opium/batch/examine(mob/user)
	. = ..()
	switch(purity)
		if(90 to 100)
			. += span_notice("Dark, glossy and even. This is the good stuff.")
		if(60 to 89)
			. += span_notice("Dark resin with a few gritty patches.")
		if(30 to 59)
			. += span_notice("Dull and crumbly. A buyer will notice.")
		else
			. += span_warning("Pale, brittle sludge.")

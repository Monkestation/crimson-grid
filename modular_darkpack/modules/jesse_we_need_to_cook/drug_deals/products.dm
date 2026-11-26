GLOBAL_LIST_INIT(drug_products, init_drug_products())

/proc/init_drug_products()
	var/list/products = list()
	for(var/product_type in valid_subtypesof(/datum/drug_product))
		var/datum/drug_product/product = new product_type()
		products[product] = product.weight
	return products

/datum/drug_product
	abstract_type = /datum/drug_product
	var/name = "unnamed product"
	/// Any item that is an istype() of one of these counts as this product.
	var/list/item_types = list()
	/// Price per item before the customer's wealth and purity modifiers.
	var/base_price = 10
	/// Relative chance of being asked for.
	var/weight = 1
	var/min_amount = 1
	var/max_amount = 3
	/// Reagent whose share of the item's contents decides purity. Null = this product has no purity.
	var/purity_reagent
	/// Minimum purities a customer can demand. Only used when purity_reagent is set.
	var/list/min_purity_choices = list(0, 0, 30, 50, 70)

/datum/drug_product/proc/matches(obj/item/item)
	for(var/item_type in item_types)
		if(istype(item, item_type))
			return TRUE
	return FALSE

/// 0-100 purity of the item, or null if this product doesn't have purity.
/datum/drug_product/proc/get_purity(obj/item/item)
	if(!purity_reagent)
		return null
	if(!item.reagents || !item.reagents.total_volume)
		return 0
	return clamp(round(item.reagents.get_reagent_amount(purity_reagent) / item.reagents.total_volume * 100), 0, 100)

/datum/drug_product/proc/roll_min_purity()
	if(!purity_reagent || !length(min_purity_choices))
		return 0
	return pick(min_purity_choices)

/// Some products come in variants (cannabis strains). Returns a variant to demand, or null for "any".
/datum/drug_product/proc/roll_variant()
	return null

/datum/drug_product/proc/variant_name(variant)
	return ""

/datum/drug_product/proc/matches_variant(obj/item/item, variant)
	return TRUE

/datum/drug_product/proc/variant_price_mult(variant)
	return variant ? 1.25 : 1

/datum/drug_product/meth
	name = "crystal meth"
	item_types = list(/obj/item/food/drug/meth_crystal)
	base_price = 60
	weight = 3
	purity_reagent = /datum/reagent/drug/methamphetamine

/datum/drug_product/opium
	name = "opium"
	item_types = list(/obj/item/food/drug/opium)
	base_price = 35
	weight = 2
	purity_reagent = /datum/reagent/medicine/morphine
	min_purity_choices = list(0, 0, 30, 50)

/datum/drug_product/mdma
	name = "MDMA"
	item_types = list(/obj/item/food/drug/lab_product/mdma)
	base_price = 45
	weight = 2
	min_amount = 2
	max_amount = 4
	purity_reagent = /datum/reagent/drug/mdma

/datum/drug_product/yayo
	name = "yayo"
	item_types = list(/obj/item/food/drug/lab_product/yayo)
	base_price = 90
	weight = 1
	max_amount = 2
	purity_reagent = /datum/reagent/drug/cocaine

/datum/drug_product/fentanyl
	name = "fentanyl"
	item_types = list(/obj/item/food/drug/lab_product/fentanyl)
	base_price = 80
	weight = 1
	max_amount = 2
	purity_reagent = /datum/reagent/drug/fentanyl
	min_purity_choices = list(0, 30, 50, 70)

/datum/drug_product/cannabis
	name = "cannabis bud"
	item_types = list(/obj/item/food/grown/cannabis)
	base_price = 20
	weight = 4
	min_amount = 2
	max_amount = 5

/datum/drug_product/cannabis/roll_variant()
	if(prob(50))
		return null
	return pick(subtypesof(/datum/reagent/drug/cannabis))

/datum/drug_product/cannabis/variant_name(variant)
	var/datum/reagent/drug/cannabis/strain = variant
	return initial(strain.name)

/datum/drug_product/cannabis/matches_variant(obj/item/item, variant)
	if(!variant)
		return TRUE
	return !!item.reagents?.has_reagent(variant)

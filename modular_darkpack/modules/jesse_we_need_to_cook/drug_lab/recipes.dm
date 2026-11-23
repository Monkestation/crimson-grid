GLOBAL_LIST_INIT(lab_recipes, init_lab_recipes())

/proc/init_lab_recipes()
	var/list/recipes = list()
	for(var/recipe_type in valid_subtypesof(/datum/lab_recipe))
		recipes += new recipe_type()
	return recipes

/datum/lab_recipe
	abstract_type = /datum/lab_recipe
	var/name = "unnamed recipe"
	var/desc = ""
	/// Slot typepath > how many go in. Order matters: the first slot that accepts an item wins.
	var/list/slots = list()
	/// Spawned with (loc, purity)
	var/output_type
	var/output_name = "product"
	var/base_yield = 2
	/// Extra items per this much purity
	var/yield_divisor = 25
	/// Added to instability when scaling the minigames. Harder recipes = higher number.
	var/base_difficulty = 0
	/// Toxin damage to everyone next to the lab when a batch is ruined.
	var/ruin_damage = 8

/// The slot this item fills for this recipe, or null if it isn't an ingredient.
/datum/lab_recipe/proc/find_slot(obj/item/tool)
	for(var/slot_type in slots)
		var/datum/lab_slot/slot = GLOB.lab_slots[slot_type]
		if(slot.accepts(tool))
			return slot
	return null

/datum/lab_recipe/meth
	name = "Crystal meth"
	desc = "The classic. Gasoline, ephedrine, and a mix of other reagents. Order matters."
	slots = list(
		/datum/lab_slot/meth_gas = 1,
		/datum/lab_slot/meth_ephedrine = 3,
		/datum/lab_slot/meth_other = 2,
	)
	output_type = /obj/item/food/drug/meth_crystal/batch
	output_name = "crystals"
	base_yield = 2
	base_difficulty = 0

/datum/lab_recipe/mdma
	name = "MDMA"
	desc = "Club staple. Press bulk stock with a catalyst, then bind it. Binder goes in last."
	slots = list(
		/datum/lab_slot/supply/stock = 2,
		/datum/lab_slot/supply/catalyst = 1,
		/datum/lab_slot/supply/finisher/binder = 1,
	)
	output_type = /obj/item/food/drug/lab_product/mdma
	output_name = "pills"
	base_yield = 3
	base_difficulty = 1

/datum/lab_recipe/yayo
	name = "Yayo"
	desc = "High-value powder. Fussy to make: leaves, catalyst, then refiner. Refiner goes in last."
	slots = list(
		/datum/lab_slot/supply/leaf = 3,
		/datum/lab_slot/supply/catalyst = 1,
		/datum/lab_slot/supply/finisher/refiner = 1,
	)
	output_type = /obj/item/food/drug/lab_product/yayo
	output_name = "bags"
	base_yield = 2
	yield_divisor = 20
	base_difficulty = 2

/datum/lab_recipe/fentanyl
	name = "Fentanyl"
	desc = "Unforgiving. Tiny margins, and a bad batch will poison everyone in the room. Catalyst first, then refine, then bind."
	slots = list(
		/datum/lab_slot/supply/precursor = 2,
		/datum/lab_slot/supply/catalyst = 1,
		/datum/lab_slot/supply/finisher/refiner = 1,
		/datum/lab_slot/supply/finisher/binder = 1,
	)
	output_type = /obj/item/food/drug/lab_product/fentanyl
	output_name = "pills"
	base_yield = 4
	yield_divisor = 25
	base_difficulty = 3
	ruin_damage = 15

/datum/lab_recipe/opium
	name = "Opium"
	desc = "Slow and forgiving. Boil down the poppies, then add the solvent once they're all in."
	slots = list(
		/datum/lab_slot/supply/poppy = 3,
		/datum/lab_slot/supply/finisher/solvent = 1,
	)
	output_type = /obj/item/food/drug/opium/batch
	output_name = "lumps of opium"
	base_yield = 2
	base_difficulty = 1

/obj/item/lab_supply
	abstract_type = /obj/item/lab_supply
	name = "lab supply"
	desc = "Unmarked supplies for a chemical laboratory."
	icon = 'icons/obj/storage/box.dmi'
	icon_state = "box"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/lab_supply/stock
	name = "bulk stock"
	desc = "A sealed bag of unlabeled stock. Goes in a chemical laboratory."

/obj/item/lab_supply/leaf
	name = "dried leaf bundle"
	desc = "A tied bundle of dried leaves. Goes in a chemical laboratory."

/obj/item/lab_supply/catalyst
	name = "catalyst vial"
	desc = "A small sealed vial. Goes in a chemical laboratory."

/obj/item/lab_supply/binder
	name = "pressing binder"
	desc = "A tub of fine binding powder. Goes in a chemical laboratory."

/obj/item/lab_supply/refiner
	name = "refining agent"
	desc = "A heavy flask of refining agent. Goes in a chemical laboratory."

/obj/item/lab_supply/poppy
	name = "raw poppy bundle"
	desc = "A bundle of scored poppy pods, still tacky. Goes in a chemical laboratory."

/obj/item/lab_supply/solvent
	name = "base solvent"
	desc = "A jug of harsh-smelling solvent. Goes in a chemical laboratory."

/obj/item/lab_supply/precursor
	name = "precursor flask"
	desc = "A heavy flask of clear liquid with no label. Goes in a chemical laboratory."

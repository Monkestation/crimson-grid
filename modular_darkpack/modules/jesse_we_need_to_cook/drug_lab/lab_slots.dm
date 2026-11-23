GLOBAL_LIST_INIT(lab_slots, init_lab_slots())

/proc/init_lab_slots()
	var/list/slots = list()
	for(var/slot_type in valid_subtypesof(/datum/lab_slot))
		slots[slot_type] = new slot_type()
	return slots

/datum/lab_slot
	abstract_type = /datum/lab_slot
	/// Label shown in the UI and examine text
	var/name = "ingredient"

/// Does this item fill this slot?
/datum/lab_slot/proc/accepts(obj/item/tool)
	return FALSE

/// FALSE to refuse the item (alert the user yourself).
/datum/lab_slot/proc/can_accept(mob/living/user, obj/item/tool)
	return TRUE

/// Instability added for putting this in now. loaded is slot typepath > count so far.
/datum/lab_slot/proc/order_penalty(obj/item/tool, list/loaded)
	return 0

/datum/lab_slot/proc/consume(mob/living/user, obj/item/tool)
	to_chat(user, span_notice("You [pick("add", "mix", "throw")] [tool] into the lab."))
	qdel(tool)

/datum/lab_slot/supply
	abstract_type = /datum/lab_slot/supply
	var/supply_path

/datum/lab_slot/supply/accepts(obj/item/tool)
	return istype(tool, supply_path)

/datum/lab_slot/supply/stock
	name = "Bulk stock"
	supply_path = /obj/item/lab_supply/stock

/datum/lab_slot/supply/leaf
	name = "Dried leaf bundle"
	supply_path = /obj/item/lab_supply/leaf

/datum/lab_slot/supply/catalyst
	name = "Catalyst vial"
	supply_path = /obj/item/lab_supply/catalyst

/datum/lab_slot/supply/poppy
	name = "Raw poppy bundle"
	supply_path = /obj/item/lab_supply/poppy

/datum/lab_slot/supply/precursor
	name = "Precursor flask"
	supply_path = /obj/item/lab_supply/precursor

/// Goes in last: penalised if the catalyst isn't in yet.
/datum/lab_slot/supply/finisher
	abstract_type = /datum/lab_slot/supply/finisher
	var/required_slot = /datum/lab_slot/supply/catalyst
	var/required_count = 1

/datum/lab_slot/supply/finisher/order_penalty(obj/item/tool, list/loaded)
	return (loaded[required_slot] || 0) < required_count ? 1 : 0

/datum/lab_slot/supply/finisher/binder
	name = "Pressing binder"
	supply_path = /obj/item/lab_supply/binder

/datum/lab_slot/supply/finisher/refiner
	name = "Refining agent"
	supply_path = /obj/item/lab_supply/refiner

/datum/lab_slot/supply/finisher/solvent
	name = "Base solvent"
	supply_path = /obj/item/lab_supply/solvent
	required_slot = /datum/lab_slot/supply/poppy
	required_count = 3

/datum/lab_slot/meth_gas
	name = "Gasoline"

/datum/lab_slot/meth_gas/accepts(obj/item/tool)
	return istype(tool, /obj/item/gas_can)

/datum/lab_slot/meth_gas/can_accept(mob/living/user, obj/item/tool)
	var/obj/item/gas_can/can = tool
	if(can.stored_gasoline < 100)
		user.balloon_alert(user, "not enough gas")
		return FALSE
	return TRUE

/datum/lab_slot/meth_gas/consume(mob/living/user, obj/item/tool)
	var/obj/item/gas_can/can = tool
	can.stored_gasoline -= 100
	playsound(user, 'sound/effects/spray2.ogg', 25, TRUE)
	to_chat(user, span_warning("You pour [can] into the lab."))

/datum/lab_slot/meth_ephedrine
	name = "Ephedrine pills"

/datum/lab_slot/meth_ephedrine/accepts(obj/item/tool)
	if(!istype(tool, /obj/item/reagent_containers) || !tool.reagents)
		return FALSE
	return tool.reagents.has_reagent(/datum/reagent/medicine/ephedrine)

/datum/lab_slot/meth_other
	name = "Other reagents"

/// Which reagent makes this item count, or null. Ephedrine containers never get here
/// because the recipe lists the ephedrine slot first and the first match wins.
/datum/lab_slot/meth_other/proc/reagent_for(obj/item/tool)
	if(!istype(tool, /obj/item/reagent_containers) || !tool.reagents)
		return null
	if(tool.reagents.has_reagent(/datum/reagent/medicine/potass_iodide))
		return /datum/reagent/medicine/potass_iodide
	if(tool.reagents.has_reagent(/datum/reagent/consumable/coffee, 10))
		return /datum/reagent/consumable/coffee
	if(tool.reagents.has_reagent(/datum/reagent/consumable/ethanol/vodka, 10))
		return /datum/reagent/consumable/ethanol/vodka
	return null

/datum/lab_slot/meth_other/accepts(obj/item/tool)
	return !isnull(reagent_for(tool))

/datum/lab_slot/meth_other/order_penalty(obj/item/tool, list/loaded)
	var/count = loaded[type] || 0
	switch(reagent_for(tool))
		if(/datum/reagent/medicine/potass_iodide)
			return (loaded[/datum/lab_slot/meth_ephedrine] || 0) < 3 ? 1 : 0
		if(/datum/reagent/consumable/coffee)
			return count != 0 ? 1 : 0
		if(/datum/reagent/consumable/ethanol/vodka)
			return count != 1 ? 1 : 0
	return 0

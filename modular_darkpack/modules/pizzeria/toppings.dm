
GLOBAL_LIST_INIT(pizza_toppings, init_pizza_toppings())
GLOBAL_LIST_EMPTY(pizza_counters)

/// Builds an assoc list of topping typepath > shared topping datum.
/proc/init_pizza_toppings()
	var/list/toppings = list()
	for(var/topping_type in subtypesof(/datum/pizza_topping))
		toppings[topping_type] = new topping_type()
	return toppings

/datum/pizza_topping
	var/name = "bugged topping"
	/// State in PIZZA_TOPPING_ICON
	var/icon_state = ""
	/// Contributes to the order's payout
	var/cost = 4

/datum/pizza_topping/pepperoni
	name = "pepperoni"
	icon_state = "pepperoni"

/datum/pizza_topping/sausage
	name = "sausage"
	icon_state = "sausage"

/datum/pizza_topping/mushroom
	name = "mushrooms"
	icon_state = "mushroom"

/datum/pizza_topping/onion
	name = "onions"
	icon_state = "onion"
	cost = 3

/datum/pizza_topping/pepper
	name = "green peppers"
	icon_state = "pepper"
	cost = 3

/datum/pizza_topping/olive
	name = "olives"
	icon_state = "olive"
	cost = 3

/datum/pizza_topping/pineapple
	name = "pineapple"
	icon_state = "pineapple"
	cost = 5

/datum/pizza_topping/shrimp
	name = "shrimp"
	icon_state = "shrimp"
	cost = 5

/datum/pizza_topping/spinach
	name = "spinach"
	icon_state = "spinach"
	cost = 3

/datum/component/pizza_toppings
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// Each entry is list(topping typepath, x offset from center, y offset from center)
	var/list/placed = list()

/datum/component/pizza_toppings/Initialize()
	if(!istype(parent, /obj/item/food/pizza))
		return COMPONENT_INCOMPATIBLE

/datum/component/pizza_toppings/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(on_update_overlays))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/pizza_toppings/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ATOM_UPDATE_OVERLAYS, COMSIG_ATOM_EXAMINE))

/// Places a topping at an offset from the pizza's center. Returns FALSE if the pizza is full.
/datum/component/pizza_toppings/proc/add_topping(topping_type, offset_x, offset_y)
	if(length(placed) >= PIZZA_MAX_TOPPINGS)
		return FALSE
	// Pull anything outside the crust back onto the pizza
	var/distance = sqrt(offset_x * offset_x + offset_y * offset_y)
	if(distance > PIZZA_TOPPING_RADIUS)
		offset_x = round(offset_x * PIZZA_TOPPING_RADIUS / distance)
		offset_y = round(offset_y * PIZZA_TOPPING_RADIUS / distance)
	placed += list(list(topping_type, offset_x, offset_y))
	var/atom/pizza = parent
	pizza.update_appearance(UPDATE_OVERLAYS)
	return TRUE

/// Removes the most recently placed topping. Returns its typepath, or FALSE if there was nothing to remove.
/datum/component/pizza_toppings/proc/remove_last()
	if(!length(placed))
		return FALSE
	var/list/last = placed[length(placed)]
	placed.Cut(length(placed))
	var/atom/pizza = parent
	pizza.update_appearance(UPDATE_OVERLAYS)
	return last[1]

/// Removes every topping. Returns a list of the removed typepaths, or FALSE if there was nothing to remove.
/datum/component/pizza_toppings/proc/clear()
	if(!length(placed))
		return FALSE
	var/list/removed = list()
	for(var/list/entry in placed)
		removed += entry[1]
	placed.Cut()
	var/atom/pizza = parent
	pizza.update_appearance(UPDATE_OVERLAYS)
	return removed

/datum/component/pizza_toppings/proc/on_update_overlays(atom/source, list/new_overlays)
	SIGNAL_HANDLER
	for(var/list/entry in placed)
		var/datum/pizza_topping/topping = GLOB.pizza_toppings[entry[1]]
		if(!topping)
			continue
		var/mutable_appearance/topping_overlay = mutable_appearance(PIZZA_TOPPING_ICON, topping.icon_state)
		topping_overlay.pixel_x = entry[2]
		topping_overlay.pixel_y = entry[3]
		new_overlays += topping_overlay

/datum/component/pizza_toppings/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!length(placed))
		return
	var/list/counts = list()
	for(var/list/entry in placed)
		counts[entry[1]]++
	var/list/parts = list()
	for(var/topping_type in counts)
		var/datum/pizza_topping/topping = GLOB.pizza_toppings[topping_type]
		parts += "[counts[topping_type]] [topping.name]"
	examine_list += span_notice("It's topped with [english_list(parts)].")

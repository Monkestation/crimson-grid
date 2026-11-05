/obj/structure/table/countertop/black/pizza_station
	name = "pizza topping station"
	desc = "Slide a baked pizza onto this, then use it with an empty hand to start decorating. Refill the toppings with boxes of toppings."
	/// The pizza currently being topped, stored inside the station
	var/obj/item/food/pizza/held_pizza
	/// Topping typepath -> servings left
	var/list/stock = list()

/obj/structure/table/countertop/black/pizza_station/Initialize(mapload)
	. = ..()
	for(var/topping_type in GLOB.pizza_toppings)
		stock[topping_type] = PIZZA_STOCK_START

/obj/structure/table/countertop/black/pizza_station/Destroy()
	eject_pizza()
	return ..()

/obj/structure/table/countertop/black/pizza_station/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/pizza_topping_box))
		return restock_from(user, tool)
	if(!istype(tool, /obj/item/food/pizza))
		return ..()
	var/obj/item/food/pizza/pizza = tool
	if(pizza.foodtypes & RAW)
		balloon_alert(user, "bake it first!")
		return ITEM_INTERACT_BLOCKING
	if(held_pizza)
		balloon_alert(user, "already topping a pizza!")
		return ITEM_INTERACT_BLOCKING
	if(!user.transferItemToLoc(pizza, src))
		return ITEM_INTERACT_BLOCKING
	held_pizza = pizza
	vis_contents += pizza
	RegisterSignal(pizza, COMSIG_QDELETING, PROC_REF(on_pizza_deleted))
	ui_interact(user)
	return ITEM_INTERACT_SUCCESS

/obj/structure/table/countertop/black/pizza_station/attack_hand(mob/living/user, list/modifiers)
	if(!held_pizza || user.combat_mode)
		return ..()
	ui_interact(user)
	return TRUE

/obj/structure/table/countertop/black/pizza_station/examine(mob/user)
	. = ..()
	var/list/low = list()
	for(var/topping_type in stock)
		if(stock[topping_type] > 0)
			continue
		var/datum/pizza_topping/topping = GLOB.pizza_toppings[topping_type]
		low += topping.name
	if(length(low))
		. += span_warning("It's out of [english_list(low)].")

/obj/structure/table/countertop/black/pizza_station/proc/on_pizza_deleted(datum/source)
	SIGNAL_HANDLER
	held_pizza = null

/// Takes the pizza back out, into the user's hands if given.
/obj/structure/table/countertop/black/pizza_station/proc/eject_pizza(mob/living/user)
	if(!held_pizza)
		return
	var/obj/item/food/pizza/pizza = held_pizza
	UnregisterSignal(pizza, COMSIG_QDELETING)
	vis_contents -= pizza
	held_pizza = null
	pizza.forceMove(drop_location())
	user?.put_in_hands(pizza)

/obj/structure/table/countertop/black/pizza_station/proc/adjust_stock(topping_type, amount)
	stock[topping_type] = clamp((stock[topping_type] || 0) + amount, 0, PIZZA_STOCK_MAX)

/// Pours a topping box into the station's stock, as much as fits.
/obj/structure/table/countertop/black/pizza_station/proc/restock_from(mob/living/user, obj/item/pizza_topping_box/box)
	var/datum/pizza_topping/topping = GLOB.pizza_toppings[box.topping_type]
	if(!topping)
		return ITEM_INTERACT_BLOCKING
	var/space = PIZZA_STOCK_MAX - (stock[box.topping_type] || 0)
	if(space <= 0)
		balloon_alert(user, "already full!")
		return ITEM_INTERACT_BLOCKING
	var/amount = min(space, box.uses)
	adjust_stock(box.topping_type, amount)
	box.uses -= amount
	balloon_alert(user, "refilled [topping.name]")
	if(box.uses <= 0)
		qdel(box)
	SStgui.update_uis(src)
	return ITEM_INTERACT_SUCCESS

/// Every order counter close enough to be "ours".
/obj/structure/table/countertop/black/pizza_station/proc/get_nearby_counters()
	var/list/counters = list()
	for(var/obj/structure/table/wood/pizza_counter/counter as anything in GLOB.pizza_counters)
		if(counter.z != z || get_dist(src, counter) > 20)
			continue
		counters += counter
	return counters

/obj/structure/table/countertop/black/pizza_station/ui_state(mob/user)
	return GLOB.physical_state

/obj/structure/table/countertop/black/pizza_station/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PizzaStation", name)
		ui.open()

/obj/structure/table/countertop/black/pizza_station/ui_static_data(mob/user)
	var/list/data = list()
	var/list/topping_data = list()
	for(var/topping_type in GLOB.pizza_toppings)
		var/datum/pizza_topping/topping = GLOB.pizza_toppings[topping_type]
		topping_data += list(list(
			"id" = "[topping_type]",
			"name" = topping.name,
			"icon_state" = topping.icon_state,
		))
	data["toppings"] = topping_data
	data["topping_icon"] = "[PIZZA_TOPPING_ICON]"
	data["radius"] = PIZZA_TOPPING_RADIUS
	data["max_toppings"] = PIZZA_MAX_TOPPINGS
	data["max_stock"] = PIZZA_STOCK_MAX
	return data

/obj/structure/table/countertop/black/pizza_station/ui_data(mob/user)
	var/list/data = list()
	data["has_pizza"] = !!held_pizza
	data["pizza_name"] = held_pizza?.name
	data["pizza_icon"] = held_pizza ? "[held_pizza.icon]" : null
	data["pizza_icon_state"] = held_pizza?.icon_state

	var/list/stock_data = list()
	for(var/topping_type in stock)
		stock_data["[topping_type]"] = stock[topping_type]
	data["stock"] = stock_data

	var/list/placed_data = list()
	var/datum/component/pizza_toppings/toppings = held_pizza?.GetComponent(/datum/component/pizza_toppings)
	if(toppings)
		for(var/list/entry in toppings.placed)
			placed_data += list(list("id" = "[entry[1]]", "x" = entry[2], "y" = entry[3]))
	data["placed"] = placed_data

	// Open orders from any counter nearby, each with a live "how close is my pizza" score
	var/list/order_data = list()
	var/any_open = FALSE
	var/list/nearby = get_nearby_counters()
	for(var/obj/structure/table/wood/pizza_counter/counter as anything in nearby)
		if(counter.accepting_orders)
			any_open = TRUE
		for(var/datum/pizza_order/order as anything in counter.orders)
			var/mob/living/carbon/human/npc/customer = order.get_customer()
			if(QDELETED(customer))
				continue
			order_data += list(list(
				"customer" = customer.real_name || customer.name,
				"description" = order.describe(),
				"seconds_left" = max(round((order.deadline - world.time) / (1 SECONDS)), 0),
				"score" = held_pizza ? order.grade(held_pizza) : 0,
			))
	data["orders"] = order_data
	data["has_counter"] = !!length(nearby)
	data["counter_open"] = any_open
	return data

/obj/structure/table/countertop/black/pizza_station/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/user = ui.user
	switch(action)
		if("place")
			if(!held_pizza)
				return FALSE
			var/topping_type = text2path(params["topping"])
			var/datum/pizza_topping/topping = GLOB.pizza_toppings[topping_type]
			if(!topping)
				return FALSE
			var/offset_x = text2num(params["x"])
			var/offset_y = text2num(params["y"])
			if(isnull(offset_x) || isnull(offset_y))
				return FALSE
			if((stock[topping_type] || 0) <= 0)
				balloon_alert(user, "out of [topping.name]!")
				return FALSE
			var/datum/component/pizza_toppings/toppings = held_pizza.LoadComponent(/datum/component/pizza_toppings)
			if(!toppings.add_topping(topping_type, round(offset_x), round(offset_y)))
				balloon_alert(user, "no more room!")
				return FALSE
			adjust_stock(topping_type, -1)
			return TRUE
		if("undo")
			var/datum/component/pizza_toppings/toppings = held_pizza?.GetComponent(/datum/component/pizza_toppings)
			var/removed = toppings?.remove_last()
			if(!removed)
				return FALSE
			// Taking a topping back off returns the serving
			adjust_stock(removed, 1)
			return TRUE
		if("clear")
			var/datum/component/pizza_toppings/toppings = held_pizza?.GetComponent(/datum/component/pizza_toppings)
			var/removed = toppings?.clear()
			if(!removed)
				return FALSE
			for(var/removed_type in removed)
				adjust_stock(removed_type, 1)
			return TRUE
		if("eject")
			eject_pizza(user)
			return TRUE
		if("toggle_open")
			var/list/nearby = get_nearby_counters()
			if(!length(nearby))
				return FALSE
			var/any_open = FALSE
			for(var/obj/structure/table/wood/pizza_counter/counter as anything in nearby)
				if(counter.accepting_orders)
					any_open = TRUE
					break
			for(var/obj/structure/table/wood/pizza_counter/counter as anything in nearby)
				counter.set_accepting_orders(!any_open)
			balloon_alert(user, any_open ? "closed to new orders" : "open for orders")
			return TRUE
	return FALSE

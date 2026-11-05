/datum/pizza_order
	var/datum/weakref/customer_ref
	var/obj/structure/table/wood/pizza_counter/counter
	/// topping typepath -> PIZZA_SIDE_*
	var/list/wanted = list()
	var/deadline = 0
	var/base_pay = PIZZA_BASE_PAY

/datum/pizza_order/New(mob/living/carbon/human/npc/new_customer, patience = PIZZA_ORDER_PATIENCE)
	. = ..()
	customer_ref = WEAKREF(new_customer)
	deadline = world.time + patience

	var/list/pool = assoc_to_keys(GLOB.pizza_toppings)
	var/count = min(pick(1, 1, 2, 2, 3), length(pool))
	// Sometimes the first two toppings are a half and half pizza
	var/halves = (count >= 2) && prob(35)
	for(var/index in 1 to count)
		var/topping_type = pick_n_take(pool)
		var/side = PIZZA_SIDE_WHOLE
		if(halves && index <= 2)
			side = (index == 1) ? PIZZA_SIDE_LEFT : PIZZA_SIDE_RIGHT
		wanted[topping_type] = side
		var/datum/pizza_topping/topping = GLOB.pizza_toppings[topping_type]
		base_pay += round(topping.cost * (side == PIZZA_SIDE_WHOLE ? 1 : 0.5))

/datum/pizza_order/Destroy()
	counter = null
	customer_ref = null
	return ..()

/datum/pizza_order/proc/get_customer()
	return customer_ref?.resolve()

/// "pepperoni on the left half, mushrooms on the right half" etc. Left/right is as seen on screen.
/datum/pizza_order/proc/describe()
	var/list/parts = list()
	for(var/topping_type in wanted)
		var/datum/pizza_topping/topping = GLOB.pizza_toppings[topping_type]
		switch(wanted[topping_type])
			if(PIZZA_SIDE_LEFT)
				parts += "[topping.name] on the left half"
			if(PIZZA_SIDE_RIGHT)
				parts += "[topping.name] on the right half"
			else
				parts += "[topping.name] all over"
	return english_list(parts)

/// Scores a pizza from 0 to 100. Missing toppings and misplaced/unwanted toppings both cost points.
/datum/pizza_order/proc/grade(obj/item/food/pizza/pizza)
	var/datum/component/pizza_toppings/toppings = pizza.GetComponent(/datum/component/pizza_toppings)
	if(!toppings)
		return 0

	var/list/matched = list()
	var/wrong = 0
	for(var/list/entry in toppings.placed)
		var/topping_type = entry[1]
		var/offset_x = entry[2]
		var/side = wanted[topping_type]
		if(isnull(side))
			wrong++
			continue
		if(side == PIZZA_SIDE_LEFT && offset_x > PIZZA_HALF_DEADZONE)
			wrong++
			continue
		if(side == PIZZA_SIDE_RIGHT && offset_x < -PIZZA_HALF_DEADZONE)
			wrong++
			continue
		matched[topping_type]++

	var/coverage = 0
	for(var/topping_type in wanted)
		var/needed = (wanted[topping_type] == PIZZA_SIDE_WHOLE) ? PIZZA_WHOLE_AMOUNT : PIZZA_HALF_AMOUNT
		coverage += min((matched[topping_type] || 0) / needed, 1)

	var/score = (coverage / length(wanted)) * 100 - wrong * 10
	return clamp(round(score), 0, 100)

/datum/pizza_order/proc/payout_for(score)
	if(score >= 90)
		return round(base_pay * 1.5)
	if(score >= 60)
		return base_pay
	if(score >= 30)
		return round(base_pay * 0.5)
	return 0

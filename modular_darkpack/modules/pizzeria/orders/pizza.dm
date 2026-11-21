/datum/food_order/pizza
	/// topping typepath -> PIZZA_SIDE_*
	var/list/wanted = list()

/datum/food_order/pizza/generate_order()
	parts_left = list(FOOD_PART_PIZZA)
	var/base = PIZZA_BASE_PAY
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
		base += round(topping.cost * (side == PIZZA_SIDE_WHOLE ? 1 : 0.5))
	part_pay[FOOD_PART_PIZZA] = base

/// "pepperoni on the left half, mushrooms on the right half" etc. Left/right is as seen on screen.
/datum/food_order/pizza/proc/describe_pizza()
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

/datum/food_order/pizza/describe()
	var/text = "a pizza with [describe_pizza()]"
	if(wanted_drink)
		text += ", plus [describe_drink()]"
	return text

/datum/food_order/pizza/order_text()
	var/text = "a pizza with [describe()]"
	if(wanted_drink)
		text += " and [describe_drink()]"
	return text

/datum/food_order/pizza/describe_remaining()
	var/list/parts = list()
	if(FOOD_PART_PIZZA in parts_left)
		parts += "a pizza with [describe_pizza()]"
	if(FOOD_PART_DRINK in parts_left)
		parts += describe_drink()
	return english_list(parts)

/datum/food_order/pizza/identify_part(obj/item/item)
	return istype(item, /obj/item/food/pizza) ? FOOD_PART_PIZZA : null

/datum/food_order/pizza/grade_part(part, obj/item/item)
	return grade(item)

/// Scores a pizza from 0 to 100. Missing toppings and misplaced/unwanted toppings both cost points.
/datum/food_order/pizza/proc/grade(obj/item/food/pizza/pizza)
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

/datum/food_order/burger
	var/patty_count = 1
	/// burger_topping datum typepath -> number of servings wanted
	var/list/wanted_toppings = list()
	/// burger_sauce datum typepaths wanted
	var/list/wanted_sauces = list()
	/// Fries item typepath, or null for no side
	var/wanted_fries

/datum/food_order/burger/generate_order()
	parts_left = list(FOOD_PART_BURGER)
	patty_count = prob(BURGER_DOUBLE_CHANCE) ? BURGER_MAX_PATTIES : 1
	var/base = BURGER_BASE_PAY + BURGER_PATTY_COST * patty_count

	var/list/topping_pool = assoc_to_keys(GLOB.burger_toppings)
	for(var/index in 1 to min(pick(0, 1, 1, 2, 3), length(topping_pool)))
		var/topping_type = pick_n_take(topping_pool)
		var/datum/burger_topping/topping = GLOB.burger_toppings[topping_type]
		var/amount = 1
		if(topping.max_amount > 1 && prob(BURGER_MULTI_TOPPING_CHANCE))
			amount = rand(2, topping.max_amount)
		wanted_toppings[topping_type] = amount
		base += topping.cost * amount

	var/list/sauce_pool = assoc_to_keys(GLOB.burger_sauces)
	for(var/index in 1 to min(pick(0, 1, 1, 2), length(sauce_pool)))
		var/sauce_type = pick_n_take(sauce_pool)
		var/datum/burger_sauce/sauce = GLOB.burger_sauces[sauce_type]
		wanted_sauces += sauce_type
		base += sauce.cost
	part_pay[FOOD_PART_BURGER] = base

	if(prob(BURGER_FRIES_CHANCE))
		wanted_fries = pick(assoc_to_keys(GLOB.order_fries))
		parts_left += FOOD_PART_FRIES
		part_pay[FOOD_PART_FRIES] = GLOB.order_fries[wanted_fries]
		deadline += BURGER_FRIES_PATIENCE

/datum/food_order/burger/proc/describe_burger()
	var/list/topping_names = list()
	for(var/topping_type in wanted_toppings)
		var/datum/burger_topping/topping = GLOB.burger_toppings[topping_type]
		topping_names += topping.amount_text(wanted_toppings[topping_type])
	var/list/sauce_names = list()
	for(var/sauce_type in wanted_sauces)
		var/datum/burger_sauce/sauce = GLOB.burger_sauces[sauce_type]
		sauce_names += sauce.name

	var/text
	switch(patty_count)
		if(1)
			text = "a burger"
		if(2)
			text = "a double burger"
		else
			text = "a [patty_count]-patty burger"
	text += length(topping_names) ? " with [english_list(topping_names)]" : " with just the patty"
	if(length(sauce_names))
		text += " and [english_list(sauce_names)]"
	return text

/datum/food_order/burger/proc/describe_fries()
	var/obj/item/path = wanted_fries
	return "a side of [initial(path.name)]"

/datum/food_order/burger/describe()
	var/text = describe_burger()
	if(wanted_fries)
		text += " and [describe_fries()]"
	return text

/datum/food_order/burger/describe_remaining()
	var/list/parts = list()
	if(FOOD_PART_BURGER in parts_left)
		parts += describe_burger()
	if(FOOD_PART_FRIES in parts_left)
		parts += describe_fries()
	return english_list(parts)

/datum/food_order/burger/identify_part(obj/item/item)
	if(istype(item, /obj/item/food/burger/empty))
		return FOOD_PART_BURGER
	if(item.type in GLOB.order_fries)
		return FOOD_PART_FRIES
	return null

/datum/food_order/burger/grade_part(part, obj/item/item)
	switch(part)
		if(FOOD_PART_BURGER)
			return grade_burger(item)
		if(FOOD_PART_FRIES)
			return (item.type == wanted_fries) ? 100 : 0
	return 0

/// every extra patty/topping, unknown item or unwanted sauce costs BURGER_WRONG_PENALTY.
/datum/food_order/burger/proc/grade_burger(obj/item/food/burger/burger)
	var/patties = 0
	var/wrong = 0
	var/list/found = list() // topping datum typepath > servings on the burger
	for(var/obj/item/ingredient in burger.contents)
		if(istype(ingredient, /obj/item/food/patty/plain))
			patties++
			continue
		var/datum/burger_topping/topping = find_burger_topping(ingredient)
		if(!topping)
			wrong++
			continue
		found[topping.type]++
	if(!patties)
		return 0

	var/needed = patty_count
	var/matched = min(patties, patty_count)
	wrong += max(patties - patty_count, 0)

	for(var/topping_type in wanted_toppings)
		needed += wanted_toppings[topping_type]
	for(var/topping_type in found)
		var/want = wanted_toppings[topping_type] || 0
		matched += min(found[topping_type], want)
		wrong += max(found[topping_type] - want, 0)

	for(var/sauce_type in GLOB.burger_sauces)
		var/datum/burger_sauce/sauce = GLOB.burger_sauces[sauce_type]
		var/has_sauce = burger.reagents?.has_reagent(sauce.reagent_type, sauce.min_units)
		if(sauce_type in wanted_sauces)
			needed++
			if(has_sauce)
				matched++
		else if(has_sauce)
			wrong++

	return clamp(round((matched / needed) * 100 - wrong * BURGER_WRONG_PENALTY), 0, 100)

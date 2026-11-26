/// topping datum typepath > instance
GLOBAL_LIST_INIT(burger_toppings, init_subtypes_w_path_keys(/datum/burger_topping, list()))
/// sauce datum typepath > instance
GLOBAL_LIST_INIT(burger_sauces, init_subtypes_w_path_keys(/datum/burger_sauce, list()))
/// fries item typepath > pay for that side
GLOBAL_LIST_INIT(order_fries, list(
	/obj/item/food/fries = 3,
	/obj/item/food/cheesyfries = 5,
))

/// Which topping datum an ingredient item counts as, or null.
/proc/find_burger_topping(obj/item/ingredient)
	for(var/topping_type in GLOB.burger_toppings)
		var/datum/burger_topping/topping = GLOB.burger_toppings[topping_type]
		if(istype(ingredient, topping.item_type))
			return topping
	return null

// A topping a customer can ask for on a burger.
/datum/burger_topping
	/// Shown in orders, e.g. "cheese"
	var/name
	///path we typecheck against
	var/item_type
	/// Pay per serving
	var/cost = 1
	/// The most servings a customer will ask for
	var/max_amount = 2

/// "cheese", "double cheese", "triple cheese", "4x cheese"
/datum/burger_topping/proc/amount_text(amount)
	switch(amount)
		if(1)
			return name
		if(2)
			return "double [name]"
		if(3)
			return "triple [name]"
	return "[amount]x [name]"

/datum/burger_topping/cheese
	name = "cheese"
	item_type = /obj/item/food/cheese/wedge
	cost = 2
	max_amount = 3

/datum/burger_topping/onion
	name = "onion"
	item_type = /obj/item/food/onion_slice
	cost = 1
	max_amount = 3

/datum/burger_topping/pickle
	name = "pickle"
	item_type = /obj/item/food/pickle
	cost = 1
	max_amount = 3

/datum/burger_sauce
	var/name
	var/reagent_type
	var/cost = 1
	/// Units that must be present to count as "has this sauce"
	var/min_units = 2

/datum/burger_sauce/ketchup
	name = "ketchup"
	reagent_type = /datum/reagent/consumable/ketchup

/datum/burger_sauce/hotsauce
	name = "hot sauce"
	reagent_type = /datum/reagent/consumable/capsaicin

/datum/burger_sauce/bbq
	name = "bbq sauce"
	reagent_type = /datum/reagent/consumable/bbqsauce

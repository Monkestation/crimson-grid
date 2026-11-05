/obj/item/pizza_topping_box
	name = "box of toppings"
	desc = "A box of pizza toppings. Use it on a topping station to refill that topping."
	icon_state = "box"
	icon = 'modular_darkpack/modules/cargo/icons/box.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	/// Typepath of the /datum/pizza_topping inside
	var/topping_type
	var/datum/pizza_topping/topping
	/// Servings left in the box
	var/uses = PIZZA_BOX_USES

/obj/item/pizza_topping_box/Initialize(mapload)
	. = ..()
	topping = GLOB.pizza_toppings[topping_type]
	if(!topping)
		stack_trace("[type] has no valid topping_type")
		return
	name = "box of [topping.name]"
	add_overlay(mutable_appearance(PIZZA_TOPPING_ICON, topping.icon_state))

/obj/item/pizza_topping_box/examine(mob/user)
	. = ..()
	. += span_notice("It has [uses] serving\s left.")

/obj/item/pizza_topping_box/pepperoni
	topping_type = /datum/pizza_topping/pepperoni

/obj/item/pizza_topping_box/sausage
	topping_type = /datum/pizza_topping/sausage

/obj/item/pizza_topping_box/mushroom
	topping_type = /datum/pizza_topping/mushroom

/obj/item/pizza_topping_box/onion
	topping_type = /datum/pizza_topping/onion

/obj/item/pizza_topping_box/pepper
	topping_type = /datum/pizza_topping/pepper

/obj/item/pizza_topping_box/olive
	topping_type = /datum/pizza_topping/olive

/obj/item/pizza_topping_box/pineapple
	topping_type = /datum/pizza_topping/pineapple

/obj/item/pizza_topping_box/shrimp
	topping_type = /datum/pizza_topping/shrimp

/obj/item/pizza_topping_box/spinach
	topping_type = /datum/pizza_topping/spinach

/obj/structure/closet/crate/freezer/burger_supplies
	name = "burger supplies crate"

/obj/structure/closet/crate/freezer/burger_supplies/PopulateContents()
	. = ..()
	for(var/i in 1 to 6)
		new /obj/item/food/bun(src)
		new /obj/item/food/patty/plain(src)
	for(var/topping_type in GLOB.burger_toppings)
		var/datum/burger_topping/topping = GLOB.burger_toppings[topping_type]
		for(var/i in 1 to 6)
			new topping.item_type(src)
	for(var/i in 1 to 2)
		new /obj/item/reagent_containers/condiment/pack/ketchup(src)
		new /obj/item/reagent_containers/condiment/pack/hotsauce(src)
		new /obj/item/reagent_containers/condiment/pack/bbqsauce(src)
	for(var/fries_type in GLOB.order_fries)
		for(var/i in 1 to 3)
			new fries_type(src)

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

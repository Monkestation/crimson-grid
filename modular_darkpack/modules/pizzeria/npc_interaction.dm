/obj/structure/table/wood/pizza_counter
	name = "order counter"
	desc = "Customers come here to order food. Examine it to see the open orders."
	/// Side of the counter customers queue up on
	var/customer_dir = SOUTH
	/// While FALSE, no new customers come to the counter. Customers already waiting are still served.
	var/accepting_orders = TRUE
	/// Order type > weight of being picked for a new customer. Subtypes below restrict this.
	var/list/order_types = list(
		/datum/food_order/pizza = 1,
		/datum/food_order/burger = 1,
	)
	var/list/datum/food_order/orders = list()
	/// Invisible activity point that draws NPCs over here
	var/obj/effect/landmark/npcactivity/attractor

/// Pizza only
/obj/structure/table/wood/pizza_counter/pizza
	name = "pizza order counter"
	desc = "Customers come here to order pizza. Examine it to see the open orders."
	order_types = list(/datum/food_order/pizza = 1)

/// Burger only
/obj/structure/table/wood/pizza_counter/burger
	name = "burger order counter"
	desc = "Customers come here to order burgers and fries. Examine it to see the open orders."
	order_types = list(/datum/food_order/burger = 1)

/obj/structure/table/wood/pizza_counter/Initialize(mapload)
	. = ..()
	if(accepting_orders)
		attractor = new(get_step(src, customer_dir))
	GLOB.pizza_counters += src
	START_PROCESSING(SSobj, src)

/obj/structure/table/wood/pizza_counter/Destroy()
	STOP_PROCESSING(SSobj, src)
	GLOB.pizza_counters -= src
	for(var/datum/food_order/order as anything in orders.Copy())
		end_order(order)
	QDEL_NULL(attractor)
	return ..()

/// Whether this counter hands out orders of the given type (used by the pizza station to ignore burger counters).
/obj/structure/table/wood/pizza_counter/proc/takes_order_type(order_type)
	return !!(order_type in order_types)

/// Opens or closes the counter. Closing removes the activity point, so NPCs stop coming over.
/obj/structure/table/wood/pizza_counter/proc/set_accepting_orders(new_state)
	if(accepting_orders == new_state)
		return
	accepting_orders = new_state
	if(accepting_orders)
		attractor = new(get_step(src, customer_dir))
	else
		QDEL_NULL(attractor)

/// Empty hand toggles whether we take new orders.
/obj/structure/table/wood/pizza_counter/attack_hand(mob/living/user, list/modifiers)
	if(user.combat_mode || user.pulling)
		return ..()
	set_accepting_orders(!accepting_orders)
	if(accepting_orders)
		balloon_alert(user, "open for orders")
	else
		balloon_alert(user, length(orders) ? "closed ([length(orders)] still waiting)" : "closed to new orders")
	return TRUE

/obj/structure/table/wood/pizza_counter/examine(mob/user)
	. = ..()
	if(accepting_orders)
		. += span_notice("It's open for orders. Use it with an empty hand to close it to new customers.")
	else
		. += span_warning("It's closed to new customers. Use it with an empty hand to reopen it.")
	if(!length(orders))
		. += span_notice("No one is waiting for an order right now.")
		return
	for(var/datum/food_order/order as anything in orders)
		var/mob/living/carbon/human/npc/customer = order.get_customer()
		if(QDELETED(customer))
			continue
		. += span_notice("[customer] wants [order.describe_remaining()] ([max(round((order.deadline - world.time) / (1 SECONDS)), 0)]s left).")

/obj/structure/table/wood/pizza_counter/process(seconds_per_tick)
	service_orders()
	if(!accepting_orders || length(orders) >= PIZZA_MAX_CUSTOMERS || !prob(PIZZA_ORDER_CHANCE))
		return
	var/turf/front = get_step(src, customer_dir)
	if(!front)
		return
	for(var/mob/living/carbon/human/npc/candidate in range(PIZZA_CUSTOMER_RANGE, front))
		if(!can_take_order_from(candidate))
			continue
		take_order(candidate)
		return

/// Only NPCs that have arrived somewhere and are idling can be pulled in
/obj/structure/table/wood/pizza_counter/proc/can_take_order_from(mob/living/carbon/human/npc/candidate)
	if(candidate.food_order || candidate.staying || candidate.walktarget || candidate.loiter_spot)
		return FALSE
	if(candidate.loiter_until <= world.time || candidate.danger_source || candidate.stat != STABLE)
		return FALSE
	return candidate.can_npc_move()

/// Closest free open turf in front of the counter, so customers don't stack up on one tile.
/obj/structure/table/wood/pizza_counter/proc/find_customer_spot()
	var/turf/front = get_step(src, customer_dir)
	var/turf/best
	var/best_dist = INFINITY
	for(var/turf/open/candidate in range(1, front))
		if(candidate.is_blocked_turf(TRUE) || (locate(/mob/living) in candidate))
			continue
		var/dist = get_dist(candidate, src)
		if(dist >= best_dist)
			continue
		best = candidate
		best_dist = dist
	return best || front

/obj/structure/table/wood/pizza_counter/proc/take_order(mob/living/carbon/human/npc/customer)
	var/order_type = pick_weight(order_types)
	var/datum/food_order/order = new order_type(customer)
	order.counter = src
	orders += order
	customer.food_order = order

	var/turf/spot = find_customer_spot()
	if(spot && get_dist(customer, spot) > 1)
		// Reuse the NPC's loiter-spot walking so they stroll up to the counter
		customer.loiter_spot = spot
		customer.walktarget = spot
		customer.stopturf = 0
	customer.say("Hey, can I get [order.order_text()]?")

/// Drops orders whose customer died, got scared off, or ran out of patience; keeps waiting customers parked.
/obj/structure/table/wood/pizza_counter/proc/service_orders()
	for(var/datum/food_order/order as anything in orders.Copy())
		var/mob/living/carbon/human/npc/customer = order.get_customer()
		if(QDELETED(customer) || customer.stat != STABLE || customer.danger_source || customer.food_order != order)
			end_order(order)
			continue
		if(world.time >= order.deadline)
			customer.say("Forget it, I'll get something somewhere else.")
			end_order(order)
			continue
		if(!customer.walktarget)
			// Keep them standing at the counter instead of wandering off
			customer.loiter_until = max(customer.loiter_until, world.time + 6 SECONDS)
			customer.face_atom(src)

/obj/structure/table/wood/pizza_counter/proc/end_order(datum/food_order/order)
	var/mob/living/carbon/human/npc/customer = order.get_customer()
	if(customer && customer.food_order == order)
		customer.food_order = null
		customer.loiter_until = world.time + rand(1 SECONDS, 3 SECONDS)
	orders -= order
	qdel(order)

/// Called when a player hands food to a waiting customer. Each part (pizza, burger, fries) is
/// graded, accepted and paid separately; the order ends once every part has been delivered.
/obj/structure/table/wood/pizza_counter/proc/complete_order(datum/food_order/order, mob/living/user, obj/item/food/food)
	var/mob/living/carbon/human/npc/customer = order.get_customer()
	if(QDELETED(customer))
		return
	if(food.foodtypes & RAW)
		customer.say("This is still raw!")
		return

	var/list/result = order.submit(food)
	if(!result)
		customer.say("That's not what I ordered!")
		return

	var/score = result["score"]
	if(score >= 90)
		customer.say("Wow, that's perfect! Keep the change.")
	else if(score >= 60)
		customer.say("Looks good, thanks.")
	else
		customer.say("...Not quite what I asked for, but fine.")

	qdel(food)
	pay_user(user, customer, result["payout"])
	if(order.is_complete())
		end_order(order)
	else
		customer.say("Thanks. Still waiting on [order.describe_remaining()].")

/obj/structure/table/wood/pizza_counter/proc/pay_user(mob/living/user, mob/living/customer, amount)
	var/obj/item/stack/dollar/cash = new(get_turf(user), amount)
	user.put_in_hands(cash)
	to_chat(user, span_notice("[customer] pays you $[amount]."))

/mob/living/carbon/human/npc
	/// The order this NPC is currently waiting on, if any. (Was pizza_order.)
	var/datum/food_order/food_order

/mob/living/carbon/human/npc/examine(mob/user)
	. = ..()
	if(food_order)
		. += span_notice("[p_They()] [p_are()] waiting on [food_order.describe_remaining()].")

/// Handing food that satisfies a still-owed part of the order completes that part.
/// Anything else falls through to normal interaction.
/mob/living/carbon/human/npc/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!food_order || stat != STABLE || !istype(tool, /obj/item/food) || !food_order.counter || !food_order.get_part(tool))
		return ..()
	food_order.counter.complete_order(food_order, user, tool)
	return ITEM_INTERACT_SUCCESS

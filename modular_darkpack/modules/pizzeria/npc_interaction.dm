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
	var/obj/effect/landmark/npcactivity/food/attractor

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
	. += span_notice("Put finished food on the counter and ring a service bell to call customers up to collect it.")
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

/// Only NPCs that have arrived somewhere, are idling, and aren't full can be pulled in
/obj/structure/table/wood/pizza_counter/proc/can_take_order_from(mob/living/carbon/human/npc/candidate)
	if(candidate.food_order || candidate.staying || candidate.walktarget || candidate.loiter_spot)
		return FALSE
	if(candidate.food_phase != NPC_FOOD_NONE || candidate.buckled || world.time < candidate.food_cooldown_until)
		return FALSE
	if(candidate.loiter_until <= world.time || candidate.danger_source || candidate.stat != STABLE)
		return FALSE
	return candidate.can_npc_move()

/// Whether some customer is already walking to (or sitting on) this chair.
/obj/structure/table/wood/pizza_counter/proc/seat_reserved(obj/structure/chair/chair)
	if(chair.has_buckled_mobs())
		return TRUE
	var/turf/turf = get_turf(chair)
	if(locate(/mob/living) in turf.contents)
		return TRUE
	for(var/obj/structure/table/wood/pizza_counter/counter as anything in GLOB.pizza_counters)
		for(var/datum/food_order/order as anything in counter.orders)
			var/mob/living/carbon/human/npc/customer = order.get_customer()
			if(customer?.seat == chair)
				return TRUE
	return FALSE

/// Closest free chair next to a table, near the counter. Null if there isn't one.
/obj/structure/table/wood/pizza_counter/proc/find_seat()
	var/obj/structure/chair/best
	var/best_dist = INFINITY
	for(var/obj/structure/chair/chair in range(PIZZA_SEAT_RANGE, src))
		var/dist = get_dist(chair, src)
		if(dist >= best_dist)
			continue
		if(seat_reserved(chair))
			continue
		var/turf/chair_turf = get_turf(chair)
		if(!chair_turf || chair_turf.density)
			continue
		// Only chairs pulled up to a table
		var/has_table = FALSE
		for(var/direction in GLOB.cardinals)
			if(locate(/obj/structure/table) in get_step(chair_turf, direction))
				has_table = TRUE
				break
		if(!has_table)
			continue
		best = chair
		best_dist = dist
	return best

/// Closest free open turf in front of the counter, so customers don't stack up on one tile.
/obj/structure/table/wood/pizza_counter/proc/find_customer_spot()
	var/turf/front = get_step(src, customer_dir)
	var/turf/best
	var/best_dist = INFINITY
	for(var/turf/open/candidate in range(1, front))
		if(candidate.is_blocked_turf(TRUE) || (locate(/mob/living) in candidate))
			continue
		// Another customer is already heading here
		var/reserved = FALSE
		for(var/datum/food_order/order as anything in orders)
			var/mob/living/carbon/human/npc/customer = order.get_customer()
			if(customer?.loiter_spot == candidate)
				reserved = TRUE
				break
		if(reserved)
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
	customer.say("Hey, can I get [order.order_text()]?")

	// Go find a table to sit at while the food is made; no free chair means waiting at the counter
	var/obj/structure/chair/chair = find_seat()
	if(chair)
		customer.go_to_seat(chair)
		return
	var/turf/spot = find_customer_spot()
	if(spot && get_dist(customer, spot) > 1)
		// Reuse the NPC's loiter-spot walking so they stroll up to the counter
		customer.loiter_spot = spot
		customer.walktarget = spot
		customer.stopturf = 1

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
			// Keep them where they are (in their chair, or at the counter) instead of wandering off
			customer.loiter_until = max(customer.loiter_until, world.time + 6 SECONDS)
			if(!customer.buckled)
				customer.face_atom(src)

/// Removes an order. finished = TRUE means it was fully delivered, so the customer keeps their seat and goes on to eat.
/obj/structure/table/wood/pizza_counter/proc/end_order(datum/food_order/order, finished = FALSE)
	var/mob/living/carbon/human/npc/customer = order.get_customer()
	if(customer && customer.food_order == order)
		customer.food_order = null
		if(!finished)
			customer.leave_table()
	orders -= order
	qdel(order)

/obj/structure/table/wood/pizza_counter/proc/grade_food(datum/food_order/order, obj/item/food/food)
	return order.preview_score(food)

/// Rings the bell for this counter: of the customers whose order has matching food sitting on the counter,
/// only the one with the best-graded match is called up. Returns how many were called (0 or 1).
/obj/structure/table/wood/pizza_counter/proc/call_customers()
	var/list/foods = list()
	for(var/obj/item/food/food in get_turf(src))
		if(food.foodtypes & RAW)
			continue
		foods += food
	if(!length(foods))
		return 0

	var/datum/food_order/best_order
	var/best_score = -INFINITY
	for(var/datum/food_order/order as anything in orders)
		var/mob/living/carbon/human/npc/customer = order.get_customer()
		if(QDELETED(customer) || customer.stat != STABLE || customer.danger_source)
			continue
		// Already on their way
		if(customer.food_phase == NPC_FOOD_CALLED)
			continue
		for(var/obj/item/food/food as anything in foods)
			var/score = grade_food(order, food)
			if(score < 0)
				continue
			// Strictly greater, so ties go to the oldest order
			if(score > best_score)
				best_score = score
				best_order = order
	if(!best_order)
		return 0
	var/mob/living/carbon/human/npc/chosen = best_order.get_customer()
	chosen.call_to_counter(find_customer_spot())
	return 1

/// A called customer reached the counter: take any matching food sitting on it, pay, then head back to the chair.
/obj/structure/table/wood/pizza_counter/proc/customer_arrived(mob/living/carbon/human/npc/customer)
	var/datum/food_order/order = customer.food_order
	if(!order || order.counter != src)
		customer.return_to_seat()
		return
	customer.face_atom(src)
	var/list/foods = list()
	for(var/obj/item/food/food in get_turf(src))
		if(order.preview_score(food) >= 0)
			foods += food
	var/taken = 0
	while(length(foods))
		var/obj/item/food/best
		var/best_score = -1
		for(var/obj/item/food/food as anything in foods)
			var/score = order.preview_score(food)
			if(score > best_score)
				best_score = score
				best = food
		if(!best)
			break
		foods -= best
		// Re-check, since an earlier delivery may have filled this part
		if(order.preview_score(best) < 0)
			continue
		complete_order(order, null, best)
		taken++
		// Fully delivered, the customer is already on their way back to eat
		if(QDELETED(order) || customer.food_order != order)
			return
	if(!taken)
		customer.say("There's nothing here for me yet.")
	customer.return_to_seat()

/// Called when a player hands food to a waiting customer, or a called customer picks it up off the counter (user = null).
/// Each part (pizza, burger, fries) is graded, accepted and paid separately; the order ends once every part has been delivered.
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

	// The customer keeps the food to eat at their table
	customer.held_food += food
	food.forceMove(customer)
	pay_user(user, customer, result["payout"])
	if(order.is_complete())
		end_order(order, TRUE)
		customer.begin_meal()
	else
		customer.say("Thanks. Still waiting on [order.describe_remaining()].")

/// Pays out into the player's hands, or leaves the cash on the counter if nobody handed the food over directly.
/obj/structure/table/wood/pizza_counter/proc/pay_user(mob/living/user, mob/living/customer, amount)
	var/obj/item/stack/dollar/cash
	if(user)
		cash = new(get_turf(user), amount)
		user.put_in_hands(cash)
		to_chat(user, span_notice("[customer] pays you $[amount]."))
		return
	cash = new(get_turf(src), amount)
	visible_message(span_notice("[customer] leaves $[amount] on [src]."))

/mob/living/carbon/human/npc
	/// The order this NPC is currently waiting on, if any. (Was pizza_order.)
	var/datum/food_order/food_order
	/// Where we are in the order > sit > collect > eat cycle, one of the NPC_FOOD_* values.
	var/food_phase = NPC_FOOD_NONE
	/// The chair we're sitting at (or walking to) while waiting for / eating food.
	var/obj/structure/chair/seat
	/// Food we've collected and are going to eat.
	var/list/obj/item/food/held_food = list()
	/// Timer for finishing the meal.
	var/eat_timer

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

///chair
/mob/living/carbon/human/npc/proc/go_to_seat(obj/structure/chair/new_seat)
	if(buckled)
		buckled.unbuckle_mob(src, force = TRUE)
	seat = new_seat
	if(food_phase == NPC_FOOD_NONE)
		food_phase = NPC_FOOD_SEATED
	loiter_spot = get_turf(new_seat)
	walktarget = loiter_spot
	stopturf = 1

/// Walk back to our chair if it's still usable. Returns FALSE if we have nowhere to sit.
/mob/living/carbon/human/npc/proc/return_to_seat()
	if(!seat || QDELETED(seat) || (seat.has_buckled_mobs() && buckled != seat))
		seat = null
		return FALSE
	if(buckled == seat)
		return TRUE
	go_to_seat(seat)
	return TRUE

///the bell rang get your food like a good boy
/mob/living/carbon/human/npc/proc/call_to_counter(turf/spot)
	if(buckled)
		buckled.unbuckle_mob(src, force = TRUE)
	food_phase = NPC_FOOD_CALLED
	if(!spot)
		return
	loiter_spot = spot
	walktarget = spot
	stopturf = 1
	say(pick("Finally!", "Oh, that's mine!", "Coming!"))

/// loiter maxxers
/mob/living/carbon/human/npc/proc/on_loiter_spot_reached()
	if(food_phase == NPC_FOOD_CALLED)
		food_phase = NPC_FOOD_SEATED
		var/obj/structure/table/wood/pizza_counter/counter = food_order?.counter
		if(counter)
			counter.customer_arrived(src)
		else
			return_to_seat()
		return
	if(seat && get_turf(src) == get_turf(seat))
		sit_down()

/mob/living/carbon/human/npc/proc/sit_down()
	if(QDELETED(seat) || get_turf(src) != get_turf(seat))
		return
	if(buckled != seat)
		if(seat.has_buckled_mobs())
			// Somebody beat us to it, eat where we stand
			seat = null
			if(food_phase == NPC_FOOD_EATING)
				start_eating()
			return
		seat.buckle_mob(src, force = TRUE)
	if(food_phase == NPC_FOOD_EATING)
		start_eating()

/// The order is complete and we're holding the food: go (back) to the table and eat it.
/mob/living/carbon/human/npc/proc/begin_meal()
	food_phase = NPC_FOOD_EATING
	if(seat && buckled == seat)
		start_eating()
		return
	if(!return_to_seat())
		start_eating()

/mob/living/carbon/human/npc/proc/start_eating()
	if(eat_timer)
		return
	var/eat_time = rand(15 SECONDS, 30 SECONDS)
	// Stay put while eating
	loiter_until = max(loiter_until, world.time + eat_time + 2 SECONDS)
	visible_message(span_notice("[src] starts eating."))
	eat_timer = addtimer(CALLBACK(src, PROC_REF(finish_eating)), eat_time, TIMER_STOPPABLE)

/mob/living/carbon/human/npc/proc/finish_eating()
	eat_timer = null
	if(food_phase != NPC_FOOD_EATING || stat != STABLE)
		return
	QDEL_LIST(held_food)
	visible_message(span_notice("[src] finishes eating."))
	// Full for a while: won't order again or path to food activity points
	food_cooldown_until = world.time + rand(NPC_FOOD_COOLDOWN_MIN, NPC_FOOD_COOLDOWN_MAX)
	leave_table()

/// Get up and go back to normal NPC behaviour.
/mob/living/carbon/human/npc/proc/leave_table()
	if(eat_timer)
		deltimer(eat_timer)
		eat_timer = null
	if(buckled)
		buckled.unbuckle_mob(src, force = TRUE)
	food_phase = NPC_FOOD_NONE
	seat = null
	loiter_until = world.time + rand(1 SECONDS, 3 SECONDS)

/// Combat / death: drop everything about the meal, the food is lost.
/mob/living/carbon/human/npc/proc/abandon_food()
	if(food_phase == NPC_FOOD_NONE && !buckled && !length(held_food))
		return
	QDEL_LIST(held_food)
	leave_table()

/// Ring it to call customers with open orders up to the counter to collect their food.
/obj/item/service_bell
	name = "service bell"
	desc = "Put finished food on an order counter, then ring this to call customers up to pick it up and pay."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "desk_bell"
	w_class = WEIGHT_CLASS_SMALL
	COOLDOWN_DECLARE(ring_cooldown)

/obj/item/service_bell/attack_self(mob/user)
	. = ..()
	if(!COOLDOWN_FINISHED(src, ring_cooldown))
		return
	COOLDOWN_START(src, ring_cooldown, 2 SECONDS)
	playsound(src, 'sound/machines/ping.ogg', 50, TRUE)
	user.visible_message(span_notice("[user] rings [src]."), span_notice("You ring [src]."))
	var/called = 0
	var/in_range = FALSE
	for(var/obj/structure/table/wood/pizza_counter/counter as anything in GLOB.pizza_counters)
		if(counter.z != user.z || get_dist(counter, user) > SERVICE_BELL_RANGE)
			continue
		in_range = TRUE
		called += counter.call_customers()
	if(!in_range)
		balloon_alert(user, "no counter nearby")
	else if(!called)
		balloon_alert(user, "no ready order on the counter")
	else
		balloon_alert(user, "customer called")

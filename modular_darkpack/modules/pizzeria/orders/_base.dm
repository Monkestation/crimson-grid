/datum/food_order
	var/datum/weakref/customer_ref
	var/obj/structure/table/wood/pizza_counter/counter
	var/deadline = 0
	/// Part keys (FOOD_PART_*) still owed to the customer
	var/list/parts_left = list()
	/// Part key -> base pay for that part
	var/list/part_pay = list()

/datum/food_order/New(mob/living/carbon/human/npc/new_customer, patience = FOOD_ORDER_PATIENCE)
	. = ..()
	customer_ref = WEAKREF(new_customer)
	deadline = world.time + patience
	generate_order()

/datum/food_order/Destroy()
	counter = null
	customer_ref = null
	return ..()

/datum/food_order/proc/get_customer()
	return customer_ref?.resolve()

/// Roll what the customer wants. Must fill parts_left and part_pay.
/datum/food_order/proc/generate_order()
	return

/// Description of the order without a leading article, e.g. "pepperoni all over".
/datum/food_order/proc/describe()
	return ""

/// Full phrase for speech/examine, e.g. "a pizza with pepperoni all over".
/datum/food_order/proc/order_text()
	return describe()

/// What is still owed, as a phrase.
/datum/food_order/proc/describe_remaining()
	return order_text()

/// Which part this item would be for, ignoring whether it is still owed. Null if none.
/datum/food_order/proc/identify_part(obj/item/item)
	return null

/// The part this item satisfies, only if that part is still owed.
/datum/food_order/proc/get_part(obj/item/item)
	var/part = identify_part(item)
	if(part && (part in parts_left))
		return part
	return null

/// 0-100 score of this item against the given part.
/datum/food_order/proc/grade_part(part, obj/item/item)
	return 0

/datum/food_order/proc/is_complete()
	return !length(parts_left)

/datum/food_order/proc/payout_for(score, base)
	if(score >= 90)
		return round(base * 1.5)
	if(score >= 60)
		return base
	if(score >= 30)
		return round(base * 0.5)
	return 0

/// Tries to hand an item over. Returns null if rejected, otherwise list("score", "payout")
/// and marks that part delivered. The caller consumes the item and pays.
/datum/food_order/proc/submit(obj/item/item)
	var/part = get_part(item)
	if(!part)
		return null
	var/score = grade_part(part, item)
	var/payout = payout_for(score, part_pay[part])
	if(!payout)
		return null
	parts_left -= part
	return list("score" = score, "payout" = payout)

/datum/food_order
	var/datum/weakref/customer_ref
	var/obj/structure/table/wood/pizza_counter/counter
	var/deadline = 0
	/// Part keys (FOOD_PART_*) still owed to the customer
	var/list/parts_left = list()
	/// Part key -> base pay for that part
	var/list/part_pay = list()
	/// Reagent typepath the customer wants to drink, or null for no drink
	var/wanted_drink
	/// Chance (0-100) this order type also asks for a drink. 0 = never.
	var/drink_chance = 80


/datum/food_order/New(mob/living/carbon/human/npc/new_customer, patience = FOOD_ORDER_PATIENCE)
	. = ..()
	customer_ref = WEAKREF(new_customer)
	deadline = world.time + patience
	generate_order()
	roll_drink()

/// Reagent typepath > base pay. Override per order type for a different drink set.
/datum/food_order/proc/get_drink_menu()
	return GLOB.order_drinks

/datum/food_order/proc/roll_drink()
	var/list/menu = get_drink_menu()
	if(!length(menu) || !prob(drink_chance))
		return
	wanted_drink = pick(assoc_to_keys(menu))
	parts_left += FOOD_PART_DRINK
	part_pay[FOOD_PART_DRINK] = menu[wanted_drink]
	deadline += FOOD_ORDER_DRINK_PATIENCE

/datum/food_order/proc/describe_drink()
	var/datum/reagent/drink = GLOB.chemical_reagents_list[wanted_drink]
	return "a glass of [drink.name]"

/// Item is a drink container, regardless of contents. Subtypes' identify_part is checked first.
/datum/food_order/proc/identify_drink(obj/item/item)
	if(wanted_drink && istype(item, /obj/item/reagent_containers/cup))
		return FOOD_PART_DRINK
	return null

/// 0-100: share of the container's contents that is the wanted reagent.
/datum/food_order/proc/grade_drink(obj/item/reagent_containers/container)
	if(!wanted_drink || !container.reagents)
		return 0
	var/total = container.reagents.total_volume
	if(total < FOOD_ORDER_DRINK_MIN_VOLUME)
		return 0
	var/amount = container.reagents.get_reagent_amount(wanted_drink)
	return clamp(round((amount / total) * 100), 0, 100)

/// Routes drinks to grade_drink, everything else to the subtype's grade_part.
/datum/food_order/proc/grade_any(part, obj/item/item)
	if(part == FOOD_PART_DRINK)
		return grade_drink(item)
	return grade_part(part, item)

/datum/food_order/Destroy()
	counter = null
	customer_ref = null
	return ..()

/datum/food_order/proc/get_customer()
	return customer_ref?.resolve()

/// Roll what the customer wants. Must fill parts_left and part_pay.
/datum/food_order/proc/generate_order()
	return

/// Full description of the whole order including article, e.g. "a pizza with pepperoni all over".
/datum/food_order/proc/describe()
	return ""

/// Full phrase for speech/examine. Defaults to describe().
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
	var/part = identify_part(item) || identify_drink(item)
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
	var/score = grade_any(part, item)
	var/payout = payout_for(score, part_pay[part])
	if(!payout)
		return null
	parts_left -= part
	return list("score" = score, "payout" = payout)

/// Score this item would get, without delivering it. -1 if it would be rejected
/// (wrong part, already delivered, or too low to pay out).
/datum/food_order/proc/preview_score(obj/item/item)
	var/part = get_part(item)
	if(!part)
		return -1
	var/score = grade_any(part, item)
	if(!payout_for(score, part_pay[part]))
		return -1
	return score

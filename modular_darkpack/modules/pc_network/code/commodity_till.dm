/obj/structure/retail/commodity
	name = "commodity dealer"
	desc = "A counter that sells precious materials at the day's market price."
	take_area_name = FALSE
	owner_needed = FALSE
	/// Multiplier on the market price. 1 = sells at spot, 1.1 = 10% over.
	var/markup = 1
	/// Fraction of market price paid when buying commodity items back. Clamped to markup on init
	/// so buying then reselling can never turn a profit.
	var/buyback_rate = 0.95
	/// Max total cash the till pays out per buyback_window. 0 = no cap.
	var/buyback_cap = 0
	var/buyback_window = 30 MINUTES
	var/buyback_paid = 0
	var/buyback_window_start = 0

/obj/structure/retail/commodity/Initialize(mapload)
	. = ..()
	buyback_rate = min(buyback_rate, markup)
	SScommodities.tills += src

/obj/structure/retail/commodity/Destroy()
	SScommodities.tills -= src
	return ..()

/obj/structure/retail/commodity/build_inventory()
	build_commodity_products()

/// SScommodities may not have initialised when this machine does (mapload), so this can run
/// again later from refresh_prices(). It realistically never should but in the offcase Recover()
/obj/structure/retail/commodity/proc/build_commodity_products()
	for(var/datum/commodity/C as anything in SScommodities.commodities)
		if(C.is_bond || !C.item_type)
			continue
		var/datum/data/vending_product/product = new /datum/data/vending_product(path = C.item_type)
		product.name = C.name
		product.amount = -1 // unlimited
		product.price = max(1, round(C.price * markup))
		products_list += product

/obj/structure/retail/commodity/proc/refresh_prices(push = TRUE)
	if(!length(products_list))
		build_commodity_products()
		if(push && length(products_list))
			update_static_data_for_all_viewers()
		return
	var/changed = FALSE
	for(var/datum/data/vending_product/product as anything in products_list)
		var/datum/commodity/C = SScommodities.commodity_by_item[product.product_path]
		if(!C)
			continue
		var/new_price = max(1, round(C.price * markup))
		if(product.price != new_price)
			product.price = new_price
			changed = TRUE
	if(changed && push)
		update_static_data_for_all_viewers()

/obj/structure/retail/commodity/ui_act(action, params)
	refresh_prices(FALSE)
	return ..()

/// Using a commodity item on the till sells it back. Anything else behaves like a normal shop.
/obj/structure/retail/commodity/attackby(obj/item/I, mob/user, params)
	var/datum/commodity/C = SScommodities.commodity_for_item(I)
	if(!C || C.is_bond)
		return ..()
	if(closed)
		to_chat(user, span_alert("The shop is closed."))
		return
	if(!can_shop(user))
		return
	if(owner_needed == TRUE && (!my_owner || (get_dist(src, my_owner) > 4) || (my_owner.stat >= HARD_CRIT)))
		to_chat(user, span_alert("There's no teller here to buy anything from you..."))
		return
	sell_to_till(I, C, user)

/// Pays cash for a commodity item or stack at spot * buyback_rate. With a cap set, a stack is
/// partly bought if only part of it fits under the cap.
/obj/structure/retail/commodity/proc/sell_to_till(obj/item/I, datum/commodity/C, mob/user)
	var/units = 1
	var/obj/item/stack/S
	if(istype(I, /obj/item/stack))
		S = I
		units = S.amount
	var/unit_value = C.price * buyback_rate
	if(unit_value < 1)
		to_chat(user, span_alert("The dealer isn't interested."))
		return
	if(buyback_cap > 0)
		if(world.time - buyback_window_start >= buyback_window)
			buyback_window_start = world.time
			buyback_paid = 0
		units = min(units, floor((buyback_cap - buyback_paid) / unit_value))
		if(units < 1)
			to_chat(user, span_alert("The till is out of cash for buybacks right now. Try again later."))
			return
	var/payout = floor(units * unit_value)
	if(payout < 1)
		to_chat(user, span_alert("The dealer isn't interested."))
		return

	if(S && units < S.amount)
		S.use(units)
	else
		qdel(I)
	buyback_paid += payout

	var/remaining = payout
	while(remaining > 0)
		var/chunk = min(remaining, 1000)
		var/obj/item/stack/dollar/cash = new /obj/item/stack/dollar(loc, chunk)
		user.put_in_hands(cash)
		remaining -= chunk
	playsound(get_turf(src), 'sound/effects/cashregister.ogg', 50, TRUE)
	to_chat(user, span_notice("The dealer buys [units] [C.name] for [payout] [MONEY_NAME]."))

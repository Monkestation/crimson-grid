SUBSYSTEM_DEF(commodities)
	name = "Commodity Desk"
	wait = 1 MINUTES
	ss_flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME

	var/list/datum/commodity/commodities = list()
	var/list/commodities_by_ticker = list()
	/// item typepath > commodity
	var/list/commodity_by_item = list()
	/// Retail tills that sell at market price; refreshed every tick
	var/list/tills = list()

/datum/controller/subsystem/commodities/Initialize()
	for(var/path in subtypesof(/datum/commodity))
		var/datum/commodity/P = path
		if(initial(P.abstract))
			continue
		var/datum/commodity/C = new path
		C.initialize_history()
		commodities += C
		commodities_by_ticker[C.ticker] = C
		if(C.item_type)
			commodity_by_item[C.item_type] = C
	// Tills built at mapload had nothing to list yet
	for(var/obj/structure/retail/commodity/T as anything in tills)
		T.refresh_prices()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/commodities/fire(resumed = FALSE)
	for(var/datum/commodity/C as anything in commodities)
		C.tick()
	for(var/obj/structure/retail/commodity/T as anything in tills)
		T.refresh_prices()

/datum/controller/subsystem/commodities/proc/commodity_for_item(obj/item/I)
	var/path = I.type
	var/datum/commodity/C = commodity_by_item[path]
	if(C)
		return C
	return null

/// Market value of an item or stack at the current price. 0 if not a commodity.
/datum/controller/subsystem/commodities/proc/item_value(obj/item/I)
	var/datum/commodity/C = commodity_for_item(I)
	if(!C)
		return 0
	var/amt = 1
	if(istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		amt = S.amount
	return round(C.price * amt)

/datum/controller/subsystem/commodities/proc/shock(ticker, pct)
	var/datum/commodity/C = commodities_by_ticker[ticker]
	if(C)
		C.shock(pct)

/datum/round_event_control/darkpack/financial_crisis
	name = "Financial Crisis"
	typepath = /datum/round_event/financial_crisis
	weight = 2
	min_players = 5
	max_occurrences = 1
	earliest_start = 35 MINUTES
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "Wall Street has crashed catastrophically causing all of Bianchi Bank's accounts to tank as people lose their savings."
	darkpack_allowed = TRUE

/datum/round_event/financial_crisis
	start_when = 1
	announce_when = 3
	var/static/list/announcement_messages = list(
		"Markets across the Bay Area are in turmoil. Merchants report sudden and sharp increases in wholesale costs.",
		"A collapse on Wall Street has sent shockwaves through local supply chains. Expect higher prices at retailers until markets stabilize.",
		"Bianchi Bank analysts warn of runaway inflation as commodity prices surge following a major market crash.",
		"Fraudulent financial instruments have been exposed, and the resulting panic has sent the cost of goods through the roof.",
	)

/datum/round_event/financial_crisis/announce(fake)
	var/chosen_announcement = "[pick(announcement_messages)] Bianchi Bank customers are reminded that account balances are unaffected, but purchasing power may be reduced."
	endpost_announce("[chosen_announcement]", "BianchiBank")

/// Pushes every commodity up.
/datum/round_event/financial_crisis/proc/shock_market(min_pct, max_pct)
	for(var/datum/commodity/C as anything in SScommodities.commodities)
		if(C.is_bond) //bonds usually fall in a crash.
			continue
		SScommodities.shock(C.ticker, rand(min_pct * 100, max_pct * 100) / 100)

/datum/round_event/financial_crisis/start()

    shock_market(2.1, 3.2)

    var/inflation = rand(220, 330) / 100
    for(var/obj/structure/retail/store in world)
        if(istype(store, /obj/structure/retail/commodity))
            continue
        for(var/datum/data/vending_product/product as anything in store.products_list)
            if(product.price <= 0)
                continue
            product.price = max(product.price + 1, round(product.price * inflation))
        store.update_static_data_for_all_viewers()

    //packs increase
    for(var/pack_id in SSshuttle.supply_packs)
        var/datum/supply_pack/pack = SSshuttle.supply_packs[pack_id]
        if(!istype(pack) || pack.cost <= 0)
            continue
        pack.cost = max(pack.cost + 1, round(pack.cost * inflation))

    //we gotta do this cause static data
    for(var/obj/machinery/computer/cargo/console in world)
        console.update_static_data_for_all_viewers()

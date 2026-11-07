/datum/commodity
	var/name = "Commodity"
	var/ticker = "CMD"
	var/desc = ""
	var/item_type = null
	var/base_price = 100
	/// Per-tick average growth. Positive = the long-run trend line climbs.
	var/drift = 0.0008
	/// Max random swing per tick (fraction of price)
	var/volatility = 0.01
	/// Price never drops below base_price * floor_frac
	var/floor_frac = 0.5
	/// Fraction of price paid per coupon payout. 0 = none.
	var/coupon = 0
	var/is_bond = FALSE
	/// Abstract types are skipped when the subsystem builds the list
	var/abstract = FALSE

	var/price = 0
	var/last_price = 0
	var/pressure = 0
	var/ticks = 0
	var/list/history = list()

/datum/commodity/proc/initialize_history()
	price = base_price
	last_price = base_price
	history = list(price)
	for(var/i in 1 to COMMODITY_HISTORY_LEN - 1)
		tick()

/datum/commodity/proc/tick()
	ticks++
	last_price = price
	var/trend = base_price * ((1 + drift) ** ticks)
	var/noise = (rand() * 2 - 1) * volatility
	var/reversion = ((trend - price) / trend) * COMMODITY_REVERSION
	var/change = drift + noise + reversion + pressure
	pressure *= 0.6
	if(abs(pressure) < 0.0001)
		pressure = 0
	price = clamp(price * (1 + change), base_price * floor_frac, trend * 3)
	price = round(price, 0.01)
	history += price
	if(history.len > COMMODITY_HISTORY_LEN)
		history.Cut(1, history.len - COMMODITY_HISTORY_LEN + 1)

/// For events (strikes, gluts, discoveries). 0.1 = +10% over the next few ticks.
/datum/commodity/proc/shock(pct)
	pressure += pct

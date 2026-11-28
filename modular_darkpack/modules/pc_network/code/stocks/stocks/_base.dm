/// Natural base for the bonding curve.
#define STOCK_E 2.718281828
/// Players can collectively hold at most this many floats' worth of a stock.
#define STOCK_MAX_HELD_FLOATS 4

/datum/stock
	var/name = "Unnamed Holdings"
	var/ticker = "UNK"
	/// Mortal-safe blurb. Shown to everyone.
	var/desc = ""
	/// The real story. Only shown to users who pass knows_the_truth().
	var/secret_desc = ""
	/// Internal sector id, used for event effects. Never shown directly.
	var/sector = "finance"
	/// Subtypes set this as the starting price; it seeds `fundamental`.
	var/price = 100
	var/volatility = 0.02
	var/drift = 0.0005
	var/dividend = 0
	/// Depth of the market. Bigger float = harder to move.
	var/float_shares = 5000
	var/last_price = 100
	var/list/history = list()

	/// Random-walk value driven by noise, drift, sector mood and events. Trading never touches it.
	var/fundamental = 100
	/// Net shares players have bought from the market. Drives the demand premium.
	var/held = 0
	/// Steepness of the curve. price = fundamental * e^(impact_k * held / float_shares)
	/// Lower is more liquid. 0.5 means holding one full float makes the price ~1.65x.
	var/impact_k = 0.5

/// Spot price at a given amount of player-held shares.
/datum/stock/proc/price_at(held_shares)
	return max(1, fundamental * (STOCK_E ** (impact_k * held_shares / float_shares)))

/// Recomputes the displayed price from the fundamental and the demand premium.
/datum/stock/proc/update_price()
	price = round(price_at(held), 0.01)

/datum/stock/proc/initialize_history()
	fundamental = price
	history = list()
	for(var/i in 1 to STOCK_HISTORY_LEN)
		history += round(fundamental, 0.01)
		fundamental = max(1, fundamental * (1 + ((rand() + rand() + rand() - 1.5) * volatility)))
	last_price = history[history.len]
	update_price()

/datum/stock/proc/tick(sector_mood)
	last_price = price
	var/noise = (rand() + rand() + rand() - 1.5) * volatility * 2
	var/change = clamp(drift + noise + (sector_mood * 0.5), -0.5, 1)
	fundamental = max(1, round(fundamental * (1 + change), 0.01))
	update_price()
	history += price
	if(history.len > STOCK_HISTORY_LEN)
		history.Cut(1, 2)

/// Exact cost (buying) or proceeds (selling) of walking `shares` along the curve.
/// Integral of fundamental * e^(k*h) dh from held to held +/- shares, with k = impact_k / float_shares.
/datum/stock/proc/trade_cost(shares, buying)
	var/k = impact_k / float_shares
	var/h1 = held + (buying ? shares : -shares)
	return abs(fundamental * ((STOCK_E ** (k * h1)) - (STOCK_E ** (k * held))) / k)

/// Spot price once an order of this size has fully executed.
/datum/stock/proc/price_after(shares, buying)
	return round(price_at(held + (buying ? shares : -shares)), 0.01)

/// How many more shares players are allowed to take out of the market.
/datum/stock/proc/max_buyable()
	return max(0, round(STOCK_MAX_HELD_FLOATS * float_shares - held))

/// Records a completed trade and moves the price along the curve.
/// Not clamped at 0 on purpose: if shares ever enter the economy outside the exchange
/// (admin grants, starting portfolios), selling them can briefly push `held` negative,
/// which just means a small discount until the market rebalances.
/datum/stock/proc/apply_trade(shares, buying)
	held += buying ? shares : -shares
	update_price()

/// Smallest number of shares (up to max_shares) whose sale raises at least `target` money.
/// Returns max_shares if even selling all of them falls short.
/datum/stock/proc/shares_to_raise(target, max_shares)
	if(max_shares < 1)
		return 0
	if(trade_cost(max_shares, FALSE) <= target)
		return max_shares
	var/lo = 1
	var/hi = max_shares
	while(lo < hi)
		var/mid = round((lo + hi) / 2)
		if(trade_cost(mid, FALSE) >= target)
			hi = mid
		else
			lo = mid + 1
	return lo


#undef STOCK_MAX_HELD_FLOATS
#undef STOCK_E

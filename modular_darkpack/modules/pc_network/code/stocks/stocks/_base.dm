/datum/stock
	var/name = "Unnamed Holdings"
	var/ticker = "UNK"
	/// Mortal-safe blurb. Shown to everyone.
	var/desc = ""
	/// The real story. Only shown to users who pass knows_the_truth().
	var/secret_desc = ""
	/// Internal sector id, used for event effects. Never shown directly.
	var/sector = "finance"
	var/price = 100
	var/volatility = 0.02
	var/drift = 0.0005
	var/dividend = 0
	var/pressure = 0
	var/float_shares = 5000
	var/last_price = 100
	var/list/history = list()

/datum/stock/proc/initialize_history()
	history = list()
	for(var/i in 1 to STOCK_HISTORY_LEN)
		history += round(price, 0.01)
		price = max(1, price * (1 + ((rand() + rand() + rand() - 1.5) * volatility)))
	last_price = history[history.len]
	price = last_price

/datum/stock/proc/tick(sector_mood)
	last_price = price
	var/noise = (rand() + rand() + rand() - 1.5) * volatility * 2
	var/change = drift + noise + (sector_mood * 0.5) + pressure
	price = max(1, round(price * (1 + change), 0.01))
	pressure *= 0.5
	history += price
	if(history.len > STOCK_HISTORY_LEN)
		history.Cut(1, 2)

/datum/stock/proc/apply_trade_pressure(shares, buying)
	var/impact = (shares / float_shares) * 0.5
	pressure += buying ? impact : -impact

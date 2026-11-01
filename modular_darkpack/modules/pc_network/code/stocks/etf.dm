/datum/bank_account
	var/list/etf_networks = list()

/datum/pc_etf
	var/datum/pc_network/network
	var/datum/bank_account/pool_account
	var/list/holdings = list()
	var/total_shares = 0
	var/list/member_accounts = list()
	var/list/pending_cards = list()
	var/min_transaction = 10

/datum/pc_etf/New(datum/pc_network/net)
	network = net
	pool_account = new /datum/bank_account
	pool_account.account_holder = "[net.name] ETF"
	pool_account.account_id = "etf_[net.id]_[rand(1000,9999)]"
	SSeconomy.bank_accounts_by_id[pool_account.account_id] = pool_account

/datum/pc_etf/Destroy()
	if(pool_account)
		SSeconomy.bank_accounts_by_id -= pool_account.account_id
		qdel(pool_account)
	return ..()

/datum/pc_etf/proc/nav()
	if(total_shares <= 0)
		return 1.0
	return max(0.01, total_value() / total_shares)

/datum/pc_etf/proc/total_value()
	var/value = pool_account.account_balance
	for(var/ticker in holdings)
		var/datum/stock/S = SSstocks.stocks_by_ticker[ticker]
		if(S)
			value += holdings[ticker] * S.price
	return value

/datum/pc_etf/proc/shares_of(datum/bank_account/acc)
	if(!acc)
		return 0
	return member_accounts["[acc.account_id]"] || 0

/datum/pc_etf/proc/value_of(datum/bank_account/acc)
	return shares_of(acc) * nav()

/datum/pc_etf/proc/is_member(datum/bank_account/acc)
	return acc && (network.id in acc.etf_networks)

/datum/pc_etf/proc/publish_card(datum/bank_account/acc, duration = 30 SECONDS, atom/scanner = null)
	if(!acc)
		return FALSE
	pending_cards["[acc.account_id]"] = list(
		"holder" = acc.account_holder,
		"expire" = world.time + duration,
		"scanned_by" = scanner ? "[scanner]" : null,
	)
	return TRUE

/datum/pc_etf/proc/get_pending()
	var/list/result = list()
	var/now = world.time
	for(var/id in pending_cards)
		var/list/entry = pending_cards[id]
		if(now >= entry["expire"])
			pending_cards -= id
			continue
		result += list(list(
			"account_id" = id,
			"holder" = entry["holder"],
			"expires_in" = round((entry["expire"] - now) / 10),
			"scanned_by" = entry["scanned_by"],
		))
	return result

/datum/pc_etf/proc/enroll(account_id)
	var/list/entry = pending_cards[account_id]
	if(!entry || world.time >= entry["expire"])
		pending_cards -= account_id
		return FALSE
	var/datum/bank_account/acc = SSeconomy.bank_accounts_by_id[account_id]
	if(!acc)
		pending_cards -= account_id
		return FALSE
	acc.etf_networks |= network.id
	pending_cards -= account_id
	return TRUE

/datum/pc_etf/proc/receive_dividends()
	var/total = 0
	for(var/ticker in holdings)
		var/datum/stock/S = SSstocks.stocks_by_ticker[ticker]
		if(!S || S.dividend <= 0 || holdings[ticker] <= 0)
			continue
		total += round(holdings[ticker] * S.price * S.dividend)
	if(total > 0)
		pool_account.adjust_money(total, "ETF dividends")
	return total

/datum/pc_etf/proc/deposit(datum/bank_account/acc, amount)
	amount = round(amount)
	if(amount < min_transaction || !acc || !acc.has_money(amount))
		return FALSE
	if(!acc.adjust_money(-amount, "ETF deposit into [network.name]"))
		return FALSE
	pool_account.adjust_money(amount, "ETF deposit from [acc.account_holder]")
	var/nav_now = nav()
	var/units = amount / nav_now
	member_accounts["[acc.account_id]"] = shares_of(acc) + units
	total_shares += units
	return TRUE

/datum/pc_etf/proc/withdraw(datum/bank_account/acc, amount = 0)
	var/my_units = shares_of(acc)
	if(my_units <= 0)
		return FALSE
	var/nav_now = nav()
	var/units_to_redeem
	if(amount > 0)
		units_to_redeem = min(my_units, amount / nav_now)
	else
		units_to_redeem = my_units
	if(units_to_redeem <= 0)
		return FALSE
	var/cash_needed = units_to_redeem * nav_now
	if(pool_account.account_balance < cash_needed)
		// Force sell holdings until we have enough (simple proportional)
		ensure_cash(cash_needed)
		cash_needed = min(cash_needed, pool_account.account_balance)
		units_to_redeem = cash_needed / nav_now
		if(units_to_redeem <= 0)
			return FALSE
	pool_account.adjust_money(-cash_needed, "ETF redeem to [acc.account_holder]")
	acc.adjust_money(cash_needed, "ETF withdrawal from [network.name]")
	member_accounts["[acc.account_id]"] -= units_to_redeem
	total_shares -= units_to_redeem
	if(member_accounts["[acc.account_id]"] <= 0.0001)
		member_accounts -= "[acc.account_id]"
	return TRUE

/datum/pc_etf/proc/ensure_cash(needed)
	needed = round(needed)
	if(pool_account.account_balance >= needed)
		return TRUE
	var/shortfall = needed - pool_account.account_balance
	if(!length(holdings))
		return FALSE
	for(var/ticker in holdings.Copy())
		if(shortfall <= 0)
			break
		var/datum/stock/S = SSstocks.stocks_by_ticker[ticker]
		if(!S || holdings[ticker] <= 0)
			continue
		var/value = holdings[ticker] * S.price
		if(value <= 0)
			continue
		var/sell_value = min(value, shortfall)
		var/shares_to_sell = max(1, round(sell_value / S.price))
		shares_to_sell = min(shares_to_sell, holdings[ticker])
		var/gross = round(S.price * shares_to_sell)
		pool_account.adjust_money(gross, "ETF internal sell [shares_to_sell] [ticker]")
		holdings[ticker] -= shares_to_sell
		if(holdings[ticker] <= 0)
			holdings -= ticker
		S.apply_trade_pressure(shares_to_sell, FALSE)
		shortfall -= gross
	return pool_account.account_balance >= needed

/datum/pc_etf/proc/buy_for_pool(ticker, amount)
	amount = round(amount)
	if(amount < 1)
		return FALSE
	var/datum/stock/S = SSstocks.stocks_by_ticker[ticker]
	if(!S)
		return FALSE
	var/cost = round(S.price * amount)
	if(pool_account.account_balance < cost)
		return FALSE
	if(!pool_account.adjust_money(-cost, "ETF pool buy [amount] [ticker]"))
		return FALSE
	holdings[ticker] = (holdings[ticker] || 0) + amount
	S.apply_trade_pressure(amount, TRUE)
	return TRUE

/datum/pc_etf/proc/sell_for_pool(ticker, amount)
	amount = round(amount)
	if(amount < 1)
		return FALSE
	var/owned = holdings[ticker] || 0
	if(owned < amount)
		return FALSE
	var/datum/stock/S = SSstocks.stocks_by_ticker[ticker]
	if(!S)
		return FALSE
	var/gross = round(S.price * amount)
	pool_account.adjust_money(gross, "ETF pool sell [amount] [ticker]")
	holdings[ticker] -= amount
	if(holdings[ticker] <= 0)
		holdings -= ticker
	S.apply_trade_pressure(amount, FALSE)
	return TRUE

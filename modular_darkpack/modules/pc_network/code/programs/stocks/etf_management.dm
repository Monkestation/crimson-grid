/datum/pc_program/etf
	name = "Night Exchange ETF"
	icon_state = "chart-pie"
	tgui_id = "PcEtf"

/datum/pc_program/etf/ui_data(mob/user)
	var/list/data = list()
	var/datum/bank_account/acc = computer.get_logged_account()
	if(!acc)
		data["error"] = "No account logged in."
		return data

	var/datum/pc_network/net = computer.current_network
	var/datum/pc_etf/etf = net?.etf

	data["holder"] = acc.account_holder
	data["balance"] = acc.account_balance
	data["debt"] = acc.account_debt
	data["network_name"] = net?.name || "No Network"
	data["etf_available"] = !!etf

	if(!etf)
		return data

	data["pending"] = etf.get_pending()
	data["etf_nav"] = etf.nav()
	data["etf_pool_value"] = etf.total_value()
	data["etf_total_shares"] = etf.total_shares
	data["etf_cash"] = etf.pool_account.account_balance
	data["etf_min"] = etf.min_transaction

	var/list/holdings_out = list()
	for(var/ticker in etf.holdings)
		var/datum/stock/S = SSstocks.stocks_by_ticker[ticker]
		if(!S)
			continue
		holdings_out += list(list(
			"ticker" = ticker,
			"name" = S.name,
			"shares" = etf.holdings[ticker],
			"price" = S.price,
			"value" = round(S.trade_cost(etf.holdings[ticker], FALSE)),
			"sector" = SSstocks.sector_labels[S.sector] || "Other",
		))
	data["holdings"] = holdings_out

	var/list/members_out = list()
	for(var/id in etf.member_accounts)
		var/datum/bank_account/member = SSeconomy.bank_accounts_by_id[id]
		if(!member)
			continue
		members_out += list(list(
			"account_id" = id,
			"holder" = member.account_holder,
			"shares" = etf.member_accounts[id],
			"value" = etf.member_accounts[id] * etf.nav(),
		))
	data["members"] = members_out

	// Full stock list for trading the pool (mirrors Night Exchange)
	var/list/stock_list = list()
	for(var/datum/stock/S as anything in SSstocks.stocks)
		stock_list += list(list(
			"ticker" = S.ticker,
			"name" = S.name,
			"desc" = S.desc,
			"sector" = SSstocks.sector_labels[S.sector] || "Other",
			"price" = S.price,
			"last_price" = S.last_price,
			"dividend" = S.dividend,
			"history" = S.history.Copy(),
			"owned" = etf.holdings[S.ticker] || 0,
			"fundamental" = S.fundamental,
			"held" = S.held,
			"impact_k" = S.impact_k,
			"float_shares" = S.float_shares,
			"max_buyable" = S.max_buyable(),
		))
	data["stocks"] = stock_list

	return data

/datum/pc_program/etf/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/bank_account/acc = computer.get_logged_account()
	if(!acc)
		return FALSE

	var/datum/pc_network/net = computer.current_network
	var/datum/pc_etf/etf = net?.etf
	if(!etf)
		return FALSE

	var/mob/user = ui?.user

	switch(action)
		if("enroll")
			var/target_id = params["account_id"]
			if(!istext(target_id))
				return FALSE
			var/success = etf.enroll(target_id)
			if(success && user)
				var/datum/bank_account/target = SSeconomy.bank_accounts_by_id[target_id]
				to_chat(user, span_notice("Enrolled [target?.account_holder || target_id] into the ETF."))
			else if(user)
				to_chat(user, span_warning("Enrollment failed (expired or invalid)."))
			return success

		if("pool_buy")
			var/ticker = params["ticker"]
			var/amount = round(text2num(params["amount"]))
			if(!istext(ticker) || amount < 1)
				return FALSE
			var/success = etf.buy_for_pool(ticker, amount)
			if(!success && user)
				to_chat(user, span_warning("Pool buy failed (insufficient cash, no shares left, or invalid)."))
			return success

		if("pool_sell")
			var/ticker = params["ticker"]
			var/amount = round(text2num(params["amount"]))
			if(!istext(ticker) || amount < 1)
				return FALSE
			var/success = etf.sell_for_pool(ticker, amount)
			if(!success && user)
				to_chat(user, span_warning("Pool sell failed."))
			return success

	return FALSE

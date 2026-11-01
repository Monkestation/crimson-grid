/datum/pc_program/stocks
	name = "Night Exchange"
	icon_state = "chart-line"
	tgui_id = "PcStockMarket"

/datum/pc_program/stocks/ui_data(mob/user)
	var/list/data = list()
	var/datum/bank_account/acc = computer.get_logged_account()
	if(!acc)
		data["error"] = "No account logged in."
		return data

	var/dots = SSstocks.finance_dots(user)
	data["holder"] = acc.account_holder
	data["balance"] = acc.account_balance
	data["debt"] = acc.account_debt
	data["finance"] = dots
	data["fee"] = SSstocks.fee_rate_for(dots)
	data["tax_rate"] = SSstocks.tax_rate_for(dots)
	data["long_term_seconds"] = STOCK_LONG_TERM / 10
	data["garnish"] = STOCK_GARNISH
	data["portfolio_value"] = SSstocks.portfolio_value(acc)
	data["knows"] = computer.current_network?.id == PC_NETWORK_SCHRECKNET

	var/show_outlook = dots >= STOCK_OUTLOOK_FINANCE
	var/list/stock_list = list()
	for(var/datum/stock/S as anything in SSstocks.stocks)
		var/list/lots_out = list()
		var/list/lots = SSstocks.get_lots(acc, S.ticker)
		for(var/datum/stock_lot/L as anything in lots)
			lots_out += list(list(L.shares, L.cost, round((world.time - L.bought_at) / 10)))
		stock_list += list(list(
			"ticker" = S.ticker,
			"name" = S.name,
			"desc" = S.desc,
			"secret" = computer.current_network?.id == PC_NETWORK_SCHRECKNET ? S.secret_desc : null,
			"sector" = SSstocks.sector_labels[S.sector] || "Other",
			"price" = S.price,
			"last_price" = S.last_price,
			"dividend" = S.dividend,
			"history" = S.history.Copy(),
			"owned" = SSstocks.count_shares(lots),
			"cost_basis" = SSstocks.cost_of(acc, S.ticker),
			"lots" = lots_out,
			"outlook" = show_outlook ? SSstocks.outlook_for(S) : null,
		))
	data["stocks"] = stock_list
	return data

/datum/pc_program/stocks/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/bank_account/acc = computer.get_logged_account()
	if(!acc)
		return FALSE

	var/mob/user = ui?.user
	var/ticker = istext(params["ticker"]) ? params["ticker"] : null
	var/amount = round(text2num(params["amount"]))
	if(isnull(ticker) || !SSstocks.stocks_by_ticker[ticker])
		return FALSE

	var/dots = SSstocks.finance_dots(user)
	var/fee_rate = SSstocks.fee_rate_for(dots)
	var/tax_rate = SSstocks.tax_rate_for(dots)

	switch(action)
		if("buy")
			if(amount < 1)
				return FALSE
			amount = min(amount, STOCK_MAX_TRADE)
			var/success = SSstocks.buy_shares(acc, ticker, amount, fee_rate)
			if(!success && user)
				to_chat(user, span_warning("The Exchange declines the order: insufficient funds."))
			return success

		if("sell", "sell_all")
			if(action == "sell_all")
				amount = SSstocks.shares_owned(acc, ticker)
			if(amount < 1)
				return FALSE
			amount = min(amount, STOCK_MAX_TRADE)
			var/list/result = SSstocks.sell_shares(acc, ticker, amount, fee_rate, tax_rate)
			if(!result)
				return FALSE
			if(user)
				var/msg = "Sold [result["shares"]] [ticker]: gross [result["gross"]], fee [result["fee"]]"
				if(result["tax"])
					msg += ", short-term gains tax [result["tax"]]"
				if(result["garnish"])
					msg += ", creditors seized [result["garnish"]]"
				to_chat(user, span_notice("[msg]. Net [result["net"]]."))
			return TRUE
	return FALSE

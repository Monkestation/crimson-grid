/datum/pc_program/bank
	name = "Bank Manager"
	icon_state = "landmark"
	tgui_id = "PcBankManager"

/datum/pc_program/bank/ui_data(mob/user)
	var/list/data = list()
	var/datum/bank_account/acc = computer.get_logged_account()
	if(!acc)
		data["error"] = "No account logged in."
		return data
	data["holder"] = acc.account_holder
	data["balance"] = acc.account_balance
	data["debt"] = acc.account_debt
	data["mining_points"] = acc.mining_points
	data["history"] = acc.transaction_history
	data["pay_token"] = acc.pay_token
	var/datum/pc_network/net = computer.current_network
	var/datum/pc_etf/etf = net?.etf
	data["etf_available"] = !!etf
	data["etf_enrolled"] = etf && (net.id in acc.etf_networks)
	if(data["etf_enrolled"])
		data["etf_shares"] = etf.shares_of(acc)
		data["etf_nav"] = etf.nav()
		data["etf_value"] = etf.value_of(acc)
		data["etf_min"] = etf.min_transaction
	return data

/datum/pc_program/bank/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/bank_account/acc = computer.get_logged_account()
	var/datum/pc_network/net = computer.current_network
	var/datum/pc_etf/etf = net?.etf
	if(!acc)
		return FALSE
	switch(action)
		if("transfer")
			var/target_id = params["target"]
			var/amount = text2num(params["amount"])
			if(amount <= 0)
				return FALSE
			for(var/id in SSeconomy.bank_accounts_by_id)
				var/datum/bank_account/T = SSeconomy.bank_accounts_by_id[id]
				if(T == acc)
					continue
				if(T.account_holder == target_id || T.pay_token == target_id)
					var/success = T.transfer_money(acc, amount, "PC Transfer")
					if(success)
						notify_tap(acc, T, amount)
					return success

		if("pay_underling")
			var/target_name = params["name"]
			var/amount = text2num(params["amount"])
			if(amount <= 0)
				return FALSE
			for(var/id in SSeconomy.bank_accounts_by_id)
				var/datum/bank_account/T = SSeconomy.bank_accounts_by_id[id]
				if(T == acc)
					continue
				if(T.account_holder == target_name || T.pay_token == target_name)
					var/success = T.transfer_money(acc, amount, "Underling Stipend")
					if(success)
						notify_tap(acc, T, amount)
					return success

		if("pay_debt")
			var/amount = text2num(params["amount"])
			if(amount <= 0 || acc.account_debt <= 0)
				return FALSE
			return acc.pay_debt(min(amount, acc.account_debt)) > 0

		if("etf_deposit")
			if(!etf || !(net.id in acc.etf_networks))
				return FALSE
			var/amount = round(text2num(params["amount"]))
			if(amount < etf.min_transaction)
				return FALSE
			return etf.deposit(acc, amount)

		if("etf_withdraw")
			if(!etf || !(net.id in acc.etf_networks))
				return FALSE
			var/amount = round(text2num(params["amount"]))
			return etf.withdraw(acc, amount)

		if("etf_leave")
			if(!etf || !(net.id in acc.etf_networks))
				return FALSE
			if(etf.shares_of(acc) > 0)
				etf.withdraw(acc, 0)
			acc.etf_networks -= net.id
			if(ui.user)
				to_chat(ui.user, span_notice("You left the [net.name] ETF."))
			return TRUE
	return FALSE

/datum/pc_program/bank/notify_tap(datum/bank_account/payer, datum/bank_account/payee, amount)
	var/datum/pc_program/hacking/hacker = tap?.resolve()
	if(!hacker || world.time > tap_until)
		tap = null
		return
	hacker.receive_payment(computer.get_network_device_id(), payer, payee, amount)

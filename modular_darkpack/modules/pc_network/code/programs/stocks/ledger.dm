/datum/pc_program/ledger
	name = "Network Ledger"
	icon_state = "landmark"
	tgui_id = "PcLedger"

/datum/pc_program/ledger/proc/can_manage(mob/user, datum/pc_network/net)
	if(!user || !net)
		return FALSE
	return net.has_access(user.real_name, PC_NETWORK_USER)

/datum/pc_program/ledger/ui_data(mob/user)
	var/list/data = list()
	var/datum/bank_account/acc = computer.get_logged_account()
	if(!acc)
		data["error"] = "No account logged in."
		return data

	var/datum/pc_network/net = computer.current_network
	var/datum/pc_treasury/T = net?.treasury
	data["holder"] = acc.account_holder
	data["network_name"] = net?.name || "No Network"
	data["available"] = !!T
	if(!T)
		return data

	data["can_manage"] = can_manage(user, net)
	data["treasury_balance"] = T.account?.account_balance || 0
	data["owed"] = T.owed
	data["network_rate"] = LENDING_NETWORK_RATE
	data["interest_minutes"] = LENDING_INTEREST_FIRES
	data["min_rate"] = LENDING_MIN_RATE
	data["max_rate"] = LENDING_MAX_RATE

	var/list/w = T.wealth()
	data["wealth"] = w
	data["credit_limit"] = max(0, round(w["total"] - T.owed))
	data["last_scan_ago"] = w["last_scan"] ? round((world.time - w["last_scan"]) / 10) : null

	var/list/atms_out = list()
	for(var/obj/machinery/atm/A as anything in T.get_atms())
		var/area/atm_area = get_area(A)
		atms_out += list(list("ref" = REF(A), "name" = A.name, "area" = atm_area ? atm_area.name : "Unknown", "cash" = A.total_stored_cash))
	data["atms"] = atms_out

	data["pending"] = T.get_pending()

	var/list/loans_out = list()
	for(var/datum/pc_loan/L as anything in T.loans)
		loans_out += list(list(
			"account_id" = L.borrower_id,
			"holder" = L.holder,
			"principal" = L.principal,
			"owed" = L.owed,
			"rate" = L.rate,
			"age" = round((world.time - L.issued_at) / 10),
			"card_published" = T.card_valid(L.borrower_id),
		))
	data["loans"] = loans_out
	return data

/datum/pc_program/ledger/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/bank_account/acc = computer.get_logged_account()
	if(!acc)
		return FALSE
	var/datum/pc_network/net = computer.current_network
	var/datum/pc_treasury/T = net?.treasury
	var/mob/user = ui?.user
	if(!T)
		return FALSE
	if(!can_manage(user, net))
		if(user)
			to_chat(user, span_warning("You do not have authority over this network's funds."))
		return FALSE

	var/amount = round(text2num(params["amount"]))

	switch(action)
		if("scan")
			var/count = T.rescan_all()
			if(user)
				var/text = count ? "Rescanned [count] area scanner\s." : "No area scanners are connected to this network."
				to_chat(user, span_notice(text))
			return TRUE

		if("borrow")
			var/ok = T.borrow(amount)
			if(!ok && user)
				to_chat(user, span_warning("The credit line declines the draw: over your limit."))
			return ok

		if("repay")
			var/paid = T.repay(amount)
			if(!paid && user)
				to_chat(user, span_warning("Nothing repaid: the treasury is empty or nothing is owed."))
			return !!paid

		if("fill_atm", "drain_atm")
			var/atom/A = net.resolve_device(params["ref"])
			if(!istype(A, /obj/machinery/atm))
				return FALSE
			var/obj/machinery/atm/atm = A
			var/moved = action == "fill_atm" ? T.fill_atm(atm, amount) : T.drain_atm(atm, amount)
			if(user)
				if(moved)
					to_chat(user, span_notice("[action == "fill_atm" ? "Sent" : "Collected"] [moved] [MONEY_NAME] [action == "fill_atm" ? "to" : "from"] [atm.name]."))
				else
					to_chat(user, span_warning("Transfer failed."))
			return !!moved

		if("issue_loan")
			var/error = T.issue_loan(params["account_id"], amount, text2num(params["rate"]))
			if(user)
				if(error)
					to_chat(user, span_warning(error))
				else
					to_chat(user, span_notice("Loan issued."))
			return !error

		if("collect")
			var/got = T.collect(params["account_id"], amount)
			if(user)
				if(got)
					to_chat(user, span_notice("Collected [got] [MONEY_NAME]."))
				else
					to_chat(user, span_warning("Nothing collected: card not published, no loan, or the account is empty."))
			return !!got

		if("forgive")
			var/datum/pc_loan/L = T.get_loan_for(params["account_id"])
			if(!L)
				return FALSE
			T.close_loan(L)
			return TRUE
	return FALSE

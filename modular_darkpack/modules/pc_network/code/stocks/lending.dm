/// A loan made by a network treasury to a person. One open loan per borrower per treasury.
/datum/pc_loan
	var/borrower_id
	var/holder
	var/principal = 0
	var/owed = 0
	var/rate = 0.01
	var/issued_at = 0
	var/datum/pc_treasury/treasury

///money that exists on this network, done so we can have seperatee vaults
/datum/pc_treasury
	var/datum/pc_network/network
	var/datum/bank_account/account
	/// What the network owes on its credit line (principal + accrued interest)
	var/owed = 0
	var/list/datum/pc_loan/loans = list()
	/// account_id > world.time the published card expires
	var/list/pending = list()

/datum/pc_treasury/New(datum/pc_network/net)
	network = net

/datum/pc_treasury/Destroy()
	for(var/datum/pc_loan/L as anything in loans)
		SSlending.unregister_loan(L)
		qdel(L)
	loans.Cut()
	network = null
	return ..()

/datum/pc_treasury/proc/get_account()
	RETURN_TYPE(/datum/bank_account)
	if(!account)
		account = new /datum/bank_account("[network.name] Treasury", null, 1, FALSE)
	return account

/datum/pc_treasury/proc/get_scanners()
	var/list/out = list()
	for(var/datum/weakref/ref as anything in network.connected)
		var/obj/machinery/pc_area_scanner/S = ref.resolve()
		if(istype(S))
			out += S
	return out

/// Fresh scan on every scanner. Returns how many scanned.
/datum/pc_treasury/proc/rescan_all()
	var/count = 0
	for(var/obj/machinery/pc_area_scanner/S as anything in get_scanners())
		S.scan()
		count++
	return count

/// Sums scanner snapshots. Two scanners in the same area are only counted once.
/datum/pc_treasury/proc/vault_snapshot()
	var/list/counted = list()
	var/dollars = 0
	var/list/units = list()
	var/newest = 0
	for(var/obj/machinery/pc_area_scanner/S as anything in get_scanners())
		if(!S.scanned_area || (S.scanned_area in counted))
			continue
		counted += S.scanned_area
		dollars += S.scanned_dollars
		for(var/ticker in S.scanned_commodities)
			units[ticker] += S.scanned_commodities[ticker]
		newest = max(newest, S.last_scan_time)
	return list("dollars" = dollars, "commodities" = units, "areas" = length(counted), "last_scan" = newest)

/// Returns list(dollars, commodity_value, commodity_rows, treasury, etf, total, areas, last_scan)
/datum/pc_treasury/proc/wealth()
	var/list/vault = vault_snapshot()
	var/list/rows = list()
	var/commodity_value = 0
	var/list/units = vault["commodities"]
	for(var/ticker in units)
		var/datum/commodity/C = SScommodities.commodities_by_ticker[ticker]
		if(!C)
			continue
		var/value = round(units[ticker] * C.price)
		commodity_value += value
		rows += list(list("ticker" = ticker, "name" = C.name, "units" = units[ticker], "price" = C.price, "value" = value))
	var/etf_value = round(network.etf?.total_value() || 0)
	var/treasury_cash = account ? account.account_balance : 0
	var/treasury_net = max(0, treasury_cash - owed)
	return list(
		"dollars" = vault["dollars"],
		"commodity_value" = commodity_value,
		"commodity_rows" = rows,
		"treasury" = treasury_net,
		"etf" = etf_value,
		"total" = vault["dollars"] + commodity_value + treasury_net + etf_value,
		"areas" = vault["areas"],
		"last_scan" = vault["last_scan"],
	)

/datum/pc_treasury/proc/deposit(amount)
	amount = round(amount)
	if(amount < 1)
		return FALSE
	get_account().adjust_money(amount, "Cash deposit")
	return TRUE

/datum/pc_treasury/proc/credit_limit()
	var/list/w = wealth()
	return max(0, round(w["total"] - owed))

/datum/pc_treasury/proc/borrow(amount)
	amount = round(amount)
	if(amount < 1)
		return FALSE
	rescan_all() // never lend against a stale snapshot
	if(amount > credit_limit())
		return FALSE
	get_account().adjust_money(amount, "Network credit line: drawn")
	owed += amount
	return TRUE

/// Returns the amount actually repaid (0 on failure)
/datum/pc_treasury/proc/repay(amount)
	var/datum/bank_account/acc = get_account()
	amount = min(round(amount), owed, acc.account_balance)
	if(amount < 1)
		return 0
	acc.adjust_money(-amount, "Network credit line: repayment")
	owed -= amount
	return amount

/datum/pc_treasury/proc/get_atms()
	var/list/out = list()
	for(var/datum/weakref/ref as anything in network.connected)
		var/obj/machinery/atm/A = ref.resolve()
		if(istype(A))
			out += A
	return out

/// Treasury cash > ATM stock. Returns amount moved.
/datum/pc_treasury/proc/fill_atm(obj/machinery/atm/atm, amount)
	if(!istype(atm) || !network.is_connected(atm))
		return 0
	var/datum/bank_account/acc = get_account()
	amount = min(round(amount), acc.account_balance)
	if(amount < 1)
		return 0
	acc.adjust_money(-amount, "ATM refill: [atm.name]")
	atm.total_stored_cash += amount
	return amount

/// ATM stock > treasury cash. Returns amount moved.
/datum/pc_treasury/proc/drain_atm(obj/machinery/atm/atm, amount)
	if(!istype(atm) || !network.is_connected(atm))
		return 0
	amount = min(round(amount), atm.total_stored_cash)
	if(amount < 1)
		return 0
	atm.total_stored_cash -= amount
	get_account().adjust_money(amount, "ATM collection: [atm.name]")
	return amount

/datum/pc_treasury/proc/publish_card(datum/bank_account/acc, duration)
	pending["[acc.account_id]"] = world.time + duration

/datum/pc_treasury/proc/card_valid(account_id)
	var/expires = pending["[account_id]"]
	return !isnull(expires) && expires > world.time

/datum/pc_treasury/proc/get_pending()
	var/list/out = list()
	for(var/id in pending.Copy())
		if(pending[id] <= world.time)
			pending -= id
			continue
		var/datum/bank_account/acc = SSeconomy.bank_accounts_by_id[id]
		if(!acc)
			pending -= id
			continue
		out += list(list(
			"account_id" = id,
			"holder" = acc.account_holder,
			"remaining" = round((pending[id] - world.time) / 10),
			"has_loan" = !!get_loan_for(id),
		))
	return out

/datum/pc_treasury/proc/get_loan_for(account_id)
	for(var/datum/pc_loan/L as anything in loans)
		if(L.borrower_id == "[account_id]")
			return L
	return null

/// Returns an error string, or null on success.
/datum/pc_treasury/proc/issue_loan(account_id, amount, rate)
	if(!card_valid(account_id))
		return "That card is no longer published."
	var/datum/bank_account/borrower = SSeconomy.bank_accounts_by_id["[account_id]"]
	if(!borrower)
		return "Unknown account."
	amount = round(amount)
	if(amount < 1)
		return "Invalid amount."
	if(get_loan_for(account_id))
		return "That account already has an open loan."
	var/datum/bank_account/acc = get_account()
	if(acc.account_balance < amount)
		return "The treasury cannot cover that."
	rate = clamp(isnum(rate) ? rate : 0.01, LENDING_MIN_RATE, LENDING_MAX_RATE)

	acc.adjust_money(-amount, "Loan issued to [borrower.account_holder]")
	borrower.adjust_money(amount, "Loan from [network.name]", FALSE) // No Garnish
	var/datum/pc_loan/L = new
	L.borrower_id = "[account_id]"
	L.holder = borrower.account_holder
	L.principal = amount
	L.owed = amount
	L.rate = rate
	L.issued_at = world.time
	L.treasury = src
	loans += L
	SSlending.register_loan(L)
	return null

/// Pulls from the borrower's account. Returns amount collected.
/datum/pc_treasury/proc/collect(account_id, amount)
	if(!card_valid(account_id))
		return 0
	var/datum/pc_loan/L = get_loan_for(account_id)
	var/datum/bank_account/borrower = SSeconomy.bank_accounts_by_id["[account_id]"]
	if(!L || !borrower)
		return 0
	amount = min(round(amount), L.owed, borrower.account_balance)
	if(amount < 1)
		return 0
	borrower.adjust_money(-amount, "Loan repayment to [network.name]")
	apply_payment(L, amount)
	return amount

/// Credits the treasury and reduces the loan. Closes it when paid off.
/datum/pc_treasury/proc/apply_payment(datum/pc_loan/L, amount)
	get_account().adjust_money(amount, "Loan repayment: [L.holder]")
	L.owed -= amount
	if(L.owed <= 0)
		close_loan(L)

/datum/pc_treasury/proc/close_loan(datum/pc_loan/L)
	loans -= L
	SSlending.unregister_loan(L)
	qdel(L)

/// compoundin step for the credit line and every loan.
/datum/pc_treasury/proc/accrue()
	if(owed > 0)
		owed += max(1, round(owed * LENDING_NETWORK_RATE))
	for(var/datum/pc_loan/L as anything in loans)
		L.owed += max(1, round(L.owed * L.rate))

SUBSYSTEM_DEF(lending)
	name = "Lending Desk"
	wait = 1 MINUTES
	ss_flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME

	var/interest_counter = 0
	/// account_id > list of /datum/pc_loan, so sales can garnish without scanning every network
	var/list/loans_by_account = list()

/datum/controller/subsystem/lending/fire(resumed = FALSE)
	interest_counter++
	if(interest_counter < LENDING_INTEREST_FIRES)
		return
	interest_counter = 0
	for(var/id in GLOB.pc_networks)
		var/datum/pc_network/net = GLOB.pc_networks[id]
		net?.treasury?.accrue()

/datum/controller/subsystem/lending/proc/register_loan(datum/pc_loan/L)
	var/list/existing = loans_by_account[L.borrower_id]
	if(!existing)
		existing = list()
		loans_by_account[L.borrower_id] = existing
	existing += L

/datum/controller/subsystem/lending/proc/unregister_loan(datum/pc_loan/L)
	var/list/existing = loans_by_account[L.borrower_id]
	if(!existing)
		return
	existing -= L
	if(!length(existing))
		loans_by_account -= L.borrower_id

/// Called from /datum/bank_account/adjust_money whenever money is deposited. Takes
/// LENDING_COLLECTION_COEFF of the deposit toward the account's open loans, oldest first.
/// Returns the amount taken.
/datum/controller/subsystem/lending/proc/garnish_account(datum/bank_account/acc, income)
	var/list/existing = loans_by_account["[acc.account_id]"]
	if(!length(existing) || income < 1)
		return 0
	var/budget = ceil(income * LENDING_COLLECTION_COEFF)
	var/taken = 0
	for(var/datum/pc_loan/L as anything in existing.Copy())
		if(budget <= 0)
			break
		var/pay = min(budget, L.owed, acc.account_balance)
		if(pay < 1)
			continue
		acc.adjust_money(-pay, "Loan repayment: [L.treasury.network?.name]")
		L.treasury.apply_payment(L, pay)
		budget -= pay
		taken += pay
	return taken

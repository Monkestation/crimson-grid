/datum/round_event_control/darkpack/financial_crisis
	name = "Financial Crisis"
	typepath = /datum/round_event/financial_crisis
	weight = 2
	min_players = 5
	max_occurrences = 1
	earliest_start = 50 MINUTES
	category = EVENT_CATEGORY_BUREAUCRATIC
	description = "Wall Street has crashed catastrophically causing all of Bianchi Bank's accounts to tank as people lose their savings."
	darkpack_allowed = TRUE

/datum/round_event/financial_crisis
	start_when = 1
	announce_when = 3
	var/static/list/announcement_messages = list(
		"Due to a recent power fluctuation, some Bianchi Bank customers may find their accounts to reflect an incorrect balance.",
		"Unfortunately, a recent banking error has affected a few Bianchi Bank customers in the Bay Area.",
		"A server crash at Bianchi Bank has resulted in bank balances reflecting the wrong amount.",
		"Bianchi Bank sadly announces that cutting-edge financial instruments have been revealed to be fraudulent, as tens of thousands of account holders savings are wiped out in seconds.",
	)

/datum/round_event/financial_crisis/announce(fake)
	var/chosen_announcement = "[pick(announcement_messages)] Customers are encouraged to contact the branch during normal business hours between 8:00am and 5:00pm, Monday through Friday."
	endpost_announce("[chosen_announcement]", "BianchiBank")

/datum/round_event/financial_crisis/start()
	for(var/account_id in SSeconomy.bank_accounts_by_id)
		var/datum/bank_account/bank = SSeconomy.bank_accounts_by_id[account_id]
		if(!istype(bank, /datum/bank_account))
			continue
		bank.adjust_money(-(round(bank.account_balance * (rand(85, 95) / 100))), "Financial Crisis") // leaves them with 5-15% of their savings


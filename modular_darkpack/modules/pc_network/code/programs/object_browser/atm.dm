/obj/machinery/atm
	network_id = PC_NETWORK_PUBLIC
	/// Set through network automation; refuses all card and cash input while TRUE
	var/locked = FALSE

/obj/machinery/atm/get_pc_triggers()
	return list(
		"swiped" = list(AUTOMATION_NAME = "Card swiped", AUTOMATION_DESC = "Fires when a card is swiped.", AUTOMATION_SIGNAL = COMSIG_ATM_CARD_SWIPED, AUTOMATION_MIN_ROLE = PC_NETWORK_USER),
		"login" = list(AUTOMATION_NAME = "Successful login", AUTOMATION_DESC = "Fires when someone enters the right PIN.", AUTOMATION_SIGNAL = COMSIG_ATM_LOGIN, AUTOMATION_MIN_ROLE = PC_NETWORK_USER),
		"login_failed" = list(AUTOMATION_NAME = "Wrong PIN entered", AUTOMATION_DESC = "Fires on a failed PIN attempt.", AUTOMATION_SIGNAL = COMSIG_ATM_LOGIN_FAILED, AUTOMATION_MIN_ROLE = PC_NETWORK_USER),
		"withdraw" = list(AUTOMATION_NAME = "Cash withdrawn", AUTOMATION_DESC = "Carries the amount.", AUTOMATION_SIGNAL = COMSIG_ATM_WITHDRAW, AUTOMATION_PAYLOAD = list("amount"), AUTOMATION_MIN_ROLE = PC_NETWORK_USER),
		"deposit" = list(AUTOMATION_NAME = "Cash deposited", AUTOMATION_DESC = "Carries the amount.", AUTOMATION_SIGNAL = COMSIG_ATM_DEPOSIT, AUTOMATION_PAYLOAD = list("amount"), AUTOMATION_MIN_ROLE = PC_NETWORK_USER),
	)

/obj/machinery/atm/get_pc_actions()
	return list(
		"lock" = list(AUTOMATION_NAME = "Lock ATM", AUTOMATION_DESC = "Refuses all cards and cash.", AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_set_lock), TRUE), AUTOMATION_MIN_ROLE = PC_NETWORK_ADMIN, AUTOMATION_ALLOW_AUTOMATE = TRUE),
		"unlock" = list(AUTOMATION_NAME = "Unlock ATM", AUTOMATION_DESC = "Accepts cards and cash again.", AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_set_lock), FALSE), AUTOMATION_MIN_ROLE = PC_NETWORK_ADMIN, AUTOMATION_ALLOW_AUTOMATE = TRUE),
	)

/obj/machinery/atm/get_pc_variables()
	return list(
		"stored_cash" = list(AUTOMATION_NAME = "Cash in machine", AUTOMATION_DESC = "Cash available to withdraw.", AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_stored_cash)), AUTOMATION_MIN_ROLE = PC_NETWORK_ADMIN),
		"locked" = list(AUTOMATION_NAME = "Locked", AUTOMATION_DESC = "1 if locked out by the network.", AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_get_locked)), AUTOMATION_MIN_ROLE = PC_NETWORK_USER),
	)

/obj/machinery/atm/proc/pc_stored_cash()
	return total_stored_cash

/obj/machinery/atm/proc/pc_get_locked()
	return locked ? 1 : 0

/obj/machinery/atm/proc/pc_set_lock(new_state, datum/bank_account/account, mob/user)
	locked = new_state
	if(locked)
		logged_in = FALSE
		logged_account = null
	return TRUE

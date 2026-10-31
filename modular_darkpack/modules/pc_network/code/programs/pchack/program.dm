GLOBAL_LIST_INIT(pc_hacks, init_pc_hacks())

/proc/init_pc_hacks()
	var/list/hacks = list()
	for(var/hack_type in subtypesof(/datum/pc_hack))
		hacks["[hack_type]"] = new hack_type
	return hacks

/datum/pc_program/hacking
	name = "Intrusion Suite"
	icon_state = "user-secret"
	tgui_id = "PcHacking"
	var/next_reveal_time = 0
	var/next_hack_time = 0
	/// device id -> TRUE for everything the last successful scan found.
	/// Devices are resolved live from net.connected_devices, so nothing stale is held here.
	var/list/revealed = list()
	/// Network id the revealed list was gathered on, the list is dropped if we move off it
	var/revealed_network_id
	/// Device id currently selected in the UI
	var/selected_device
	var/list/results = list()
	var/list/intercepts = list()
	var/list/payments = list()
	/// REF(atm) -> weakref, for every ATM we have signals registered on
	var/list/tapped_atms = list()
	/// REF(atm) -> world.time the tap runs out
	var/list/tap_expiry = list()

/datum/pc_program/hacking/Destroy()
	for(var/key in tapped_atms)
		var/datum/weakref/ref = tapped_atms[key]
		var/obj/machinery/atm/atm = ref?.resolve()
		if(atm)
			UnregisterSignal(atm, list(COMSIG_ATM_WITHDRAW, COMSIG_ATM_DEPOSIT))
	tapped_atms.Cut()
	return ..()

/datum/pc_program/hacking/proc/add_result(text)
	results.Insert(1, "[time_to_twelve_hour()] - [text]")
	if(length(results) > HACK_MAX_RESULTS)
		results.Cut(HACK_MAX_RESULTS + 1)

/datum/pc_program/hacking/proc/get_network_difficulty(datum/pc_network/net)
	if(istype(net, /datum/pc_network/player))
		var/datum/pc_network/player/player_net = net
		return player_net.hack_difficulty
	return HACK_DEFAULT_NET_DIFFICULTY

/datum/pc_program/hacking/proc/roll_hack(mob/user, difficulty)
	var/datum/storyteller_roll/hack_network/roll = new()
	roll.difficulty = difficulty + computer.hack_difficulty
	var/result = roll.st_roll(user, computer)
	qdel(roll)
	return result

/// Rolls an intrusion attempt against a revealed device. Returns TRUE on success.
/// Starts the shared cooldown and handles the failure logging for every kind of attempt.
/datum/pc_program/hacking/proc/roll_intrusion(mob/user, datum/pc_network/net, atom/target, device_id, label, difficulty_mod = 0)
	next_hack_time = world.time + HACK_ATTEMPT_COOLDOWN
	var/result = roll_hack(user, get_network_difficulty(net) + difficulty_mod)
	if(result == ROLL_SUCCESS)
		return TRUE
	net.log_event(NETWORK_LOG_INTRUSION, target)
	add_result("[label] against [device_id] failed. The attempt was logged.")
	if(result == ROLL_BOTCH)
		net.log_event(NETWORK_LOG_INTRUSION_TRACED, computer)
		add_result("Warning: your device ID was exposed in the intrusion log.")
	return FALSE

/datum/pc_program/hacking/proc/validate_reveal()
	var/datum/pc_network/net = computer.current_network
	if(!net || net.id != revealed_network_id)
		revealed.Cut()
		revealed_network_id = null
		selected_device = null

/datum/pc_program/hacking/proc/get_revealed_device(device_id)
	validate_reveal()
	if(!revealed[device_id])
		return null
	var/datum/pc_network/net = computer.current_network
	var/datum/weakref/ref = net?.connected_devices[device_id]
	var/atom/device = ref?.resolve()
	if(QDELETED(device) || device == computer)
		revealed -= device_id
		if(selected_device == device_id)
			selected_device = null
		return null
	return device

/datum/pc_program/hacking/proc/receive_intercept(source_device_id, board_name, datum/pc_post/post)
	intercepts.Insert(1, list(list(
		"device" = source_device_id,
		"board" = board_name,
		"name" = post.name,
		"subject" = post.subject,
		"body" = post.body,
		"has_image" = !!(post.image || post.photo_key),
		"time" = post.timestamp,
	)))
	if(length(intercepts) > HACK_MAX_INTERCEPTS)
		intercepts.Cut(HACK_MAX_INTERCEPTS + 1)

/datum/pc_program/hacking/ui_data(mob/user)
	validate_reveal()
	var/list/data = list()
	var/datum/pc_network/net = computer.current_network
	data["network"] = net?.name
	data["reveal_cooldown"] = max(0, round((next_reveal_time - world.time) / 10))
	data["hack_cooldown"] = max(0, round((next_hack_time - world.time) / 10))

	var/list/devices = list()
	for(var/device_id in revealed)
		var/datum/weakref/ref = net?.connected_devices[device_id]
		var/atom/device = ref?.resolve()
		if(QDELETED(device))
			continue
		devices += list(list(
			"id" = device_id,
			"is_pc" = istype(device, /obj/machinery/computer/pc),
		))
	data["devices"] = devices

	// Each device gets the hacks that apply to it, non-PCs also expose their automation actions
	data["selected"] = null
	if(selected_device)
		var/obj/selected = get_revealed_device(selected_device)
		if(selected)
			var/is_pc = istype(selected, /obj/machinery/computer/pc)
			var/list/selected_data = list(
				"id" = selected_device,
				"is_pc" = is_pc,
				"actions" = list(),
				"hacks" = list(),
			)
			for(var/hack_id in GLOB.pc_hacks)
				var/datum/pc_hack/hack = GLOB.pc_hacks[hack_id]
				if(!hack.applies_to(selected))
					continue
				selected_data["hacks"] += list(list("id" = hack_id, "name" = hack.name, "desc" = hack.desc))
			if(!is_pc)
				var/list/device_actions = selected.get_pc_actions()
				for(var/action_id in device_actions)
					var/list/device_action = device_actions[action_id]
					selected_data["actions"] += list(list(
						"id" = action_id,
						"name" = device_action[AUTOMATION_NAME],
						"desc" = device_action[AUTOMATION_DESC],
					))
			data["selected"] = selected_data

	data["results"] = results
	data["intercepts"] = intercepts
	data["payments"] = payments
	return data

/datum/pc_program/hacking/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/mob/user = ui?.user
	var/datum/pc_network/net = computer.current_network
	if(!net || !user)
		return FALSE

	switch(action)
		if("reveal")
			if(world.time < next_reveal_time)
				return FALSE
			if(net.id == PC_NETWORK_OFFLINE)
				add_result("Scan failed: no network connection.")
				return TRUE
			next_reveal_time = world.time + HACK_REVEAL_COOLDOWN
			var/result = roll_hack(user, get_network_difficulty(net))
			if(result == ROLL_SUCCESS)
				revealed.Cut()
				selected_device = null
				revealed_network_id = net.id
				for(var/device_id in net.connected_devices)
					var/datum/weakref/ref = net.connected_devices[device_id]
					var/atom/device = ref?.resolve()
					if(!device || device == computer)
						continue
					revealed[device_id] = TRUE
				add_result("Scan complete: [length(revealed)] device\s found on [net.name].")
			else
				add_result("Scan failed. Nothing useful came back.")
				if(result == ROLL_BOTCH)
					net.log_event(NETWORK_LOG_INTRUSION_TRACED, computer)
					add_result("Warning: the scan was traced back to this device.")
			return TRUE

		if("select")
			var/device_id = params["device"]
			if(!istext(device_id) || !get_revealed_device(device_id))
				selected_device = null
				return TRUE
			selected_device = device_id
			return TRUE

		if("hack")
			if(world.time < next_hack_time)
				return FALSE
			var/datum/pc_hack/hack = GLOB.pc_hacks[params["hack"]]
			if(!hack)
				return FALSE
			var/device_id = params["device"]
			if(!istext(device_id))
				return FALSE
			var/atom/target = get_revealed_device(device_id)
			if(!target)
				add_result("[device_id] is no longer reachable. Run another scan.")
				return TRUE
			// Each hack says what it can be used on
			if(!hack.applies_to(target))
				return FALSE
			var/problem = hack.can_target(target)
			if(problem)
				add_result(problem)
				return TRUE
			if(!roll_intrusion(user, net, target, device_id, hack.name, hack.difficulty_mod))
				return TRUE
			add_result(hack.execute(src, target, user))
			return TRUE

		if("run_action")
			if(world.time < next_hack_time)
				return FALSE
			var/device_id = params["device"]
			if(!istext(device_id))
				return FALSE
			var/obj/target = get_revealed_device(device_id)
			if(!target)
				add_result("[device_id] is no longer reachable. Run another scan.")
				return TRUE
			if(istype(target, /obj/machinery/computer/pc))
				return FALSE
			var/list/device_actions = target.get_pc_actions()
			var/action_id = params["action_id"]
			var/list/device_action = istext(action_id) ? device_actions[action_id] : null
			if(!islist(device_action))
				return FALSE
			var/datum/callback/callback = device_action[AUTOMATION_CALLBACK]
			if(!istype(callback))
				return FALSE

			// Role requirements are deliberately ignored here, bypassing them is the point
			if(!roll_intrusion(user, net, target, device_id, "Forced action", HACK_ACTION_DIFFICULTY_MOD))
				return TRUE
			callback.Invoke(null, user)
			add_result("Forced '[device_action[AUTOMATION_NAME]]' on [device_id].")
			return TRUE

		if("clear_intercepts")
			intercepts.Cut()
			return TRUE

		if("clear_payments")
			payments.Cut()
			return TRUE

	return FALSE

/// Called by a tapped Bank Manager after a payment went through.
/// Nothing is sent to the victim and the cut never shows in their transaction history.
/datum/pc_program/hacking/proc/receive_payment(source_device_id, datum/bank_account/payer, datum/bank_account/payee, amount)
	var/skimmed = try_skim(payer, amount)
	record_payment(source_device_id, "payment", payer?.account_holder, payee?.account_holder, amount, skimmed)

/// Rolls to skim a cut off a payer on top of what they just paid. Returns the amount taken.
/// The cut goes to whoever is logged in on this computer. Balances are edited directly on
/// purpose, adjust_money would write a transaction history entry the victim could read.
/datum/pc_program/hacking/proc/try_skim(datum/bank_account/payer, amount)
	var/datum/bank_account/thief = computer.get_logged_account()
	if(!thief || !payer || thief == payer || !prob(HACK_SKIM_CHANCE))
		return 0
	// Capped at what the payer has left
	var/cut = min(max(1, round(amount * HACK_SKIM_FRACTION)), payer.account_balance)
	if(cut <= 0)
		return 0
	payer.account_balance -= cut
	thief.account_balance += cut
	return cut

/datum/pc_program/hacking/proc/record_payment(source_device_id, kind, account, counterparty, amount, skimmed)
	payments.Insert(1, list(list(
		"device" = source_device_id,
		"kind" = kind,
		"account" = account,
		"counterparty" = counterparty,
		"amount" = amount,
		"skimmed" = skimmed,
		"time" = time_to_twelve_hour(),
	)))
	if(length(payments) > HACK_MAX_PAYMENTS)
		payments.Cut(HACK_MAX_PAYMENTS + 1)

/// Whoever is logged in on an ATM, or null.
/datum/pc_program/hacking/proc/get_atm_account(obj/machinery/atm/atm)
	var/account = atm.logged_account
	if(istype(account, /datum/weakref))
		var/datum/weakref/ref = account
		account = ref.resolve()
	if(istype(account, /datum/bank_account))
		return account
	return null

/datum/pc_program/hacking/proc/tap_atm(obj/machinery/atm/atm, duration)
	var/key = REF(atm)
	tap_expiry[key] = world.time + duration
	if(!tapped_atms[key])
		tapped_atms[key] = WEAKREF(atm)
		RegisterSignal(atm, COMSIG_ATM_WITHDRAW, PROC_REF(on_atm_withdraw))
		RegisterSignal(atm, COMSIG_ATM_DEPOSIT, PROC_REF(on_atm_deposit))
	addtimer(CALLBACK(src, PROC_REF(untap_atm), key), duration + 1 SECONDS)

/datum/pc_program/hacking/proc/untap_atm(key)
	// A later extension of the tap owns its own timer
	if(world.time < tap_expiry[key])
		return
	var/datum/weakref/ref = tapped_atms[key]
	var/obj/machinery/atm/atm = ref?.resolve()
	if(atm)
		UnregisterSignal(atm, list(COMSIG_ATM_WITHDRAW, COMSIG_ATM_DEPOSIT))
	tapped_atms -= key
	tap_expiry -= key

/datum/pc_program/hacking/proc/on_atm_withdraw(obj/machinery/atm/atm, amount)
	SIGNAL_HANDLER
	var/datum/bank_account/victim = get_atm_account(atm)
	var/skimmed = try_skim(victim, amount)
	record_payment(atm.get_network_device_id(), "withdrawal", victim?.account_holder, null, amount, skimmed)

/datum/pc_program/hacking/proc/on_atm_deposit(obj/machinery/atm/atm, amount)
	SIGNAL_HANDLER
	var/datum/bank_account/victim = get_atm_account(atm)
	record_payment(atm.get_network_device_id(), "deposit", victim?.account_holder, null, amount, 0)

///these are both array lists because when I tried to datumize them the callbacks got fucky.
/obj
	var/network_auth
	var/network_id

/obj/proc/get_network_id()
	var/datum/component/networked/net = GetComponent(/datum/component/networked)
	return net?.network_id

/obj/proc/get_pc_actions()
	return list()

/obj/proc/get_pc_triggers()
	return list()

/obj/proc/get_pc_variables()
	return list()

/obj/Initialize(mapload)
	. = ..()
	if(network_id)
		AddComponent(/datum/component/networked, get_pc_actions(), network_id, get_pc_triggers(), get_pc_variables())

/obj/machinery/button
	network_auth = PC_NETWORK_ADMIN
	network_id = PC_NETWORK_OFFLINE

/obj/machinery/button/get_pc_actions()
	return list(
		"press" = list(
			AUTOMATION_NAME = "Emergency Override",
			AUTOMATION_DESC = "Trigger this secure button.",
			AUTOMATION_CALLBACK = CALLBACK(src, TYPE_PROC_REF(/obj/machinery/button, pc_network_press)),
			AUTOMATION_MIN_ROLE = network_auth,
			AUTOMATION_ALLOW_AUTOMATE = FALSE,
		)
	)

/obj/machinery/button/get_pc_triggers()
	return list(
		"pressed" = list(
			AUTOMATION_NAME = "Button Pressed",
			AUTOMATION_DESC = "Fires whenever someone presses this button.",
			AUTOMATION_SIGNAL = COMSIG_BUTTON_PRESSED,
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
		),
	)

/obj/machinery/button/proc/pc_network_press(datum/bank_account/account, mob/user)
	if(!user)
		return FALSE
	return attempt_press(user)

/obj/item/assembly
	/// Network this assembly starts on. Offline by default so crafted assemblies don't
	/// flood the public network's device list; they join later via a switch signal / set_network().
	var/pc_network_id = PC_NETWORK_OFFLINE
	/// AUTOMATION_SIGNAL = list("network" = id, "allow_restricted" = FALSE), see /datum/component/networked
	var/list/pc_network_switches

/obj/item/assembly/proc/setup_pc_network()
	var/list/pc_actions = get_pc_actions()
	var/list/pc_triggers = get_pc_triggers()
	if(!length(pc_actions) && !length(pc_triggers) && !length(pc_network_switches))
		return
	AddComponent(/datum/component/networked, pc_actions, pc_network_id, pc_triggers, pc_network_switches, get_pc_variables())

/obj/item/assembly/signaler/get_pc_triggers()
	return list(
		"received" = list(
			AUTOMATION_NAME = "Signal Received",
			AUTOMATION_DESC = "Fires when this signaler receives a signal matching its code.",
			AUTOMATION_SIGNAL = COMSIG_ASSEMBLY_SIGNALER_RECEIVED,
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
		),
	)

/obj/item/assembly/signaler/get_pc_actions()
	return list(
		"send" = list(
			AUTOMATION_NAME = "Send Signal",
			AUTOMATION_DESC = "Transmits this signaler's code on its frequency.",
			AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_send_signal)),
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
			AUTOMATION_ALLOW_AUTOMATE = TRUE,
		),
	)

/obj/item/assembly/signaler/proc/pc_send_signal(datum/bank_account/account, mob/user)
	if(!secured || !isturf(get_turf(src))) // signal() dereferences the turf, nullspace would runtime
		return FALSE
	if(cooldown_length > 0)
		if(TIMER_COOLDOWN_RUNNING(src, COOLDOWN_SIGNALLER_SEND))
			return FALSE
		TIMER_COOLDOWN_START(src, COOLDOWN_SIGNALLER_SEND, cooldown_length)
	INVOKE_ASYNC(src, PROC_REF(signal))
	return TRUE

/obj/item/assembly/infra/get_pc_triggers()
	return list(
		"beam_broken" = list(
			AUTOMATION_NAME = "Beam Broken",
			AUTOMATION_DESC = "Fires when something crosses the beam.",
			AUTOMATION_SIGNAL = COMSIG_ASSEMBLY_INFRA_TRIGGERED,
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
		),
	)

/obj/item/assembly/infra/get_pc_actions()
	return list(
		"toggle_power" = list(
			AUTOMATION_NAME = "Toggle Beam",
			AUTOMATION_DESC = "Switches the emitter on or off.",
			AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_toggle_power)),
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
			AUTOMATION_ALLOW_AUTOMATE = TRUE,
		),
		"toggle_visible" = list(
			AUTOMATION_NAME = "Toggle Visibility",
			AUTOMATION_DESC = "Makes the beam visible or invisible.",
			AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_toggle_visible)),
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
			AUTOMATION_ALLOW_AUTOMATE = TRUE,
		),
	)

/obj/item/assembly/infra/proc/pc_toggle_power(datum/bank_account/account, mob/user)
	if(!secured)
		return FALSE
	toggle_on()
	return TRUE

/obj/item/assembly/infra/proc/pc_toggle_visible(datum/bank_account/account, mob/user)
	if(!secured)
		return FALSE
	toggle_visible()
	return TRUE

/obj/item/assembly/voice/get_pc_triggers()
	return list(
		"heard" = list(
			AUTOMATION_NAME = "Voice Matched",
			AUTOMATION_DESC = "Fires when the analyzer hears its activation phrase or voice (or any speech in sensor mode).",
			AUTOMATION_SIGNAL = COMSIG_ASSEMBLY_VOICE_TRIGGERED,
			AUTOMATION_MIN_ROLE = PC_NETWORK_USER,
		),
	)

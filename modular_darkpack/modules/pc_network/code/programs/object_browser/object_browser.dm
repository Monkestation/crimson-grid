/datum/pc_program/browser
	name = "Network Browser"
	icon_state = "globe"
	tgui_id = "PcNetworkBrowser"

/datum/pc_program/browser/ui_data(mob/user)
	var/list/data = list()
	var/datum/pc_network/net = computer.current_network
	var/login = computer.login_name || "anonymous"

	data["devices"] = list()
	data["current_role"] = net ? net.get_user_role(login) : "Guest"

	if(net)
		for(var/datum/weakref/ref in net.connected)
			var/atom/A = ref.resolve()
			if(!A)
				continue
			var/datum/component/networked/C = A.GetComponent(/datum/component/networked)
			if(!C)
				continue

			var/list/device_actions = list()
			for(var/action_id in C.actions)
				var/list/act = C.actions[action_id]
				var/req_role = act["min_role"] || "User"
				device_actions[action_id] = list(
					"name" = act["name"],
					"desc" = act["desc"],
					"min_role" = req_role,
					"allowed" = net.has_access(login, req_role)
				)

			data["devices"] += list(list(
				"name" = A.name,
				"ref" = REF(A),
				"actions" = device_actions
			))
	return data

/datum/pc_program/browser/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/pc_network/net = computer.current_network
	if(!net)
		return FALSE

	var/login = computer.login_name || "anonymous"

	if(action == "run_action")
		var/atom/A = locate(params["ref"])
		var/datum/component/networked/C = A?.GetComponent(/datum/component/networked)
		if(!C || !C.actions[params["action_id"]])
			return FALSE

		var/list/act = C.actions[params["action_id"]]
		var/required_role = act["min_role"] || "User"

		// Enforce per-action role requirement
		if(!net.has_access(login, required_role))
			to_chat(ui.user, span_warning("Access denied: This action requires '[required_role]' network clearance."))
			return FALSE

		if(islist(act) && act["callback"])
			var/datum/callback/callback = act["callback"]
			callback.Invoke(computer.get_logged_account(), ui.user)
		return TRUE
	return FALSE

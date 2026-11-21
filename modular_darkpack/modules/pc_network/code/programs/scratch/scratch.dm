/datum/pc_program/automation
	name = "Network Automation"
	icon_state = "cogs"
	tgui_id = "PcNetworkAutomation"

/datum/pc_program/automation/ui_data(mob/user)
	var/list/data = list()
	var/datum/pc_network/net = computer.current_network
	var/login = computer.login_name || "anonymous"

	data["devices"] = list()
	data["rules"] = list()
	data["vars"] = list()
	data["current_role"] = net ? net.get_user_role(login) : "Guest"
	data["can_create"] = !!net && login != "anonymous" && net.has_access(login, PC_AUTOMATION_MIN_ROLE)
	if(!net?.automation)
		return data

	for(var/datum/weakref/ref in net.connected)
		var/atom/A = ref.resolve()
		var/datum/component/networked/C = A?.GetComponent(/datum/component/networked)
		if(!C)
			continue
		var/list/trigger_list = list()
		for(var/trigger_id in C.triggers)
			var/list/t = C.triggers[trigger_id]
			trigger_list += list(list(
				"payload" = t[AUTOMATION_PAYLOAD] || list(),
				"id" = trigger_id,
				AUTOMATION_NAME = t[AUTOMATION_NAME],
				AUTOMATION_DESC = t[AUTOMATION_DESC],
				"allowed" = net.has_access(login, t[AUTOMATION_MIN_ROLE] || PC_NETWORK_USER),
			))
		var/list/action_list = list()
		for(var/action_id in C.actions)
			var/list/a = C.actions[action_id]
			if(!a[AUTOMATION_ALLOW_AUTOMATE])
				continue
			action_list += list(list(
				"id" = action_id,
				AUTOMATION_NAME = a[AUTOMATION_NAME],
				AUTOMATION_DESC = a[AUTOMATION_DESC],
				"allowed" = net.has_access(login, a[AUTOMATION_MIN_ROLE] || PC_NETWORK_USER),
			))
		var/list/variable_list = list()
		for(var/var_id in C.variables)
			var/list/v = C.variables[var_id]
			var/allowed = net.has_access(login, v[AUTOMATION_MIN_ROLE] || PC_NETWORK_USER)
			variable_list += list(list(
				"id" = var_id,
				AUTOMATION_NAME = v[AUTOMATION_NAME],
				AUTOMATION_DESC = v[AUTOMATION_DESC],
				"allowed" = allowed,
				"value" = allowed ? C.read_variable(var_id) : null,
			))
		if(!trigger_list.len && !action_list.len && !variable_list.len)
			continue
		data["devices"] += list(list(
			AUTOMATION_NAME = A.name,
			"ref" = REF(A),
			"triggers" = trigger_list,
			"actions" = action_list,
			"variables" = variable_list,
		))

	for(var/datum/pc_rule/R as anything in net.automation.rules)
		data["rules"] += list(list(
			"id" = R.id,
			AUTOMATION_NAME = R.name,
			"enabled" = R.enabled,
			"owner" = R.owner_login,
			"summary" = R.describe(),
			"steps" = R.steps.len,
			"running" = R.running,
			"last_fired" = R.last_fired ? "[round((world.time - R.last_fired) / 10)]s ago" : "never",
			"can_manage" = net.automation.can_manage(login, R),
		))

	for(var/key in net.automation.auto_vars)
		data["vars"][key] = "[net.automation.vars[key]]"
	return data

/datum/pc_program/automation/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/pc_network/net = computer.current_network
	if(!net?.automation)
		return FALSE
	var/login = computer.login_name || "anonymous"
	var/datum/pc_rule/R = net.automation.get_rule(text2num(params["id"]))

	switch(action)
		if("save_rule")
			var/list/rule_data = safe_json_decode(params["rule"])
			var/error = net.automation.save_rule(login, computer.get_logged_account(), rule_data)
			if(error)
				to_chat(ui.user, span_warning(error))
				return FALSE
			to_chat(ui.user, span_notice("Rule saved and enabled."))
			return TRUE
		if("toggle_rule")
			if(!R || !net.automation.can_manage(login, R))
				return FALSE
			R.set_enabled(!R.enabled)
			return TRUE
		if("delete_rule")
			if(!R || !net.automation.can_manage(login, R))
				return FALSE
			net.automation.remove_rule(R)
			return TRUE
		if("test_rule")
			if(!R || !net.automation.can_manage(login, R))
				return FALSE
			return R.attempt_run(list(), TRUE)
	return FALSE

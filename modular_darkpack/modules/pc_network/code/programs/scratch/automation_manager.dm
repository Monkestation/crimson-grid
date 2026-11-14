/datum/pc_automation
	var/datum/pc_network/network
	var/list/datum/pc_rule/rules = list()
	/// Scratch-style variables shared by every rule on the network
	var/list/auto_vars = list()
	var/next_rule_id = 1

/datum/pc_automation/New(datum/pc_network/network)
	. = ..()
	src.network = network

/datum/pc_automation/proc/get_rule(rule_id)
	if(isnull(rule_id))
		return null
	for(var/datum/pc_rule/R as anything in rules)
		if(R.id == rule_id)
			return R
	return null

/datum/pc_automation/proc/can_manage(login, datum/pc_rule/R)
	return R.owner_login == login || network.has_access(login, PC_NETWORK_ADMIN)

/datum/pc_automation/proc/remove_rule(datum/pc_rule/R)
	rules -= R
	qdel(R)

/datum/pc_automation/proc/on_device_trigger(atom/device, trigger_id, list/payload)
	for(var/datum/pc_rule/R as anything in rules)
		if(!R.enabled || R.trigger_type != PC_TRIGGER_DEVICE || R.trigger_id != trigger_id)
			continue
		if(R.trigger_device?.resolve() != device)
			continue
		R.attempt_run(list("device" = device, "trigger" = trigger_id, "vars" = payload))

/datum/pc_automation/proc/on_mail(datum/pc_mail/mail)
	// Our own send-mail steps must not retrigger mail rules
	if(mail.from_address == PC_AUTOMATION_ADDRESS)
		return
	var/to_var = LOWER_TEXT(mail.to_address)
	for(var/datum/pc_rule/R as anything in rules)
		if(!R.enabled || R.trigger_type != PC_TRIGGER_MAIL || R.trigger_address != to_var)
			continue
		R.attempt_run(list("mail" = mail))

/datum/pc_automation/proc/clean(text, max_len = 64)
	return trim(STRIP_HTML_SIMPLE("[text]", max_len))

/datum/pc_automation/proc/as_num(value)
	return isnum(value) ? value : text2num(value)

/// Validates and builds a rule from untrusted UI data. Returns an error string, or null on success.
/datum/pc_automation/proc/save_rule(login, datum/bank_account/account, list/data)
	if(!login || login == "anonymous")
		return "Log in before creating rules."
	if(!network.has_access(login, PC_AUTOMATION_MIN_ROLE))
		return "Creating rules requires '[PC_AUTOMATION_MIN_ROLE]' clearance."
	if(length(rules) >= PC_AUTOMATION_MAX_RULES)
		return "This network has reached its rule limit."
	if(!islist(data))
		return "Malformed rule."

	var/datum/pc_rule/draft = new(src)
	var/error = fill_rule(draft, login, data)
	if(error)
		qdel(draft)
		return error

	draft.id = next_rule_id++
	draft.owner_login = login
	draft.owner_account = account ? WEAKREF(account) : null
	rules += draft
	draft.set_enabled(TRUE)
	return null

/datum/pc_automation/proc/fill_rule(datum/pc_rule/draft, login, list/data)
	draft.name = clean(data[AUTOMATION_NAME], 40) || "Untitled rule"
	var/cooldown_s = as_num(data["cooldown"]) || 1
	draft.cooldown = clamp(cooldown_s SECONDS, PC_AUTOMATION_MIN_COOLDOWN, 10 MINUTES)

	// ---- trigger ("WHEN") ----
	var/list/trig = data["trigger"]
	if(!islist(trig))
		return "Pick a trigger."
	draft.trigger_type = trig["type"]
	switch(draft.trigger_type)
		if(PC_TRIGGER_DEVICE)
			var/atom/A = network.resolve_device(trig["device"])
			var/datum/component/networked/C = A?.GetComponent(/datum/component/networked)
			var/list/def = C?.triggers[trig["trigger_id"]]
			if(!def)
				return "Unknown device trigger."
			if(!network.has_access(login, def[AUTOMATION_MIN_ROLE] || PC_NETWORK_USER))
				return "You lack clearance for '[def[AUTOMATION_NAME]]'."
			draft.trigger_device = WEAKREF(A)
			draft.trigger_id = trig["trigger_id"]
			draft.trigger_name = def[AUTOMATION_NAME]
		if(PC_TRIGGER_TIMER)
			var/secs = as_num(trig["seconds"])
			if(!secs)
				return "Timer needs an interval."
			draft.trigger_interval = max(secs SECONDS, PC_AUTOMATION_MIN_TIMER)
		if(PC_TRIGGER_MAIL)
			draft.trigger_address = LOWER_TEXT(clean(trig["address"], 64))
			if(!draft.trigger_address)
				return "Mail trigger needs an address."
		else
			return "Unknown trigger type."

	// ---- conditions ("IF") ----
	var/list/raw_conds = data["conditions"]
	if(islist(raw_conds))
		if(raw_conds.len > PC_AUTOMATION_MAX_CONDITIONS)
			return "Too many conditions."
		for(var/list/cond in raw_conds)
			var/ctype = cond["type"]
			switch(ctype)
				if(PC_COND_VAR_EQUALS, PC_COND_VAR_NOT_EQUALS)
					var/key = clean(cond["key"], 32)
					if(!key)
						return "Variable conditions need a variable name."
					draft.conditions += list(list("type" = ctype, "key" = key, "value" = clean(cond["value"], 64)))
				if(PC_COND_MAIL_FROM, PC_COND_MAIL_SUBJECT, PC_COND_MAIL_BODY)
					if(draft.trigger_type != PC_TRIGGER_MAIL)
						return "Mail conditions only work with a mail trigger."
					draft.conditions += list(list("type" = ctype, "value" = clean(cond["value"], 64)))
				if(PC_COND_COMPARE)
					var/static/list/valid_ops = list("eq", "neq", "gt", "lt", "gte", "lte")
					var/source = cond["source"]
					var/key = clean(cond["key"], 32)
					if(!(cond["op"] in valid_ops))
						return "Unknown comparison."
					if(!key)
						return "Comparisons need something to read."
					var/list/entry = list("type" = ctype, "source" = source, "op" = cond["op"], "key" = key, "value" = clean(cond["value"], 64))
					switch(source)
						if("event")
							if(draft.trigger_type != PC_TRIGGER_DEVICE)
								return "Trigger data only works with a device trigger."
						if("device")
							var/atom/A = network.resolve_device(cond["device"])
							var/datum/component/networked/C = A?.GetComponent(/datum/component/networked)
							var/list/def = C?.variables[key]
							if(!def)
								return "Unknown device reading."
							if(!network.has_access(login, def[AUTOMATION_MIN_ROLE] || PC_NETWORK_USER))
								return "You lack clearance for '[def[AUTOMATION_NAME]]'."
							entry["device"] = WEAKREF(A)
						else
							if(source != "var") //fuck you opendream
								return "Unknown comparison source."
					draft.conditions += list(entry)
				else
					return "Unknown condition type."

	// ---- steps ("THEN") ----
	var/list/raw_steps = data["steps"]
	if(!islist(raw_steps) || !raw_steps.len)
		return "Add at least one step."
	if(raw_steps.len > PC_AUTOMATION_MAX_STEPS)
		return "Too many steps."
	for(var/list/step in raw_steps)
		var/stype = step["type"]
		switch(stype)
			if(PC_STEP_ACTION)
				var/atom/A = network.resolve_device(step["device"])
				var/datum/component/networked/C = A?.GetComponent(/datum/component/networked)
				var/list/act = C?.actions[step["action_id"]]
				if(!act)
					return "Unknown device action."
				if(!act[AUTOMATION_ALLOW_AUTOMATE])
					return "'[act[AUTOMATION_NAME]]' cannot be automated."
				if(!network.has_access(login, act[AUTOMATION_MIN_ROLE] || PC_NETWORK_USER))
					return "You lack clearance for '[act[AUTOMATION_NAME]]'."
				draft.steps += list(list("type" = stype, "device" = WEAKREF(A), "action_id" = step["action_id"], "label" = "[A.name]: [act[AUTOMATION_NAME]]"))
			if(PC_STEP_WAIT)
				var/wait_s = as_num(step["seconds"])
				if(!wait_s)
					return "Wait needs a duration."
				draft.steps += list(list("type" = stype, "delay" = clamp(wait_s SECONDS, 1, PC_AUTOMATION_MAX_WAIT), "label" = "Wait"))
			if(PC_STEP_MAIL)
				var/to_var = LOWER_TEXT(clean(step["to"], 64))
				if(!to_var)
					return "Send-mail needs a recipient."
				draft.steps += list(list("type" = stype, "to" = to_var, "subject" = clean(step["subject"], 64), "body" = clean(step["body"], 256), "label" = "Mail [to_var]"))
			if(PC_STEP_SET_VAR)
				var/key = clean(step["key"], 32)
				if(!key)
					return "Set-variable needs a name."
				draft.steps += list(list("type" = stype, "key" = key, "value" = clean(step["value"], 64), "label" = "Set [key]"))
			if(PC_STEP_READ_VAR)
				var/atom/A = network.resolve_device(step["device"])
				var/datum/component/networked/C = A?.GetComponent(/datum/component/networked)
				var/list/def = C?.variables[step["var_id"]]
				if(!def)
					return "Unknown device reading."
				if(!network.has_access(login, def[AUTOMATION_MIN_ROLE] || PC_NETWORK_USER))
					return "You lack clearance for '[def[AUTOMATION_NAME]]'."
				var/key = clean(step["key"], 32)
				if(!key)
					return "Read-value needs a variable to store into."
				draft.steps += list(list("type" = stype, "device" = WEAKREF(A), "var_id" = step["var_id"], "key" = key, "label" = "Read [A.name]: [def[AUTOMATION_NAME]]"))
			else
				return "Unknown step type."
	return null

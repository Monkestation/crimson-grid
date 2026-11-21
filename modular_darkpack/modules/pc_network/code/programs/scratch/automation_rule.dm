/datum/pc_rule
	var/id
	var/name = "Untitled rule"
	var/enabled = FALSE
	var/datum/pc_automation/automation
	/// The rule runs with the OWNER's clearance, re-checked every run.
	var/owner_login
	var/datum/weakref/owner_account

	var/trigger_type
	var/datum/weakref/trigger_device
	var/trigger_id
	var/trigger_name
	var/trigger_interval
	var/trigger_address

	var/cooldown = PC_AUTOMATION_MIN_COOLDOWN
	var/list/conditions = list()
	var/list/steps = list()

	var/last_fired = 0
	var/timer_id
	var/running = FALSE
	/// Bumped to cancel an execution that is sleeping in a wait step
	var/run_serial = 0

/datum/pc_rule/New(datum/pc_automation/automation)
	. = ..()
	src.automation = automation

/datum/pc_rule/Destroy()
	stop_timer()
	cancel()
	automation = null
	return ..()

/datum/pc_rule/proc/describe()
	switch(trigger_type)
		if(PC_TRIGGER_DEVICE)
			var/atom/A = trigger_device?.resolve()
			return "When [A ? A.name : "(missing device)"]: [trigger_name]"
		if(PC_TRIGGER_TIMER)
			return "Every [trigger_interval / 10]s"
		if(PC_TRIGGER_MAIL)
			return "When mail arrives for [trigger_address]"
	return "Unknown trigger"

/datum/pc_rule/proc/set_enabled(new_state)
	enabled = new_state
	if(enabled)
		schedule_timer()
	else
		stop_timer()
		cancel()

/datum/pc_rule/proc/cancel()
	run_serial++
	running = FALSE

/datum/pc_rule/proc/schedule_timer()
	stop_timer()
	if(!enabled || trigger_type != PC_TRIGGER_TIMER)
		return
	timer_id = addtimer(CALLBACK(src, PROC_REF(timer_fire)), trigger_interval, TIMER_STOPPABLE)

/datum/pc_rule/proc/stop_timer()
	if(timer_id)
		deltimer(timer_id)
		timer_id = null

/datum/pc_rule/proc/timer_fire()
	timer_id = null
	schedule_timer() // reschedule first so a failed run can't kill the loop
	attempt_run(list("timer" = TRUE))

/datum/pc_rule/proc/attempt_run(list/context, force = FALSE)
	if(QDELETED(src) || running)
		return FALSE
	if(!force)
		if(!enabled)
			return FALSE
		if(last_fired && world.time < last_fired + cooldown)
			return FALSE
		if(!check_conditions(context))
			return FALSE
	last_fired = world.time
	running = TRUE // also stops a rule from re-triggering itself through its own actions
	INVOKE_ASYNC(src, PROC_REF(execute), context)
	return TRUE

/datum/pc_rule/proc/check_conditions(list/context)
	var/datum/pc_mail/mail = context?["mail"]
	for(var/list/cond as anything in conditions)
		switch(cond["type"])
			if(PC_COND_VAR_EQUALS)
				if("[automation.auto_vars[cond["key"]]]" != cond["value"])
					return FALSE
			if(PC_COND_VAR_NOT_EQUALS)
				if("[automation.auto_vars[cond["key"]]]" == cond["value"])
					return FALSE
			if(PC_COND_MAIL_FROM)
				if(!mail || LOWER_TEXT(mail.from_address) != LOWER_TEXT(cond["value"]))
					return FALSE
			if(PC_COND_MAIL_SUBJECT)
				if(!mail || !findtext(mail.subject, cond["value"]))
					return FALSE
			if(PC_COND_MAIL_BODY)
				if(!mail || !findtext(mail.body, cond["value"]))
					return FALSE
			if(PC_COND_COMPARE)
				if(!check_compare(cond, context))
					return FALSE
	return TRUE

/datum/pc_rule/proc/execute(list/context)
	var/serial = ++run_serial
	for(var/list/step as anything in steps)
		if(QDELETED(src) || serial != run_serial)
			return // cancelled or deleted while waiting
		switch(step["type"])
			if(PC_STEP_ACTION)
				run_device_action(step)
			if(PC_STEP_WAIT)
				sleep(step["delay"])
			if(PC_STEP_MAIL)
				var/datum/pc_mail/M = new
				M.from_address = PC_AUTOMATION_ADDRESS
				M.to_address = step["to"]
				M.subject = render(step["subject"], context)
				M.body = render(step["body"], context)
				automation.network.deliver_mail(M)
			if(PC_STEP_SET_VAR)
				automation.auto_vars[step["key"]] = render(step["value"], context)
			if(PC_STEP_READ_VAR)
				var/reading = read_device_var(step["device"], step["var_id"])
				if(!isnull(reading))
					automation.auto_vars[step["key"]] = reading
	if(serial == run_serial)
		running = FALSE

/// Reads a device value using the OWNER's clearance, re-checked every time.
/datum/pc_rule/proc/read_device_var(datum/weakref/ref, var_id)
	var/atom/A = ref?.resolve()
	if(!A || !automation.network.is_connected(A))
		return null
	var/datum/component/networked/C = A.GetComponent(/datum/component/networked)
	var/list/def = C?.variables[var_id]
	if(!def)
		return null
	if(!automation.network.has_access(owner_login, def[AUTOMATION_MIN_ROLE] || PC_NETWORK_USER))
		return null
	return C.read_variable(var_id)

/datum/pc_rule/proc/check_compare(list/cond, list/context)
	var/actual
	switch(cond["source"])
		if("var")
			actual = automation.auto_vars[cond["key"]]
		if("event")
			actual = context?["vars"]?[cond["key"]]
		if("device")
			actual = read_device_var(cond["device"], cond["key"])
	if(isnull(actual))
		return FALSE
	var/expected = cond["value"]
	var/a_num = isnum(actual) ? actual : text2num(actual)
	var/b_num = text2num(expected)
	var/numeric = !isnull(a_num) && !isnull(b_num)
	switch(cond["op"])
		if("eq")
			return numeric ? (a_num == b_num) : ("[actual]" == expected)
		if("neq")
			return numeric ? (a_num != b_num) : ("[actual]" != expected)
		if("gt")
			return numeric && a_num > b_num
		if("lt")
			return numeric && a_num < b_num
		if("gte")
			return numeric && a_num >= b_num
		if("lte")
			return numeric && a_num <= b_num
	return FALSE

/// Expands {var.name} and {event.name}. Unknown tokens are left as written.
/datum/pc_rule/proc/render(text, list/context)
	text = "[text]"
	if(!findtext(text, "{"))
		return text
	var/out = ""
	var/pos = 1
	while(pos <= length(text))
		var/open = findtext(text, "{", pos)
		if(!open)
			break
		var/close = findtext(text, "}", open)
		if(!close)
			break
		out += copytext(text, pos, open)
		var/token = copytext(text, open + 1, close)
		var/dot = findtext(token, ".")
		var/value
		if(dot)
			var/key = copytext(token, dot + 1)
			switch(copytext(token, 1, dot))
				if("var")
					value = automation.auto_vars[key]
				if("event")
					value = context?["vars"]?[key]
		out += isnull(value) ? copytext(text, open, close + 1) : "[value]"
		pos = close + 1
	out += copytext(text, pos)
	return copytext(out, 1, PC_MAX_RENDERED_LEN + 1)

/datum/pc_rule/proc/run_device_action(list/step)
	var/datum/weakref/ref = step["device"]
	var/atom/A = ref?.resolve()
	var/datum/pc_network/net = automation.network
	if(!A || !net.is_connected(A))
		return
	var/datum/component/networked/C = A.GetComponent(/datum/component/networked)
	var/list/act = C?.actions[step["action_id"]]
	if(!act || !act[AUTOMATION_ALLOW_AUTOMATE])
		return
	//demoting the owner disarms their rules.
	if(!net.has_access(owner_login, act[AUTOMATION_MIN_ROLE] || PC_NETWORK_USER))
		return
	var/datum/callback/cb = act[AUTOMATION_CALLBACK]
	cb?.Invoke(owner_account?.resolve(), null) //automated callbacks must tolerate user == null because chud shit

/datum/pc_program/permissions
	name = "Access Manager"
	icon_state = "key"
	tgui_id = "PcPermissions"

/datum/pc_program/permissions/ui_data(mob/user)
	var/list/data = list()
	var/datum/pc_network/net = computer.current_network
	if(!net)
		return data

	var/login = computer.login_name || "anonymous"
	data["is_master_unlocked"] = net.authenticated_sessions[login] || FALSE
	data["current_role"] = net.get_user_role(login)
	data["role_hierarchy"] = net.role_hierarchy

	var/list/users_list = list()
	// Gather all known users from mailboxes or connected devices
	var/list/known_users = net.mailboxes | list(computer.login_name)
	for(var/uname in known_users)
		if(!uname) continue
		users_list += list(list(
			"name" = uname,
			"role" = net.get_user_role(uname)
		))
	data["users"] = users_list
	return data

/datum/pc_program/permissions/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/pc_network/net = computer.current_network
	if(!net)
		return FALSE

	var/login = computer.login_name || "anonymous"

	switch(action)
		if("auth_master")
			var/pwd = params["password"]
			if(pwd == net.master_password)
				net.authenticated_sessions[login] = TRUE
				to_chat(usr, span_notice("Master password accepted. Full network access granted for this session."))
				return TRUE
			else
				to_chat(usr, span_warning("Incorrect master password."))
				return FALSE

		if("set_role")
			if(!net.has_access(login, PC_NETWORK_MASTER))
				return FALSE

			var/target_user = params["target"]
			var/new_role = params["role"]
			if(target_user && (new_role in net.role_hierarchy))
				net.user_roles[target_user] = new_role
				return TRUE

	return FALSE

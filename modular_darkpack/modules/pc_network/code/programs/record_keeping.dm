/datum/pc_program/records
	name = "Records"
	icon_state = "folder"
	tgui_id = "PcRecords"

/datum/pc_program/records/ui_data(mob/user)
	var/list/data = list()
	var/datum/pc_network/net = computer.current_network
	var/login = computer.login_name || "anonymous"

	data["records"] = list()
	var/role = net ? net.get_user_role(login) : PC_NETWORK_USER
	data["current_role"] = role
	data["role_hierarchy"] = net ? net.role_hierarchy : list(PC_NETWORK_MASTER, PC_NETWORK_ADMIN, PC_NETWORK_USER, PC_NETWORK_GUEST)
	data["can_admin"] = net ? net.has_access(login, PC_NETWORK_ADMIN) : TRUE

	if(net)
		for(var/id in net.records)
			var/datum/pc_record/R = net.records[id]
			data["records"] += list(list(
				"id" = R.id,
				"title" = R.title,
				"author" = R.author,
				"body" = R.body,
				"access" = R.access_level,
				"time" = R.timestamp
			))
	return data

/datum/pc_program/records/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/pc_network/net = computer.current_network
	if(!net)
		return FALSE

	var/login = computer.login_name || "anonymous"

	switch(action)
		if("create")
			if(!net.has_access(login, "User"))
				to_chat(usr, span_warning("Access denied: Insufficient network privileges to create records."))
				return FALSE

			var/datum/pc_record/R = new
			R.id = "[world.time]-[rand(1000,9999)]"
			R.title = params["title"]
			R.body = params["body"]
			R.author = login
			R.timestamp = time_to_twelve_hour()
			R.access_level = params["access"] || PC_NETWORK_USER
			net.records[R.id] = R
			return TRUE

		if("delete")
			if(!net.has_access(login, PC_NETWORK_ADMIN))
				to_chat(usr, span_warning("Access denied: Requires Admin network role to delete records."))
				return FALSE

			net.records -= params["id"]
			return TRUE

	return FALSE

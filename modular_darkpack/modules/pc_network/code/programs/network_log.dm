/atom/proc/get_network_device_id()
	if(!src) //and god said I fucking hate you and I hope you die
		return "UNKNOWN"
	return "DEV-[uppertext(copytext(md5(REF(src)), 1, 7))]"

/datum/pc_program/network_log
	name = "Network Log"
	icon_state = "key"
	tgui_id = "PcNetworkLog"

/datum/pc_program/network_log/ui_data(mob/user)
	var/list/data = list()
	var/datum/pc_network/net = computer?.current_network
	data["network_name"] = net?.name
	var/list/entries = list()
	if(net)
		// newest first for display
		for(var/i in length(net.event_log) to 1 step -1)
			entries += list(net.event_log[i])
	data["entries"] = entries

	var/list/devices = list()
	if(net)
		for(var/device_id in net.connected_devices)
			var/datum/weakref/ref = net.connected_devices[device_id]
			var/atom/device = ref?.resolve()
			if(!device)
				continue
			devices += list(list(
				"device_id" = device_id,
				"device_name" = "[device.name]",
				"is_self" = (device == computer),
			))
	data["devices"] = devices
	data["can_disconnect"] = !!computer?.is_admin
	return data

/datum/pc_program/network_log/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("disconnect")
			if(!computer?.is_admin)
				to_chat(ui.user, span_warning("Access denied: administrator permissions required."))
				return TRUE
			var/device_id = clean_text(params["device_id"], 16)
			if(disconnect_device(device_id))
				to_chat(ui.user, span_notice("[device_id] was disconnected from the network."))
			else
				to_chat(ui.user, span_warning("Unable to disconnect [device_id]."))
			return TRUE

/// Kick a device off the network this computer is on. Can't disconnect the computer you're using.
/datum/pc_program/network_log/proc/disconnect_device(device_id)
	var/datum/pc_network/net = computer?.current_network
	if(!net || !device_id)
		return FALSE
	var/datum/weakref/ref = net.connected_devices[device_id]
	var/atom/device = ref?.resolve()
	if(!device)
		net.connected_devices -= device_id // stale entry
		return FALSE
	if(device == computer)
		return FALSE
	if(istype(device, /obj/machinery/computer/pc))
		var/obj/machinery/computer/pc/target_pc = device
		target_pc.disconnect_from_network()
	else
		SEND_SIGNAL(device, COMSIG_NETWORKED_SET_NETWORK, PC_NETWORK_OFFLINE)
	// leave() runs the log hook, which drops the device from connected_devices
	return !(device_id in net.connected_devices)

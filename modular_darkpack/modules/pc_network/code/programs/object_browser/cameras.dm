/obj/machinery/camera
	network_auth = PC_NETWORK_ADMIN
	network_id = PC_NETWORK_OFFLINE
	var/network_enabled = TRUE

/obj/machinery/camera/get_pc_actions()
	return list(
		"toggle_power" = list(
			AUTOMATION_NAME = "Toggle Camera Power",
			AUTOMATION_DESC = "Enable or disable camera feed transmission.",
			AUTOMATION_CALLBACK = CALLBACK(src, PROC_REF(pc_toggle_power)),
			AUTOMATION_MIN_ROLE = network_auth,
			AUTOMATION_ALLOW_AUTOMATE = TRUE,
		),
	)

/obj/machinery/camera/proc/pc_toggle_power(datum/bank_account/account, mob/user)
	if(!user)
		return FALSE
	network_enabled = !network_enabled
	to_chat(user, span_notice("Camera [c_tag || name] transmission is now [network_enabled ? "enabled" : "disabled"]."))
	update_icon()
	return TRUE

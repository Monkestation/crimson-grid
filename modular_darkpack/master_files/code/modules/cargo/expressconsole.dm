/obj/machinery/computer/cargo/express
	req_access = list()
	locked = FALSE
	landingzone = /area/vtm/outside/supply

/obj/machinery/computer/cargo/express/Initialize(mapload)
	. = ..()
	for(var/obj/item/supplypod_beacon/beacon in range(20, src))
		beacon.link_console(src)

// CRIMSON EDIT ADD START - Supply console restricted to supply workers
/obj/machinery/computer/cargo/express/allowed(mob/accessor)
	if(isAdminGhostAI(accessor))
		return TRUE
	var/datum/job/assigned_role = accessor?.mind?.assigned_role
	return assigned_role && (/datum/job_department/supply in assigned_role.departments_list)

/obj/machinery/computer/cargo/express/ui_interact(mob/user, datum/tgui/ui)
	if(!isobserver(user) && !allowed(user))
		if(isnull(ui))
			balloon_alert(user, "access denied!")
		return
	return ..()

/obj/machinery/computer/cargo/express/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(. != UI_INTERACTIVE || isobserver(user))
		return
	if(allowed(user))
		return
	return UI_CLOSE
// CRIMSON EDIT ADD END - Supply console restricted to supply workers

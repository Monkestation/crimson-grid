/atom/movable/screen/map_view/camera/greyscale/display_to_client(client/show_to)
	show_to.register_map_obj(cam_background)
	var/datum/plane_master_group/popup/pop_planes = ..()
	greyscale_planes(pop_planes)
	return pop_planes

/atom/movable/screen/map_view/camera/greyscale/proc/greyscale_planes(datum/plane_master_group/popup/pop_planes)
	if(!pop_planes)
		return
	for(var/plane_key in pop_planes.plane_masters)
		var/atom/movable/screen/plane_master/plane = pop_planes.plane_masters[plane_key]
		// luminance-weighted greyscale
		plane.color = list(0.3,0.3,0.3, 0.59,0.59,0.59, 0.11,0.11,0.11)

/datum/pc_program/security_camera
	name = "SecurEye"
	icon_state = "video"
	tgui_id = "PcSecurityCamera"

	var/datum/weakref/camera_ref
	var/turf/last_camera_turf
	var/atom/movable/screen/map_view/camera/greyscale/cam_screen

/datum/pc_program/security_camera/New(obj/machinery/computer/pc/host)
	. = ..()
	var/map_name = "pc_camera_[REF(src)]_map"
	cam_screen = new
	cam_screen.generate_view(map_name)

/datum/pc_program/security_camera/Destroy()
	QDEL_NULL(cam_screen)
	last_camera_turf = null
	return ..()

/datum/pc_program/security_camera/ui_data(mob/user)
	var/list/data = list()
	var/datum/pc_network/net = computer.current_network
	var/login = computer.login_name || "anonymous"

	data["current_role"] = net ? net.get_user_role(login) : PC_NETWORK_GUEST
	data["can_view"] = net ? net.has_access(login, PC_NETWORK_USER) : TRUE

	var/obj/machinery/camera/active_camera = camera_ref?.resolve()
	data["activeCamera"] = null
	if(active_camera)
		data["activeCamera"] = list(
			"name" = active_camera.c_tag || active_camera.name,
			"ref" = REF(active_camera),
			"status" = active_camera.can_use() ? 1 : 0
		)

	var/list/cameras_data = list()
	if(net)
		for(var/datum/weakref/ref in net.connected)
			var/atom/A = ref.resolve()
			if(istype(A, /obj/machinery/camera))
				var/obj/machinery/camera/cam = A
				cameras_data += list(list(
					"name" = cam.c_tag || cam.name,
					"ref" = REF(cam),
					"status" = cam.can_use() ? 1 : 0
				))

	data["cameras"] = cameras_data
	data["mapRef"] = cam_screen?.assigned_map
	return data

/datum/pc_program/security_camera/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	update_active_camera_screen()
	if(cam_screen && ui)
		cam_screen.display_to(user, ui.window)

/datum/pc_program/security_camera/ui_close(mob/user)
	. = ..()
	if(cam_screen && user)
		cam_screen.hide_from(user)

/datum/pc_program/security_camera/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/pc_network/net = computer.current_network
	if(!net)
		return FALSE

	var/login = computer.login_name || "anonymous"
	if(!net.has_access(login, PC_NETWORK_USER))
		return FALSE

	switch(action)
		if("switch_camera")
			var/obj/machinery/camera/cam = locate(params["camera"])
			if(cam)
				camera_ref = WEAKREF(cam)
				update_active_camera_screen()
				return TRUE
	return FALSE

/datum/pc_program/security_camera/proc/update_active_camera_screen()
	var/obj/machinery/camera/active_camera = camera_ref?.resolve()
	if(!active_camera?.can_use())
		cam_screen?.show_camera_static()
		return

	var/list/visible_things = view(active_camera.view_range, get_turf(active_camera))
	var/list/visible_turfs = list()
	for(var/turf/T in visible_things)
		visible_turfs += T

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1

	cam_screen?.show_camera(visible_turfs, size_x, size_y)
	cam_screen?.set_display(active_camera)

/obj/item/broadcast_camera
	network_id = PC_NETWORK_PUBLIC

/// message_id (text) -> asset key of its registered thumbnail. Registered once per story.
GLOBAL_LIST_EMPTY(nightcrawler_photo_keys)

///sends assest along for the ride, lets news papers contain photos and such
/proc/nightcrawler_photo_key(datum/feed_message/story)
	if(!story.img)
		return null
	var/cache_id = "[story.message_id]"
	var/key = GLOB.nightcrawler_photo_keys[cache_id]
	if(key)
		return key
	var/icon/thumb = icon(story.img)
	var/w = thumb.Width()
	var/h = thumb.Height()
	var/biggest = max(w, h)
	if(biggest > NIGHTCRAWLER_THUMB_SIZE)
		var/factor = NIGHTCRAWLER_THUMB_SIZE / biggest
		thumb.Scale(max(1, round(w * factor)), max(1, round(h * factor)))
	key = SSmodular_computers.get_next_picture_name()
	SSassets.transport.register_asset(key, thumb)
	GLOB.nightcrawler_photo_keys[cache_id] = key
	return key

/datum/pc_program/nightcrawler
	name = "Nightcrawler"
	icon_state = "newspaper"
	tgui_id = "PcNightcrawler"

	var/current_channel_id
	var/datum/weakref/camera_ref
	var/next_screen_refresh = 0
	/// Same as SecurEye's screen, but NOT greyscale
	var/atom/movable/screen/map_view/camera/cam_screen

/datum/pc_program/nightcrawler/New(obj/machinery/computer/pc/host)
	. = ..()
	cam_screen = new
	cam_screen.generate_view("pc_nightcrawler_[REF(src)]_map")

/datum/pc_program/nightcrawler/Destroy()
	QDEL_NULL(cam_screen)
	camera_ref = null
	return ..()

/// Returns list(headline or null, text)
/datum/pc_program/nightcrawler/proc/split_story(text)
	var/pos = findtext_char(text, NIGHTCRAWLER_SEPARATOR)
	if(!pos || pos > NIGHTCRAWLER_MAX_HEADLINE + 1)
		return list(null, text)
	return list(
		copytext_char(text, 1, pos),
		copytext_char(text, pos + length_char(NIGHTCRAWLER_SEPARATOR)),
	)


/// Live cameras on our network, or none if the login lacks network access (same check as SecurEye)
/datum/pc_program/nightcrawler/proc/get_live_cameras()
	var/datum/pc_network/net = computer.current_network
	if(!net || !net.has_access(computer.login_name || "anonymous", PC_NETWORK_USER))
		return list()
	var/list/live = list()
	if(!net)
		return live
	for(var/datum/weakref/ref in net.connected)
		var/obj/item/broadcast_camera/broadcaster = ref.resolve()
		if(!istype(broadcaster) || !broadcaster.active)
			continue
		var/obj/machinery/camera/cam = broadcaster.internal_camera
		if(!cam?.can_use())
			continue
		live += cam
	return live

/datum/pc_program/nightcrawler/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	if(cam_screen && ui)
		cam_screen.display_to(user, ui.window)

/datum/pc_program/nightcrawler/ui_close(mob/user)
	. = ..()
	if(cam_screen && user)
		cam_screen.hide_from(user)

/datum/pc_program/nightcrawler/ui_data(mob/user)
	var/list/data = list()

	var/list/live = get_live_cameras()
	data["live_count"] = length(live)

	var/list/channels_out = list()
	for(var/datum/feed_channel/C as anything in GLOB.news_network.network_channels)
		if(C.censored)
			continue
		channels_out += list(list(
			"id" = C.channel_id,
			"name" = C.channel_name,
			"desc" = C.channel_desc,
			"count" = length(C.messages),
		))
	data["channels"] = channels_out

	var/datum/feed_channel/current = current_channel_id ? GLOB.news_network.network_channels_by_id["[current_channel_id]"] : null
	if(current?.censored)
		current = null
		current_channel_id = null
	if(current)
		data["channel"] = list("id" = current.channel_id, "name" = current.channel_name, "desc" = current.channel_desc)
		var/list/stories = list()
		var/list/photo_keys = list()
		for(var/i in length(current.messages) to 1 step -1)
			var/datum/feed_message/M = current.messages[i]
			var/list/split = split_story(strip_markdown(M.return_body(-1)))
			var/photo_key = nightcrawler_photo_key(M)
			if(photo_key)
				photo_keys += photo_key
			stories += list(list(
				"id" = M.message_id,
				"headline" = split[1],
				"body" = split[2],
				"author" = M.return_author(-1),
				"time" = M.time_stamp,
				"photo" = photo_key ? SSassets.transport.get_asset_url(photo_key) : null,
				"caption" = M.caption,
			))
			if(length(stories) >= NIGHTCRAWLER_MAX_STORIES)
				break
		data["stories"] = stories
		// send_assets skips anything the client already has
		if(user && length(photo_keys))
			SSassets.transport.send_assets(user, photo_keys)

	// The live feed is always shown beside the stories
	var/obj/machinery/camera/active = camera_ref?.resolve()
	if(!active || !(active in live))
		active = length(live) ? live[1] : null
		camera_ref = active ? WEAKREF(active) : null
		update_live_screen(TRUE)
	else
		update_live_screen()
	var/list/cams_out = list()
	for(var/obj/machinery/camera/cam as anything in live)
		cams_out += list(list(
			"name" = replacetext(cam.c_tag, NIGHTCRAWLER_LIVE_PREFIX, ""),
			"ref" = REF(cam),
		))
	data["live_cameras"] = cams_out
	data["activeCamera"] = active ? list("ref" = REF(active), "name" = replacetext(active.c_tag, NIGHTCRAWLER_LIVE_PREFIX, "")) : null
	data["mapRef"] = cam_screen?.assigned_map
	return data

/datum/pc_program/nightcrawler/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	switch(action)
		if("open_channel")
			var/id = text2num(params["id"])
			var/datum/feed_channel/C = GLOB.news_network.network_channels_by_id["[id]"]
			if(!C || C.censored)
				return FALSE
			current_channel_id = id
			return TRUE

		if("home")
			current_channel_id = null
			return TRUE

		if("switch_camera")
			// Only broadcast cameras are selectable, never an arbitrary REF
			var/obj/machinery/camera/cam = locate(params["camera"])
			if(!istype(cam) || !(cam in get_live_cameras()))
				return FALSE
			camera_ref = WEAKREF(cam)
			update_live_screen(TRUE)
			return TRUE
	return FALSE

/datum/pc_program/nightcrawler/proc/update_live_screen(force = FALSE)
	if(!cam_screen)
		return
	if(!force && world.time < next_screen_refresh)
		return
	next_screen_refresh = world.time + NIGHTCRAWLER_LIVE_REFRESH

	var/obj/machinery/camera/active_camera = camera_ref?.resolve()
	if(!active_camera?.can_use())
		cam_screen.show_camera_static()
		return

	var/list/visible_turfs = list()
	for(var/turf/T in view(active_camera.view_range, get_turf(active_camera)))
		visible_turfs += T

	var/list/bbox = get_bbox_of_atoms(visible_turfs)
	var/size_x = bbox[3] - bbox[1] + 1
	var/size_y = bbox[4] - bbox[2] + 1
	cam_screen.show_camera(visible_turfs, size_x, size_y)
	cam_screen.set_display(active_camera)

#define IMAGEBOARD_MAX_THREADS 25
#define IMAGEBOARD_MAX_REPLIES 100
#define IMAGEBOARD_POST_COOLDOWN (10 SECONDS)
#define IMAGEBOARD_MAX_NAME 30
#define IMAGEBOARD_MAX_SUBJECT 60
#define IMAGEBOARD_MAX_BODY 1500
#define IMAGEBOARD_PREVIEW_REPLIES 3
/// Longest side, in pixels, of a camera photo thumbnail stored on a post, larger then what paint allows
#define IMAGEBOARD_THUMB_SIZE 192

GLOBAL_VAR_INIT(imageboard_post_counter, 0)

/// Filenames of tgui assets users may attach to posts
GLOBAL_LIST_EMPTY(imageboard_images)

/datum/pc_post
	var/id
	var/name = "Anonymous"
	var/subject
	var/body
	var/image
	/// Asset-cache key of an attached camera photo (registered with SSassets.transport).
	/// We keep only the key, not the /datum/picture, so the board never holds the original alive.
	var/photo_key
	var/photo_name
	var/timestamp

/datum/pc_thread
	var/id
	var/datum/pc_post/op
	var/list/replies = list()

/datum/pc_program/imageboard
	name = "Image Board"
	icon_state = "images"
	tgui_id = "PcImageBoard"
	var/current_board
	var/current_thread
	var/next_post_time = 0
	/// Photo asset keys referenced by whatever ui_data is currently showing.
	var/list/visible_photo_keys = list()

/datum/pc_program/imageboard/proc/get_boards(datum/pc_network/net)
	if(net?.id == PC_NETWORK_SCHRECKNET)
		return list(
			"elysium" = "Elysium Gossip",
			"rumors" = "Rumors & Whispers",
			"hunting" = "Hunting Grounds",
		)
	return list(
		"general" = "General",
		"classifieds" = "Classifieds",
		"lostfound" = "Lost & Found",
	)

/datum/pc_program/imageboard/proc/get_threads(datum/pc_network/net, board)
	if(!islist(net.imageboard[board]))
		net.imageboard[board] = list()
	return net.imageboard[board]

/datum/pc_program/imageboard/proc/find_thread(datum/pc_network/net, board, id)
	for(var/datum/pc_thread/T in get_threads(net, board))
		if(T.id == id)
			return T
	return null

/datum/pc_program/imageboard/proc/post_to_list(datum/pc_post/P)
	if(P.photo_key)
		visible_photo_keys |= P.photo_key
	return list(
		"id" = P.id,
		"name" = P.name,
		"subject" = P.subject,
		"body" = P.body,
		"image" = P.image,
		"photo" = P.photo_key ? SSassets.transport.get_asset_url(P.photo_key) : null,
		"photo_name" = P.photo_name,
		"time" = P.timestamp,
	)

/// Scales a /datum/picture down and registers it as a permanent asset, like the
/// same as messanger pretty much
/datum/pc_program/imageboard/proc/register_photo_asset(datum/picture/pic)
	var/icon/thumb = icon(pic.picture_image)
	var/w = thumb.Width()
	var/h = thumb.Height()
	var/biggest = max(w, h)
	if(biggest > IMAGEBOARD_THUMB_SIZE)
		var/factor = IMAGEBOARD_THUMB_SIZE / biggest
		thumb.Scale(max(1, round(w * factor)), max(1, round(h * factor)))
	var/key = SSmodular_computers.get_next_picture_name()
	SSassets.transport.register_asset(key, thumb)
	return key

/datum/pc_program/imageboard/proc/build_post(list/params, mob/user, with_subject = FALSE)
	var/datum/pc_post/P = new
	P.name = clean_text(params["name"], IMAGEBOARD_MAX_NAME) || "Anonymous"
	if(with_subject)
		P.subject = clean_text(params["subject"], IMAGEBOARD_MAX_SUBJECT)
	P.body = clean_text(params["body"], IMAGEBOARD_MAX_BODY)
	var/img = params["image"]
	if(istext(img) && (img in GLOB.imageboard_images))
		P.image = img
	var/photo_ref = params["photo"]
	if(istext(photo_ref) && photo_ref)
		for(var/obj/item/photo/photo as anything in get_carried_photos(user))
			if(REF(photo) != photo_ref)
				continue
			P.photo_key = register_photo_asset(photo.picture)
			P.photo_name = clean_text(photo.picture.picture_name, IMAGEBOARD_MAX_SUBJECT)
			P.image = null
			break
	if(!P.body && !P.image && !P.photo_key)
		qdel(P)
		return null
	P.id = ++GLOB.imageboard_post_counter
	P.timestamp = time_to_twelve_hour()
	return P

/datum/pc_program/imageboard/ui_data(mob/user)
	visible_photo_keys = list()
	var/list/data = build_ui_data(user)
	// send_assets skips anything this client already has, so calling it every refresh is cheap.
	if(user && length(visible_photo_keys))
		SSassets.transport.send_assets(user, visible_photo_keys)
	return data

/datum/pc_program/imageboard/proc/build_ui_data(mob/user)
	var/list/data = list()
	var/datum/pc_network/net = computer.current_network

	data["view"] = "index"
	data["boards"] = list()
	data["images"] = GLOB.imageboard_images
	data["cooldown_left"] = max(0, round((next_post_time - world.time) / 10))
	data["limits"] = list(
		"name" = IMAGEBOARD_MAX_NAME,
		"subject" = IMAGEBOARD_MAX_SUBJECT,
		"body" = IMAGEBOARD_MAX_BODY,
	)

	data["photos"] = list()
	for(var/obj/item/photo/P as anything in get_carried_photos(user))
		data["photos"] += list(list(
			"ref" = REF(P),
			"name" = P.picture.picture_name || "photo",
		))

	if(!net)
		return data

	var/list/boards = get_boards(net)
	for(var/id in boards)
		data["boards"] += list(list("id" = id, "name" = boards[id]))

	if(current_board && !(current_board in boards))
		current_board = null
		current_thread = null

	if(!current_board)
		return data

	data["board"] = current_board
	data["board_name"] = boards[current_board]

	if(current_thread)
		var/datum/pc_thread/T = find_thread(net, current_board, current_thread)
		if(T)
			var/list/replies = list()
			for(var/datum/pc_post/R in T.replies)
				replies += list(post_to_list(R))
			data["view"] = "thread"
			data["thread"] = list(
				"id" = T.id,
				"op" = post_to_list(T.op),
				"replies" = replies,
				"full" = length(T.replies) >= IMAGEBOARD_MAX_REPLIES,
			)
			return data
		current_thread = null

	data["view"] = "board"
	var/list/threads_out = list()
	for(var/datum/pc_thread/T in get_threads(net, current_board))
		var/list/preview = list()
		var/total = length(T.replies)
		var/start = max(1, total - IMAGEBOARD_PREVIEW_REPLIES + 1)
		for(var/i in start to total)
			preview += list(post_to_list(T.replies[i]))
		threads_out += list(list(
			"id" = T.id,
			"op" = post_to_list(T.op),
			"replies" = preview,
			"omitted" = max(0, total - length(preview)),
		))
	data["threads"] = threads_out
	return data

/datum/pc_program/imageboard/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/pc_network/net = computer.current_network
	if(!net)
		return FALSE

	var/list/boards = get_boards(net)

	switch(action)
		if("open_board")
			var/board = params["board"]
			if(!istext(board) || !(board in boards))
				return FALSE
			current_board = board
			current_thread = null
			return TRUE

		if("open_thread")
			if(!current_board)
				return FALSE
			var/id = text2num(params["id"])
			if(!find_thread(net, current_board, id))
				return FALSE
			current_thread = id
			return TRUE

		if("back")
			if(current_thread)
				current_thread = null
			else
				current_board = null
			return TRUE

		if("home")
			current_board = null
			current_thread = null
			return TRUE

		if("new_thread")
			if(!current_board || world.time < next_post_time)
				return FALSE
			var/datum/pc_post/P = build_post(params, ui?.user, with_subject = TRUE)
			if(!P)
				return FALSE
			var/datum/pc_thread/T = new
			T.id = P.id
			T.op = P
			var/list/threads = get_threads(net, current_board)
			threads.Insert(1, T)
			// Drop the stalest threads off the bottom of the board
			while(length(threads) > IMAGEBOARD_MAX_THREADS)
				threads.Cut(length(threads))
			next_post_time = world.time + IMAGEBOARD_POST_COOLDOWN
			notify_tap(P, boards[current_board])
			current_thread = T.id
			return TRUE

		if("reply")
			if(!current_board || !current_thread || world.time < next_post_time)
				return FALSE
			var/datum/pc_thread/T = find_thread(net, current_board, current_thread)
			if(!T || length(T.replies) >= IMAGEBOARD_MAX_REPLIES)
				return FALSE
			var/datum/pc_post/P = build_post(params, ui?.user)
			if(!P)
				return FALSE
			T.replies += P
			// Bump to the top of the board
			var/list/threads = get_threads(net, current_board)
			threads -= T
			threads.Insert(1, T)
			next_post_time = world.time + IMAGEBOARD_POST_COOLDOWN
			notify_tap(P, boards[current_board])
			return TRUE

	return FALSE

/datum/pc_program/imageboard/notify_tap(datum/pc_post/P, board_name)
	var/datum/pc_program/hacking/H = tap?.resolve()
	if(!H || world.time > tap_until)
		tap = null
		return
	H.receive_intercept(computer.get_network_device_id(), board_name, P)

#undef IMAGEBOARD_MAX_THREADS
#undef IMAGEBOARD_MAX_REPLIES
#undef IMAGEBOARD_POST_COOLDOWN
#undef IMAGEBOARD_MAX_NAME
#undef IMAGEBOARD_MAX_SUBJECT
#undef IMAGEBOARD_MAX_BODY
#undef IMAGEBOARD_PREVIEW_REPLIES
#undef IMAGEBOARD_THUMB_SIZE

/datum/pc_program/nightcrawler_editor
	name = "Nightcrawler Editor"
	icon_state = "newspaper"
	tgui_id = "PcNightcrawlerEditor"

	var/next_publish_time = 0
	var/next_print_time = 0
	/// Last result message shown to the user
	var/status

/datum/pc_program/nightcrawler_editor/proc/get_byline(raw)
	return clean_text(raw, NIGHTCRAWLER_MAX_BYLINE) || computer.login_name || "Anonymous"

/datum/pc_program/nightcrawler_editor/proc/printer_status(datum/pc_network/net)
	if(!net)
		return "No network"
	var/obj/machinery/pc_printer/printer = net.find_printer(NIGHTCRAWLER_PRINT_SHEETS)
	if(!printer)
		return "No printer with enough paper"
	return "Ready"

/datum/pc_program/nightcrawler_editor/proc/count_player_channels()
	var/total = 0
	for(var/datum/feed_channel/C as anything in GLOB.news_network.network_channels)
		if(!C.is_admin_channel)
			total++
	return total

/datum/pc_program/nightcrawler_editor/ui_data(mob/user)
	var/list/data = list()
	var/datum/pc_network/net = computer.current_network
	var/login = computer.login_name || "anonymous"

	data["can_edit"] = net ? net.has_access(login, PC_NETWORK_USER) : FALSE
	data["byline"] = computer.login_name || "Anonymous"
	data["status"] = status
	data["publish_cooldown"] = max(0, round((next_publish_time - world.time) / 10))
	data["print_cooldown"] = max(0, round((next_print_time - world.time) / 10))
	data["limits"] = list(
		"headline" = NIGHTCRAWLER_MAX_HEADLINE,
		"body" = NIGHTCRAWLER_MAX_BODY,
		"byline" = NIGHTCRAWLER_MAX_BYLINE,
		"channel_name" = NIGHTCRAWLER_MAX_CHANNEL_NAME,
		"channel_desc" = NIGHTCRAWLER_MAX_CHANNEL_DESC,
	)

	var/list/channels_out = list()
	for(var/datum/feed_channel/C as anything in GLOB.news_network.network_channels)
		if(C.is_admin_channel || C.censored)
			continue
		channels_out += list(list("id" = C.channel_id, "name" = C.channel_name, "desc" = C.channel_desc))
	data["channels"] = channels_out
	data["can_create_channel"] = count_player_channels() < NIGHTCRAWLER_MAX_CHANNELS

	var/list/photos_out = list()
	for(var/obj/item/photo/P as anything in get_carried_photos(user))
		photos_out += list(list("ref" = REF(P), "name" = P.picture.picture_name || "photo"))
	data["photos"] = photos_out

	data["printer_status"] = printer_status(net)
	data["print_sheets"] = NIGHTCRAWLER_PRINT_SHEETS
	return data

/datum/pc_program/nightcrawler_editor/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/datum/pc_network/net = computer.current_network
	if(!net)
		status = "No network connection."
		return TRUE
	var/login = computer.login_name || "anonymous"
	if(!net.has_access(login, PC_NETWORK_USER))
		status = "Access denied."
		return TRUE
	var/mob/user = ui?.user

	switch(action)
		if("publish")
			if(world.time < next_publish_time)
				return FALSE
			var/channel_id = text2num(params["channel"])
			var/datum/feed_channel/C = GLOB.news_network.network_channels_by_id["[channel_id]"]
			if(!C || C.is_admin_channel || C.censored)
				status = "Pick a section to publish in."
				return TRUE
			var/headline = clean_text(params["headline"], NIGHTCRAWLER_MAX_HEADLINE)
			var/body = clean_text(params["body"], NIGHTCRAWLER_MAX_BODY)
			if(!headline || !body)
				status = "A story needs a headline and a body."
				return TRUE
			var/byline = get_byline(params["byline"])

			var/datum/picture/pic
			var/photo_ref = params["photo"]
			if(istext(photo_ref) && photo_ref)
				for(var/obj/item/photo/photo as anything in get_carried_photos(user))
					if(REF(photo) == photo_ref)
						pic = photo.picture
						break

			var/story_text = "[uppertext(headline)][NIGHTCRAWLER_SEPARATOR][body]"
			GLOB.news_network.submit_article(story_text, byline, C.channel_name, pic, FALSE, TRUE, TRUE, user)
			user?.log_message("published a Nightcrawler story in [C.channel_name] as [byline]: [story_text]", LOG_GAME)
			next_publish_time = world.time + NIGHTCRAWLER_PUBLISH_COOLDOWN
			status = "Published in [C.channel_name]."
			return TRUE

		if("create_channel")
			var/channel_name = clean_text(params["name"], NIGHTCRAWLER_MAX_CHANNEL_NAME)
			var/desc = clean_text(params["desc"], NIGHTCRAWLER_MAX_CHANNEL_DESC)
			if(!channel_name)
				status = "A section needs a name."
				return TRUE
			if(GLOB.news_network.network_channels_by_name["[channel_name]"])
				status = "A section with that name already exists."
				return TRUE
			if(count_player_channels() >= NIGHTCRAWLER_MAX_CHANNELS)
				status = "There are too many sections already."
				return TRUE
			var/byline = get_byline(params["byline"])
			GLOB.news_network.create_feed_channel(channel_name, byline, desc, FALSE)
			user?.log_message("created Nightcrawler section [channel_name] as [byline]", LOG_GAME)
			status = "Created section [channel_name]."
			return TRUE

		if("print")
			if(world.time < next_print_time)
				return FALSE
			var/obj/machinery/pc_printer/printer = net.find_printer(NIGHTCRAWLER_PRINT_SHEETS)
			if(!printer)
				status = "No printer with enough paper on [net.name]."
				return TRUE
			var/problem = printer.begin_print(NIGHTCRAWLER_PRINT_SHEETS, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(create_newspaper)))
			if(problem)
				status = problem
				return TRUE
			next_print_time = world.time + NIGHTCRAWLER_PRINT_COOLDOWN
			user?.log_message("printed a Nightcrawler newspaper on [printer]", LOG_GAME)
			status = "Printing..."
			return TRUE
	return FALSE

#define GEO_DIR "data/geocities/"
#define GEO_MAX_HTML 80000
#define GEO_MAX_TITLE 48
#define GEO_PUBLISH_COOLDOWN (10 SECONDS)

///loaded cache key>site
GLOBAL_LIST_EMPTY(geocities_sites)

/datum/pc_geosite
	var/key
	var/ckey
	var/char_name
	var/title = "Welcome to my homepage!"
	var/html = ""
	var/bg = "#000080"
	var/updated = ""
	var/visits = 0

/datum/pc_geosite/proc/to_list()
	return list(
		"ckey" = ckey,
		"char_name" = char_name,
		"title" = title,
		"html" = html,
		"bg" = bg,
		"updated" = updated,
		"visits" = visits,
	)

/datum/pc_geosite/proc/save()
	var/path = geo_path(key)
	fdel(path)
	text2file(json_encode(to_list()), path)

/proc/geo_make_key(ckey, char_name)
	return "[ckey]-[char_name]"

/proc/geo_path(key)
	var/static/regex/unsafe = regex(@"[^a-z0-9_\-]", "g")
	var/safe = unsafe.Replace(LOWER_TEXT(key), "_")
	return "[GEO_DIR][copytext(safe, 1, 120)].json"

/proc/geo_get_site(key)
	if(GLOB.geocities_sites[key])
		return GLOB.geocities_sites[key]
	var/path = geo_path(key)
	if(!fexists(path))
		return null
	var/list/L = json_decode(file2text(path))
	if(!islist(L))
		return null
	var/datum/pc_geosite/S = new
	S.key = key
	S.ckey = L["ckey"]
	S.char_name = L["char_name"]
	S.title = L["title"]
	S.html = L["html"]
	S.bg = L["bg"]
	S.updated = L["updated"]
	S.visits = text2num(L["visits"]) || 0
	GLOB.geocities_sites[key] = S
	return S

/proc/geo_sanitize_html(text)
	text = copytext(text, 1, GEO_MAX_HTML + 1)
	var/static/regex/bad_tags = regex(@"</?\s*(iframe|object|embed|link|meta|base|form|input|button|textarea|svg|math)\b[^>]*>", "gi")
	var/static/regex/bad_attrs = regex(@{"\son\w+\s*=\s*("[^"]*"|'[^']*'|[^\s>]+)"}, "gi")
	text = bad_tags.Replace(text, "")
	text = bad_attrs.Replace(text, "")
	return text

/proc/geo_sanitize_color(text)
	var/static/regex/hex = regex(@"^#[0-9a-fA-F]{6}$")
	if(istext(text) && hex.Find(text))
		return LOWER_TEXT(text)
	return "#000080"

/datum/pc_program/geocities
	name = "Homepage Builder"
	icon_state = "globe-americas"
	tgui_id = "PcGeocities"
	var/viewing_key
	var/next_publish = 0
	var/message

/datum/pc_program/geocities/proc/own_key(mob/user)
	if(!user?.ckey || !user.real_name)
		return null
	return geo_make_key(user.ckey, user.real_name)

/datum/pc_program/geocities/ui_data(mob/user)
	var/list/data = list()
	var/my_key = own_key(user)

	var/list/sites = list()
	var/list/seen = list()
	for(var/mob/M in GLOB.player_list)
		if(!M.ckey || !M.real_name)
			continue
		var/key = geo_make_key(M.ckey, M.real_name)
		if(seen[key])
			continue
		seen[key] = TRUE
		var/datum/pc_geosite/S = geo_get_site(key)
		if(!S)
			continue
		sites += list(list(
			"key" = key,
			"title" = S.title,
			"owner" = S.char_name,
			"visits" = S.visits,
			"updated" = S.updated,
		))
	data["sites"] = sites

	data["page"] = null
	if(viewing_key && seen[viewing_key])
		var/datum/pc_geosite/V = geo_get_site(viewing_key)
		if(V)
			var/list/page = V.to_list()
			page["key"] = viewing_key
			data["page"] = page

	var/datum/pc_geosite/mine = my_key ? geo_get_site(my_key) : null
	data["mine"] = mine ? mine.to_list() : null
	data["my_key"] = my_key
	data["my_name"] = user?.real_name
	data["max_html"] = GEO_MAX_HTML
	data["max_title"] = GEO_MAX_TITLE
	data["cooldown_left"] = max(0, round((next_publish - world.time) / 10))
	data["message"] = message
	return data

/datum/pc_program/geocities/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/mob/user = ui?.user
	if(!user)
		return FALSE
	message = null

	switch(action)
		if("view")
			var/key = params["key"]
			if(!istext(key))
				return FALSE
			var/found = FALSE
			for(var/mob/M in GLOB.player_list)
				if(M.ckey && M.real_name && geo_make_key(M.ckey, M.real_name) == key)
					found = TRUE
					break
			if(!found)
				message = "That user is not online."
				return TRUE
			var/datum/pc_geosite/S = geo_get_site(key)
			if(!S)
				return FALSE
			if(viewing_key != key && key != own_key(user))
				S.visits++
				S.save()
			viewing_key = key
			return TRUE

		if("publish")
			var/key = own_key(user)
			if(!key)
				return FALSE
			if(world.time < next_publish)
				message = "Please wait before publishing again."
				return TRUE
			var/title = copytext(STRIP_HTML_SIMPLE(params["title"], GEO_MAX_TITLE + 1), 1, GEO_MAX_TITLE + 1)
			if(!length(title))
				title = "Untitled"
			var/datum/pc_geosite/S = geo_get_site(key)
			if(!S)
				S = new
				S.key = key
				S.ckey = user.ckey
				S.char_name = user.real_name
				GLOB.geocities_sites[key] = S
			S.title = title
			S.html = geo_sanitize_html(params["html"])
			S.bg = geo_sanitize_color(params["bg"])
			S.updated = time_to_twelve_hour()
			S.save()
			next_publish = world.time + GEO_PUBLISH_COOLDOWN
			message = "Published!"
			return TRUE

		if("delete")
			var/key = own_key(user)
			if(!key)
				return FALSE
			fdel(geo_path(key))
			GLOB.geocities_sites -= key
			if(viewing_key == key)
				viewing_key = null
			message = "Your page was deleted."
			return TRUE

	return FALSE

#undef GEO_DIR
#undef GEO_MAX_HTML
#undef GEO_MAX_TITLE
#undef GEO_PUBLISH_COOLDOWN

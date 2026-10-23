/// Largest canvas side, in pixels. Photos bigger than this are scaled down on import.
#define PAINT_MAX_SIZE 128
#define PAINT_MIN_SIZE 8
#define PAINT_EXPORT_COOLDOWN (20 SECONDS)
/// Max characters accepted in one export chunk (6 hex chars per pixel)
#define PAINT_CHUNK_MAX 2400
/// Max number of carried photos offered in the import picker
#define PAINT_MAX_PHOTO_CHOICES 10
#define PAINT_MAX_NAME 40
/// Wire encoding of a fully transparent pixel; everything else is RRGGBB hex
#define PAINT_TRANSPARENT "------"

/datum/pc_program/paint
	name = "Paint"
	icon_state = "paint-brush"
	tgui_id = "PcPaint"
	/// Export cooldown, so the printer-of-photos can't be spammed
	var/next_export_time = 0
	/// Message shown in the UI after the last import/export attempt
	var/status_message

	/// Pending import, sent to the client until it acknowledges it.
	/// id increments per import so the client never applies the same one twice.
	var/import_id = 0
	var/import_w
	var/import_h
	var/import_name
	var/import_data

	/// In-progress export, assembled from client chunks
	var/exporting = FALSE
	var/export_w
	var/export_h
	var/export_name
	var/export_buffer = ""

/// Reads a picture's pixels into the wire format (rows top to bottom, RRGGBB or PAINT_TRANSPARENT)
/// and queues it for the client. Returns FALSE if the picture is unusable.
/datum/pc_program/paint/proc/load_import(datum/picture/pic)
	if(!pic?.picture_image)
		return FALSE
	var/icon/I = icon(pic.picture_image) // copy, never touch the original
	var/w = I.Width()
	var/h = I.Height()
	if(w < 1 || h < 1)
		return FALSE
	var/biggest = max(w, h)
	if(biggest > PAINT_MAX_SIZE)
		var/factor = PAINT_MAX_SIZE / biggest
		I.Scale(max(1, round(w * factor)), max(1, round(h * factor)))
		w = I.Width()
		h = I.Height()

	var/list/out = list()
	// icon y=1 is the bottom row, the canvas starts at the top
	for(var/y = h, y >= 1, y--)
		for(var/x in 1 to w)
			var/px = I.GetPixel(x, y)
			if(!px)
				out += PAINT_TRANSPARENT
				continue
			// "#RRGGBB" or "#RRGGBBAA"
			if(length(px) >= 9 && text2num(copytext(px, 8, 10), 16) < 128)
				out += PAINT_TRANSPARENT
				continue
			out += copytext(px, 2, 8)

	import_w = w
	import_h = h
	import_name = clean_text(pic.picture_name, PAINT_MAX_NAME) || "Photo"
	import_data = jointext(out, "")
	import_id++
	return TRUE

/datum/pc_program/paint/proc/abort_export(reason)
	exporting = FALSE
	export_buffer = ""
	status_message = reason

/// Turns the received buffer into a /datum/picture and a new /obj/item/photo.
/datum/pc_program/paint/proc/finish_export(mob/user)
	if(!exporting || length(export_buffer) != export_w * export_h * 6)
		abort_export("Export failed: the image was incomplete.")
		return FALSE

	var/icon/I = icon('icons/blanks/32x32.dmi', "nothing")
	I.Scale(export_w, export_h)
	var/idx = 1
	for(var/row = 0, row < export_h, row++)
		var/iy = export_h - row // canvas row 0 is the top, icon y=1 is the bottom
		for(var/col = 0, col < export_w, col++)
			var/chunk = copytext(export_buffer, idx, idx + 6)
			idx += 6
			if(chunk == PAINT_TRANSPARENT)
				continue
			I.DrawBox("#[chunk]", col + 1, iy)

	var/datum/picture/pic = new
	pic.picture_name = export_name
	pic.picture_desc = "A digital painting titled \"[export_name]\"."
	pic.picture_image = I
	pic.psize_x = export_w
	pic.psize_y = export_h

	var/obj/item/photo/photo = new(get_turf(computer), pic)
	if(user)
		user.put_in_hands(photo)

	next_export_time = world.time + PAINT_EXPORT_COOLDOWN
	exporting = FALSE
	export_buffer = ""
	status_message = "Exported \"[export_name]\" as a photo."
	return TRUE

/datum/pc_program/paint/ui_data(mob/user)
	var/list/data = list()
	data["cooldown_left"] = max(0, round((next_export_time - world.time) / 10))
	data["message"] = status_message
	data["exporting"] = exporting
	data["limits"] = list(
		"min" = PAINT_MIN_SIZE,
		"max" = PAINT_MAX_SIZE,
		"chunk" = PAINT_CHUNK_MAX,
		"name" = PAINT_MAX_NAME,
	)

	// Names only; pixels are read once, when the player picks one to import.
	data["photos"] = list()
	for(var/obj/item/photo/P as anything in get_carried_photos(user))
		data["photos"] += list(list(
			"ref" = REF(P),
			"name" = P.picture.picture_name || "photo",
		))

	if(import_data)
		data["import"] = list(
			"id" = import_id,
			"w" = import_w,
			"h" = import_h,
			"name" = import_name,
			"data" = import_data,
		)
	return data

/datum/pc_program/paint/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	var/mob/user = ui?.user
	var/static/regex/bad_chars = regex("\[^0-9a-fA-F-]")

	switch(action)
		if("import_photo")
			var/photo_ref = params["photo"]
			if(!istext(photo_ref) || !photo_ref)
				return FALSE
			// Match the client's ref against what the user is actually carrying,
			// so nobody can pull pixels from a photo they don't hold.
			for(var/obj/item/photo/photo as anything in get_carried_photos(user))
				if(REF(photo) != photo_ref)
					continue
				if(!load_import(photo.picture))
					status_message = "That photo is blank."
				else
					status_message = null
				return TRUE
			status_message = "You aren't carrying that photo anymore."
			return TRUE

		if("import_ack")
			if(text2num(params["id"]) == import_id)
				import_data = null
			return TRUE

		if("export_begin")
			if(world.time < next_export_time)
				status_message = "The export queue is busy; wait a moment."
				return TRUE
			var/w = round(text2num(params["w"]))
			var/h = round(text2num(params["h"]))
			if(!isnum(w) || !isnum(h) || w < PAINT_MIN_SIZE || h < PAINT_MIN_SIZE || w > PAINT_MAX_SIZE || h > PAINT_MAX_SIZE)
				status_message = "Export failed: invalid canvas size."
				return TRUE
			exporting = TRUE
			export_w = w
			export_h = h
			export_name = clean_text(params["name"], PAINT_MAX_NAME) || "Painting"
			export_buffer = ""
			status_message = null
			return TRUE

		if("export_chunk")
			if(!exporting)
				return FALSE
			var/offset = text2num(params["offset"])
			var/chunk = params["data"]
			if(!istext(chunk) || !length(chunk) || length(chunk) > PAINT_CHUNK_MAX)
				abort_export("Export failed: bad data.")
				return TRUE
			// Chunks must arrive in order and contain nothing but hex digits and the transparent marker
			if(offset != length(export_buffer) || findtext(chunk, bad_chars))
				abort_export("Export failed: data went out of sync.")
				return TRUE
			if(length(export_buffer) + length(chunk) > export_w * export_h * 6)
				abort_export("Export failed: too much data.")
				return TRUE
			export_buffer += chunk
			return TRUE

		if("export_finish")
			finish_export(user)
			return TRUE

		if("export_cancel")
			abort_export(null)
			return TRUE

	return FALSE

#undef PAINT_MAX_SIZE
#undef PAINT_MIN_SIZE
#undef PAINT_EXPORT_COOLDOWN
#undef PAINT_CHUNK_MAX
#undef PAINT_MAX_PHOTO_CHOICES
#undef PAINT_MAX_NAME
#undef PAINT_TRANSPARENT

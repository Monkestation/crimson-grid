/datum/pc_medical_record
	var/name
	var/text = ""
	var/last_editor
	var/last_edited
	/// base64 png of a photo attached to this record on the network, if any
	var/attachment_image
	var/attachment_name

#define PC_MEDICAL_MAX_LEN 4000
#define PC_MEDICAL_PRINT_SHEETS 1
#define PC_MEDICAL_PRINT_COOLDOWN (10 SECONDS)

/datum/pc_program/medical_base
	abstract_type = /datum/pc_program/medical_base
	name = "Medical Records"
	icon_state = "user-doctor"
	/// Minimum network role needed to open the program
	var/read_role = PC_NETWORK_USER
	/// Name of the crew record currently open
	var/selected_name
	/// base64 of the open record's front/side photos. Built once when a record is opened, not every UI tick.
	var/selected_front
	var/selected_side
	/// Last result message shown to the user
	var/status
	var/next_print_time = 0

/datum/pc_program/medical_base/proc/get_login()
	return computer?.login_name || "anonymous"

/datum/pc_program/medical_base/proc/is_listed(datum/record/crew/crew)
	return !(crew.name == "Unknown" || crew.rank == "Unassigned" || crew.rank == "Unknown")

/datum/pc_program/medical_base/proc/find_crew(crew_name)
	if(!crew_name)
		return null
	for(var/datum/record/crew/crew as anything in GLOB.manifest.general)
		if(crew.name == crew_name && is_listed(crew))
			return crew
	return null

/datum/pc_program/medical_base/proc/clear_selection()
	selected_name = null
	selected_front = null
	selected_side = null

/datum/pc_program/medical_base/proc/photo_to_base64(obj/item/photo/photo)
	if(!istype(photo) || !photo.picture || !isicon(photo.picture.picture_image))
		return null
	return icon2base64(photo.picture.picture_image)

/datum/pc_program/medical_base/proc/get_medical_text(datum/record/crew/crew, datum/pc_network/net)
	var/datum/pc_medical_record/local = net.get_medical_record(crew.name)
	return local ? local.text : crew.past_medical_records

/datum/pc_program/medical_base/proc/printer_status(datum/pc_network/net)
	if(!net)
		return "No network"
	var/obj/machinery/pc_printer/printer = net.find_printer(PC_MEDICAL_PRINT_SHEETS)
	if(!printer)
		return "No printer with enough paper"
	return "Ready"

/datum/pc_program/medical_base/proc/build_detail(datum/record/crew/crew, datum/pc_network/net)
	var/datum/pc_medical_record/local = net.get_medical_record(crew.name)
	var/list/notes = list()
	for(var/datum/medical_note/note as anything in crew.medical_notes)
		notes += list(list("author" = note.author, "content" = note.content, "time" = note.time))
	return list(
		"name" = crew.name,
		"rank" = crew.rank,
		"age" = crew.age,
		"gender" = crew.gender,
		"species" = crew.species,
		"blood_type" = crew.blood_type,
		"dna" = crew.dna_string,
		"physical_status" = crew.physical_status,
		"mental_status" = crew.mental_status,
		"cause_of_death" = crew.cause_of_death,
		"major_conditions" = crew.major_disabilities_desc,
		"minor_conditions" = crew.minor_disabilities_desc,
		"quirk_notes" = crew.quirk_notes,
		"notes" = notes,
		"front" = selected_front,
		"side" = selected_side,
		"medical" = local ? local.text : crew.past_medical_records,
		"baseline" = crew.past_medical_records,
		"edited" = !!local,
		"editor" = local?.last_editor,
		"time" = local?.last_edited,
		"attachment" = local?.attachment_image,
		"attachment_name" = local?.attachment_name,
	)

/datum/pc_program/medical_base/ui_data(mob/user)
	var/list/data = list()
	var/datum/pc_network/net = computer?.current_network
	data["status"] = status
	data["limits"] = list("text" = PC_MEDICAL_MAX_LEN)
	data["records"] = list()
	if(!net)
		data["error"] = "Not connected to a network."
		return data
	var/login = get_login()
	data["current_role"] = net.get_user_role(login)
	if(!net.has_access(login, read_role))
		data["error"] = "Your role cannot access medical records on this network."
		return data

	var/list/records = list()
	for(var/datum/record/crew/crew as anything in GLOB.manifest.general)
		if(!is_listed(crew))
			continue
		var/datum/pc_medical_record/local = net.get_medical_record(crew.name)
		records += list(list(
			"name" = crew.name,
			"rank" = crew.rank,
			"edited" = !!local,
			"has_attachment" = !!local?.attachment_image,
		))
	data["records"] = records

	if(selected_name)
		var/datum/record/crew/crew = find_crew(selected_name)
		if(crew)
			data["selected"] = build_detail(crew, net)
		else
			clear_selection() // record was removed from the manifest

	data["printer_status"] = printer_status(net)
	data["print_sheets"] = PC_MEDICAL_PRINT_SHEETS
	data["print_cooldown"] = max(0, round((next_print_time - world.time) / 10))
	return data

/datum/pc_program/medical_base/proc/build_printout(datum/record/crew/crew, datum/pc_network/net)
	var/datum/pc_medical_record/local = net.get_medical_record(crew.name)
	var/list/lines = list()
	lines += "<center><b>MEDICAL RECORD</b></center><br>"
	lines += "Name: [html_encode(crew.name)]<br>"
	lines += "Rank: [html_encode(crew.rank)]<br>"
	lines += "Age: [crew.age] | Gender: [html_encode(crew.gender)] | Species: [html_encode(crew.species)]<br>"
	lines += "Blood type: [html_encode(crew.blood_type)]<br>"
	lines += "Physical: [html_encode(crew.physical_status)] | Mental: [html_encode(crew.mental_status)]<br>"
	if(crew.cause_of_death)
		lines += "Cause of death: [html_encode(crew.cause_of_death)]<br>"
	lines += "Major conditions: [html_encode(crew.major_disabilities_desc)]<br>"
	lines += "Minor conditions: [html_encode(crew.minor_disabilities_desc)]<br><br>"
	lines += "<b>Medical history</b><br>"
	lines += "[replacetext(html_encode(local ? local.text : crew.past_medical_records), "\n", "<br>")]<br><br>"
	if(length(crew.medical_notes))
		lines += "<b>Notes</b><br>"
		for(var/datum/medical_note/note as anything in crew.medical_notes)
			lines += "- [html_encode(note.content)] ([html_encode(note.author)], [html_encode(note.time)])<br>"
		lines += "<br>"
	if(local)
		lines += "<i>Network copy on [html_encode(net.name)], last edited by [html_encode(local.last_editor)] at [html_encode(local.last_edited)]</i><br>"
	return jointext(lines, "")

/proc/create_medical_printout(obj/machinery/pc_printer/printer, title, html)
	if(QDELETED(printer))
		return
	var/obj/item/paper/paper = new(get_turf(printer))
	paper.name = title
	paper.add_raw_text(html)
	paper.update_appearance()

/datum/pc_program/medical_base/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	var/datum/pc_network/net = computer?.current_network
	if(!net)
		status = "No network connection."
		return TRUE
	if(!net.has_access(get_login(), read_role))
		status = "Access denied."
		return TRUE
	var/mob/user = ui?.user

	switch(action)
		if("select")
			var/datum/record/crew/crew = find_crew(clean_text(params["name"], 100))
			if(!crew)
				status = "No such record."
				return TRUE
			selected_name = crew.name
			selected_front = photo_to_base64(crew.get_front_photo())
			selected_side = photo_to_base64(crew.get_side_photo())
			status = null
			return TRUE

		if("deselect")
			clear_selection()
			status = null
			return TRUE

		if("print")
			if(world.time < next_print_time)
				return FALSE
			var/datum/record/crew/crew = find_crew(selected_name)
			if(!crew)
				status = "Open a record first."
				return TRUE
			var/obj/machinery/pc_printer/printer = net.find_printer(PC_MEDICAL_PRINT_SHEETS)
			if(!printer)
				status = "No printer with enough paper on [net.name]."
				return TRUE
			var/title = "Medical Record: [crew.name]"
			var/problem = printer.begin_print(PC_MEDICAL_PRINT_SHEETS, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(create_medical_printout), printer, title, build_printout(crew, net)))
			if(problem)
				status = problem
				return TRUE
			next_print_time = world.time + PC_MEDICAL_PRINT_COOLDOWN
			user?.log_message("printed the medical record of [crew.name] on [printer]", LOG_GAME)
			status = "Printing..."
			return TRUE
	return FALSE

/datum/pc_program/medical_base/reader
	name = "Medical Records"
	tgui_id = "PcMedicalReader"

/datum/pc_program/medical_base/writer
	name = "Medical Records Editor"
	tgui_id = "PcMedicalWriter"
	/// Minimum network role needed to edit
	var/write_role = PC_NETWORK_USER

/datum/pc_program/medical_base/writer/ui_data(mob/user)
	. = ..()
	var/datum/pc_network/net = computer?.current_network
	.["can_write"] = !!net && !!computer?.login_name && net.has_access(computer.login_name, write_role)
	var/list/photos_out = list()
	for(var/obj/item/photo/photo as anything in get_carried_photos(user))
		photos_out += list(list("ref" = REF(photo), "name" = photo.picture.picture_name || "photo"))
	.["photos"] = photos_out

/datum/pc_program/medical_base/writer/proc/get_or_create_record(datum/pc_network/net, datum/record/crew/crew)
	var/datum/pc_medical_record/rec = net.get_medical_record(crew.name)
	if(!rec)
		rec = net.set_medical_record(crew.name, crew.past_medical_records, computer.login_name)
	return rec

/datum/pc_program/medical_base/writer/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	if(!(action in list("save", "attach", "detach", "revert")))
		return FALSE
	var/datum/pc_network/net = computer?.current_network
	var/mob/user = ui?.user
	if(!computer?.login_name)
		status = "Insert a card and log in to edit records."
		return TRUE
	if(!net || !net.has_access(computer.login_name, write_role))
		status = "Access denied."
		return TRUE
	var/datum/record/crew/crew = find_crew(selected_name)
	if(!crew)
		status = "Open a record first."
		return TRUE
	var/login = computer.login_name

	switch(action)
		if("save")
			var/text = clean_text(params["text"], PC_MEDICAL_MAX_LEN)
			net.set_medical_record(crew.name, text, login)
			user?.log_message("edited the network medical record of [crew.name] on [net.name]: [text]", LOG_GAME)
			status = "Saved to [net.name]."
			return TRUE

		if("attach")
			var/photo_ref = params["photo"]
			if(!istext(photo_ref) || !photo_ref)
				return TRUE
			for(var/obj/item/photo/photo as anything in get_carried_photos(user))
				if(REF(photo) != photo_ref)
					continue
				var/image = photo_to_base64(photo)
				if(!image)
					status = "That photo can't be read."
					return TRUE
				var/datum/pc_medical_record/rec = get_or_create_record(net, crew)
				rec.attachment_image = image
				rec.attachment_name = photo.picture.picture_name || "photo"
				rec.last_editor = login
				rec.last_edited = time_to_twelve_hour()
				user?.log_message("attached a photo to the network medical record of [crew.name] on [net.name]", LOG_GAME)
				status = "Photo attached."
				return TRUE
			status = "You aren't carrying that photo."
			return TRUE

		if("detach")
			var/datum/pc_medical_record/rec = net.get_medical_record(crew.name)
			if(rec?.attachment_image)
				rec.attachment_image = null
				rec.attachment_name = null
				rec.last_editor = login
				rec.last_edited = time_to_twelve_hour()
				status = "Photo removed."
			return TRUE

		if("revert")
			net.clear_medical_record(crew.name)
			user?.log_message("reverted the network medical record of [crew.name] on [net.name] to the manifest", LOG_GAME)
			status = "Reverted to the manifest copy."
			return TRUE
	return FALSE

#undef PC_MEDICAL_MAX_LEN
#undef PC_MEDICAL_PRINT_SHEETS
#undef PC_MEDICAL_PRINT_COOLDOWN

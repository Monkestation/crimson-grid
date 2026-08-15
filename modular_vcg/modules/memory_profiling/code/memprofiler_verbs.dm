ADMIN_VERB(memory_profiler, R_DEBUG, "Memory Profiler", "Poke around what BYOND is actually holding onto: how many of each thing, who owns which list, var rows, and what grew since you last looked.", ADMIN_CATEGORY_PROFILE)
	BLACKBOX_LOG_ADMIN_VERB("Memory Profiler")
	MemProfiler.ui_interact(user.mob)

ADMIN_VERB(memory_profile_census, R_DEBUG, "Memory Census (Text)", "Walk the whole heap and dump it to chat and world.log. Freezes the server for a few seconds while it does.", ADMIN_CATEGORY_PROFILE)
	if(!MemProfiler.enabled)
		to_chat(user, span_warning("byond_memprofile didn't load: [MemProfiler.error || "and it gave no reason"]"), type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return
	if(tgui_alert(user, "This walks the entire heap and the server is frozen for every second of it. Still want to?", "Memory Census", list("Run it", "Cancel")) != "Run it")
		return
	BLACKBOX_LOG_ADMIN_VERB("Memory Census (Text)")
	var/report = MemProfiler.run_extension(user, "text census", CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(memprofile_census)))
	if(!length(report))
		to_chat(user, span_warning("Got nothing back: [MemProfiler.last_error || "and no reason why"]"), type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return
	for(var/line in splittext(report, "\n"))
		SEND_TEXT(world.log, line)
	to_chat(user, fieldset_block("Memory Census", "<pre>[html_encode(report)]</pre>", "boxed_message purple_box"), avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG, confidential = TRUE)

ADMIN_VERB(memory_profile_dump, R_DEBUG, "Memory Profile Dump", "Write the whole thing out to a JSON Lines file and hand it to you. Server stays frozen for the walk and the write both.", ADMIN_CATEGORY_PROFILE)
	if(!MemProfiler.enabled)
		to_chat(user, span_warning("byond_memprofile didn't load: [MemProfiler.error || "and it gave no reason"]"), type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return
	var/kind = tgui_alert(user, "Dump which one? The full scan is always complete. A list dump gets cut off unless you pick \"all\".", "Memory Profile Dump", list("Census", "Lists", "Cancel"))
	if(!kind || kind == "Cancel")
		return
	var/rows
	if(kind == "Lists")
		rows = tgui_input_list(user, "How many rows? \"all\" can run to hundreds of megabytes on a live world.", "Memory Profile Dump", MemProfiler.dump_row_options)
		if(isnull(rows))
			return
	BLACKBOX_LOG_ADMIN_VERB("Memory Profile Dump")
	if(!MemProfiler.dump_to_file(user, LOWER_TEXT(kind), rows))
		to_chat(user, span_warning("Dump failed: [MemProfiler.last_error || "and no reason why"]"), type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return
	MemProfiler.download_dump(user, length(MemProfiler.dumps))

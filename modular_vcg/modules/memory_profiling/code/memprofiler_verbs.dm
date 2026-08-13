ADMIN_VERB(memory_profiler, R_DEBUG, "Memory Profiler", "Browse the byond_memprofile heap census: instance counts, list owners, var rows, retained size and round-over-round diffs.", ADMIN_CATEGORY_PROFILE)
	BLACKBOX_LOG_ADMIN_VERB("Memory Profiler")
	MemProfiler.ui_interact(user.mob)

ADMIN_VERB(memory_profile_census, R_DEBUG, "Memory Census (Text)", "Run a full heap census and print it to chat and world.log. Freezes the server for several seconds.", ADMIN_CATEGORY_PROFILE)
	if(!MemProfiler.enabled)
		to_chat(user, span_warning("byond_memprofile is unavailable: [MemProfiler.error || "unknown reason"]"), type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return
	if(tgui_alert(user, "A census walks the entire heap. The server will freeze for several seconds. Continue?", "Memory Census", list("Run it", "Cancel")) != "Run it")
		return
	BLACKBOX_LOG_ADMIN_VERB("Memory Census (Text)")
	var/report = MemProfiler.run_extension(user, "text census", CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(memprofile_census)))
	if(!length(report))
		to_chat(user, span_warning("Memory census returned nothing: [MemProfiler.last_error || "unknown reason"]"), type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return
	for(var/line in splittext(report, "\n"))
		SEND_TEXT(world.log, line)
	to_chat(user, fieldset_block("Memory Census", "<pre>[html_encode(report)]</pre>", "boxed_message purple_box"), avoid_highlighting = TRUE, type = MESSAGE_TYPE_DEBUG, confidential = TRUE)

ADMIN_VERB(memory_profile_dump, R_DEBUG, "Memory Profile Dump", "Stream a full census or list table to a JSON Lines file and download it. Freezes the server while it walks and writes.", ADMIN_CATEGORY_PROFILE)
	if(!MemProfiler.enabled)
		to_chat(user, span_warning("byond_memprofile is unavailable: [MemProfiler.error || "unknown reason"]"), type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return
	var/kind = tgui_alert(user, "Dump which report? A census dump is always complete; a list dump is capped unless you pick \"all\".", "Memory Profile Dump", list("Census", "Lists", "Cancel"))
	if(!kind || kind == "Cancel")
		return
	var/rows
	if(kind == "Lists")
		rows = tgui_input_list(user, "How many rows? \"all\" can run to hundreds of megabytes on a live world.", "Memory Profile Dump", MemProfiler.dump_row_options)
		if(isnull(rows))
			return
	BLACKBOX_LOG_ADMIN_VERB("Memory Profile Dump")
	if(!MemProfiler.dump_to_file(user, LOWER_TEXT(kind), rows))
		to_chat(user, span_warning("Memory profile dump failed: [MemProfiler.last_error || "unknown reason"]"), type = MESSAGE_TYPE_DEBUG, confidential = TRUE)
		return
	MemProfiler.download_dump(user, length(MemProfiler.dumps))

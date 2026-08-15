GLOBAL_REAL(MemProfiler, /datum/memprofiler)

/datum/memprofiler
	VAR_FINAL/enabled = FALSE
	VAR_FINAL/error
	/// a walk freezes the whole server, but the text verbs sit on a tgui_alert first, so
	/// two admins really can race for one.
	VAR_FINAL/capture_in_progress = FALSE
	/// why the last report died, as opposed to `error`, which is why we never started.
	VAR_FINAL/last_error

	/// grabbed once at enable(). if its "complete" is FALSE, every total is short.
	VAR_FINAL/list/coverage
	/// grabbed once at enable(). don't hardcode these, /client's size moves between builds.
	VAR_FINAL/list/base_sizes

	VAR_FINAL/list/census
	VAR_FINAL/list/lists_report
	VAR_FINAL/list/vars_report
	VAR_FINAL/list/diff_report
	VAR_FINAL/list/compat_report
	VAR_FINAL/debug_text

	/// who ran what and how long it took, keyed by kind.
	VAR_FINAL/list/report_meta
	/// files written this round, newest last.
	VAR_FINAL/list/dumps

	VAR_FINAL/baseline_at
	VAR_FINAL/baseline_by

	/// go bigger and the tgui payload chokes the browser long before the extension cares.
	VAR_FINAL/list/panel_row_options = list(100, 500, 2000)
	/// "all" only works when it's writing to a file.
	VAR_FINAL/list/dump_row_options = list(500, 5000, 25000, "all")

/datum/memprofiler/New()
	if(!isnull(MemProfiler))
		CRASH("Attempted to initialize /datum/memprofiler when global.MemProfiler is already set!")
	MemProfiler = src
	report_meta = list()
	dumps = list()
	base_sizes = list()
	enable()

/datum/memprofiler/proc/enable()
#ifndef OPENDREAM_REAL
	if(enabled)
		return TRUE
	if(!fexists(MEMPROFILE_DLL))
		error = "[MEMPROFILE_DLL] not found"
		SEND_TEXT(world.log, "Error initializing byond_memprofile: [error]")
		return FALSE

	var/init_result
	try
		init_result = memprofile_init()
	catch(var/exception/init_exception)
		error = "[init_exception]"
		SEND_TEXT(world.log, "Error initializing byond_memprofile: [error]")
		return FALSE

	if(length(init_result))
		error = init_result
		SEND_TEXT(world.log, "Error initializing byond_memprofile: [error]")
		return FALSE

	enabled = TRUE
	coverage = memprofile_coverage()
	var/list/legend = memprofile_base_sizes()
	base_sizes = legend?["ok"] ? legend["sizes"] : list()
	SEND_TEXT(world.log, "byond_memprofile initialized[islist(coverage) ? " (build [coverage["build"]])" : ""]")
	return TRUE
#else
	error = "OpenDream has no byondcore, and reading byondcore symbols is the entire trick"
	return FALSE
#endif

/datum/memprofiler/proc/unavailable_reason()
	if(!enabled)
		return error || "byond_memprofile never started up"
	if(capture_in_progress)
		return "something is already walking the heap, wait for it"
	return null

/datum/memprofiler/vv_edit_var(var_name, var_value)
	return FALSE // no.

/datum/memprofiler/CanProcCall(procname)
	return FALSE // double no.

/datum/pc_program/operating
	name = "Operating Monitor"
	icon_state = "operating"
	tgui_id = "PcOperating"

	/// Linked operating table, if any
	var/obj/structure/table/optable/table
	/// Surgery operations unlocked via disks / techweb on top of the globally unlocked ones
	var/list/advanced_surgeries = list()
	/// Techweb linked to this program
	var/datum/techweb/linked_techweb
	/// Currently selected body zone for surgery
	var/target_zone = BODY_ZONE_CHEST
	/// Experiment handler (lives on the host computer so signals sent to it keep working)
	var/datum/component/experiment_handler/experiment_handler
	/// Cached surgery list for the UI, rebuilt by refresh()
	var/list/cached_surgeries
	var/refresh_queued = FALSE

/datum/pc_program/operating/New(obj/machinery/computer/pc/host)
	. = ..()
	find_table()
	addtimer(CALLBACK(src, PROC_REF(late_setup)), 1 SECONDS)

/datum/pc_program/operating/proc/late_setup()
	if(QDELETED(computer))
		return
	if(!CONFIG_GET(flag/no_default_techweb_link) && !linked_techweb)
		CONNECT_TO_RND_SERVER_ROUNDSTART(linked_techweb, computer)
	link_techweb(linked_techweb)

	var/list/operating_signals = list(
		COMSIG_OPERATING_COMPUTER_AUTOPSY_COMPLETE = TYPE_PROC_REF(/datum/component/experiment_handler, try_run_autopsy_experiment),
	)
	experiment_handler = computer.AddComponent(
		/datum/component/experiment_handler, \
		allowed_experiments = list(/datum/experiment/autopsy), \
		config_flags = EXPERIMENT_CONFIG_ALWAYS_ACTIVE, \
		config_mode = EXPERIMENT_CONFIG_ALTCLICK, \
		experiment_signals = operating_signals, \
	)

/datum/pc_program/operating/Destroy()
	if(table && table.operating_program == src)
		table.operating_program = null
		table.computer = null
	table = null
	if(linked_techweb)
		UnregisterSignal(linked_techweb, list(COMSIG_TECHWEB_ADD_DESIGN, COMSIG_TECHWEB_REMOVE_DESIGN, COMSIG_TECHWEB_EXPERIMENT_COMPLETED))
	linked_techweb = null
	QDEL_NULL(experiment_handler)
	return ..()

/// (Re)binds to a techweb and pulls all of its researched surgeries.
/datum/pc_program/operating/proc/link_techweb(datum/techweb/new_web)
	if(linked_techweb && linked_techweb != new_web)
		UnregisterSignal(linked_techweb, list(COMSIG_TECHWEB_ADD_DESIGN, COMSIG_TECHWEB_REMOVE_DESIGN, COMSIG_TECHWEB_EXPERIMENT_COMPLETED))
	linked_techweb = new_web
	if(!linked_techweb)
		return
	RegisterSignal(linked_techweb, COMSIG_TECHWEB_ADD_DESIGN, PROC_REF(on_techweb_research), TRUE)
	RegisterSignal(linked_techweb, COMSIG_TECHWEB_REMOVE_DESIGN, PROC_REF(on_techweb_unresearch), TRUE)
	RegisterSignal(linked_techweb, COMSIG_TECHWEB_EXPERIMENT_COMPLETED, PROC_REF(refresh_batched), TRUE)
	for(var/datum/design/surgery/design in linked_techweb.get_researched_design_datums())
		advanced_surgeries |= design.surgery
	refresh_batched()

/datum/pc_program/operating/proc/find_table()
	if(!computer)
		return
	for(var/direction in GLOB.alldirs)
		var/obj/structure/table/optable/found = locate() in get_step(computer, direction)
		if(found)
			table = found
			found.computer = computer
			found.operating_program = src
			return

/datum/pc_program/operating/proc/on_techweb_research(datum/source, datum/design/surgery/design)
	SIGNAL_HANDLER
	if(!istype(design))
		return
	advanced_surgeries |= design.surgery
	refresh_batched()

/datum/pc_program/operating/proc/on_techweb_unresearch(datum/source, datum/design/surgery/design)
	SIGNAL_HANDLER
	if(!istype(design))
		return
	advanced_surgeries -= design.surgery
	refresh_batched()

/// Invalidate cached surgery data and push a UI update right now.
/datum/pc_program/operating/proc/refresh(...)
	cached_surgeries = null
	if(computer)
		SStgui.update_uis(computer)

/// Same as refresh(), but coalesces multiple calls within a tick or two.
/datum/pc_program/operating/proc/refresh_batched(...)
	SIGNAL_HANDLER
	cached_surgeries = null
	if(refresh_queued)
		return
	refresh_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(finish_batched_refresh)), 0.1 SECONDS)

/datum/pc_program/operating/proc/finish_batched_refresh()
	refresh_queued = FALSE
	refresh()

/datum/pc_program/operating/proc/build_surgeries()
	var/list/surgeries = list()
	var/mob/living/patient = table?.patient
	var/list/operations = GLOB.operations.get_instances_from(GLOB.operations.unlocked | advanced_surgeries)
	var/any_recommended = FALSE
	for(var/datum/surgery_operation/operation as anything in operations)
		var/recommend = FALSE
		if(patient && operation.show_as_next_step(patient, target_zone))
			recommend = TRUE
			any_recommended = TRUE
		surgeries += list(list(
			"name" = operation.rnd_name || operation.name,
			"desc" = operation.rnd_desc || operation.desc,
			"tool_rec" = operation.get_recommended_tool() || "error",
			"requirements" = operation.get_requirements(),
			"show_as_next" = recommend,
			"show_in_list" = TRUE,
			"priority" = !!(operation.operation_flags & OPERATION_PRIORITY_NEXT_STEP),
			"mechanic" = !!(operation.operation_flags & OPERATION_MECHANIC),
		))

	if(!any_recommended && patient && !HAS_TRAIT(patient, TRAIT_READY_TO_OPERATE))
		surgeries += list(list(
			"name" = "Prepare for surgery",
			"desc" = "Begin surgery by applying surgical drapes to the patient or by buckling the patient to the surgical table.",
			"tool_rec" = /obj/item/surgical_drapes::name,
			"show_as_next" = TRUE,
			"show_in_list" = FALSE,
		))
	return surgeries

/datum/pc_program/operating/get_ui_assets()
	return list(get_asset_datum(/datum/asset/simple/body_zones))

/datum/pc_program/operating/ui_data(mob/user)
	var/list/data = list()

	if(QDELETED(table))
		table = null
	if(!table)
		find_table()

	var/lock = get_lock_reason(user)
	data["locked"] = lock
	data["has_table"] = !!table
	data["target_zone"] = target_zone
	data["zones"] = GLOB.all_body_zones + GLOB.all_precise_body_zones
	if(lock)
		return data

	data["techwebs"] = list()
	data["experiments"] = list()
	if(linked_techweb)
		data["techwebs"] += list(list(
			"web_id" = linked_techweb.id,
			"web_org" = linked_techweb.organization,
			"ref" = REF(linked_techweb),
			"all_servers" = linked_techweb.techweb_servers,
		))
		for(var/datum/experiment/experiment as anything in linked_techweb.available_experiments)
			if(istype(experiment, /datum/experiment/autopsy))
				data["experiments"] += list(experiment.to_ui_data())

	if(!cached_surgeries)
		cached_surgeries = build_surgeries()
	data["surgeries"] = cached_surgeries

	var/mob/living/patient = table?.patient
	if(isnull(patient))
		return data

	var/list/info = list()
	if(patient.stat == DEAD)
		info["stat"] = "Dead"
		info["statstate"] = "bad"
	else if(patient.stat == HARD_CRIT || patient.stat == SOFT_CRIT)
		info["stat"] = "Critical"
		info["statstate"] = patient.stat == HARD_CRIT ? "bad" : "average"
	else if(IS_UNCONSCIOUS(patient))
		info["stat"] = "Unconscious"
		info["statstate"] = "average"
	else
		info["stat"] = "Stable"
		info["statstate"] = "good"

	info["health"] = patient.health
	info["blood_type"] = patient.get_bloodtype()?.name || "UNKNOWN"
	info["maxHealth"] = patient.maxHealth
	info["minHealth"] = patient.dead_threshold
	info["bruteLoss"] = patient.get_brute_loss()
	info["fireLoss"] = patient.get_fire_loss()
	info["toxLoss"] = patient.get_tox_loss()
	info["oxyLoss"] = patient.get_oxy_loss()
	info["blood_level"] = patient.blood_volume
	info["standard_blood_level"] = BLOOD_VOLUME_NORMAL
	info["surgery_state"] = patient.get_surgery_state_as_list(deprecise_zone(target_zone))
	data["patient"] = info
	return data

/datum/pc_program/operating/ui_act(action, list/params, datum/tgui/tgui)
	. = ..()
	var/mob/user = tgui.user
	if(get_lock_reason(user))
		return FALSE
	switch(action)
		if("open_experiments")
			experiment_handler?.ui_interact(user)
			return TRUE
		if("change_zone")
			var/new_zone = params["new_zone"]
			if(!(new_zone in (GLOB.all_body_zones + GLOB.all_precise_body_zones)))
				return FALSE
			target_zone = new_zone
			var/atom/movable/screen/zone_sel/selector = user?.hud_used?.screen_objects[HUD_MOB_ZONE_SELECTOR]
			selector?.set_selected_zone(new_zone, user, FALSE)
			refresh()
			return TRUE
	return FALSE

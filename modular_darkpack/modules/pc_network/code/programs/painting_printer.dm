#define PORTRAIT_PRINT_COOLDOWN (4 SECONDS)
#define PORTRAIT_SEARCH_MAX_LEN 64

/datum/pc_program/portrait_printer
	name = "Art Galaxy"
	icon_state = "print"
	tgui_id = "PcPortraitPrinter"
	/// The last input in the search box, reused in the UI to show whether the list is currently filtered.
	var/search_string
	/// Whether the search checks the title of the painting or the author's name.
	var/search_mode = PAINTINGS_FILTER_SEARCH_TITLE
	/// Result of the last search, null means "show everything".
	var/list/matching_paintings
	COOLDOWN_DECLARE(print_cooldown)

/datum/pc_program/portrait_printer/proc/get_printer()
	return computer.current_network?.find_printer(CANVAS_PAPER_COST)

/datum/pc_program/portrait_printer/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/portraits)
	)

/datum/pc_program/portrait_printer/ui_data(mob/user)
	var/list/data = list()
	data["paintings"] = matching_paintings || SSpersistent_paintings.painting_ui_data()
	data["search_string"] = search_string
	data["search_mode"] = search_mode == PAINTINGS_FILTER_SEARCH_TITLE ? "Title" : "Author"
	var/obj/machinery/pc_printer/printer = get_printer()
	data["can_print"] = !!printer
	data["paper"] = printer?.paper || 0
	data["paper_cost"] = CANVAS_PAPER_COST
	data["cooldown_left"] = printer ? max(0, round(COOLDOWN_TIMELEFT(printer, print_cooldown) / 10)) : 0
	return data

/datum/pc_program/portrait_printer/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	switch(action)
		if("search")
			var/raw = params["to_search"]
			var/new_search = istext(raw) ? trim(copytext_char(raw, 1, PORTRAIT_SEARCH_MAX_LEN + 1)) : null
			if(search_string != new_search)
				search_string = new_search
				generate_matching_paintings_list()
			return TRUE

		if("change_search_mode")
			search_mode = search_mode == PAINTINGS_FILTER_SEARCH_TITLE ? PAINTINGS_FILTER_SEARCH_CREATOR : PAINTINGS_FILTER_SEARCH_TITLE
			generate_matching_paintings_list()
			return TRUE

		if("print")
			print_painting(params["selected"], ui?.user)
			return TRUE

	return FALSE

/datum/pc_program/portrait_printer/proc/generate_matching_paintings_list()
	matching_paintings = null
	if(!search_string)
		return
	matching_paintings = SSpersistent_paintings.painting_ui_data(filter = search_mode, search_text = search_string)

/datum/pc_program/portrait_printer/proc/print_painting(selected_painting, mob/user)
	var/obj/machinery/pc_printer/printer = get_printer()
	if(!printer)
		to_chat(user, span_warning("Printing error: No printer found on this network."))
		return
	if(!istext(selected_painting))
		return
	var/datum/painting/chosen_portrait = locate(selected_painting) in SSpersistent_paintings.paintings
	if(!chosen_portrait)
		to_chat(user, span_notice("Printing error: That painting no longer exists."))
		return
	var/error = printer.print_painting(chosen_portrait, CANVAS_PAPER_COST)
	if(error)
		to_chat(user, span_warning("Printing error: [error]"))
		return
	to_chat(user, span_notice("You sent [chosen_portrait.title] to the printer."))

#undef PORTRAIT_PRINT_COOLDOWN
#undef PORTRAIT_SEARCH_MAX_LEN

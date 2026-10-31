/datum/pc_program/notepad
	name = "Notepad"
	icon_state = "file-alt"
	tgui_id = "PcNotepad"
	var/current_text = ""

/datum/pc_program/notepad/ui_data(mob/user)
	return list("text" = current_text)

/datum/pc_program/notepad/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(action == "save")
		current_text = params["text"]
		return TRUE
	return FALSE

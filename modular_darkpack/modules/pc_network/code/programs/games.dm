/// Base for programs whose tgui side keeps its own game state and just needs
/// somewhere to park it. state is a string with a max size of 1500 (probably could raise this but why?)
/datum/pc_program/saved_game
	abstract_type = /datum/pc_program/saved_game
	var/saved_state = ""

/datum/pc_program/saved_game/ui_data(mob/user)
	return list("saved_state" = saved_state)

/datum/pc_program/saved_game/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("save")
			saved_state = clean_text(params["state"], 1500)
			return TRUE

/datum/pc_program/saved_game/solitaire
	name = "Solitaire"
	icon_state = "heart"
	tgui_id = "PcSolitaire"

/datum/pc_program/saved_game/minesweeper
	name = "Minesweeper"
	icon_state = "broom"
	tgui_id = "PcMinesweeper"

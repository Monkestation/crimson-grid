/datum/discipline/path
	abstract_type = /datum/discipline/path
	action_type = /datum/action/discipline/path
	var/action_replaced = FALSE
	selectable = FALSE //cant buy it as a ghoul

/datum/action/discipline/path
	check_flags = NONE
	background_icon = 'modular_darkpack/modules/paths/icons/paths.dmi'
	button_icon = 'modular_darkpack/modules/paths/icons/paths.dmi'
	overlay_icon = 'modular_darkpack/modules/paths/icons/paths.dmi'
	background_icon_state = "default"
	button_icon_state = "default"
	overlay_icon_state = "default"

/datum/action/discipline/path/New(Target, datum/discipline/discipline)
	. = ..()
	button_icon = discipline.icon
	button_icon_state = discipline.icon_state

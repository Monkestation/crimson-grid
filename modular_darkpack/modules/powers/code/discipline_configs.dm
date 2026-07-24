// I'm not happy about it either, but keybinds by default load before config so I had to put it somewhere

/datum/config_entry/flag/discipline_keybinds

/datum/config_entry/flag/discipline_keybinds/ValidateAndSet(str_val)
	. = ..()

	init_normal_discipline_keybinds()

/datum/config_entry/flag/individual_power_keybinds

/datum/config_entry/flag/individual_power_keybinds/ValidateAndSet(str_val)
	. = ..()

	init_individual_power_keybinds()

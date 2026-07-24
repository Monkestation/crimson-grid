/**
 * Keybind for generically selecting which Discipline to select, used in tandem with
 * /datum/keybinding/discipline_activate to activate a power of the selected Discipline
 *
 * Enabled by the DISCIPLINE_KEYBINDS config
 */
/datum/keybinding/discipline_select
	category = CATEGORY_DISCIPLINES
	keybind_signal = COMSIG_KB_DISCIPLINE_SELECT
	/// Number (from left to right on the UI) of the Discipline to select
	var/slot

/datum/keybinding/discipline_select/proc/assign_slot(slot)
	hotkey_keys = list()
	classic_keys = list()
	src.slot = slot
	switch (slot)
		if (0)
			name = "unselect Discipline"
			full_name = "Unselect Discipline"
			description = "Unselect the Discipline you previously used keybinds to select"
		if (1)
			// Bloodheal is technically counted as a Discipline and it always takes slot 1
			name = "select Bloodheal"
			full_name = "Select Bloodheal"
		else
			name = "select Discipline [slot - 1]"
			full_name = "Select Discipline [slot - 1]"
			description = "Select your [slot - 1]\th Discipline in the order you were given them"

/datum/keybinding/discipline_select/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if (.)
		return

	var/datum/splat/vampire/vampirism = get_splat_with_discipline(user.mob)

	return vampirism?.set_selected_power(slot)

/**
 * Keybind for activating a specified level of the Discipline previously selected
 * with /datum/keybinding/discipline_select
 *
 * Enabled by the DISCIPLINE_KEYBINDS config
 */
/datum/keybinding/discipline_activate
	category = CATEGORY_DISCIPLINES
	keybind_signal = COMSIG_KB_DISCIPLINE_ACTIVATE
	/// Which level of the selected Discipline to activate
	var/level

/datum/keybinding/discipline_activate/proc/assign_level(level)
	hotkey_keys = list()
	classic_keys = list()
	src.level = level
	name = "activate Discipline level [level]"
	full_name = "Activate Discipline level [level]"
	description = "Activate the [level]\th level power of your selected Discipline"

/datum/keybinding/discipline_activate/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if (.)
		return

	var/datum/splat/vampire/vampirism = get_splat_with_discipline(user.mob)

	return vampirism?.get_selected_power()?.trigger_level(user.mob, level)

/**
 * Keybind for activating a specified Discipline power, with a keybind for every possible power
 *
 * Enabled by the INDIVIDUAL_POWER_KEYBINDS config, off by default due to keybind spam
 */
/datum/keybinding/discipline_power
	category = CATEGORY_DISCIPLINE_POWERS
	keybind_signal = COMSIG_KB_DISCIPLINE_POWER_ACTIVATE
	/// Which Discipline the power falls under
	var/datum/discipline/discipline_type
	/// Which level of the Discipline the power is
	var/level

/datum/keybinding/discipline_power/proc/assign_power(datum/discipline/discipline_type, level)
	hotkey_keys = list()
	classic_keys = list()
	src.discipline_type = discipline_type
	src.level = level
	name = "activate [discipline_type::name] [level]"
	full_name = "Activate [discipline_type::name] [level]"

/datum/keybinding/discipline_power/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if (.)
		return

	var/datum/splat/vampire/vampirism = get_splat_with_discipline(user.mob)
	if (!vampirism)
		return

	var/datum/action/discipline/discipline_action = vampirism.get_power(discipline_type)

	return discipline_action?.trigger_level(user.mob, level)

// These are called when the configs for them are set rather than on keybind init because keybind init happens before configs are loaded
/proc/init_normal_discipline_keybinds()
	if (!CONFIG_GET(flag/discipline_keybinds))
		return

	// Slot 0 is for unselecting, and Bloodheal counts as an extra Discipline
	for (var/slot in 0 to DISCIPLINE_SELECTION_KEYBINDS_AMOUNT + 1)
		var/datum/keybinding/discipline_select/selection_kb = new
		selection_kb.assign_slot(slot)
		add_keybinding(selection_kb)

	for (var/level in 1 to DISCIPLINE_ACTIVATION_KEYBINDS_AMOUNT)
		var/datum/keybinding/discipline_activate/activation_kb = new
		activation_kb.assign_level(level)
		add_keybinding(activation_kb)

/proc/init_individual_power_keybinds()
	if (!CONFIG_GET(flag/individual_power_keybinds))
		return

	for (var/discipline_type in valid_subtypesof(/datum/discipline))
		// Special case since Torpor has only one level
		if (discipline_type == /datum/discipline/torpor)
			var/datum/keybinding/discipline_power/torpor_kb = new
			torpor_kb.assign_power(discipline_type, 1)
			add_keybinding(torpor_kb)
			continue

		for (var/level in 1 to DISCIPLINE_ACTIVATION_KEYBINDS_AMOUNT)
			var/datum/keybinding/discipline_power/power_kb = new
			power_kb.assign_power(discipline_type, level)
			add_keybinding(power_kb)

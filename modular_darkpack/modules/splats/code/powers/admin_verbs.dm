ADMIN_VERB(give_power, R_FUN, "Give Power", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/power_recipient)
	var/which = tgui_alert(user, "Chose by name or by type path?", "Chose option", list("Name", "Typepath"))
	if(!which)
		return
	if(QDELETED(power_recipient))
		to_chat(user, span_warning("The intended power recipient no longer exists."))
		return

	var/list/power_list = list()
	for(var/datum/action/cooldown/power/to_add as anything in valid_subtypesof(/datum/action/cooldown/power))
		var/power_name = to_add::name
		if(which == "Name")
			power_list[power_name] = to_add
		else
			power_list += to_add

	var/chosen_power = tgui_input_list(user, "Choose the power to give to [power_recipient]", "ABRAKADABRA", sort_list(power_list))
	if(isnull(chosen_power))
		return
	var/datum/action/cooldown/power/power_path = which == "Typepath" ? chosen_power : power_list[chosen_power]
	if(!ispath(power_path))
		return

	if(QDELETED(power_recipient))
		to_chat(user, span_warning("The intended power recipient no longer exists."))
		return

	BLACKBOX_LOG_ADMIN_VERB("Give Power")
	log_admin("[key_name(user)] gave [key_name(power_recipient)] the power [chosen_power].")
	message_admins("[key_name_admin(user)] gave [key_name_admin(power_recipient)] the power [chosen_power].")

	var/datum/action/cooldown/power/new_power = new power_path(power_recipient.mind || power_recipient)

	new_power.Grant(power_recipient)

ADMIN_VERB(remove_power, R_FUN, "Remove Power", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/removal_target)
	var/list/target_power_list = list()
	for(var/datum/action/cooldown/power/power in removal_target.actions)
		target_power_list[power.name] = power

	if(!length(target_power_list))
		return

	var/chosen_power = tgui_input_list(user, "Choose the power to remove from [removal_target]", "ABRAKADABRA", sort_list(target_power_list))
	if(isnull(chosen_power))
		return
	var/datum/action/cooldown/power/to_remove = target_power_list[chosen_power]
	if(!istype(to_remove))
		return

	qdel(to_remove)
	log_admin("[key_name(user)] removed the power [chosen_power] from [key_name(removal_target)].")
	message_admins("[key_name_admin(user)] removed the power [chosen_power] from [key_name_admin(removal_target)].")
	BLACKBOX_LOG_ADMIN_VERB("Remove Power")


ADMIN_VERB(give_action, R_FUN, "Give Action", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/action_recipient)
	var/which = tgui_alert(user, "Chose by name or by type path?", "Chose option", list("Name", "Typepath"))
	if(!which)
		return
	if(QDELETED(action_recipient))
		to_chat(user, span_warning("The intended action recipient no longer exists."))
		return

	var/static/list/action_list
	if(!action_list)
		action_list = list()
		var/blacklist = valid_subtypesof(/datum/action/cooldown/power) + valid_subtypesof(/datum/action/cooldown/spell) + valid_subtypesof(/datum/action/cooldown/mob_cooldown)
		for(var/datum/action/to_add as anything in valid_subtypesof(/datum/action) - blacklist)
			var/action_name = to_add::name
			if(which == "Name")
				action_list[action_name] = to_add
			else
				action_list += to_add

	var/chosen_action = tgui_input_list(user, "Choose the action to give to [action_recipient]. Many actions wont function without further varediting.", "ABRAKADABRA", sort_list(action_list))
	if(isnull(chosen_action))
		return
	var/datum/action/action_path = which == "Typepath" ? chosen_action : action_list[chosen_action]
	if(!ispath(action_path))
		return

	if(QDELETED(action_recipient))
		to_chat(user, span_warning("The intended action recipient no longer exists."))
		return

	BLACKBOX_LOG_ADMIN_VERB("Give Action")
	log_admin("[key_name(user)] gave [key_name(action_recipient)] the action [chosen_action].")
	message_admins("[key_name_admin(user)] gave [key_name_admin(action_recipient)] the action [chosen_action].")

	var/datum/action/new_action = new action_path(action_recipient.mind || action_recipient)

	new_action.Grant(action_recipient)

ADMIN_VERB(remove_action, R_FUN, "Remove Action", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/removal_target)
	var/list/target_action_list = list()
	for(var/datum/action/action in removal_target.actions)
		target_action_list[action.name] = action

	if(!length(target_action_list))
		return

	var/chosen_action = tgui_input_list(user, "Choose the action to remove from [removal_target]", "ABRAKADABRA", sort_list(target_action_list))
	if(isnull(chosen_action))
		return
	var/datum/action/to_remove = target_action_list[chosen_action]
	if(!istype(to_remove))
		return

	qdel(to_remove)
	log_admin("[key_name(user)] removed the action [chosen_action] from [key_name(removal_target)].")
	message_admins("[key_name_admin(user)] removed the action [chosen_action] from [key_name_admin(removal_target)].")
	BLACKBOX_LOG_ADMIN_VERB("Remove Action")

ADMIN_VERB(cure_breach, R_FUN, "Cure Masquerade Breach", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/breached_player)
	var/list/breaches = list()
	for(var/list/masquerade_breach in SSmasquerade.masquerade_breachers)
		if(masquerade_breach[1] != breached_player)
			continue
		breaches += masquerade_breach[2]
	var/atom/chosen_breach_to_restore = tgui_input_list(user, "Cure Masquerade Breach", "Choose a breach source to cure", breaches)
	if(!chosen_breach_to_restore)
		return
	SEND_SIGNAL(chosen_breach_to_restore, COMSIG_MASQUERADE_REINFORCE, breached_player)

ADMIN_VERB(cure_all_breaches, R_FUN, "Cure All Masquerade Breaches", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/breached_player)
	for(var/list/masquerade_breach in SSmasquerade.masquerade_breachers)
		if(masquerade_breach[1] != breached_player)
			continue
		var/atom/masquerade_breach_source = masquerade_breach[2]
		SEND_SIGNAL(masquerade_breach_source, COMSIG_MASQUERADE_REINFORCE, breached_player)

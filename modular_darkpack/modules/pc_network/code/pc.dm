/obj/machinery/computer/pc
	name = "personal computer"
	desc = "A desktop computer."
	icon = 'modular_darkpack/modules/pc_network/icons/computer.dmi'
	icon_state = "computer"
	icon_keyboard = "computer_keyboard"
	icon_screen = "computer_screen"
	light_color = COLOR_BLUE_LIGHT
	generate_map_preview = FALSE
	var/datum/weakref/logged_account
	var/obj/item/card/credit/inserted_card
	var/list/installed_programs = list()
	var/datum/pc_network/current_network
	var/list/open_windows = list() // program type -> TRUE
	var/active_program
	var/login_name
	var/is_admin = FALSE
	/// The fallback network to return to if SchreckNet access is lost or revoked
	var/datum/pc_network/fallback_network
	var/list/hacked_networks = list()
	var/datum/pc_book_cache/book_cache
	var/hack_difficulty = 0
	var/obj/item/pc_floppy/inserted_floppy
	var/obj/item/pc_cd/inserted_cd

	var/adware_until = 0

/obj/machinery/computer/pc/unanchored
	anchored = FALSE
/obj/machinery/computer/pc/Initialize(mapload)
	. = ..()
	install_default_programs()
	if(!fallback_network)
		fallback_network = GLOB.pc_networks[PC_NETWORK_PUBLIC]
	if(!current_network)
		current_network = fallback_network
	current_network?.join(src)
	AddElement(/datum/element/drag_carry, force_two_handed = TRUE, carry_slowdown = 1.5, throw_damage = 20, do_after_time = 2 SECONDS)

/obj/machinery/computer/pc/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	balloon_alert(user, "[anchored ? "un" : ""]securing...")
	tool.play_tool_sound(src)
	if(tool.use_tool(src, user, 6 SECONDS))
		playsound(loc, 'sound/items/deconstruct.ogg', 50, vary = TRUE)
		balloon_alert(user, "[anchored ? "un" : ""]secured")
		anchored = FALSE
		return TRUE

/obj/machinery/computer/pc/Destroy()
	current_network?.leave(src)
	QDEL_LIST(installed_programs)
	if(inserted_floppy)
		inserted_floppy.forceMove(drop_location())
		inserted_floppy = null
	if(inserted_cd)
		inserted_cd.forceMove(drop_location())
		inserted_cd = null
	return ..()

/obj/machinery/computer/pc/proc/install_from_floppy(mob/user)
	if(!inserted_floppy?.program_type)
		balloon_alert(user, "disk is blank!")
		return FALSE
	var/program_type = inserted_floppy.program_type
	if(get_program(program_type))
		balloon_alert(user, "already installed!")
		return FALSE
	balloon_alert(user, "installing...")
	if(!do_after(user, 3 SECONDS, src))
		return FALSE
	if(!inserted_floppy || inserted_floppy.program_type != program_type || get_program(program_type))
		return FALSE

	var/datum/storyteller_roll/install_program/roll = new()
	roll.difficulty = inserted_floppy.install_difficulty
	var/result = roll.st_roll(user, src)
	qdel(roll)
	if(result != ROLL_SUCCESS)
		to_chat(user, span_warning("The installer chokes and the drive spits an error. Maybe try again."))
		return FALSE

	installed_programs += new program_type(src)
	balloon_alert(user, "installed")
	if(inserted_floppy.consumed_on_install)
		QDEL_NULL(inserted_floppy)
	return TRUE

/obj/machinery/computer/pc/proc/eject_floppy(mob/user)
	if(!inserted_floppy)
		return FALSE
	user.put_in_hands(inserted_floppy)
	inserted_floppy = null
	return TRUE

/obj/machinery/computer/pc/proc/get_program(datum/pc_program/program_type)
	for(var/datum/pc_program/program as anything in installed_programs)
		if(!istype(program, program_type))
			continue
		return program

/obj/machinery/computer/pc/proc/get_logged_account()
	return logged_account?.resolve()

/// Put this computer on the offline network. It can reconnect via its network switcher.
/obj/machinery/computer/pc/proc/disconnect_from_network()
	if(!current_network || current_network.id == PC_NETWORK_OFFLINE)
		return FALSE
	current_network.leave(src)
	current_network = GLOB.pc_networks[PC_NETWORK_OFFLINE]
	current_network?.join(src)
	open_windows.Cut()
	active_program = null
	return TRUE

/obj/machinery/computer/pc/proc/try_login(mob/user)
	if(!inserted_card?.registered_account)
		return FALSE

	logged_account = WEAKREF(inserted_card.registered_account)
	login_name = inserted_card.registered_account.account_holder

	// Validate network permissions immediately upon login
	if(!verify_network_access(user))
		// If login failed due to strict network lock, kick the login
		logged_account = null
		login_name = null
		return FALSE

	current_network.known_users |= login_name

	return TRUE

/obj/machinery/computer/pc/proc/hack_network(mob/living/user, network_id)
	var/datum/pc_network/player/net = GLOB.pc_networks[network_id]
	if(!istype(net)) // SchreckNet and the built-in networks can't be hacked
		return FALSE
	if(network_id in hacked_networks)
		return TRUE
	if(current_network && current_network.id != PC_NETWORK_OFFLINE)
		var/datum/storyteller_roll/hack_network/roll = new()
		roll.difficulty = net.hack_difficulty + hack_difficulty
		var/result = roll.st_roll(user, src)
		qdel(roll)
		if(result != ROLL_SUCCESS)
			net.log_event(NETWORK_LOG_HACK_FAIL, src)
			to_chat(user, span_warning("You fail to break into [net.name]."))
			return FALSE
	hacked_networks |= network_id
	return TRUE

/obj/machinery/computer/pc/multitool_act(mob/living/user, obj/item/multitool/tool)
	var/datum/pc_network/player/net = tool.buffer
	if(!istype(net))
		// Nothing usable in the buffer, so store this PC's network instead (same as the server) so we can easily connect from laptops or to pubnet.
		var/datum/pc_network/player/own_net = current_network
		if(!istype(own_net))
			balloon_alert(user, "not on a player network!")
			return ITEM_INTERACT_BLOCKING
		tool.set_buffer(own_net)
		balloon_alert(user, "network paired")
		to_chat(user, span_notice("You pair [tool] with [own_net.name]."))
		return ITEM_INTERACT_SUCCESS
	if(!hack_network(user, net.id))
		return ITEM_INTERACT_BLOCKING
	to_chat(user, span_notice("[net.name] is now available on [src]."))
	return ITEM_INTERACT_SUCCESS

/obj/item/laptop/multitool_act(mob/living/user, obj/item/multitool/tool)
	return internal_pc.multitool_act(user, tool)

/obj/machinery/computer/pc/proc/verify_network_access(mob/user)
	// If connected to SchreckNet (or any restricted network) and user lacks permissions, revert!
	if(current_network && current_network.is_restricted)
		if(!can_access_schrecknet(user))
			to_chat(user, span_warning("SchreckNet interface locked: Unauthorized user detected. Reverting to local network."))
			revert_network()
			return FALSE
	return TRUE

/obj/machinery/computer/pc/proc/revert_network()
	if(current_network == fallback_network)
		return
	current_network?.leave(src)
	current_network = fallback_network || GLOB.pc_networks[PC_NETWORK_PUBLIC]
	current_network?.join(src)

	// Close active windows on network reset for security
	open_windows.Cut()
	active_program = null

/obj/machinery/computer/pc/proc/get_formatted_address()
	var/datum/bank_account/acc = get_logged_account()
	if(acc && acc.account_holder)
		// Convert "Rusty Venture" -> "rusty_venture"
		var/formatted = LOWER_TEXT(acc.account_holder)
		formatted = replacetext(formatted, " ", "_")
		return formatted
	return login_name ? LOWER_TEXT(replacetext(login_name, " ", "_")) : "anonymous"

/obj/machinery/computer/pc/proc/can_access_schrecknet(mob/living/user)
	if(is_admin)
		return TRUE
	return user.get_clan()

/obj/machinery/computer/pc/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/pc_floppy))
		if(inserted_floppy)
			to_chat(user, span_warning("There is already a disk in the drive."))
			return
		if(!user.transferItemToLoc(I, src))
			return
		inserted_floppy = I
		balloon_alert(user, "disk inserted")
		return
	if(istype(I, /obj/item/card/credit) || istype(I, /obj/item/card/id))
		if(inserted_card)
			to_chat(user, span_warning("There is already a card in the slot."))
			return
		if(!user.transferItemToLoc(I, src))
			return
		inserted_card = I
		try_login(user)
		update_appearance()
		return
	if(istype(I, /obj/item/pc_cd))
		if(inserted_cd)
			to_chat(user, span_warning("There is already a CD in the drive."))
			return
		if(!user.transferItemToLoc(I, src))
			return
		inserted_cd = I
		balloon_alert(user, "cd inserted")
		return

	return ..()

/obj/machinery/computer/pc/proc/eject_cd(mob/user)
	if(!inserted_cd)
		return FALSE
	var/datum/pc_program/media_player/player = get_program(/datum/pc_program/media_player)
	player?.stop_playback() // the disc is leaving, so cut the audio
	user.put_in_hands(inserted_cd)
	inserted_cd = null
	return TRUE


/obj/machinery/computer/pc/proc/logout(mob/user)
	if(inserted_card)
		user.put_in_hands(inserted_card)
		inserted_card = null
		logged_account = null
		login_name = null
		update_appearance()

/obj/machinery/computer/pc/ui_status(mob/user, datum/ui_state/state)
	if(istype(loc, /obj/item/laptop))
		var/obj/item/laptop/laptop = loc
		if(!laptop.screen_on)
			return UI_CLOSE
		return state.can_use_topic(laptop, user)
	return ..()

/obj/machinery/computer/pc/ui_assets(mob/user)
	return list(get_asset_datum(/datum/asset/simple/pc_xp))

/obj/machinery/computer/pc/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	verify_network_access(user)

	if(active_program)
		for(var/datum/pc_program/P in installed_programs)
			if(P.type == active_program)
				if(hascall(P, "ui_interact"))
					P.ui_interact(user, ui)
				break

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "WindowsXP", name)
		ui.open()

/obj/machinery/computer/pc/ui_static_data(mob/user)
	var/list/data = ..() || list()
	if(active_program)
		for(var/datum/pc_program/P in installed_programs)
			if(P.type == active_program)
				var/list/prog_static = P.ui_static_data(user)
				if(islist(prog_static))
					data += prog_static
				break
	return data

/obj/machinery/computer/pc/ui_data(mob/user)
	var/list/data = list()
	data["adware"] = world.time < adware_until
	data["logged_in"] = !!get_logged_account()
	data["login_name"] = login_name
	data["network_name"] = current_network?.name
	data["network_id"] = current_network?.id
	data["is_schrecknet"] = (current_network?.id == PC_NETWORK_SCHRECKNET)
	data["floppy"] = inserted_floppy ? list(
		"name" = inserted_floppy.name,
		"program" = inserted_floppy.program_type ? initial(inserted_floppy.program_type.name) : null,
		"installed" = inserted_floppy.program_type ? !!get_program(inserted_floppy.program_type) : FALSE,
	) : null

	// Provide a list of available networks for the UI to switch between
	var/list/nets = list()
	for(var/net_id in GLOB.pc_networks)
		var/datum/pc_network/net = GLOB.pc_networks[net_id]
		if(net)
			var/allowed = TRUE
			if(net.id == PC_NETWORK_SCHRECKNET && !can_access_schrecknet(user))
				continue
			if(net.private && !(net.id in hacked_networks))
				continue
			nets += list(list(
				"id" = net.id,
				"name" = net.name,
				"allowed" = allowed
			))
	data["available_networks"] = nets

	data["programs"] = list()
	//keyed by program type data
	var/list/program_data = list()
	for(var/datum/pc_program/P in installed_programs)
		var/is_open = (P.type in open_windows)
		data["programs"] += list(list(
			"name" = P.name,
			"id" = P.type,
			"tgui_id" = P.tgui_id,
			"icon" = P.icon_state,
			"open" = is_open
		))
		if(!is_open)
			continue
		var/list/prog_data = P.ui_data(user)
		if(!islist(prog_data))
			continue
		program_data["[P.type]"] = prog_data
	data["program_data"] = program_data
	data["time"] = time_to_twelve_hour()
	return data

/obj/machinery/computer/pc/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(!verify_network_access(ui.user))
		return TRUE
	if(.)
		return
	switch(action)
		if("switch_network")
			var/target_id = params["network_id"]
			var/datum/pc_network/target_net = GLOB.pc_networks[target_id]
			if(!target_net)
				return FALSE

			// Check SchreckNet restrictions
			if(target_net.id == PC_NETWORK_SCHRECKNET && !can_access_schrecknet(ui.user))
				to_chat(ui.user, span_warning("Access denied: You lack the required affinity for SchreckNet."))
				return FALSE

			current_network?.leave(src)
			current_network = target_net
			current_network.join(src)

			open_windows.Cut()
			active_program = null
			return TRUE

		if("open_program")
			var/prog_type = text2path(params["id"])
			for(var/datum/pc_program/P in installed_programs)
				if(P.type == prog_type)
					open_windows[prog_type] = TRUE
					active_program = prog_type
					return TRUE
		if("close_program")
			var/prog_type = text2path(params["id"])
			open_windows -= prog_type
			if(active_program == prog_type)
				active_program = null
			return TRUE
		if("set_active")
			active_program = text2path(params["id"])
			return TRUE
		if("logout")
			logged_account = null
			login_name = null
			logout(usr)
			return TRUE

		if("install_floppy")
			install_from_floppy(ui.user)
			return TRUE
		if("eject_floppy")
			eject_floppy(ui.user)
			return TRUE
		if("eject_cd")
			eject_cd(ui.user)
			return TRUE

	// Route to the window the action came from, falling back to the active program.
	// Only programs that are actually open can receive actions.
	var/target_type = active_program
	if(istext(params["program"]))
		target_type = text2path(params["program"])
	if(target_type && (target_type in open_windows))
		for(var/datum/pc_program/P in installed_programs)
			if(P.type == target_type)
				return P.ui_act(action, params, ui)
	return FALSE

/obj/machinery/computer/pc/proc/infect_adware(duration)
	adware_until = max(adware_until, world.time + duration)
	SStgui.update_uis(src)
	addtimer(CALLBACK(SStgui, TYPE_PROC_REF(/datum/controller/subsystem/tgui, update_uis), src), duration + 1 SECONDS)

/obj/item/laptop
	name = "laptop computer"
	desc = "A portable computer. Still running that same ancient OS."
	icon = 'icons/obj/devices/modular_laptop.dmi'
	icon_state = "laptop-closed"
	w_class = WEIGHT_CLASS_NORMAL
	interaction_flags_mouse_drop = NEED_HANDS
	// No running around with open laptops in hands.
	item_flags = SLOWS_WHILE_IN_HAND
	drag_slowdown = 0

	var/obj/machinery/computer/pc/internal_pc
	var/screen_on = FALSE // starts closed, Initialize opens it if start_open is set
	var/start_open = TRUE
	var/icon_state_closed = "laptop-closed"
	var/icon_state_open = "laptop"
	var/icon_state_menu = "menu"
	var/w_class_open = WEIGHT_CLASS_BULKY
	var/slowdown_open = 1

/obj/item/laptop/Initialize(mapload)
	. = ..()
	internal_pc = new /obj/machinery/computer/pc(src)
	internal_pc.name = name
	register_context()
	if(start_open && !screen_on)
		toggle_open()
	AddElement(/datum/element/drag_pickup)

/obj/item/laptop/Destroy()
	QDEL_NULL(internal_pc)
	return ..()

/obj/item/laptop/examine(mob/user)
	. = ..()
	if(screen_on)
		. += span_notice("Alt-click to close it.")

/obj/item/laptop/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	if(screen_on)
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Close"
		context[SCREENTIP_CONTEXT_RMB] = "Interact"
	else
		context[SCREENTIP_CONTEXT_RMB] = "Open"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/laptop/update_icon_state()
	icon_state = screen_on ? icon_state_open : icon_state_closed
	return ..()

/obj/item/laptop/update_overlays()
	. = ..()
	if(!screen_on)
		return
	. += mutable_appearance(icon, icon_state_menu)
	. += emissive_appearance(icon, icon_state_menu, src)

/obj/item/laptop/attack_self(mob/user)
	if(!screen_on)
		try_toggle_open(user)
		return
	internal_pc.ui_interact(user)

/obj/item/laptop/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	attack_self(user)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/laptop/click_alt(mob/user)
	if(!screen_on)
		return CLICK_ACTION_BLOCKING
	try_toggle_open(user) // close it
	return CLICK_ACTION_SUCCESS

GAME_VERB_SRC(/obj/item/laptop, open_computer, view(1), "Toggle Open", null)

	try_toggle_open(usr)

/obj/item/laptop/proc/try_toggle_open(mob/living/user)
	if(issilicon(user))
		return
	if(!isturf(loc) && !ismob(loc)) // no opening it in a backpack
		return
	if(!user.can_perform_action(src))
		return
	toggle_open(user)

/obj/item/laptop/proc/toggle_open(mob/living/user = null)
	if(screen_on)
		to_chat(user, span_notice("You close \the [src]."))
		slowdown -= slowdown_open
		update_weight_class(initial(w_class))
		drag_slowdown = initial(drag_slowdown)
		SStgui.close_uis(internal_pc) // nobody keeps using a closed laptop
	else
		to_chat(user, span_notice("You open \the [src]."))
		slowdown += slowdown_open
		update_weight_class(w_class_open)
		drag_slowdown = slowdown_open

	if(isliving(loc))
		var/mob/living/localmob = loc
		localmob.update_equipment_speed_mods()
		localmob.update_pull_movespeed()

	screen_on = !screen_on
	update_appearance()

/obj/item/laptop/attackby(obj/item/I, mob/user, params)
	if(!screen_on) // can't feed disks or cards into a closed laptop
		return ..()
	return internal_pc.attackby(I, user, params)

/obj/item/laptop/multitool_act(mob/living/user, obj/item/multitool/tool)
	if(!screen_on)
		balloon_alert(user, "open it first!")
		return ITEM_INTERACT_BLOCKING
	return internal_pc.multitool_act(user, tool)

/// Closed on spawn.
/obj/item/laptop/closed
	start_open = FALSE

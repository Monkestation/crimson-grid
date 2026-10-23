/obj/item/flatpack/pc_server
	name = "home server"
	machine_path = /obj/machinery/pc_server

/obj/machinery/pc_server
	name = "network server"
	desc = "A rack-mounted server. Tune it to a network, or start a new one. A multitool can pair to its network."
	icon = 'modular_darkpack/modules/pc_network/icons/racks.dmi'
	icon_state = "rack_2"
	density = TRUE
	anchored = TRUE
	SET_BASE_VISUAL_PIXEL(0, 4)
	var/datum/pc_network/player/network
	/// Hack difficulty this server adds to its network, set by the Computers skill of whoever tuned it
	var/hack_contribution = 0

/obj/machinery/pc_server/examine(mob/user)
	. = ..()
	if(network)
		. += span_notice("It is tuned to [network.name] ([length(network.servers)] server\s).")
		if(network.private)
			. += span_notice("The network is private.")
		if(network.is_restricted)
			. += span_notice("The network is restricted.")
	else
		. += span_notice("It is not tuned to any network.")

/obj/machinery/pc_server/Destroy()
	detune()
	return ..()

/obj/machinery/pc_server/update_overlays()
	. = ..()
	if(network)
		. += emissive_appearance(icon, "rack_2_emissive", src)
		. += mutable_appearance(icon, "rack_2_on", src)

/obj/machinery/pc_server/proc/tune(datum/pc_network/player/new_network, mob/living/tuner)
	// 5 + Computers
	hack_contribution = clamp(5 + (tuner ? tuner.st_get_stat(STAT_COMPUTER) : 0), 6, 10)
	if(network == new_network)
		network.recalculate_difficulty()
		return
	detune()
	network = new_network
	network.add_server(src)
	update_appearance()
	set_light(1, 2, COLOR_FIRE_LIGHT_RED)

/obj/machinery/pc_server/proc/detune()
	var/datum/pc_network/player/old = network
	network = null
	hack_contribution = 0
	old?.remove_server(src)
	update_appearance()
	set_light(0, 0, COLOR_FIRE_LIGHT_RED)

/// Tunes to an existing network. Private or restricted networks need a Computers roll first.
/obj/machinery/pc_server/proc/try_tune(mob/living/user, datum/pc_network/player/target)
	if(target != network && (target.private || target.is_restricted))
		var/datum/storyteller_roll/hack_network/roll = new()
		roll.difficulty = target.hack_difficulty
		var/result = roll.st_roll(user, src) // can sleep
		qdel(roll)
		if(QDELETED(target) || !user.Adjacent(src))
			return FALSE
		if(result != ROLL_SUCCESS)
			to_chat(user, span_warning("You fail to break into [target.name]."))
			return FALSE
	tune(target, user)
	to_chat(user, span_notice("You tune the server to [target.name]."))
	return TRUE

/obj/machinery/pc_server/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	var/list/options = list()
	if(network)
		options += list("Toggle private", "Toggle restricted", "Detune")
	options += list("Create network", "Tune to network")
	var/choice = tgui_input_list(user, "Server options", name, options)
	if(!choice || !user.Adjacent(src))
		return

	switch(choice)
		if("Create network")
			var/new_name = sanitize(tgui_input_text(user, "Name the new network.", "Create network", max_length = 32))
			if(!new_name || !user.Adjacent(src))
				return
			for(var/net_id in GLOB.pc_networks)
				var/datum/pc_network/existing = GLOB.pc_networks[net_id]
				if(existing && lowertext(existing.name) == lowertext(new_name))
					to_chat(user, span_warning("A network with that name already exists."))
					return
			tune(new /datum/pc_network/player(new_name), user)
			to_chat(user, span_notice("You create the network [new_name] and tune the server to it."))

		if("Tune to network")
			var/list/choices = list()
			for(var/net_id in GLOB.pc_networks)
				var/datum/pc_network/player/net = GLOB.pc_networks[net_id]
				if(istype(net))
					choices[net.name] = net
			if(!length(choices))
				to_chat(user, span_warning("There are no player networks to tune to."))
				return
			var/picked = tgui_input_list(user, "Pick a network.", "Tune to network", choices)
			if(!picked || !user.Adjacent(src))
				return
			var/datum/pc_network/player/target = choices[picked]
			if(QDELETED(target))
				return
			try_tune(user, target)

		if("Toggle private")
			if(!network)
				return
			network.private = !network.private
			to_chat(user, span_notice("[network.name] is now [network.private ? "private" : "public"]."))

		if("Toggle restricted")
			if(!network)
				return
			network.is_restricted = !network.is_restricted
			to_chat(user, span_notice("[network.name] is now [network.is_restricted ? "restricted" : "unrestricted"]."))

		if("Detune")
			var/net_name = network?.name
			detune()
			to_chat(user, span_notice("You detune the server from [net_name]."))

/// Pairs the multitool with this server's network. The multitool's buffer then holds the network.
/obj/machinery/pc_server/multitool_act(mob/living/user, obj/item/multitool/tool)
	if(!network)
		balloon_alert(user, "not tuned to a network!")
		return ITEM_INTERACT_BLOCKING
	tool.set_buffer(network)
	balloon_alert(user, "network paired")
	to_chat(user, span_notice("You pair [tool] with [network.name]."))
	return ITEM_INTERACT_SUCCESS

/proc/find_pc_network_by_name(net_name)
	if(!istext(net_name))
		return null
	var/lowered = lowertext(net_name)
	for(var/net_id in GLOB.pc_networks)
		var/datum/pc_network/player/net = GLOB.pc_networks[net_id]
		if(istype(net) && lowertext(net.name) == lowered)
			return net
	return null

/proc/get_or_create_player_network(net_name)
	if(!istext(net_name) || !length(net_name))
		return null
	return find_pc_network_by_name(net_name) || new /datum/pc_network/player(net_name)

/obj/machinery/pc_server/mapped
	/// Name of the network to tune to on mapload. If null the server is just left untuned.
	var/mapped_network_name
	var/mapped_private
	var/mapped_restricted
	/// If set, this server's hack_contribution is forced to this value (1-10) instead of 5 + the tuner's Computers
	var/mapped_hack_difficulty

/obj/machinery/pc_server/mapped/Initialize(mapload)
	. = ..()
	if(mapload)
		return INITIALIZE_HINT_LATELOAD

/obj/machinery/pc_server/mapped/post_machine_initialize()
	. = ..()
	if(!mapped_network_name || network)
		return

	// A mapped networked device may have already made the network.
	var/datum/pc_network/player/net = get_or_create_player_network(mapped_network_name)
	if(!isnull(mapped_private))
		net.private = mapped_private
	if(!isnull(mapped_restricted))
		net.is_restricted = mapped_restricted

	tune(net, null)

/// Applies the mapped hack difficulty after the normal Computers-based calculation.
/obj/machinery/pc_server/mapped/tune(datum/pc_network/player/new_network, mob/living/tuner)
	. = ..()
	if(isnull(mapped_hack_difficulty) || !network)
		return
	hack_contribution = mapped_hack_difficulty
	network.recalculate_difficulty()

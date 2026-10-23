/obj/effect/mapping_helpers/pc
	abstract_type = /obj/effect/mapping_helpers/pc
	layer = DOOR_HELPER_LAYER
	// Late, so the pc has finished Initialize and joined its default network
	late = TRUE
	// TODO: new sprites
	icon = 'modular_darkpack/modules/doors/icons/mapping_helpers.dmi'
	icon_state = "locklevel_easy"

/obj/effect/mapping_helpers/pc/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return

/obj/effect/mapping_helpers/pc/LateInitialize()
	var/obj/machinery/computer/pc/pc
	for(var/atom/movable/thing in loc)
		if(istype(thing, /obj/machinery/computer/pc))
			pc = thing
			break
		if(istype(thing, /obj/item/laptop))
			var/obj/item/laptop/laptop = thing
			pc = laptop.internal_pc
			break
	if(!pc)
		log_mapping("[src] failed to find a pc at [AREACOORD(src)]")
		qdel(src)
		return

	payload(pc)
	qdel(src)

/obj/effect/mapping_helpers/pc/proc/payload(obj/machinery/computer/pc/payload)
	return

/// Puts the pc on a network. If network_id is an existing id (PC_NETWORK_SCHRECKNET, PC_NETWORK_OFFLINE, ...) it joins that.
/// Otherwise a player network with that name is created if it doesn't exist yet, and the pc joins it.
/// Use the same value as the pc_server network_name helper to share a network with mapped servers.
/obj/effect/mapping_helpers/pc/network_id
	name = "pc network id helper"
	network_id = PC_NETWORK_PUBLIC

/obj/effect/mapping_helpers/pc/network_id/payload(obj/machinery/computer/pc/payload)
	var/datum/pc_network/net
	if(network_id != PC_NETWORK_OFFLINE)
		net = GLOB.pc_networks[network_id] || get_or_create_player_network(network_id)
		if(!net)
			log_mapping("[src] failed to find or create network [network_id] at [AREACOORD(src)]")
			return
	if(net == payload.current_network)
		return

	payload.current_network?.leave(payload)
	payload.current_network = net
	net?.join(payload)
	if(istype(net, /datum/pc_network/player))
		payload.hacked_networks |= net.id

/obj/effect/mapping_helpers/pc/network_auth
	name = "pc auth helper"
	var/hack_difficulty = 0

/obj/effect/mapping_helpers/pc/network_auth/payload(obj/machinery/computer/pc/payload)
	payload.hack_difficulty = hack_difficulty

/obj/effect/mapping_helpers/pc/network_id/endron
	network_id = PC_NETWORK_ENDRON

/obj/effect/mapping_helpers/pc/network_id/bianchi
	network_id = PC_NETWORK_BIANCHI_BANK

/obj/effect/mapping_helpers/networked
	abstract_type = /obj/effect/mapping_helpers/networked
	layer = DOOR_HELPER_LAYER
	late = TRUE
	// TODO: new sprites
	icon = 'modular_darkpack/modules/doors/icons/mapping_helpers.dmi'
	icon_state = "locklevel_easy"

/obj/effect/mapping_helpers/networked/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return

/obj/effect/mapping_helpers/networked/LateInitialize()
	var/datum/component/networked/networked
	for(var/atom/movable/thing in loc)
		networked = thing.GetComponent(/datum/component/networked)
		if(networked)
			break
	if(!networked)
		log_mapping("[src] failed to find a networked device at [AREACOORD(src)]")
		qdel(src)
		return

	payload(networked)
	qdel(src)

/obj/effect/mapping_helpers/networked/proc/payload(datum/component/networked/payload)
	return

/// Puts the device on a network. If network_id is an existing id (PC_NETWORK_SCHRECKNET, PC_NETWORK_OFFLINE, ...) it joins that.
/// Otherwise a player network with that name is created if it doesn't exist yet, and the device joins it.
/// Use the same value as the pc_server network_name helper to share a network with mapped servers.
/obj/effect/mapping_helpers/networked/network_id
	name = "networked device network id helper"
	network_id = PC_NETWORK_PUBLIC

/obj/effect/mapping_helpers/networked/network_id/payload(datum/component/networked/payload)
	var/result
	if(GLOB.pc_networks[network_id] || network_id == PC_NETWORK_OFFLINE)
		result = payload.set_network(network_id, TRUE)
	else
		result = payload.set_network_by_name(network_id, TRUE)
	if(!result)
		log_mapping("[src] failed to set network [network_id] at [AREACOORD(src)]")

/// Sets how hard this device is to hack onto or off of a network (the component's hack_difficulty, added to the network's).
/obj/effect/mapping_helpers/networked/network_auth
	name = "networked device auth helper"
	var/hack_difficulty = 0

/obj/effect/mapping_helpers/networked/network_auth/payload(datum/component/networked/payload)
	payload.hack_difficulty = hack_difficulty

/obj/effect/mapping_helpers/networked/network_id/endron
	network_id = PC_NETWORK_ENDRON

/obj/effect/mapping_helpers/networked/network_id/bianchi
	network_id = PC_NETWORK_BIANCHI_BANK

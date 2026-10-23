/obj/effect/mapping_helpers/pc_server
	abstract_type = /obj/effect/mapping_helpers/pc_server
	layer = DOOR_HELPER_LAYER
	// TODO: new sprites
	icon = 'modular_darkpack/modules/doors/icons/mapping_helpers.dmi'
	icon_state = "locklevel_easy"

/obj/effect/mapping_helpers/pc_server/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return

	var/obj/machinery/pc_server/mapped/server = locate(/obj/machinery/pc_server/mapped) in loc
	if(!server)
		log_mapping("[src] failed to find a mapped pc_server at [AREACOORD(src)]")
		return

	payload(server)

/obj/effect/mapping_helpers/pc_server/proc/payload(obj/machinery/pc_server/mapped/payload)
	return

/// Sets the network the server tunes to. Servers with the same name share a network. Set network_name per instance in the map.
/obj/effect/mapping_helpers/pc_server/network_name
	name = "pc server network name helper"
	var/network_name = "Mapped Network"

/obj/effect/mapping_helpers/pc_server/network_name/payload(obj/machinery/pc_server/mapped/payload)
	payload.mapped_network_name = network_name

/obj/effect/mapping_helpers/pc_server/private
	name = "pc server private network helper"

/obj/effect/mapping_helpers/pc_server/private/payload(obj/machinery/pc_server/mapped/payload)
	payload.mapped_private = TRUE

/obj/effect/mapping_helpers/pc_server/restricted
	name = "pc server restricted network helper"

/obj/effect/mapping_helpers/pc_server/restricted/payload(obj/machinery/pc_server/mapped/payload)
	payload.mapped_restricted = TRUE

/obj/effect/mapping_helpers/pc_server/hack_difficulty
	name = "pc server hack difficulty helper"
	icon_state = "locklevel_easy"
	var/hack_difficulty = 6

/obj/effect/mapping_helpers/pc_server/hack_difficulty/payload(obj/machinery/pc_server/mapped/payload)
	payload.mapped_hack_difficulty = clamp(hack_difficulty, 1, 10)

/obj/effect/mapping_helpers/pc_server/hack_difficulty/two
	icon_state = "locklevel_trivial"
	hack_difficulty = 2

/obj/effect/mapping_helpers/pc_server/hack_difficulty/three
	icon_state = "locklevel_trivial"
	hack_difficulty = 3

/obj/effect/mapping_helpers/pc_server/hack_difficulty/four
	icon_state = "locklevel_trivial"
	hack_difficulty = 4

/obj/effect/mapping_helpers/pc_server/hack_difficulty/five
	icon_state = "locklevel_trivial"
	hack_difficulty = 5

/obj/effect/mapping_helpers/pc_server/hack_difficulty/six
	icon_state = "locklevel_easy"
	hack_difficulty = 6

/obj/effect/mapping_helpers/pc_server/hack_difficulty/seven
	icon_state = "locklevel_medium"
	hack_difficulty = 7

/obj/effect/mapping_helpers/pc_server/hack_difficulty/eight
	icon_state = "locklevel_hard"
	hack_difficulty = 8

/obj/effect/mapping_helpers/pc_server/hack_difficulty/nine
	icon_state = "locklevel_harder"
	hack_difficulty = 9

/obj/effect/mapping_helpers/pc_server/hack_difficulty/ten
	icon_state = "locklevel_hardest"
	hack_difficulty = 10

/obj/effect/mapping_helpers/pc_server/network_name/endron
	network_name = PC_NETWORK_ENDRON

/obj/effect/mapping_helpers/pc_server/network_name/bianchi
	network_name = PC_NETWORK_BIANCHI_BANK

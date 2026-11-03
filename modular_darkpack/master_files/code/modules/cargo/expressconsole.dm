/obj/machinery/computer/cargo/express
	req_access = list()
	locked = TRUE
	landingzone = /area/vtm/outside/supply

/obj/machinery/computer/cargo/express/Initialize(mapload)
	. = ..()
	for(var/obj/item/supplypod_beacon/beacon in range(20, src))
		beacon.link_console(src)

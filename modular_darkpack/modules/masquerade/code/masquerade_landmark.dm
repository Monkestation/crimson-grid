/obj/effect/landmark/latejoin_masquerade
	name = "JoinLate"

/obj/effect/landmark/latejoin_masquerade/Initialize(mapload)
	. = ..()

	REGISTER_REQUIRED_MAP_ITEM(1, INFINITY)
	GLOB.masquerade_latejoin += src

/obj/effect/landmark/latejoin_masquerade/Destroy()
	. = ..()

	GLOB.masquerade_latejoin -= src

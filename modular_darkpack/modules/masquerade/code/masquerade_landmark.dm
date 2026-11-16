/obj/effect/landmark/latejoin_masquerade
	name = "JoinLate Masquerade"

/obj/effect/landmark/latejoin_masquerade/Initialize(mapload)
	REGISTER_REQUIRED_MAP_ITEM(1, INFINITY)

	..()

	GLOB.masquerade_latejoin += loc
	return INITIALIZE_HINT_QDEL


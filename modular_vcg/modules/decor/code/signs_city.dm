/obj/structure/sign/city/crown_blue
	name = "Crown Blue sign"
	desc = "It says Crown Blue. It looks fancy."
	icon = 'modular_vcg/modules/decor/icons/crown_blues_sign.dmi'
	icon_state = "crownblues"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	pixel_w = -8
	//pixel_z = 0

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/crown_blue, 32)
/obj/structure/sign/city/crown_blue/Initialize(mapload)
	. = ..()
	set_light(3, 2, "#4d60b6")

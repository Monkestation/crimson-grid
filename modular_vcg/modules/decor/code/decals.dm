// Road paint lines:
/obj/effect/turf_decal/asphaltline/yellow
	icon = 'modular_vcg/modules/decor/icons/decals.dmi'
	icon_state = "line_yellow"

/obj/effect/turf_decal/asphaltline/alt/white
	icon = 'modular_vcg/modules/decor/icons/decals.dmi'
	icon_state = "line_alt_white"

/obj/effect/turf_decal/asphaltline/arrow
	icon = 'modular_vcg/modules/decor/icons/decals.dmi'
	icon_state = "arrow"

/obj/effect/turf_decal/asphaltline/arrow/left
	icon_state = "arrow_l"

/obj/effect/turf_decal/asphaltline/arrow/right
	icon_state = "arrow_r"

/obj/effect/turf_decal/asphaltline/stop
	icon = 'modular_vcg/modules/decor/icons/decals.dmi'
	icon_state = "stop"

/obj/effect/turf_decal/asphaltline/ped
	icon = 'modular_vcg/modules/decor/icons/decals.dmi'
	icon_state = "ped"

/obj/effect/turf_decal/asphaltline/xing
	icon = 'modular_vcg/modules/decor/icons/decals.dmi'
	icon_state = "xing"

/obj/effect/decal/roof
	name = "roof"
	icon = 'modular_vcg/modules/decor/icons/decals.dmi'
	icon_state = "roof"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/decal/roof/NeverShouldHaveComeHere(turf/here_turf)
	return FALSE

/obj/effect/decal/roof/red
	icon_state = "roof_red"

/obj/effect/decal/roof/blue
	icon_state = "roof_blue"

/obj/effect/decal/roof/gray
	icon_state = "roof_gray"

/obj/effect/decal/roof/small
	icon_state = "smallroof"

/obj/effect/decal/roof/small/red
	icon_state = "smallroof_red"

/obj/effect/decal/roof/small/blue
	icon_state = "smallroof_blue"

/obj/effect/decal/roof/small/gray
	icon_state = "smallroof_gray"

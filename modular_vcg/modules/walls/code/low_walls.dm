// ehhh... for now.

// Put here to allow downstreams to add subtypes.
#define LOW_WALL_HELPER_CRIMSON(wall_type, wall_icon)	\
	/obj/structure/platform/lowwall/##wall_type {	\
		icon = ##wall_icon; \
	}	\
	/obj/structure/platform/lowwall/##wall_type/window {			\
		window = /obj/structure/window/fulltile;		\
		WHEN_MAP(icon = 'modular_vcg/modules/walls/icons/lowwalls.dmi'); \
		WHEN_MAP(icon_state = "window_spawner"); 		\
	}	\
	/obj/structure/platform/lowwall/##wall_type/window/reinforced { \
		window = /obj/structure/window/reinforced/fulltile; \
	}


/obj/structure/platform/lowwall
	icon = 'modular_vcg/modules/walls/icons/lowwalls.dmi'
	icon_state = "wall-0"


LOW_WALL_HELPER_CRIMSON(rich, 'icons/obj/smooth_structures/darkpack/crimson_grid/wall/rich/low_wall.dmi')

LOW_WALL_HELPER_CRIMSON(rich/old, 'icons/obj/smooth_structures/darkpack/crimson_grid/wall/rich_old/low_wall.dmi')

//LOW_WALL_HELPER_CRIMSON(brick_old, 'icons/obj/smooth_structures/darkpack/crimson_grid/wall/brick_old/low_wall.dmi')

//LOW_WALL_HELPER_CRIMSON(junk, 'icons/obj/smooth_structures/darkpack/crimson_grid/wall/junk/low_wall.dmi')

//LOW_WALL_HELPER_CRIMSON(junk/alt, 'icons/obj/smooth_structures/darkpack/crimson_grid/wall/junk_alt/low_wall.dmi')

//LOW_WALL_HELPER_CRIMSON(market, 'icons/obj/smooth_structures/darkpack/crimson_grid/wall/market/low_wall.dmi')

//LOW_WALL_HELPER_CRIMSON(old, 'icons/obj/smooth_structures/darkpack/crimson_grid/wall/old/low_wall.dmi')

//LOW_WALL_HELPER_CRIMSON(painted, 'icons/obj/smooth_structures/darkpack/crimson_grid/wall/painted/low_wall.dmi')

LOW_WALL_HELPER_CRIMSON(brick, 'icons/obj/smooth_structures/darkpack/crimson_grid/wall/brick/low_wall.dmi')

//LOW_WALL_HELPER_CRIMSON(city, 'icons/obj/smooth_structures/darkpack/crimson_grid/wall/city/low_wall.dmi')

LOW_WALL_HELPER_CRIMSON(bar, 'icons/obj/smooth_structures/darkpack/crimson_grid/wall/bar/low_wall.dmi')

//LOW_WALL_HELPER_CRIMSON(wood, 'icons/obj/smooth_structures/darkpack/crimson_grid/wall/wood/low_wall.dmi')


/obj/structure/platform/lowwall
	name = "low wall"
	desc = "It's a lot like a wall, but lower."
	icon = 'modular_darkpack/modules/walls/icons/lowwalls.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	abstract_type = /obj/structure/platform/lowwall
	max_integrity = 350
	smoothing_groups = SMOOTH_GROUP_CITY_LOW_WALL
	canSmoothWith = SMOOTH_GROUP_CITY_LOW_WALL
	var/window

/obj/structure/platform/lowwall/Initialize(mapload)
	. = ..()
	if(window)
		new window(loc)

LOW_WALL_HELPER(rich, 'icons/obj/smooth_structures/darkpack/wall/rich/low_wall.dmi')

LOW_WALL_HELPER(rich/old, 'icons/obj/smooth_structures/darkpack/wall/rich_old/low_wall.dmi')

LOW_WALL_HELPER(brick_old, 'icons/obj/smooth_structures/darkpack/wall/brick_old/low_wall.dmi')

LOW_WALL_HELPER(junk, 'icons/obj/smooth_structures/darkpack/wall/junk/low_wall.dmi')

LOW_WALL_HELPER(junk/alt, 'icons/obj/smooth_structures/darkpack/wall/junk_alt/low_wall.dmi')

LOW_WALL_HELPER(market, 'icons/obj/smooth_structures/darkpack/wall/market/low_wall.dmi')

LOW_WALL_HELPER(old, 'icons/obj/smooth_structures/darkpack/wall/old/low_wall.dmi')

LOW_WALL_HELPER(painted, 'icons/obj/smooth_structures/darkpack/wall/painted/low_wall.dmi')

LOW_WALL_HELPER(brick, 'icons/obj/smooth_structures/darkpack/wall/brick/low_wall.dmi')

LOW_WALL_HELPER(city, 'icons/obj/smooth_structures/darkpack/wall/city/low_wall.dmi')

LOW_WALL_HELPER(bar, 'icons/obj/smooth_structures/darkpack/wall/bar/low_wall.dmi')

LOW_WALL_HELPER(wood, 'icons/obj/smooth_structures/darkpack/wall/wood/low_wall.dmi')


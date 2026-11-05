
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

// CRIMSON GRID EDIT START
// Fixable windows.

/obj/structure/platform/lowwall/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stack/sheet/glass))
		return try_repair(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING
	return NONE

/obj/structure/platform/lowwall/proc/try_repair(mob/living/user,obj/item/stack/tool)
	if(!window) return
	for(var/obj/structure/window/potential_window in get_turf(src)) //This is mostly redundant as its in theory impossible to click a frame with a window on, but you never know
		if(potential_window)
			to_chat(user, span_warning("This frame already seems to have a window."))
			return FALSE
	if(tool.tool_use_check(user, 2))
		playsound(src, 'sound/items/tools/ratchet.ogg', 50)
		if(do_after(user, 2 SECONDS, src, interaction_key = "doafter_window"))
			for(var/obj/structure/window/potential_window in get_turf(src)) //Repeating to filter edge cases where someone repairs window while we're reparing it ourselves
				if(potential_window)
					return FALSE
			if(tool.use(2))
				playsound(src, 'sound/items/deconstruct.ogg', 50)
				new window(get_turf(src))
				return TRUE
// CRIMSON GRID EDIT END

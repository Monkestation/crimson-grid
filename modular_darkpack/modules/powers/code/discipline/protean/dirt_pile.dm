/obj/effect/decal/dirt_pile // Should only be used for Earth Meld!
	name = "disturbed earth"
	icon = 'modular_darkpack/modules/powers/icons/dirt_pile.dmi'
	icon_state = "dirt_pile"
	alpha = 64
	var/expiring = FALSE

/obj/effect/decal/dirt_pile/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.tool_behaviour == TOOL_SHOVEL)
		to_chat(user,"You begin to dig up the disturbed earth.")
		if(!tool.use_tool(src, user, 2 SECONDS))
			return ITEM_INTERACT_BLOCKING
		expiring = TRUE
		for(var/mob/living/L in contents)
			to_chat(L, span_warning("Your resting place is disturbed by [user]!"))
			L.forceMove(get_turf(loc))
			L.Knockdown(3 SECONDS) // Get-up lag for anyone hiding in here
			L.SetStun(0) // End the hider's stun to allow them to crawl
		remove_dirt_pile()
		return ITEM_INTERACT_SUCCESS

/obj/effect/decal/dirt_pile/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/effect/decal/dirt_pile/update_overlays()
	. = ..()
	var/turf/my_turf = get_turf(src)
	var/mutable_appearance/mask = new(my_turf.appearance)
	mask.blend_mode = BLEND_MULTIPLY
	. += mask

/obj/effect/decal/dirt_pile/proc/remove_dirt_pile()
	animate(src, alpha = 0, time = 1 SECONDS) // Fade out
	spawn(3 SECONDS)
		qdel(src)


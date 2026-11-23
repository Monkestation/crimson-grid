/obj/item/stack/sheet/meat/examine(mob/user)
	. = ..()
	var/mob/living/living_user = astype(user)
	if(living_user?.get_discipline(/datum/discipline/vicissitude))
		. += span_notice("You can build a flesh wall by right clicking on an empty floor.")

// You can build the fleshwall with right click, if you are Tzi
/obj/item/stack/sheet/meat/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isopenturf(interacting_with))
		return NONE
	var/mob/living/living_user = astype(user)
	if(living_user?.get_discipline(/datum/discipline/vicissitude))
		user.balloon_alert(user, "no clue, what to do with that!")
		return ITEM_INTERACT_BLOCKING
	var/turf/open/build_on = interacting_with
	if(!user.Adjacent(build_on))
		return ITEM_INTERACT_BLOCKING
	if(isgroundlessturf(build_on))
		user.balloon_alert(user, "can't place it here!")
		return ITEM_INTERACT_BLOCKING
	if(build_on.is_blocked_turf())
		user.balloon_alert(user, "something is blocking the tile!")
		return ITEM_INTERACT_BLOCKING

	var/frame_path = null
	var/cost = 2 // Default flesh wall cost
	var/time = 4 SECONDS // build time
	var/obj/item/circuitboard/held_board = user.is_holding_item_of_type(__IMPLIED_TYPE__)
	if(!isnull(held_board))
		if(istype(held_board, /obj/item/circuitboard/machine))
			frame_path = /obj/structure/frame/machine
		else
			frame_path = /obj/structure/frame/computer
		for(var/datum/stack_recipe/recipe in GLOB.metal_recipes)
			if(recipe.result_type == frame_path)
				time = recipe.time
				cost = recipe.req_amount
				break
	if(get_amount() < cost)
		user.balloon_alert(user, "need [cost] metal sheets!")
		return ITEM_INTERACT_BLOCKING
	if(!do_after(user, time, build_on))
		return ITEM_INTERACT_BLOCKING
	if(build_on.is_blocked_turf())
		user.balloon_alert(user, "something is blocking the tile!")
		return ITEM_INTERACT_BLOCKING
	if(!use(cost))
		user.balloon_alert(user, "not enough material!")
		return ITEM_INTERACT_BLOCKING
	if(frame_path)
		var/obj/structure/frame/constructed_frame = new frame_path(build_on)
		constructed_frame.setDir(REVERSE_DIR(user.dir)) //to align computer frame with player direction
		user.balloon_alert(user, "frame created")
	else
		new/obj/structure/girder/displaced(build_on)
		user.balloon_alert(user, "girder created")
	return ITEM_INTERACT_SUCCESS

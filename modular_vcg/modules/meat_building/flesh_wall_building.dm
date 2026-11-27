// only Tzi can examine and get info about flesh wall building
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
	if(!living_user?.get_discipline(/datum/discipline/vicissitude))
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

	var/cost = 2 // Default flesh wall cost
	var/time = 4 SECONDS // build time
	if(get_amount() < cost)
		user.balloon_alert(user, "need [cost] meat!")
		return ITEM_INTERACT_BLOCKING
	if(!do_after(user, time, build_on))
		return ITEM_INTERACT_BLOCKING
	if(build_on.is_blocked_turf())
		user.balloon_alert(user, "something is blocking the tile!")
		return ITEM_INTERACT_BLOCKING
	if(!use(cost))
		user.balloon_alert(user, "not enough material!")
		return ITEM_INTERACT_BLOCKING
	new/obj/structure/fleshwall(build_on)
	user.balloon_alert(user, "flesh wall created")
	return ITEM_INTERACT_SUCCESS

/obj/item/bong
	name = "bong"
	desc = "Technically known as a water pipe."
	icon = 'modular_darkpack/modules/drugs/icons/items.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/drugs/icons/onfloor.dmi')
	icon_state = "bulbulator"

	light_range = 1
	light_color = LIGHT_COLOR_FIRE
	light_system = OVERLAY_LIGHT
	light_on = FALSE

	///The icon state when the bong is lit
	var/icon_on = "bulbulator"
	///The icon state when the bong is not lit
	var/icon_off = "bulbulator"
	///Whether the bong is lit or not
	var/lit = FALSE
	///How many hits can the bong be used for?
	var/max_hits = 4
	///How many uses does the bong have remaining?
	var/bong_hits = 0
	///How likely is it we moan instead of cough?
	var/moan_chance = 0

	///Max units able to be stored inside the bong
	var/chem_volume = 100
	///Is it filled?
	var/packeditem = FALSE
	var/obj/item/packed_object // CRIMSON EDIT ADD - Drug Fixes

	///How many reagents do we transfer each use?
	var/reagent_transfer_per_use = 0
	///How far does the smoke reach per use?
	var/smoke_range = 2

/obj/item/bong/Initialize(mapload)
	. = ..()
	create_reagents(chem_volume, INJECTABLE | NO_REACT)

// CRIMSON EDIT ADD START - Drug Fixes
/obj/item/bong/examine(mob/user)
	. = ..()
	if(!packeditem)
		. += span_notice("It is empty.")
		return
	var/datum/reagent/drug/cannabis/strain
	if(reagents)
		strain = locate() in reagents.reagent_list
	if(strain?.strain_name)
		. += span_notice("It is packed with [strain.strain_name] cannabis. [bong_hits] hit\s remain.")
		return
	. += span_notice("It is packed with \a [packeditem]. [bong_hits] hit\s remain.")
// CRIMSON EDIT ADD END - Drug Fixes

/obj/item/bong/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if((istype(tool, /obj/item/food/grown) || istype(tool, /obj/item/food/drug)))
		if(packeditem)
			to_chat(user, span_warning("It is already packed!"))
			return ITEM_INTERACT_BLOCKING

		/* // CRIMSON EDIT REMOVAL START - Drug Fixes
		if(istype(tool, /obj/item/food/grown) && !HAS_TRAIT(tool, TRAIT_DRIED))
			to_chat(user, span_warning("It has to be dried first!"))
			return ITEM_INTERACT_BLOCKING
		*/ // CRIMSON EDIT REMOVAL END - Drug Fixes

		// CRIMSON EDIT ADD START - Drug Fixes
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		packed_object = tool
		// CRIMSON EDIT ADD END - Drug Fixes
		to_chat(user, span_notice("You stuff [tool] into [src]."))
		bong_hits = max_hits
		packeditem = tool.name
		update_name()
		if(tool.reagents)
			tool.reagents.trans_to(src, tool.reagents.total_volume, transferred_by = user)
			reagent_transfer_per_use = reagents.total_volume / max_hits
		//qdel(tool) // CRIMSON EDIT REMOVAL - Drug Fixes
		return ITEM_INTERACT_SUCCESS
	else
		var/lighting_text = tool.ignition_effect(src, user)
		if(!lighting_text)
			return NONE
		if(bong_hits <= 0)
			to_chat(user, span_warning("Nothing to smoke!"))
			return ITEM_INTERACT_BLOCKING
		light(lighting_text)
		return ITEM_INTERACT_SUCCESS

/obj/item/bong/attack_self(mob/user)
	/* // CRIMSON EDIT REMOVAL START - Drug Fixes
	var/turf/location = get_turf(user)
	if(lit)
		user.visible_message(span_notice("[user] puts out [src]."), span_notice("You put out [src]."))
		put_out()
	else if(!lit && bong_hits > 0)
		to_chat(user, span_notice("You empty [src] onto [location]."))
		new /obj/effect/decal/cleanable/ash(location)
		empty_out()
	return
	*/ // CRIMSON EDIT REMOVAL END - Drug Fixes
	// CRIMSON EDIT ADD START - Drug Fixes
	if(lit && packeditem && isliving(user))
		interact_with_atom(user, user)
		return
	if(lit)
		user.visible_message(span_notice("[user] puts out [src]."), span_notice("You put out [src]."))
		put_out()
		return
	if(packeditem)
		to_chat(user, span_warning("It is not lit!"))
	// CRIMSON EDIT ADD END - Drug Fixes

// CRIMSON EDIT ADD START - Drug Fixes
/obj/item/bong/click_ctrl(mob/user)
	if(loc != user)
		return NONE
	if(lit)
		user.visible_message(span_notice("[user] puts out [src]."), span_notice("You put out [src]."))
		put_out()
		return CLICK_ACTION_SUCCESS
	if(!packeditem)
		return CLICK_ACTION_BLOCKING
	if(bong_hits >= max_hits && packed_object)
		var/obj/item/unpacked = packed_object
		reagents.trans_to(unpacked, reagents.total_volume)
		packed_object = null
		empty_out()
		to_chat(user, span_notice("You tip [unpacked] back out of [src]."))
		user.put_in_hands(unpacked)
		return CLICK_ACTION_SUCCESS
	var/atom/location = drop_location()
	to_chat(user, span_notice("You empty [src] onto [location]."))
	new /obj/effect/decal/cleanable/ash(location)
	empty_out()
	return CLICK_ACTION_SUCCESS
// CRIMSON EDIT ADD END - Drug Fixes

/obj/item/bong/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	var/mob/living/interacting_living = interacting_with
	if(!packeditem || !lit)
		return ITEM_INTERACT_BLOCKING
	interacting_with.visible_message(
		span_notice("[user] starts [interacting_with == user ? "taking a hit from [src]." : "forcing [interacting_with] to take a hit from [src]!"]"),
		"[interacting_with == user ? span_notice("You start taking a hit from [src].") : span_danger("[user] starts forcing you to take a hit from [src]!")]"
	)
	playsound(src, 'modular_darkpack/modules/drugs/sounds/heatdam.ogg', 50, TRUE)
	if(!do_after(user, 4 SECONDS, src))
		return ITEM_INTERACT_BLOCKING
	to_chat(interacting_with, span_notice("You finish taking a hit from [src]."))
	if(reagents.total_volume)
		reagents.trans_to(interacting_with, reagent_transfer_per_use, methods = INHALE, ignore_stomach = TRUE)
		bong_hits--
	var/turf/open/pos = get_turf(src)
	if(istype(pos))
		for(var/i in 1 to smoke_range)
			spawn_cloud(pos, smoke_range)
	if(prob(10)) // CRIMSON EDIT - Drug Fixes - Original: if(moan_chance > 0)
		if(prob(moan_chance))
			playsound(interacting_with, pick('modular_darkpack/modules/drugs/sounds/lungbust_moan1.ogg','modular_darkpack/modules/drugs/sounds/lungbust_moan2.ogg', 'modular_darkpack/modules/drugs/sounds/lungbust_moan3.ogg'), 50, TRUE)
			interacting_living.emote("moan")
		else
			playsound(interacting_with, pick('modular_darkpack/modules/drugs/sounds/lungbust_cough1.ogg','modular_darkpack/modules/drugs/sounds/lungbust_cough2.ogg'), 50, TRUE)
			interacting_living.emote("cough")
	if(bong_hits <= 0)
		to_chat(interacting_with, span_warning("Out of uses!"))
		put_out()
		empty_out()
	return ITEM_INTERACT_SUCCESS

// CRIMSON EDIT ADD START - Drug Fixes
/obj/item/bong/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == packed_object)
		packed_object = null
// CRIMSON EDIT ADD END - Drug Fixes

/obj/item/bong/proc/light(flavor_text = null)
	if(lit)
		return
	if(!(flags_1 & INITIALIZED_1))
		icon_state = icon_on
		return
	lit = TRUE
	name = "lit [initial(name)]"
	set_light_on(TRUE)

	if(reagents.spark_act(0, NONE, list()) & SPARK_ACT_DESTRUCTIVE)
		usr?.log_message("lit a rigged bong", LOG_VICTIM)
		qdel(src)
		return

	// allowing reagents to react after being lit
	reagents.flags &= ~(NO_REACT)
	reagents.handle_reactions()
	icon_state = icon_on
	if(flavor_text)
		visible_message(flavor_text)

	if(iscarbon(loc))
		var/mob/living/carbon/smoker = loc
		smoker.trigger_rotschreck(src, 3)

/obj/item/bong/proc/put_out()
	set_light_on(FALSE)
	lit = FALSE
	name = "[initial(name)]"
	icon_state = icon_off

/obj/item/bong/proc/empty_out()
	packeditem = FALSE
	bong_hits = 0
	reagents.clear_reagents() //just to make sure
	QDEL_NULL(packed_object) // CRIMSON EDIT ADD - Drug Fixes

/obj/item/bong/proc/spawn_cloud(turf/open/location, smoke_range)
	var/list/turfs_affected = list(location)
	var/list/turfs_to_spread = list(location)
	var/spread_stage = smoke_range
	for(var/i in 1 to smoke_range)
		if(!turfs_to_spread.len)
			break
		var/list/new_spread_list = list()
		for(var/turf/open/turf_to_spread as anything in turfs_to_spread)
			if(isspaceturf(turf_to_spread))
				continue
			var/obj/effect/abstract/fake_steam/fake_steam = locate() in turf_to_spread
			var/at_edge = FALSE
			if(!fake_steam)
				at_edge = TRUE
				fake_steam = new(turf_to_spread)
			fake_steam.stage_up(spread_stage)

			if(!at_edge)
				for(var/turf/open/open_turf as anything in turf_to_spread.atmos_adjacent_turfs)
					if(!(open_turf in turfs_affected))
						new_spread_list += open_turf
						turfs_affected += open_turf

		turfs_to_spread = new_spread_list
		spread_stage--

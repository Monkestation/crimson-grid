/obj/item/storage/ashtray
	name = "ashtray"
	desc = "A small bowl for holding and disposing of smokestuffs."
	icon = 'modular_darkpack/modules/ashtray/icons/ashtray.dmi'
	icon_state = "ashtray"
	base_icon_state = "ashtray"
	color = "#303030"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/items/handling/drinkglass_drop.ogg'
	pickup_sound = 'sound/items/handling/drinkglass_pickup.ogg'
	custom_price = 30
	storage_type = /datum/storage/ashtray
	var/recolored = FALSE

/obj/item/storage/ashtray/update_overlays()
	. = ..()
	if(!length(contents) || isnull(atom_storage))
		return .
	if((atom_storage.max_slots / 2) >= length(contents))
		. += mutable_appearance(icon, "[base_icon_state]_overlay-half", appearance_flags = RESET_COLOR|KEEP_APART)
	else
		. += mutable_appearance(icon, "[base_icon_state]_overlay-full", appearance_flags = RESET_COLOR|KEEP_APART)

/obj/item/storage/ashtray/Entered()
	. = ..()
	update_icon(UPDATE_OVERLAYS)

/obj/item/storage/ashtray/Exited()
	. = ..()
	update_icon(UPDATE_OVERLAYS)

/obj/item/storage/ashtray/attack_self(mob/user)
	. = ..()

	if(recolored)
		dump_ashtray(user)
		return
	var/option_select = tgui_alert(user, "Choose an option", "[src]", list("Dump", "Recolor", "Don't ask again"))
	switch(option_select)
		if("Recolor")
			var/input_color = tgui_color_picker(user, "Choose a Color.", "[src]", color)
			if(isnull(input_color))
				return
			var/list/skin_hsv = rgb2hsv(input_color)
			if(skin_hsv[3] < 20)
				to_chat(user, span_warning("A color that dark on an object like this? Surely not..."))
				return
			color = input_color
			recolored = TRUE

		if("Don't ask again")
			recolored = TRUE

		if("Dump")
			dump_ashtray(user)


/obj/item/storage/ashtray/proc/dump_ashtray(mob/user)
	var/ciggie_butts = 0

	if(!contents.len)
		to_chat(user, span_warning("You dump [src] out onto the ground. Too bad it has nothing in it."))
		return

	user.visible_message(span_notice("[user] dumps [src] out onto the ground."), \
		span_notice("You dump [src] out onto the ground."))
	for(var/obj/item/cigbutt/butt in contents)
		ciggie_butts += 1
		qdel(butt)

	if(ciggie_butts > 8)
		new /obj/effect/decal/cleanable/ash/large(get_turf(user))
	else if(ciggie_butts)
		new /obj/effect/decal/cleanable/ash(get_turf(user))

	emptyStorage()
	playsound(user, 'sound/items/lighter/cig_snuff.ogg', rand(10,50), TRUE)


/datum/storage/ashtray
	max_slots = 16
	max_specific_storage = WEIGHT_CLASS_TINY

/datum/storage/ashtray/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_holdable(
		list(
			/obj/item/match,
			/obj/item/cigbutt,
			/obj/item/cigarette,
			/obj/item/rollingpaper
		),
		list(/obj/item/cigarette/pipe) // Blacklist
	)


/datum/loadout_item/pocket_items/ashtray
	name = "Ashtray"
	item_path = /obj/item/storage/ashtray

/datum/loadout_item/pocket_items/ashtray/get_item_information()
	. = ..()
	.[FA_ICON_PALETTE] = "Recolorable"

/obj/item/storage/ashtray/lollipop
	name = "lollipop bowl"
	desc = "A small bowl filled with lollipops."
	icon = 'modular_darkpack/modules/ashtray/icons/ashtray.dmi'
	icon_state = "lollipop"
	base_icon_state = "lollipop"
	color = "#303030"
	resistance_flags = FIRE_PROOF
	drop_sound = 'sound/items/handling/drinkglass_drop.ogg'
	pickup_sound = 'sound/items/handling/drinkglass_pickup.ogg'
	storage_type = /datum/storage/lollipops

/obj/item/storage/ashtray/lollipop/PopulateContents()
	for(var/i in 1 to 14)
		new /obj/item/food/lollipop(src)
	update_appearance(UPDATE_ICON)

/datum/storage/lollipops
	max_slots = 16
	max_specific_storage = WEIGHT_CLASS_TINY

/datum/storage/lollipops/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_holdable(list(/obj/item/food/lollipop))

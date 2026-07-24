/obj/item/darkpack/drill
	name = "thermal drill"
	desc = "Guys! The thermal drill, go get it!"
	icon = 'modular_darkpack/modules/vaults/icons/drill48x32.dmi'
	icon_state = "vaultdrill"
	inhand_icon_state = "vaultdrill"
	lefthand_file = 'modular_darkpack/modules/vaults/icons/drill_lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/vaults/icons/drill_righthand.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/deprecated/icons/onfloor.dmi')
	w_class = WEIGHT_CLASS_HUGE
	force = 8
	throwforce = 10
	throw_range = 3
	var/obj/structure/drill/origin_type = /obj/structure/drill

/obj/item/darkpack/drill/proc/plant(mob/user)
	var/turf/T = get_turf(loc)
	if(!isfloorturf(T))
		to_chat(user, span_warning("You need ground to put this on!"))
		return

	user.visible_message(span_notice("[user] places down \the [src.name]."))
	var/obj/structure/drill/placed_drill = new origin_type(get_turf(loc))
	TransferComponents(placed_drill)
	placed_drill.setDir(user.dir)
	qdel(src)

/obj/item/darkpack/drill/attack_self(mob/user)
	plant(user)

/obj/structure/drill
	name = "thermal drill"
	desc = "Guys! The thermal drill, go get it!"
	icon = 'modular_darkpack/modules/vaults/icons/drill.dmi'
	icon_state = "vaultdrill"
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	layer = GASFIRE_LAYER
	max_integrity = 3000
	var/item_drill = /obj/item/darkpack/drill
	var/gas = 0
	var/max_gas = 300
	var/ready = FALSE
	var/active = FALSE
	var/attached_door = null
	var/drill_sound = 'modular_darkpack/modules/vaults/sounds/vault_drilling.ogg'

/obj/structure/drill/proc/health_status()
	if(atom_integrity < max_integrity)
		switch(atom_integrity)
			if(2500 to 3000)
				return "slightly damaged"
			if(2000 to 2500)
				return "moderately damaged"
			if(1000 to 2000)
				return "severely damaged"
			if(500 to 1000)
				return "barely functional"
			else
				return "about to break"

/obj/structure/drill/examine(mob/user)
	. = ..()
	var/health_status = health_status()
	. += "[src] has [gas] gas left."
	if(atom_integrity < max_integrity)
		. += span_notice("[src] is [health_status].")

/obj/structure/drill/mouse_drop_dragged(atom/over_object, mob/user, src_location, over_location, params)

	//lifting onto myself to pick it up
	if(over_object == user && Adjacent(user) && !active)
		if(!item_drill)
			return

		if(!do_after(user, 5 SECONDS, target = src))
			return

		user.visible_message(span_notice("[user] lifts [src]."), span_notice("You grab [src]."))
		ready = FALSE
		attached_door = null
		var/obj/item/picked_drill = new item_drill(loc)
		TransferComponents(picked_drill)
		user.put_in_hands(picked_drill)
		qdel(src)
		return

	//putting it on the vault door
	if(istype(over_object, /obj/structure/vaultdoor) && Adjacent(user) && !active)
		var/obj/structure/vaultdoor/target_door = over_object

		if(target_door.is_broken)
			to_chat(user, span_warning("The door is already broken!"))
			return

		if(ISDIAGONALDIR(get_dir(src, over_object)))
			to_chat(user, span_warning("The drill must be directly adjacent to the door, not diagonal!"))
			return

		if(!do_after(user, 5 SECONDS, target = src))
			return

		ready = TRUE
		attached_door = over_object
		var/direction = get_dir(src, over_object)
		switch(direction)
			if(WEST)
				dir = WEST
				pixel_x = -17
				pixel_y = 21
			if(EAST)
				dir = EAST
				pixel_x = 17
				pixel_y = 21
			if(NORTH)
				dir = NORTH
				pixel_y = 30
			if(SOUTH)
				dir = SOUTH
				pixel_y = -5

		user.visible_message(span_notice("[user] attaches [src] to [over_object]."))

/obj/structure/drill/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/gas_can))
		var/obj/item/gas_can/can = tool

		if(can.stored_gasoline <= 0)
			balloon_alert(user, "empty!")
			return ITEM_INTERACT_BLOCKING

		var/gas_space = max_gas - gas
		if(gas_space <= 0)
			balloon_alert(user, "already full!")
			return ITEM_INTERACT_BLOCKING

		var/transfer_amount = min(gas_space, can.stored_gasoline)
		can.stored_gasoline -= transfer_amount
		gas += transfer_amount

		balloon_alert(user, "filled [transfer_amount] gas")
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/structure/drill/update_overlays()
	. = ..()
	if(active)
		var/mutable_appearance/sparks = mutable_appearance('modular_darkpack/modules/deprecated/icons/particle_effects.dmi', "welding_sparks", ABOVE_ALL_MOB_LAYER, src, ABOVE_LIGHTING_PLANE)
		. += sparks

/obj/structure/drill/proc/process_drill()
	while(active && ready && gas > 0)
		playsound(src, drill_sound, 100, TRUE, ignore_walls = TRUE)
		update_icon(UPDATE_OVERLAYS)
		update_appearance(UPDATE_OVERLAYS)

		if(!attached_door || !istype(attached_door, /obj/structure/vaultdoor))
			active = FALSE
			ready = FALSE
			return

		var/obj/structure/vaultdoor/vault_door = attached_door
		vault_door.door_health -= 1
		gas -= 5
		if(vault_door.door_health <= 0)
			vault_door.break_open()
			active = FALSE
			update_appearance(UPDATE_OVERLAYS)

		sleep(3 SECONDS)

/obj/structure/drill/attack_hand(mob/user)
	. = ..()
	if(!ready)
		to_chat(user, span_warning("You need to place the drill on a vault door first!"))
		return
	if(gas <= 0)
		to_chat(user, span_warning("The drill is out of gas!"))
		return
	if(!active)
		if(do_after(user, 5 SECONDS, target = src))
			active = TRUE
			process_drill()
	else
		if(do_after(user, 2 SECONDS, target = src))
			active = FALSE
			update_appearance(UPDATE_OVERLAYS)
			visible_message(span_warning("[src] shuts off!"))

/obj/structure/drill/proc/handle_layer()
	if(dir == SOUTH)
		layer = ABOVE_MOB_LAYER
	else
		layer = ABOVE_ALL_MOB_LAYER

#define DOAFTER_SOURCE_CAR "doafter_car"
#define CAR_TANK_MAX 1000
#define CAR_TURF_CROSS_OFFSET 8

/obj/effect/temp_visual/car
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	layer = BELOW_MOB_LAYER
	duration = 0.5 SECONDS

/obj/effect/temp_visual/telegraphing/car
	icon_state = "target_circle"
	duration = 0.5 SECONDS

/datum/looping_sound/car_engine
	start_sound = 'modular_darkpack/modules/cars/sounds/start.ogg'
	start_length = 2 SECONDS
	mid_sounds = list('modular_darkpack/modules/cars/sounds/work.ogg')
	mid_length = 1.1 SECONDS
	end_sound = 'modular_darkpack/modules/cars/sounds/stop.ogg'

/obj/car_trunk
	name = "car trunk"
	desc = "How did this get out of the car."

/datum/storage/car
	animated = FALSE
	max_slots = 40
	max_total_storage = 100
	max_specific_storage = WEIGHT_CLASS_HUGE
	insert_on_attack = FALSE
	click_alt_open = FALSE

/datum/storage/car/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_locked(STORAGE_FULLY_LOCKED)

/datum/storage/car/limo
	max_slots = 45

/datum/storage/car/truck
	max_slots = 100
	max_total_storage = 200
	max_specific_storage = WEIGHT_CLASS_GIGANTIC

/datum/storage/car/van
	max_slots = 60
	max_specific_storage = WEIGHT_CLASS_GIGANTIC

/obj/darkpack_car
	name = "car"
	desc = "Take me home, country roads..."
	icon_state = "2"
	icon = 'modular_darkpack/modules/cars/icons/cars.dmi'
	anchored = TRUE
	layer = CAR_LAYER
	density = TRUE
	resistance_flags = UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	throwforce = 150


	MAP_SWITCH(pixel_w = -32, pixel_x = -32)
	MAP_SWITCH(pixel_z = -32, pixel_y = -32)

	animate_movement = NO_STEPS
	set_dir_on_move = FALSE

	light_system = OVERLAY_LIGHT_DIRECTIONAL
	light_color = COLOR_LIGHT_ORANGE
	light_range = 6
	light_power = 1
	light_on = FALSE

	var/movement_vector = 0 //0-359 degrees
	/// Pixels per second along movement_vector, negative when reversing.
	var/speed = 0
	/// Last direction the driver held, from relaymove.
	var/input_dir = NONE
	var/last_input_time = 0
	var/last_process = 0
	/// Exact position inside the tile in pixels. pixel_x/y get truncated to whole pixels, so movement is tracked here instead.
	var/offset_x = 0
	var/offset_y = 0
	/// How far ahead of the car the riders' cameras are shifted, in pixels.
	var/camera_lead_x = 0
	var/camera_lead_y = 0

	max_integrity = 400
	integrity_failure = 0.25
	var/broken = FALSE

	var/image/headlight_image
	var/headlight_on = FALSE

	var/mob/living/driver
	var/list/passengers = list()
	var/max_passengers = 3

	var/stage = 1
	var/on = FALSE
	var/locked = TRUE
	var/lockpick_difficulty = 6
	var/access = "none"

	var/car_storage_type = /datum/storage/car
	var/obj/car_trunk/trunk

	var/exploded = FALSE
	var/beep_sound = 'modular_darkpack/modules/cars/sounds/beep.ogg'

	var/gas = CAR_TANK_MAX

	/// If we provide extra debug information like path indicators
	var/debug_car = FALSE

	var/grant_car_keys = FALSE

	/// sound loop for the engine
	var/datum/looping_sound/car_engine/engine_sound_loop

	COOLDOWN_DECLARE(impact_delay)
	COOLDOWN_DECLARE(beep_cooldown)
	COOLDOWN_DECLARE(hit_cooldown)
	COOLDOWN_DECLARE(smoke_cooldown)
	COOLDOWN_DECLARE(drive_sound_cooldown)

/obj/darkpack_car/Initialize(mapload)
	. = ..()
	engine_sound_loop = new(src)

	trunk = new(src)
	create_storage(storage_type = car_storage_type)
	atom_storage.set_real_location(trunk)

	if(access == "none")
		grant_car_keys = TRUE
		access = "[rand(1,9999999)]"
		AddComponent(/datum/component/door_ownership)

	if(mapload)
		GLOB.city_door_lock_ids |= access

	// DARKPACK TODO - see about reimplementing this sprite for cars
	/*
	headlight_image = new(src)
	headlight_image.icon = 'icons/effects/light_overlays/light_cone_car.dmi'
	headlight_image.icon_state = "light"
	headlight_image.pixel_x = -64
	headlight_image.pixel_y = -64
	headlight_image.layer = O_LIGHTING_VISUAL_LAYER
	headlight_image.plane = O_LIGHTING_VISUAL_PLANE
	headlight_image.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	headlight_image.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	//headlight_image.vis_flags = NONE
	headlight_image.alpha = 110
	*/

	gas = rand(100, CAR_TANK_MAX)
	movement_vector = dir2angle(dir)


	var/static/list/loc_connections = list(
		COMSIG_ATOM_MAGICALLY_UNLOCKED = PROC_REF(on_magic_unlock),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/darkpack_car/Destroy()
	STOP_PROCESSING(SScarpool, src)
	QDEL_NULL(engine_sound_loop)
	QDEL_NULL(trunk)
	empty_car()
	. = ..()

/obj/darkpack_car/click_alt(mob/user)
	var/list/radial_menu_options = list(
		"Open Trunk" = icon('modular_darkpack/modules/cars/icons/car_actions.dmi', "baggage"),
	)
	var/list/passanger_map = list()
	for(var/mob/living/guy in (passengers + driver))
		var/guy_name = guy.name
		radial_menu_options[guy_name] = image(icon = guy, icon_state = guy)
		passanger_map[guy_name] = guy

	var/pick = show_radial_menu(user, src, radial_menu_options, require_near = TRUE)
	if(!pick)
		return

	if(pick == "Open Trunk")
		atom_storage.open_storage(user)
		return CLICK_ACTION_SUCCESS

	if(locked)
		to_chat(user, span_warning("[src] is locked!"))
		return CLICK_ACTION_BLOCKING
	var/mob/living/occupent = passanger_map[pick]
	if(!occupent)
		return CLICK_ACTION_BLOCKING

	user.visible_message(span_warning("[user] begins pulling someone out of [src]!"), \
		span_warning("You begin pulling [occupent] out of [src]..."))
	if(do_after(user, 5 SECONDS, src, interaction_key = DOAFTER_SOURCE_CAR))
		user.visible_message(span_warning("[user] has managed to get [occupent] out of [src]."), \
			span_warning("You've managed to get [occupent] out of [src]."))
		empty_occupant(occupent)
		return CLICK_ACTION_SUCCESS
	else
		to_chat(user, span_warning("You've failed to get [occupent] out of [src]."))

/obj/darkpack_car/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/gas_can))
		return try_refuel(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING
	if(istype(tool, /obj/item/melee/vamp/tire))
		return try_repair(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING
	if(istype(tool, /obj/item/vamp/keys/hack))
		return try_lockpick(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING
	if(istype(tool, /obj/item/vamp/keys))
		return try_keys(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING
	return NONE

/obj/darkpack_car/proc/try_refuel(mob/living/user, obj/item/gas_can/can_used)
	if(can_used.stored_gasoline && gas < CAR_TANK_MAX && isturf(user.loc))
		if(do_after(user, 5 SECONDS, src, interaction_key = DOAFTER_SOURCE_CAR))
			var/gas_to_transfer = min(CAR_TANK_MAX-gas, min(CAR_TANK_MAX, max(1, can_used.stored_gasoline)))
			can_used.stored_gasoline = max(0, can_used.stored_gasoline-gas_to_transfer)
			gas = min(CAR_TANK_MAX, gas+gas_to_transfer)
			to_chat(user, span_notice("You transfer [gas_to_transfer] fuel to [src]."))
			playsound(loc, 'modular_darkpack/master_files/sounds/effects/gas_fill.ogg', 25, TRUE)

/obj/darkpack_car/proc/try_repair(mob/living/user, obj/item/tool)
	if(atom_integrity >= max_integrity)
		to_chat(user, span_notice("[src] is already fully repaired."))
		return

	var/time_to_repair = (max_integrity - atom_integrity) / 4 //Repair 4hp for every second spent repairing
	var/start_time = world.time

	user.visible_message(span_notice("[user] begins repairing [src]..."), \
		span_notice("You begin repairing [src]. Stop at any time to only partially repair it."))
	if(do_after(user, time_to_repair SECONDS, src, interaction_key = DOAFTER_SOURCE_CAR))
		atom_integrity = max_integrity
		playsound(src, 'modular_darkpack/master_files/sounds/effects/repair.ogg', 50, TRUE)
		user.visible_message(span_notice("[user] repairs [src]."), \
			span_notice("You finish repairing all the dents on [src]."))
		color = "#ffffff"
		return TRUE
	else
		repair_damage((world.time - start_time) * 2 / 5) //partial repair
		playsound(src, 'modular_darkpack/master_files/sounds/effects/repair.ogg', 50, TRUE)
		user.visible_message(span_notice("[user] repairs [src]."), \
			span_notice("You repair some of the dents on [src]."))
		color = "#ffffff"
		return TRUE

/obj/darkpack_car/proc/try_lockpick(mob/living/user, obj/item/tool)
	if(!locked)
		to_chat(user, span_warning("The [src] is already unlocked."))
		return
	for(var/mob/living/carbon/human/npc/police/P in oviewers(DEFAULT_SIGHT_DISTANCE, src))
		P.Aggro(user)
	log_game("[user] tried lockpicking [src]")
	var/total_lockpicking = user.st_get_stat(STAT_LARCENY)
	if(CONFIG_GET(flag/punishing_zero_dots) && total_lockpicking < 1)
		to_chat(user, span_warning("How do I do this...?"))
	if(do_after(user, 1 TURNS, src, interaction_key = DOAFTER_SOURCE_CAR))
		if(!locked)
			return
		var/datum/storyteller_roll/lockpick/our_roll = new()
		our_roll.difficulty = lockpick_difficulty
		switch(our_roll.st_roll(user, src, using_item = tool))
			if(ROLL_SUCCESS)
				to_chat(user, span_notice("You've managed to open [src]'s lock."))
				playsound(src, 'modular_darkpack/modules/cars/sounds/open.ogg', 50, TRUE)
				locked = FALSE
				if(initial(access) == "none") //Stealing a car with no keys assigned to it is basically robbing a random person and not an organization
					if(ishuman(user))
						var/mob/living/carbon/human/H = user
						SEND_SIGNAL(H, COMSIG_PATH_HIT, -1, 6, FALSE)
				return TRUE
			if(ROLL_FAILURE)
				to_chat(user, span_warning("You've failed to open [src]'s lock."))
				return
			if(ROLL_BOTCH)
				to_chat(user, span_warning("Your lockpick broke!"))
				qdel(tool)
				if(COOLDOWN_FINISHED(src, beep_cooldown))
					playsound(src, 'modular_darkpack/modules/cars/sounds/signal.ogg', 50, FALSE)
					COOLDOWN_START(src, beep_cooldown, 7 SECONDS)
				return
	else
		to_chat(user, span_warning("You've failed to open [src]'s lock."))
		return

/obj/darkpack_car/proc/try_keys(mob/living/user, obj/item/vamp/keys/key_used)
	if(key_used.accesslocks)
		for(var/i in key_used.accesslocks)
			if(i == access)
				to_chat(user, span_notice("You [locked ? "open" : "close"] [src]'s lock."))
				playsound(src, 'modular_darkpack/modules/cars/sounds/open.ogg', 50, TRUE)
				locked = !locked
				return TRUE

/obj/darkpack_car/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(I.force)
		for(var/mob/living/L in src)
			if(prob(50))
				L.apply_damage(round(I.force/2), I.damtype, pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST))

		if(!driver && !length(passengers) && COOLDOWN_FINISHED(src, beep_cooldown) && locked)
			COOLDOWN_START(src, beep_cooldown, 7 SECONDS)
			playsound(src, 'modular_darkpack/modules/cars/sounds/signal.ogg', 50, FALSE)
			for(var/mob/living/carbon/human/npc/police/P in oviewers(DEFAULT_SIGHT_DISTANCE, src))
				P.Aggro(user)

		if(prob(10) && locked)
			playsound(src, 'modular_darkpack/modules/cars/sounds/open.ogg', 50, TRUE)
			locked = FALSE

/obj/darkpack_car/attack_hand(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.combat_mode && H.st_get_stat(STAT_STRENGTH) > 6)
			var/atom/throw_target = get_edge_target_turf(src, user.dir)
			playsound(get_turf(src), 'modular_darkpack/modules/cars/sounds/bump.ogg', 100, FALSE)
			take_damage(10)
			log_combat(user, src, "threw")
			throw_at(throw_target, rand(4, 6), 4, user)
			return TRUE

/obj/darkpack_car/bullet_act(obj/projectile/P, def_zone, piercing_hit = FALSE)
	. = ..()
	for(var/mob/living/L in src)
		if(prob(50))
			L.apply_damage(P.damage, P.damage_type, pick(BODY_ZONE_HEAD, BODY_ZONE_CHEST))

/obj/darkpack_car/examine(mob/user)
	. = ..()
	if(user.loc == src)
		. += "<b>Gas</b>: [gas]/[CAR_TANK_MAX]"

	if(broken)
		. += span_notice("It appears to be broken.")
	var/healthpercent = (atom_integrity/max_integrity) * 100
	switch(healthpercent)
		if(75 to 99)
			. += "It's slightly dented..."
		if(50 to 74)
			. += "It has some major dents..."
		if(25 to 50)
			. += "It's heavily damaged..."
		if(0 to 25)
			. += span_warning("It's falling apart!")

	if(locked)
		. += span_warning("It's locked.")
	if(driver || length(passengers))
		. += span_notice("\nYou see the following people inside:")
		for(var/mob/living/rider in src)
			. += span_notice("* [rider]")

/obj/darkpack_car/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1, attack_dir)
	. = ..()
	if(prob(50) && atom_integrity <= max_integrity/2)
		stop_engine()
		set_light(0)
	if(broken)
		if(!exploded && prob(50))
			exploded = TRUE
			empty_car()
			explosion(loc,0,1,3,4)

/obj/darkpack_car/atom_break(damage_flag)
	. = ..()
	stop_engine()
	set_light(0)
	color = "#919191"
	broken = TRUE

/obj/darkpack_car/proc/set_headlight_on(new_value)
	if(headlight_on == new_value)
		return
	. = headlight_on
	headlight_on = new_value
	if(headlight_on)
		START_PROCESSING(SScarpool, src)
		add_overlay(headlight_image)
	else
		cut_overlay(headlight_image)

	set_light_on(headlight_on)

/obj/darkpack_car/mouse_drop_receive(mob/living/dropped, mob/user, params)
	. = ..()
	if(!isliving(dropped))
		return

	if(locked)
		to_chat(user, span_warning("[src] is locked."))
		return

	if(driver && (length(passengers) >= max_passengers))
		to_chat(dropped, span_warning("There's no space left for you in [src]."))
		return

	var/list/radial_menu_options = list()
	if(!driver)
		radial_menu_options["Driver Seat"] = icon('modular_darkpack/modules/cars/icons/car_actions.dmi', "driver")
	if(passengers.len < max_passengers)
		radial_menu_options["Passanger Seat"] = icon('modular_darkpack/modules/cars/icons/car_actions.dmi', "passanger")
	var/pick = show_radial_menu(user, src, radial_menu_options, require_near = TRUE)
	if(!pick)
		return

	visible_message(span_notice("[dropped] begins entering [src]..."), \
		span_notice("You begin entering [src]..."))
	if(do_after(user, 1 SECONDS, dropped, interaction_key = DOAFTER_SOURCE_CAR))
		if(pick == "Driver Seat" && driver_enter(dropped))
			return
		else if(pick == "Passanger Seat" && passenger_enter(dropped))
			return
	to_chat(dropped, span_warning("You fail to enter [src]."))
	return

/obj/darkpack_car/proc/driver_enter(mob/living/user)
	if(driver)
		return
	driver = user
	for(var/car_action in subtypesof(/datum/action/darkpack_car))
		var/datum/action/darkpack_car/new_action = new car_action()
		new_action.Grant(user)
	enter_car(user)
	return TRUE

/obj/darkpack_car/proc/passenger_enter(mob/living/user)
	if(passengers.len >= max_passengers)
		return
	passengers += user
	var/datum/action/darkpack_car/exit_car/E = new()
	E.Grant(user)
	enter_car(user)
	return TRUE

// Please only call via driver_enter or passanger_enter
/obj/darkpack_car/proc/enter_car(mob/living/user)
	RegisterSignal(user, COMSIG_MOB_LOGOUT, PROC_REF(on_rider_logout))
	user.forceMove(src)
	visible_message(span_notice("[user] enters [src]."), \
		span_notice("You enter [src]."))
	playsound(src, 'modular_darkpack/master_files/sounds/effects/door/door.ogg', 50, TRUE)

//Dump out all living from the car
/obj/darkpack_car/proc/empty_car()
	for(var/mob/living/L in src)
		empty_occupant(L)

//Dump one guy out of the car.
/obj/darkpack_car/proc/empty_occupant(mob/living/dumpe)
	dumpe.forceMove(loc)

	var/list/exit_side = list(
		SIMPLIFY_DEGREES(movement_vector + 90),
		SIMPLIFY_DEGREES(movement_vector - 90)
	)
	for(var/angle in exit_side)
		if(get_step(dumpe, angle2dir(angle)).density)
			exit_side.Remove(angle)
	var/list/exit_alt = GLOB.alldirs.Copy()
	for(var/dir in exit_alt)
		if(get_step(dumpe, dir).density)
			exit_alt.Remove(dir)
	if(length(exit_side))
		dumpe.Move(get_step(dumpe, angle2dir(pick(exit_side))))
	else if(length(exit_alt))
		dumpe.Move(get_step(dumpe, pick(exit_alt)))

	to_chat(dumpe, span_notice("You exit [src]."))
	playsound(src, 'modular_darkpack/master_files/sounds/effects/door/door.ogg', 50, TRUE)

/obj/darkpack_car/Exited(atom/movable/gone, direction)
	. = ..()
	if(!isliving(gone))
		return
	var/mob/living/rider = gone
	if(rider == driver)
		driver = null
	else
		passengers -= rider
	UnregisterSignal(rider, COMSIG_MOB_LOGOUT)
	reset_rider_camera(rider.client)
	for(var/datum/action/darkpack_car/car_action in rider.actions)
		qdel(car_action)

/// Signal proc for [COMSIG_MOB_LOGOUT]. The client is already detached by now, so the camera has to be reset through canon_client.
/obj/darkpack_car/proc/on_rider_logout(mob/living/source)
	SIGNAL_HANDLER

	reset_rider_camera(source.canon_client)

/obj/darkpack_car/proc/reset_rider_camera(client/rider_client)
	if(!rider_client)
		return
	animate(rider_client)
	rider_client.pixel_x = 0
	rider_client.pixel_y = 0

/obj/darkpack_car/Bump(atom/bumped_atom)
	. = ..()
	if(istype(bumped_atom, /obj/transfer_point_vamp))
		COOLDOWN_START(src, impact_delay, 0.75 SECONDS)
		return

	if(!COOLDOWN_FINISHED(src, hit_cooldown))
		return

	var/velocity_x = sin(movement_vector) * speed
	var/velocity_y = cos(movement_vector) * speed
	var/bump_dir = get_dir(src, bumped_atom)
	var/impact_speed = 0
	if(bump_dir & EAST)
		impact_speed = max(impact_speed, velocity_x)
	if(bump_dir & WEST)
		impact_speed = max(impact_speed, -velocity_x)
	if(bump_dir & NORTH)
		impact_speed = max(impact_speed, velocity_y)
	if(bump_dir & SOUTH)
		impact_speed = max(impact_speed, -velocity_y)

	var/mob/living/hit_mob = isliving(bumped_atom) ? bumped_atom : null
	if(!hit_mob && impact_speed < abs(speed) * 0.5)
		return

	var/impact_damage = round(impact_speed / 8)
	if(!impact_damage)
		return
	COOLDOWN_START(src, hit_cooldown, 0.5 SECONDS)

	if(hit_mob)
		switch(hit_mob.mob_size)
			if(MOB_SIZE_HUGE) // zulo form
				playsound(src, 'modular_darkpack/modules/cars/sounds/bump.ogg', 75, TRUE)
				speed = 0
				COOLDOWN_START(src, impact_delay, 2 SECONDS)
				hit_mob.Paralyze(1 SECONDS)
			if(MOB_SIZE_LARGE) // gangrel warforms, werewolves, bears
				playsound(src, 'modular_darkpack/modules/cars/sounds/bump.ogg', 60, TRUE)
				speed = round(speed * 0.35)
				hit_mob.Knockdown(1 SECONDS)
			if(MOB_SIZE_SMALL) //small animals
				playsound(src, 'modular_darkpack/modules/cars/sounds/bump.ogg', 40, TRUE)
				speed = round(speed * 0.75)
				hit_mob.Knockdown(1 SECONDS)
			else //everything else
				playsound(src, 'modular_darkpack/modules/cars/sounds/bump.ogg', 50, TRUE)
				speed = round(speed * 0.5)
				hit_mob.Knockdown(1 SECONDS)
	else
		playsound(src, 'modular_darkpack/modules/cars/sounds/bump.ogg', 75, TRUE)
		speed = 0
		COOLDOWN_START(src, impact_delay, 2 SECONDS)

	if(driver && istype(bumped_atom, /mob/living/carbon/human/npc))
		var/mob/living/carbon/human/npc/NPC = bumped_atom
		NPC.Aggro(driver, TRUE)

	if(hit_mob)
		var/hit_dam = impact_damage
		if(!HAS_TRAIT(hit_mob, TRAIT_TOUGH_FLESH))
			hit_dam = hit_dam*2
		hit_mob.apply_damage(hit_dam, BRUTE, BODY_ZONE_CHEST)
		if(driver)
			log_combat(driver, hit_mob, "hit with", src)
	var/dam = impact_damage
	if(driver)
		var/driver_skill = clamp(driver.st_get_stat(STAT_DRIVE)/2, 1, 4)
		dam = round(dam/driver_skill)
		driver.apply_damage(impact_damage, BRUTE, BODY_ZONE_CHEST)
	take_damage(dam)

/obj/darkpack_car/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	if(!forced)
		return
	animate(src)
	pixel_x = 0
	pixel_y = 0
	offset_x = 0
	offset_y = 0
	camera_lead_x = 0
	camera_lead_y = 0
	for(var/mob/living/rider in src)
		reset_rider_camera(rider.client)

/obj/darkpack_car/process(seconds_per_tick)
	var/elapsed = min(world.time - last_process, world.tick_lag * 2)
	last_process = world.time
	if(elapsed <= 0)
		return

	var/seconds = elapsed / (1 SECONDS)
	if(on && gas <= 0)
		stop_engine()
		if(driver)
			to_chat(driver, span_warning("No fuel in the tank!"))

	update_speed(seconds)
	if(on && COOLDOWN_FINISHED(src, smoke_cooldown))
		COOLDOWN_START(src, smoke_cooldown, 0.5 SECONDS)
		var/obj/effect/temp_visual/car/smoke = new(loc)
		smoke.pixel_x = pixel_x
		smoke.pixel_y = pixel_y

	if(!throwing && speed)
		move_car(seconds)
	else if(camera_lead_x || camera_lead_y)
		update_rider_cameras(seconds, offset_x, offset_y)
	else if(!speed && !on && !light_on)
		return PROCESS_KILL

/obj/darkpack_car/proc/update_speed(seconds)
	var/throttle = 0
	var/steering = 0
	if(driver && COOLDOWN_FINISHED(src, impact_delay) && world.time - last_input_time <= world.tick_lag * 2)
		throttle = !!(input_dir & NORTH) - !!(input_dir & SOUTH)
		steering = !!(input_dir & EAST) - !!(input_dir & WEST)

	var/braking = throttle * speed < 0
	if(braking)
		speed += throttle * 120 * seconds
		if(!on)
			speed = throttle > 0 ? min(speed, 0) : max(speed, 0)
		if(COOLDOWN_FINISHED(src, drive_sound_cooldown))
			COOLDOWN_START(src, drive_sound_cooldown, 0.3 SECONDS)
			playsound(src, 'modular_darkpack/modules/cars/sounds/stopping.ogg', 10, FALSE)
	else if(throttle && on)
		speed = clamp(speed + throttle * stage * 40 * seconds, -128, stage * 128)
		if(COOLDOWN_FINISHED(src, drive_sound_cooldown))
			COOLDOWN_START(src, drive_sound_cooldown, 0.3 SECONDS)
			playsound(src, 'modular_darkpack/modules/cars/sounds/drive.ogg', 10, FALSE)
	else if(!on || !driver)
		speed = speed > 0 ? max(speed - 60 * seconds, 0) : min(speed + 60 * seconds, 0)

	if(!steering || !speed)
		return
	if(speed < 0 && !driver.client?.prefs?.read_preference(/datum/preference/toggle/enable_legacy_driving_controls))
		steering = -steering
	var/turn_rate = min(abs(speed), 60) * seconds
	if(braking)
		turn_rate *= 1 + clamp(driver.st_get_stat(STAT_DRIVE)/4, 0.25, 4)
	movement_vector = SIMPLIFY_DEGREES(movement_vector + steering * turn_rate)
	apply_vector_angle()

/obj/darkpack_car/proc/move_car(seconds)
	var/start_x = offset_x
	var/start_y = offset_y
	var/step_x = sin(movement_vector) * speed * seconds
	var/step_y = cos(movement_vector) * speed * seconds
	var/new_x = start_x + step_x
	var/new_y = start_y + step_y
	var/from_x = start_x
	var/from_y = start_y
	var/crossed = FALSE

	var/shift_x = 0
	if(new_x > CAR_TURF_CROSS_OFFSET && step_x > 0)
		shift_x = 1
	else if(new_x < -CAR_TURF_CROSS_OFFSET && step_x < 0)
		shift_x = -1
	if(shift_x)
		var/turf/old_turf = loc
		var/turf/next_turf = get_step(old_turf, shift_x > 0 ? EAST : WEST)
		step(src, shift_x > 0 ? EAST : WEST)
		if(QDELETED(src) || (loc != old_turf && loc != next_turf))
			return
		if(loc == next_turf)
			pixel_x -= ICON_SIZE_X * shift_x
			new_x -= ICON_SIZE_X * shift_x
			from_x -= ICON_SIZE_X * shift_x
			crossed = TRUE
		else if(shift_x > 0)
			new_x = min(new_x, max(start_x, CAR_TURF_CROSS_OFFSET))
		else
			new_x = max(new_x, min(start_x, -CAR_TURF_CROSS_OFFSET))

	var/shift_y = 0
	if(new_y > CAR_TURF_CROSS_OFFSET && step_y > 0)
		shift_y = 1
	else if(new_y < -CAR_TURF_CROSS_OFFSET && step_y < 0)
		shift_y = -1
	if(shift_y)
		var/turf/old_turf = loc
		var/turf/next_turf = get_step(old_turf, shift_y > 0 ? NORTH : SOUTH)
		step(src, shift_y > 0 ? NORTH : SOUTH)
		if(QDELETED(src) || (loc != old_turf && loc != next_turf))
			return
		if(loc == next_turf)
			pixel_y -= ICON_SIZE_Y * shift_y
			new_y -= ICON_SIZE_Y * shift_y
			from_y -= ICON_SIZE_Y * shift_y
			crossed = TRUE
		else if(shift_y > 0)
			new_y = min(new_y, max(start_y, CAR_TURF_CROSS_OFFSET))
		else
			new_y = max(new_y, min(start_y, -CAR_TURF_CROSS_OFFSET))

	offset_x = new_x
	offset_y = new_y
	animate(src, pixel_x = new_x, pixel_y = new_y, time = world.tick_lag, flags = ANIMATION_PARALLEL | ANIMATION_CONTINUE)
	update_rider_cameras(seconds, from_x, from_y)
	if(crossed)
		handle_npc_dodge()

/obj/darkpack_car/proc/handle_npc_dodge()
	var/angle = speed < 0 ? REVERSE_ANGLE(movement_vector) : movement_vector
	for(var/turf/line_turf in get_line(src, get_turf_in_angle(angle, loc, 3)))
		if(debug_car)
			new /obj/effect/temp_visual/telegraphing/car(line_turf)
		for(var/mob/living/carbon/human/npc/dodger in line_turf)
			if(!dodger.density || !COOLDOWN_FINISHED(dodger, car_dodge) || HAS_TRAIT(dodger, TRAIT_INCAPACITATED))
				continue
			var/list/dodge_direction = list(
				SIMPLIFY_DEGREES(angle + 45),
				SIMPLIFY_DEGREES(angle - 45),
				SIMPLIFY_DEGREES(angle + 90),
				SIMPLIFY_DEGREES(angle - 90),
			)
			for(var/dir_angle in dodge_direction)
				if(get_step(dodger, angle2dir(dir_angle)).density)
					dodge_direction.Remove(dir_angle)
			if(!length(dodge_direction))
				continue
			step(dodger, angle2dir(pick(dodge_direction)), dodger.cached_multiplicative_slowdown)
			COOLDOWN_START(dodger, car_dodge, 2 SECONDS)
			if(prob(50))
				dodger.realistic_say(pick(dodger.socialrole.car_dodged))

/// Animates the riders' cameras to follow the car, a little ahead of it. from_x/from_y is where the camera was heading last tick, in this tick's tile frame.
/obj/darkpack_car/proc/update_rider_cameras(seconds, from_x, from_y)
	var/old_lead_x = camera_lead_x
	var/old_lead_y = camera_lead_y
	var/lead_blend = min(seconds / 0.5, 1)
	camera_lead_x += (sin(movement_vector) * speed * 0.5 - camera_lead_x) * lead_blend
	camera_lead_y += (cos(movement_vector) * speed * 0.5 - camera_lead_y) * lead_blend
	if(abs(camera_lead_x) < 0.5)
		camera_lead_x = 0
	if(abs(camera_lead_y) < 0.5)
		camera_lead_y = 0

	for(var/mob/living/rider in src)
		var/client/rider_client = rider.client
		if(!rider_client)
			continue
		rider_client.pixel_x = from_x + old_lead_x
		rider_client.pixel_y = from_y + old_lead_y
		animate(rider_client, pixel_x = offset_x + camera_lead_x, pixel_y = offset_y + camera_lead_y, time = world.tick_lag, flags = ANIMATION_PARALLEL | ANIMATION_CONTINUE)

/obj/darkpack_car/relaymove(mob/living/user, direction)
	if(user != driver)
		return ..()
	if(!COOLDOWN_FINISHED(src, impact_delay))
		return
	if(user.IsUnconscious() || HAS_TRAIT(user, TRAIT_INCAPACITATED) || HAS_TRAIT(user, TRAIT_RESTRAINED))
		return
	if(!ISADVANCEDTOOLUSER(user))
		return
	input_dir = direction
	last_input_time = world.time

/obj/darkpack_car/proc/apply_vector_angle()
	// angle2dir truncates fractional angles, so derive the dir from the same rounding as the residual turn
	var/sprite_angle = round(SIMPLIFY_DEGREES(movement_vector + 22.5) / 45) * 45
	setDir(angle2dir(sprite_angle))

	var/matrix/M = matrix()
	M.Turn(movement_vector - sprite_angle)
	transform = M

/obj/darkpack_car/proc/start_engine()
	if(on)
		return
	last_process = world.time
	START_PROCESSING(SScarpool, src)
	on = TRUE
	engine_sound_loop.start()

/obj/darkpack_car/proc/stop_engine()
	if(!on)
		return
	on = FALSE
	engine_sound_loop.stop()

/// Signal proc for [COMSIG_ATOM_MAGICALLY_UNLOCKED]. Unlock and open up when we get knock casted.
/obj/darkpack_car/proc/on_magic_unlock(datum/source, datum/spell, atom/caster)
	SIGNAL_HANDLER

	if(!locked)
		return
	playsound(src, 'modular_darkpack/modules/cars/sounds/open.ogg', 50, TRUE)
	locked = FALSE

#undef DOAFTER_SOURCE_CAR
#undef CAR_TANK_MAX
#undef CAR_TURF_CROSS_OFFSET

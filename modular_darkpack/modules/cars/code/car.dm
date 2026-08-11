#define DOAFTER_SOURCE_CAR "doafter_car"
#define CAR_TANK_MAX 1000

/obj/effect/temp_visual/car
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	layer = BELOW_MOB_LAYER
	light_range = 1
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


	MAP_SWITCH(pixel_x = 0, pixel_x = -32)
	MAP_SWITCH(pixel_y = 0, pixel_y = -32)

	glide_size = 96

	light_system = OVERLAY_LIGHT_DIRECTIONAL
	light_color = COLOR_LIGHT_ORANGE
	light_range = 6
	light_power = 1
	light_on = FALSE

	var/movement_vector = 0 //0-359 degrees
	var/speed_in_pixels = 0 // 16 pixels (turf is 2x2m) = 1 meter per 1 SECOND (process fire). Minus equals to reverse, max should be 444
	var/last_pos = list("x" = 0, "y" = 0, "x_pix" = 0, "y_pix" = 0, "x_frwd" = 0, "y_frwd" = 0)

	max_integrity = 400
	integrity_failure = 0.25
	var/broken = FALSE

	var/image/headlight_image
	var/headlight_on = FALSE

	var/mob/living/driver
	var/list/passengers = list()
	var/max_passengers = 3

	var/speed = 1 //Future
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
	last_pos["x"] = x
	last_pos["y"] = y
	movement_vector = dir2angle(dir)

	add_overlay(image(icon = src.icon, icon_state = src.icon_state, pixel_x = -32, pixel_y = -32))
	icon_state = "empty"

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
		empty_occupent(occupent)
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
		switch(our_roll.st_roll(user, src))
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
	user.forceMove(src)
	visible_message(span_notice("[user] enters [src]."), \
		span_notice("You enter [src]."))
	playsound(src, 'modular_darkpack/master_files/sounds/effects/door/door.ogg', 50, TRUE)

//Dump out all living from the car
/obj/darkpack_car/proc/empty_car()
	for(var/mob/living/L in src)
		empty_occupent(L)

//Dump one guy out of the car.
/obj/darkpack_car/proc/empty_occupent(mob/living/dumpe)
	if(driver == dumpe)
		driver = null
	if(dumpe in passengers)
		passengers -= dumpe
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
	if(dumpe?.client)
		dumpe.client.pixel_x = 0
		dumpe.client.pixel_y = 0
	playsound(src, 'modular_darkpack/master_files/sounds/effects/door/door.ogg', 50, TRUE)
	for(var/datum/action/darkpack_car/C in dumpe.actions)
		qdel(C)

/obj/darkpack_car/Bump(atom/bumped_atom)
	. = ..()
	var/prev_speed = round(abs(speed_in_pixels)/4)
	if(!prev_speed)
		return

	if(istype(bumped_atom, /obj/transfer_point_vamp))
		COOLDOWN_START(src, impact_delay, 0.75 SECONDS)
		/*
		speed_in_pixels = 0
		last_pos["x_pix"] = 0
		last_pos["y_pix"] = 0
		last_pos["x_frwd"] = 0
		last_pos["y_frwd"] = 0
		*/
		return

	if(istype(bumped_atom, /mob/living))
		var/mob/living/hit_mob = bumped_atom
		switch(hit_mob.mob_size)
			if(MOB_SIZE_HUGE) // zulo form
				playsound(src, 'modular_darkpack/modules/cars/sounds/bump.ogg', 75, TRUE)
				speed_in_pixels = 0
				COOLDOWN_START(src, impact_delay, 2 SECONDS)
				hit_mob.Paralyze(1 SECONDS)
			if(MOB_SIZE_LARGE) // gangrel warforms, werewolves, bears
				playsound(src, 'modular_darkpack/modules/cars/sounds/bump.ogg', 60, TRUE)
				speed_in_pixels = round(speed_in_pixels * 0.35)
				hit_mob.Knockdown(1 SECONDS)
			if(MOB_SIZE_SMALL) //small animals
				playsound(src, 'modular_darkpack/modules/cars/sounds/bump.ogg', 40, TRUE)
				speed_in_pixels = round(speed_in_pixels * 0.75)
				hit_mob.Knockdown(1 SECONDS)
			else //everything else
				playsound(src, 'modular_darkpack/modules/cars/sounds/bump.ogg', 50, TRUE)
				speed_in_pixels = round(speed_in_pixels * 0.5)
				hit_mob.Knockdown(1 SECONDS)
	else
		playsound(src, 'modular_darkpack/modules/cars/sounds/bump.ogg', 75, TRUE)
		speed_in_pixels = 0
		COOLDOWN_START(src, impact_delay, 2 SECONDS)

	if(driver && istype(bumped_atom, /mob/living/carbon/human/npc))
		var/mob/living/carbon/human/npc/NPC = bumped_atom
		NPC.Aggro(driver, TRUE)

	last_pos["x_pix"] = 0
	last_pos["y_pix"] = 0
	for(var/mob/living/L in src)
		if(L.client)
			L.client.pixel_x = 0
			L.client.pixel_y = 0
	if(istype(bumped_atom, /mob/living))
		var/mob/living/L = bumped_atom
		var/hit_dam = prev_speed
		if(!HAS_TRAIT(L, TRAIT_TOUGH_FLESH))
			hit_dam = hit_dam*2
		L.apply_damage(hit_dam, BRUTE, BODY_ZONE_CHEST)
		if(driver)
			log_combat(driver, L, "hit with", src)
	var/dam = prev_speed
	if(driver)
		var/driver_skill = clamp(driver.st_get_stat(STAT_DRIVE)/2, 1, 4)
		dam = round(dam/driver_skill)
		driver.apply_damage(prev_speed, BRUTE, BODY_ZONE_CHEST)
	take_damage(dam)
	return

/obj/darkpack_car/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change = TRUE)
	. = ..()
	last_pos["x"] = x
	last_pos["y"] = y

/obj/darkpack_car/process(seconds_per_tick)
	car_move()

/obj/darkpack_car/proc/car_move()
	speed_in_pixels = max(speed_in_pixels, -64)
	var/used_vector = movement_vector
	var/used_speed = speed_in_pixels

	if(gas <= 0)
		stop_engine()
		if(driver)
			to_chat(driver, span_warning("No fuel in the tank!"))
	if(!on || !driver)
		speed_in_pixels = (speed_in_pixels < 0 ? -1 : 1) * max(abs(speed_in_pixels) - 15, 0)
		if(speed_in_pixels == 0 && !light_on)
			return PROCESS_KILL

	forceMove(locate(last_pos["x"], last_pos["y"], z))
	if(on)
		new /obj/effect/temp_visual/car(loc)

	pixel_x = last_pos["x_pix"]
	pixel_y = last_pos["y_pix"]
	var/moved_x = round(sin(used_vector)*used_speed)
	var/moved_y = round(cos(used_vector)*used_speed)
	var/bump_target
	if(used_speed != 0)
		var/true_movement_angle = used_vector
		if(used_speed < 0)
			true_movement_angle = SIMPLIFY_DEGREES(used_vector+180)

		// Here lies the Car Backwards Long Jump - 2021-2025
		var/turf/check_turf = get_turf_in_angle(true_movement_angle, src.loc, 3)

		handle_npc_dodge(check_turf, true_movement_angle)

		var/turf/hit_turf
		var/list/in_line = get_line(src, check_turf)
		for(var/turf/T in in_line)
			if(debug_car)
				// For visualising path of car.
				new /obj/effect/temp_visual/telegraphing/car(T)

			if(hit_turf == get_turf(src))
				continue // Avoid spam bumping and trapping us inside of a dense turf.

			var/dist_to_hit = get_dist_in_pixels(last_pos["x"]*32+last_pos["x_pix"], last_pos["y"]*32+last_pos["y_pix"], T.x*32, T.y*32)
			if(dist_to_hit <= abs(used_speed))
				var/list/stuff = T.get_blocking_contents(FALSE, src)
				if(length(stuff))
					if(!hit_turf || dist_to_hit < get_dist_in_pixels(last_pos["x"]*32+last_pos["x_pix"], last_pos["y"]*32+last_pos["y_pix"], hit_turf.x*32, hit_turf.y*32))
						hit_turf = T
						if(debug_car)
							// For visualising hit tile of car.
							new /obj/effect/temp_visual/telegraphing(T)
		if(hit_turf)
			if(COOLDOWN_FINISHED(src, impact_delay))
				bump_target = pick(hit_turf.get_blocking_contents(FALSE, src))
			// to_chat(world, "I can't pass that [hit_turf] at [hit_turf.x] x [hit_turf.y] cause of [pick(hit_turf.unpassable)] FUCK")
			// var/bearing = get_angle_raw(x, y, pixel_x, pixel_y, hit_turf.x, hit_turf.y, 0, 0)
			var/actual_distance = get_dist_in_pixels(last_pos["x"]*32+last_pos["x_pix"], last_pos["y"]*32+last_pos["y_pix"], hit_turf.x*32, hit_turf.y*32)-32
			moved_x = round(sin(true_movement_angle)*actual_distance)
			moved_y = round(cos(true_movement_angle)*actual_distance)
			if(last_pos["x"]*32+last_pos["x_pix"] > hit_turf.x*32)
				moved_x = max((hit_turf.x*32+32)-(last_pos["x"]*32+last_pos["x_pix"]), moved_x)
			if(last_pos["x"]*32+last_pos["x_pix"] < hit_turf.x*32)
				moved_x = min((hit_turf.x*32-32)-(last_pos["x"]*32+last_pos["x_pix"]), moved_x)
			if(last_pos["y"]*32+last_pos["y_pix"] > hit_turf.y*32)
				moved_y = max((hit_turf.y*32+32)-(last_pos["y"]*32+last_pos["y_pix"]), moved_y)
			if(last_pos["y"]*32+last_pos["y_pix"] < hit_turf.y*32)
				moved_y = min((hit_turf.y*32-32)-(last_pos["y"]*32+last_pos["y_pix"]), moved_y)
	var/turf/west_turf = get_step(src, WEST)
	if(west_turf.is_blocked_turf())
		moved_x = max(-8-last_pos["x_pix"], moved_x)
	var/turf/east_turf = get_step(src, EAST)
	if(east_turf.is_blocked_turf())
		moved_x = min(8-last_pos["x_pix"], moved_x)
	var/turf/north_turf = get_step(src, NORTH)
	if(north_turf.is_blocked_turf())
		moved_y = min(8-last_pos["y_pix"], moved_y)
	var/turf/south_turf = get_step(src, SOUTH)
	if(south_turf.is_blocked_turf())
		moved_y = max(-8-last_pos["y_pix"], moved_y)

	move_car_riders(moved_x, moved_y)

	animate(src, pixel_x = last_pos["x_pix"]+moved_x, pixel_y = last_pos["y_pix"]+moved_y, SScarpool.wait, 1)
	update_last_pos(moved_x, moved_y)

	if(bump_target)
		Bump(bump_target)

/obj/darkpack_car/proc/handle_npc_dodge(turf/target, angle)
	for(var/turf/T in get_line(src, target))
		var/list/unpassable = T.get_blocking_contents(FALSE, src)
		if(!length(unpassable))
			continue
		for(var/mob/living/carbon/human/npc/NPC in unpassable)
			if(COOLDOWN_FINISHED(NPC, car_dodge) && !HAS_TRAIT(NPC, TRAIT_INCAPACITATED))
				var/list/dodge_direction = list(
					SIMPLIFY_DEGREES(angle + 45),
					SIMPLIFY_DEGREES(angle - 45),
					SIMPLIFY_DEGREES(angle + 90),
					SIMPLIFY_DEGREES(angle - 90),
				)
				for(var/dir_angle in dodge_direction)
					if(get_step(NPC, angle2dir(dir_angle)).density)
						dodge_direction.Remove(dir_angle)
				if(length(dodge_direction))
					step(NPC, angle2dir(pick(dodge_direction)), NPC.cached_multiplicative_slowdown)
					COOLDOWN_START(NPC, car_dodge, 2 SECONDS)
					if(prob(50))
						NPC.realistic_say(pick(NPC.socialrole.car_dodged))

/// Moves the client cameras of living inside of the car.
/obj/darkpack_car/proc/move_car_riders(moved_x, moved_y)
	for(var/mob/living/rider in src)
		if(rider.client)
			rider.client.pixel_x = last_pos["x_frwd"]
			rider.client.pixel_y = last_pos["y_frwd"]
			animate(rider.client, \
				pixel_x = last_pos["x_pix"] + moved_x * 2, \
				pixel_y = last_pos["y_pix"] + moved_y * 2, \
				SScarpool.wait, 1)

/obj/darkpack_car/proc/update_last_pos(moved_x, moved_y)
	// Step 1: Move pixel and forward positions
	last_pos["x_frwd"] = last_pos["x_pix"] + moved_x * 2
	last_pos["y_frwd"] = last_pos["y_pix"] + moved_y * 2
	last_pos["x_pix"] = last_pos["x_pix"] + moved_x
	last_pos["y_pix"] = last_pos["y_pix"] + moved_y

	// Step 2: Calculate how many whole tiles we moved (if we crossed tile boundaries)
	var/x_add = (last_pos["x_pix"] < 0 ? -1 : 1) * round((abs(last_pos["x_pix"]) + 16) / 32)
	var/y_add = (last_pos["y_pix"] < 0 ? -1 : 1) * round((abs(last_pos["y_pix"]) + 16) / 32)

	// Step 3: Subtract tile offsets to wrap pixel position into 0–31 range
	last_pos["x_frwd"] -= x_add * 32
	last_pos["y_frwd"] -= y_add * 32
	last_pos["x_pix"] -= x_add * 32
	last_pos["y_pix"] -= y_add * 32

	// Step 4: Update absolute turf coordinates with clamping
	last_pos["x"] = clamp(last_pos["x"] + x_add, 1, world.maxx)
	last_pos["y"] = clamp(last_pos["y"] + y_add, 1, world.maxy)

/obj/darkpack_car/relaymove(mob/living/user, direction)
	if(user != driver)
		return ..()
	if(!COOLDOWN_FINISHED(src, impact_delay))
		return
	if(user.IsUnconscious() || HAS_TRAIT(user, TRAIT_INCAPACITATED) || HAS_TRAIT(user, TRAIT_RESTRAINED))
		return
	if(!ISADVANCEDTOOLUSER(user))
		return
	var/turn_speed = min(abs(speed_in_pixels) / 10, 3)
	switch(direction)
		if(NORTH)
			controlling(1, 0)
		if(NORTHEAST)
			controlling(1, turn_speed)
		if(NORTHWEST)
			controlling(1, -turn_speed)
		if(SOUTH)
			controlling(-1, 0)
		if(SOUTHEAST)
			controlling(-1, turn_speed)
		if(SOUTHWEST)
			controlling(-1, -turn_speed)
		if(EAST)
			controlling(0, turn_speed)
		if(WEST)
			controlling(0, -turn_speed)

/obj/darkpack_car/proc/controlling(adjusting_speed, adjusting_turn)
	var/drift = clamp(driver.st_get_stat(STAT_DRIVE)/4, 0.25, 4)
	var/adjust_true = adjusting_turn
	if(speed_in_pixels != 0)
		movement_vector = SIMPLIFY_DEGREES(movement_vector+adjust_true)
		apply_vector_angle()
	if(adjusting_speed)
		if(on)
			if(adjusting_speed > 0 && speed_in_pixels <= 0)
				playsound(src, 'modular_darkpack/modules/cars/sounds/stopping.ogg', 10, FALSE)
				speed_in_pixels = speed_in_pixels+adjusting_speed*3
				movement_vector = SIMPLIFY_DEGREES(movement_vector+adjust_true*drift)
			else if(adjusting_speed < 0 && speed_in_pixels > 0)
				playsound(src, 'modular_darkpack/modules/cars/sounds/stopping.ogg', 10, FALSE)
				speed_in_pixels = speed_in_pixels+adjusting_speed*3
				movement_vector = SIMPLIFY_DEGREES(movement_vector+adjust_true*drift)
			else
				speed_in_pixels = min(stage*64, max(-stage*64, speed_in_pixels+adjusting_speed*stage))
				playsound(src, 'modular_darkpack/modules/cars/sounds/drive.ogg', 10, FALSE)
		else
			if(adjusting_speed > 0 && speed_in_pixels < 0)
				playsound(src, 'modular_darkpack/modules/cars/sounds/stopping.ogg', 10, FALSE)
				speed_in_pixels = min(0, speed_in_pixels+adjusting_speed*3)
				movement_vector = SIMPLIFY_DEGREES(movement_vector+adjust_true*drift)
			else if(adjusting_speed < 0 && speed_in_pixels > 0)
				playsound(src, 'modular_darkpack/modules/cars/sounds/stopping.ogg', 10, FALSE)
				speed_in_pixels = max(0, speed_in_pixels+adjusting_speed*3)
				movement_vector = SIMPLIFY_DEGREES(movement_vector+adjust_true*drift)

/obj/darkpack_car/proc/apply_vector_angle()
	var/new_dir = angle2dir(movement_vector)
	setDir(new_dir)

	var/turn_state = round(SIMPLIFY_DEGREES(movement_vector + 22.5) / 45)
	var/minus_angle = turn_state * 45

	var/matrix/M = matrix()
	M.Turn(movement_vector - minus_angle)
	transform = M

/obj/darkpack_car/proc/start_engine()
	if(on)
		return
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

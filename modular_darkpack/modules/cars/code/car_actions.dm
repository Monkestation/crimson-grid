/datum/action/darkpack_car
	button_icon = 'modular_darkpack/modules/cars/icons/car_actions.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED | AB_CHECK_CONSCIOUS

/datum/action/darkpack_car/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	if(!owner)
		return FALSE
	if(!istype(owner.loc, /obj/darkpack_car))
		return FALSE

/datum/action/darkpack_car/headlight
	name = "Toggle Light"
	desc = "Toggle light on/off."
	button_icon_state = "lights"

/datum/action/darkpack_car/headlight/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	var/obj/darkpack_car/owned_car = owner.loc
	owned_car.set_headlight_on(!owned_car.headlight_on)
	to_chat(owner, span_notice("You toggle [owned_car]'s lights."))
	playsound(owned_car, 'sound/items/weapons/magout.ogg', 40, TRUE)

/datum/action/darkpack_car/beep
	name = "Signal"
	desc = "Beep-beep."
	button_icon_state = "beep"

/datum/action/darkpack_car/beep/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	var/obj/darkpack_car/owned_car = owner.loc
	if(COOLDOWN_FINISHED(owned_car, beep_cooldown))
		COOLDOWN_START(owned_car, beep_cooldown, 1 SECONDS)
		playsound(owned_car.loc, owned_car.beep_sound, 60, FALSE)

/datum/action/darkpack_car/stage
	name = "Toggle Transmission"
	desc = "Toggle transmission to 1, 2 or 3."
	button_icon_state = "stage"

/datum/action/darkpack_car/stage/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	var/obj/darkpack_car/owned_car = owner.loc
	if(owned_car.stage < 3)
		owned_car.stage = owned_car.stage+1
	else
		owned_car.stage = 1
	to_chat(owner, span_notice("You enable [owned_car]'s transmission at [owned_car.stage]."))

/datum/action/darkpack_car/baggage
	name = "Lock Baggage"
	desc = "Lock/Unlock Baggage."
	button_icon_state = "baggage"

/datum/action/darkpack_car/baggage/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	var/obj/darkpack_car/vamp_car = owner.loc
	var/datum/storage/trunk_datum = vamp_car.atom_storage
	trunk_datum.set_locked(trunk_datum.locked ? STORAGE_NOT_LOCKED : STORAGE_FULLY_LOCKED)

	//vamp_car.balloon_alert(owner, trunk_datum.locked ? "locked" : "unlocked")
	to_chat(owner, span_notice("You [trunk_datum.locked ? "locked" : "unlocked"] [vamp_car]'s baggage."))

	playsound(vamp_car, 'modular_darkpack/master_files/sounds/effects/door/door.ogg', 50, TRUE)

/datum/action/darkpack_car/engine
	name = "Toggle Engine"
	desc = "Toggle engine on/off."
	button_icon_state = "keys"

/datum/action/darkpack_car/engine/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	if(isliving(owner))
		var/mob/living/driver = owner
		if(CONFIG_GET(flag/punishing_zero_dots) && driver.st_get_stat(STAT_DRIVE) < 1)
			to_chat(owner, span_danger("You don't know what you're doing!"))
			return FALSE

	if(!ISADVANCEDTOOLUSER(clicker))
		return

	var/obj/darkpack_car/owned_car = owner.loc
	if(!owned_car.on)
		if((owned_car.get_integrity() == owned_car.max_integrity) || (prob(100*(owned_car.get_integrity()/owned_car.max_integrity))))
			owned_car.start_engine()
			to_chat(owner, span_notice("You managed to start [owned_car]'s engine."))
			return
		else
			to_chat(owner, span_warning("You failed to start [owned_car]'s engine."))
			return
	else
		owned_car.stop_engine()
		to_chat(owner, span_notice("You stop [owned_car]'s engine."))
		return

/datum/action/darkpack_car/exit_car
	name = "Exit"
	desc = "Exit the vehicle."
	button_icon_state = "exit"

/datum/action/darkpack_car/exit_car/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	var/obj/darkpack_car/owned_car = owner.loc
	if(owned_car.driver == owner)
		owned_car.driver = null
	if(owner in owned_car.passengers)
		owned_car.passengers -= owner
	owner.forceMove(owned_car.loc)

	var/list/exit_side = list(
		SIMPLIFY_DEGREES(owned_car.movement_vector + 90),
		SIMPLIFY_DEGREES(owned_car.movement_vector - 90)
	)
	for(var/angle in exit_side)
		if(get_step(owner, angle2dir(angle)).density)
			exit_side.Remove(angle)
	var/list/exit_alt = GLOB.alldirs.Copy()
	for(var/dir in exit_alt)
		if(get_step(owner, dir).density)
			exit_alt.Remove(dir)
	if(length(exit_side))
		owner.Move(get_step(owner, angle2dir(pick(exit_side))))
	else if(length(exit_alt))
		owner.Move(get_step(owner, exit_alt))

	to_chat(owner, span_notice("You exit [owned_car]."))
	if(owner?.client)
		owner.client.pixel_x = 0
		owner.client.pixel_y = 0
	playsound(owned_car, 'modular_darkpack/master_files/sounds/effects/door/door.ogg', 50, TRUE)
	for(var/datum/action/darkpack_car/C in owner.actions)
		qdel(C)

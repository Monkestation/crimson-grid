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
	name = "Фары"
	desc = "Включить или выключить фары."
	button_icon_state = "lights"

/datum/action/darkpack_car/headlight/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	var/obj/darkpack_car/owned_car = owner.loc
	owned_car.set_headlight_on(!owned_car.headlight_on)
	to_chat(owner, span_notice("Вы [owned_car.headlight_on ? "включаете" : "выключаете"] фары [owned_car.declent_ru(GENITIVE)]."))
	playsound(owned_car, 'sound/items/weapons/magout.ogg', 40, TRUE)

/datum/action/darkpack_car/beep
	name = "Сигнал"
	desc = "Би-бип."
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
	name = "Переключить передачу"
	desc = "Переключить передачу: первая, вторая или третья."
	button_icon_state = "stage"

/datum/action/darkpack_car/stage/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	var/obj/darkpack_car/owned_car = owner.loc

	if(trigger_flags & TRIGGER_SECONDARY_ACTION) // CORVAX EDIT
		owned_car.stage = owned_car.stage > 1 ? owned_car.stage - 1 : 3
	else
		owned_car.stage = owned_car.stage < 3 ? owned_car.stage + 1 : 1

	to_chat(owner, span_notice("Вы включаете [owned_car.stage]-ю передачу."))

/datum/action/darkpack_car/baggage
	name = "Багажник"
	desc = "Запереть или отпереть багажник."
	button_icon_state = "baggage"

/datum/action/darkpack_car/baggage/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	var/obj/darkpack_car/vamp_car = owner.loc
	var/datum/storage/trunk_datum = vamp_car.atom_storage
	trunk_datum.set_locked(trunk_datum.locked ? STORAGE_NOT_LOCKED : STORAGE_FULLY_LOCKED)

	//vamp_car.balloon_alert(owner, trunk_datum.locked ? "locked" : "unlocked")
	to_chat(owner, span_notice("Вы [trunk_datum.locked ? "запираете" : "отпираете"] багажник [vamp_car.declent_ru(GENITIVE)]."))

	playsound(vamp_car, 'modular_darkpack/master_files/sounds/effects/door/door.ogg', 50, TRUE)

/datum/action/darkpack_car/engine
	name = "Зажигание"
	desc = "Завести или заглушить двигатель."
	button_icon_state = "keys"

/datum/action/darkpack_car/engine/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	if(isliving(owner))
		var/mob/living/driver = owner
		if(CONFIG_GET(flag/punishing_zero_dots) && driver.st_get_stat(STAT_DRIVE) < 1)
			to_chat(owner, span_danger("Вы понятия не имеете, как этим управлять!"))
			return FALSE

	if(!ISADVANCEDTOOLUSER(clicker))
		return

	var/obj/darkpack_car/owned_car = owner.loc
	if(!owned_car.on)
		if((owned_car.get_integrity() == owned_car.max_integrity) || (prob(100*(owned_car.get_integrity()/owned_car.max_integrity))))
			owned_car.start_engine()
			to_chat(owner, span_notice("Двигатель [owned_car.declent_ru(GENITIVE)] заводится."))
			return
		else
			to_chat(owner, span_warning("Стартер крутит, но двигатель [owned_car.declent_ru(GENITIVE)] не схватывает."))
			return
	else
		owned_car.stop_engine()
		to_chat(owner, span_notice("Вы глушите двигатель [owned_car.declent_ru(GENITIVE)]."))
		return

/datum/action/darkpack_car/exit_car
	name = "Выйти"
	desc = "Выйти из машины."
	button_icon_state = "exit"

/datum/action/darkpack_car/exit_car/Trigger(mob/clicker, trigger_flags)
	. = ..()
	if(!.)
		return FALSE
	var/obj/darkpack_car/owned_car = owner.loc
	owned_car.empty_occupant(owner)

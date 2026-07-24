/obj/effect/temp_visual/rain
	icon = 'modular_darkpack/modules/deprecated/icons/props.dmi'
	icon_state = "rain"
	duration = 2 SECONDS

/datum/looping_sound/sprinkler
	mid_sounds = list('modular_darkpack/modules/deprecated/sounds/rain.ogg' = 1)
	mid_length = 7 SECONDS
	volume = 50

/obj/machinery/sprinkler
	name = "fire sprinkler"
	icon = 'modular_darkpack/modules/fire/icons/sprinkler.dmi'
	icon_state = "sprinkler"
	layer = ABOVE_ALL_MOB_LAYER
	pixel_y = 8
	var/fire_detection_range = 1
	var/current_spray_range = 1
	var/sprinkler_spray_range = 6

	var/has_water_reclaimer = TRUE
	var/last_fire_detection
	/// If the sprinkler triggers and is triggered my the area being set to on fire
	var/area_managed = FALSE
	var/datum/looping_sound/sprinkler/looping_sound

/obj/machinery/sprinkler/Initialize(mapload)
	. = ..()
	looping_sound = new(src)
	create_reagents(20)
	if(src.has_water_reclaimer)
		reagents.add_reagent(/datum/reagent/water, 20)
	AddComponent(/datum/component/seethrough, SEE_THROUGH_MAP_DEFAULT)
	//AddComponent(/datum/component/plumbing/simple_demand)

	for(var/turf/open/open_turf in RANGE_TURFS(fire_detection_range, src))
		RegisterSignals(open_turf, list(COMSIG_ATOM_FIRE_ACT, COMSIG_TURF_HOTSPOT_EXPOSE, COMSIG_TURF_IGNITED), PROC_REF(fire_act_listener))


/obj/machinery/sprinkler/proc/fire_act_listener()
	SIGNAL_HANDLER

	trigger_sprinkler()

/obj/machinery/sprinkler/fire_act(exposed_temperature, exposed_volume)
	trigger_sprinkler()
	. = ..()

/obj/machinery/sprinkler/process(seconds_per_tick)
	if(has_water_reclaimer)
		reagents.add_reagent(/datum/reagent/water, 2.5 * seconds_per_tick)

	if(is_active())
		looping_sound.start()
		for(var/turf/open/turf in circle_view_turfs(src, current_spray_range))
			reagents.expose(turf, TOUCH, current_spray_range/sprinkler_spray_range)
			new /obj/effect/temp_visual/rain(turf)
		for(var/atom/movable/stuff in circle_view(src, current_spray_range))
			reagents.expose(stuff, TOUCH, current_spray_range/sprinkler_spray_range)

		reagents.remove_all(1 * seconds_per_tick)
		current_spray_range = min(sprinkler_spray_range, current_spray_range + 2)
	else
		looping_sound.stop()
		current_spray_range = 1
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/sprinkler/update_overlays()
	. = ..()
	if(is_active())
		. += mutable_appearance('modular_darkpack/modules/fire/icons/sprinkler.dmi', "sprinkler_water")

/obj/machinery/sprinkler/proc/trigger_sprinkler()
	last_fire_detection = world.time

	if(!area_managed)
		return
	var/area/my_area = get_area(src)
	if(my_area)
		my_area.set_fire_effect(TRUE, AREA_FAULT_AUTOMATIC, name)
		my_area.alarm_manager.send_alarm(ALARM_FIRE, src)
	spawn(30 SECONDS)
		my_area.set_fire_effect(FALSE)
		my_area.alarm_manager.clear_alarm(ALARM_FIRE, my_area)

/obj/machinery/sprinkler/proc/is_active()
	if(last_fire_detection && (last_fire_detection + 15 SECONDS > world.time))
		return TRUE

	if(!area_managed)
		return
	var/area/my_area = get_area(src)
	if(my_area)
		return my_area.fire

/obj/machinery/sprinkler/attackby(obj/item/weapon, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	var/msg = weapon.ignition_effect(src, user)
	if(msg)
		visible_message(msg)
		trigger_sprinkler()

/obj/machinery/sprinkler/area_managed
	area_managed = TRUE

// All the code for interacting with other objects that doesnt require master_files

/turf/proc/ignite_turf(power, fire_color = "red")
	return SEND_SIGNAL(src, COMSIG_TURF_IGNITED, power, fire_color)

/turf/proc/extinguish_turf()
	return

/turf/open/ignite_turf(power, fire_color, fire_type = /obj/effect/abstract/turf_fire) // CRIMSON GRID EDIT - Fire color
	. = ..()
	if(. & SUPPRESS_FIRE)
		return
	if(turf_fire)
		turf_fire.AddPower(power)
		return
	if(isgroundlessturf(src))
		return
	new fire_type(src, power, fire_color) // CRIMSON GRID EDIT - Fire color

/turf/open/extinguish_turf(cooling_power = 1.2)
	if(!air)
		return
	if(!active_hotspot && !turf_fire)
		return
	// Cooling down the turf ONLY when there was a fire is just really strange behavoir
	//air.temperature = min(max(min(air.temperature-(cooling_power*1000), air.temperature/cooling_power), T0C), air.temperature) // the outer min temperature check is for weird phenomena like freon combustion
	//temperature = clamp(min(temperature-(cooling_power*1000), temperature/cooling_power), T20C, temperature) // turfs normally don't go below T20C so I'll just clamp it to that in case of weird phenomena.
	//air.react(src)
	if(active_hotspot)
		qdel(active_hotspot)
	if(turf_fire)
		qdel(turf_fire)

/turf/open/misc/grass/burn_tile()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	return TRUE

/turf/open/misc/dirt/burn_tile()
	return FALSE

/obj/structure/flora/fire_act(exposed_temperature, exposed_volume)
	. = ..()
	var/turf/open/plant_turf = get_turf(src)
	if(isopenturf(plant_turf) && prob(plant_turf.flammability >= 1))
		plant_turf.ignite_turf(fuel_power + plant_turf.flammability)

/// Younger stains are left for the police to investigate
#define RAIN_WASH_MIN_AGE (20 MINUTES)
#define RAIN_SHOWER_CHECK_INTERVAL (5 MINUTES)
#define RAIN_SHOWER_ROUNDSTART_GRACE (20 MINUTES)
#define RAIN_SHOWER_COOLDOWN (30 MINUTES)
#define RAIN_SHOWER_BASE_CHANCE 3
/// Every this many blood stains on the streets add one percent of shower chance
#define RAIN_SHOWER_STAINS_PER_PERCENT 5
#define RAIN_SHOWER_MAX_CHANCE 35

GLOBAL_LIST_EMPTY(street_blood)

/obj/effect/decal/cleanable
	var/spawn_time = 0

/obj/effect/decal/cleanable/Initialize(mapload, list/datum/disease/diseases)
	. = ..()
	if(!mapload)
		spawn_time = world.time

/obj/effect/decal/cleanable/blood/Initialize(mapload, list/datum/disease/diseases, list/blood_or_dna)
	. = ..()
	if(. == INITIALIZE_HINT_QDEL)
		return
	var/area/stain_area = get_area(src)
	if(stain_area?.outdoors)
		GLOB.street_blood += src

/obj/effect/decal/cleanable/blood/Destroy()
	GLOB.street_blood -= src
	return ..()

/datum/weather/proc/rain_wash_turf(turf/open/weather_turf)
	for(var/obj/effect/decal/cleanable/stain in weather_turf)
		if(istype(stain, /obj/effect/decal/cleanable/crayon))
			continue
		if(world.time - stain.spawn_time < RAIN_WASH_MIN_AGE)
			continue
		qdel(stain)

/datum/weather/particle/rain_storm
	/// A per-turf chance scaled with the city size into dozens of strikes and fires every second
	var/thunder_strikes_per_second = 1 / 40

/datum/weather/particle/rain_storm/setup_weather_turfs()
	. = ..()
	if(weather_flags & WEATHER_THUNDER)
		thunder_turfs_per_tick = thunder_strikes_per_second * SSweather.wait / (1 SECONDS)

/datum/weather/particle/rain_storm/endless
	thunder_strikes_per_second = 1 / 30

/datum/weather/particle/rain_storm/shower
	name = "rain shower"
	probability = 0
	target_trait = ZTRAIT_STATION
	weather_duration_lower = 4 MINUTES
	weather_duration_upper = 8 MINUTES
	turf_weather_chance = 0.001

SUBSYSTEM_DEF(rain_showers)
	name = "Rain Showers"
	wait = RAIN_SHOWER_CHECK_INTERVAL
	ss_flags = SS_NO_INIT | SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	COOLDOWN_DECLARE(shower_cooldown)

/datum/controller/subsystem/rain_showers/fire(resumed)
	if(world.time - SSticker.round_start_time < RAIN_SHOWER_ROUNDSTART_GRACE)
		return
	if(!COOLDOWN_FINISHED(src, shower_cooldown) || is_raining())
		return
	var/chance = shower_chance()
	if(!prob(chance))
		return
	COOLDOWN_START(src, shower_cooldown, RAIN_SHOWER_COOLDOWN)
	log_game("Rain shower started, chance was [chance]% with [length(GLOB.street_blood)] blood stains on the streets")
	SSweather.run_weather(/datum/weather/particle/rain_storm/shower)

/datum/controller/subsystem/rain_showers/proc/shower_chance()
	return min(RAIN_SHOWER_BASE_CHANCE + length(GLOB.street_blood) / RAIN_SHOWER_STAINS_PER_PERCENT, RAIN_SHOWER_MAX_CHANCE)

/datum/controller/subsystem/rain_showers/proc/is_raining()
	for(var/datum/weather/weather as anything in SSweather.processing)
		if(istype(weather, /datum/weather/particle/rain_storm))
			return TRUE
	return FALSE

#undef RAIN_WASH_MIN_AGE
#undef RAIN_SHOWER_CHECK_INTERVAL
#undef RAIN_SHOWER_ROUNDSTART_GRACE
#undef RAIN_SHOWER_COOLDOWN
#undef RAIN_SHOWER_BASE_CHANCE
#undef RAIN_SHOWER_STAINS_PER_PERCENT
#undef RAIN_SHOWER_MAX_CHANCE

// Drops cross the screen in about two and a half seconds, the base 30 second lifespan kept up to 8000 of them simulated on every client
/particles/weather/rain_storm
	count = 3000
	lifespan = 4 SECONDS
	max_spawn = 150

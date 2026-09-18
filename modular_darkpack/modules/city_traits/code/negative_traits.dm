/datum/station_trait/thunder_storm
	name = "Thunder Storm"
	trait_type = STATION_TRAIT_NEGATIVE
	can_revert = FALSE

	darkpack_allowed = TRUE
	newspaper_message = "Expect a pretty fierce storm tonight."
	newspaper_chance = 75

/datum/station_trait/thunder_storm/on_round_start()
	. = ..()
	SSweather.run_weather(/datum/weather/particle/rain_storm/endless)

/datum/weather/particle/rain_storm/endless
	name = "endless rain"
	probability = 0
	target_trait = ZTRAIT_STATION
	turf_weather_chance = 0.0001
	turf_thunder_chance = THUNDER_CHANCE_VERY_RARE
	weather_flags = parent_type::weather_flags | WEATHER_ENDLESS

/datum/station_trait/foggy_night
	name = "Foggy Night"
	trait_type = STATION_TRAIT_NEGATIVE

	darkpack_allowed = TRUE
	newspaper_message = "Forecasts predict foggy driving conditions, make sure to use your high beams."
	newspaper_chance = 60

/datum/station_trait/foggy_night/on_round_start()
	. = ..()
	set_starlight(null, GLOB.starlight_range*0.8, GLOB.starlight_power*0.5)

/datum/station_trait/faulty_power_grid
	name = "Faulty power grid"
	trait_type = STATION_TRAIT_NEGATIVE
	can_revert = FALSE
	darkpack_allowed = TRUE
	trait_to_give = STATION_TRAIT_BLACKOUT
	newspaper_message = "We continue to receive delays from city officals on estimates when power will be returned city-wide."
	newspaper_chance = 60

/datum/station_trait/faulty_power_grid/on_round_start()
	. = ..()
	for(var/obj/fusebox/F in GLOB.fuseboxes)
		if(prob(75))
			continue
		F.take_damage(rand(50,200))

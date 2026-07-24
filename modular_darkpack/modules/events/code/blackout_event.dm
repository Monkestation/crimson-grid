/datum/round_event_control/darkpack/blackout
	name = "Blackout"
	typepath = /datum/round_event/blackout
	weight = 6
	min_players = 5
	max_occurrences = 1
	earliest_start = 10 MINUTES
	category = EVENT_CATEGORY_ENGINEERING
	description = "A cascading failure in the city's power grid."
	darkpack_allowed = TRUE

/datum/round_event_control/darkpack/blackout/can_spawn_event(players_amt, allow_magic)
	. = ..()
	if(HAS_TRAIT(SSstation, STATION_TRAIT_BLACKOUT))
		return FALSE // Dont piss in my soup twice.

/datum/round_event/blackout
	start_when = 1
	announce_when = 5

/datum/round_event/blackout/announce(fake)
	endpost_announce("Rolling blackouts are impacting your area due to inclement weather. City workers are delayed due to widespread outages across the city.")

/datum/round_event/blackout/start()
	for(var/obj/fusebox/F in GLOB.fuseboxes)
		if(prob(50))
			continue
		F.take_damage(rand(75,200))
		F.power_off()

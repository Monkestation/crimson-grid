/datum/round_event_control/darkpack/szlachta
	name = "Szlachta Attack"
	typepath = /datum/round_event/szlachta
	weight = 3
	min_players = 10
	max_occurrences = 1
	earliest_start = 90 MINUTES
	category = EVENT_CATEGORY_INVASION
	description = "Roving, loose szlachta have found their way into the city."
	darkpack_allowed = TRUE

/datum/round_event_control/darkpack/szlachta/can_spawn_event(players_amt, allow_magic)
	. = ..()
	if(!locate(/obj/effect/landmark/event_spawn/szlachta) in GLOB.generic_event_spawns)
		return FALSE

/datum/round_event/szlachta
	start_when = 1
	announce_when = 5
	announce_chance = 75

/datum/round_event/szlachta/announce(fake)
	var/endpost_szlachta_author = pick("thesupernaturalguy71", "mhaley71", "justplumbin92", "illuminati_truther777", "satanwatch_now")
	var/endpost_szlachta_post = pick("saw something soooo weird... :) new video coming soon on my channel", "just had the most terrifying moment of my life. saw some kind of monster.", "Yeap, whatever I saw, I'm just goin' right the fuck home.", "(the post has an extremely blurry image attached of what looks to be some kind monster. is it photoshopped?)")
	endpost_announce(endpost_szlachta_post, endpost_szlachta_author)

/datum/round_event/szlachta/start()
	for(var/obj/effect/landmark/event_spawn/szlachta/landmark in GLOB.generic_event_spawns)
		if(!prob(20))
			continue
		var/turf/spawn_turf = get_turf(landmark)
		if(!spawn_turf)
			continue

		// dont spawn if a player is nearby we don't need them popping in unrealistically
		var/player_nearby = FALSE
		for(var/mob/living/nearby_mob in view(DEFAULT_SIGHT_DISTANCE, spawn_turf))
			if(nearby_mob.client)
				player_nearby = TRUE
				break
		if(player_nearby)
			continue

		new /mob/living/basic/szlachta(spawn_turf)
		new /mob/living/basic/szlachta/fister(spawn_turf)
		if(prob(40))
			new /mob/living/basic/szlachta(spawn_turf)

		var/vozhd_type = (rand(1, 100) <= 80) ? /mob/living/basic/szlachta/tanker : /mob/living/basic/szlachta/otherthing
		new vozhd_type(spawn_turf)

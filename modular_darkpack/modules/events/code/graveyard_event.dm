/datum/round_event_control/darkpack/graveyard
	name = "Zombie Attack"
	typepath = /datum/round_event/graveyard
	weight = 1
	min_players = 10
	max_occurrences = 2
	earliest_start = 90 MINUTES
	category = EVENT_CATEGORY_INVASION
	description = "Zombies rise at the Graveyard - giving Necromancers an opportunity to control, or suppress, the restless dead."

/datum/round_event_control/darkpack/graveyard/can_spawn_event(players_amt, allow_magic)
	. = ..()
	if(!.)
		return FALSE
	if(!locate(/obj/vampgrave) in GLOB.generic_event_spawns)
		return FALSE
	// run the event if at least one player has necromancy
	for(var/mob/living/player in GLOB.player_list)
		if(!player.get_discipline(/datum/discipline/necromancy))
			continue
		return TRUE
	return FALSE

/datum/round_event/graveyard
	start_when = 1
	announce_when = 5
	end_when = 155 // 5 minutes of zombies

/datum/round_event/graveyard/announce(fake)
	for(var/mob/living/player in GLOB.player_list)
		if(!player.get_discipline(/datum/discipline/necromancy))
			continue
		to_chat(player, span_hypnophrase("You feel uneasiness from across the Shroud... a great mass of spirits awaken."))

/datum/round_event/graveyard/start()
	for(var/obj/vampgrave/grave in GLOB.generic_event_spawns)
		if(!prob(20))
			continue
		grave.zombies_rising = TRUE

/datum/round_event/graveyard/end()
	for(var/obj/vampgrave/grave in GLOB.generic_event_spawns)
		grave.zombies_rising = FALSE
	return ..()


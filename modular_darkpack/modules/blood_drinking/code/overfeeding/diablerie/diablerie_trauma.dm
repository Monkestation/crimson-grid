/datum/brain_trauma/special/imaginary_friend/diablerie
	resilience = TRAUMA_RESILIENCE_ABSOLUTE
	// multiple diableries
	var/list/mob/eye/imaginary_friend/extra_friends

// no need for a ghost poll, its always the diab victim
/datum/brain_trauma/special/imaginary_friend/diablerie/get_ghost()
	return

/datum/brain_trauma/special/imaginary_friend/diablerie/on_life(seconds_per_tick)
	. = ..()
	for(var/mob/eye/imaginary_friend/extra_friend as anything in extra_friends)
		if(QDELETED(extra_friend))
			LAZYREMOVE(extra_friends, extra_friend)
			continue
		if(get_dist(owner, extra_friend) > 9)
			extra_friend.recall()

/datum/brain_trauma/special/imaginary_friend/diablerie/on_lose()
	QDEL_LAZYLIST(extra_friends)
	return ..()

/datum/brain_trauma/special/imaginary_friend/diablerie/proc/add_victim(mob/living/victim)
	var/datum/preferences/victim_prefs = victim.client?.prefs
	var/mob/eye/imaginary_friend/victim_friend = friend
	// main friend already has a past victim in it, make a new one so we dont kick them out
	if(friend in owner.imaginary_group)
		victim_friend = new(get_turf(owner))
		LAZYADD(extra_friends, victim_friend)
	victim_friend.PossessByPlayer(victim.ckey)
	victim_friend.attach_to_owner(owner)
	victim_friend.setup_appearance(victim_prefs)
	victim_friend.log_message("became [key_name(owner)]'s diablerie ghost.", LOG_GAME)

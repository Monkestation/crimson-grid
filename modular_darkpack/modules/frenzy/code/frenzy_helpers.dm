/mob/living/proc/get_blood_frenzy_targets(range = DEFAULT_SIGHT_DISTANCE)
	var/list/blood = list()

	for(var/obj/effect/decal/cleanable/blood/blood_spot in view(range, src))
		blood += blood_spot
	for(var/mob/living/carbon/human/possible_blood_bag in view(range, src))
		if(possible_blood_bag.is_bloodied())
			blood += possible_blood_bag

	return blood


/atom/proc/is_bloodied()
	return GET_ATOM_BLOOD_DECAL_LENGTH(src)

/mob/living/carbon/is_bloodied()
	if(GET_ATOM_BLOOD_DECAL_LENGTH(src) && num_hands) // Blood decals only actually show up if we have hands as its seperate from blood soles..
		return TRUE

	for(var/obj/item/visible_item in get_visible_items())
		if(visible_item.is_bloodied())
			return TRUE


/// Find targets to ATTACK while frenzying
/mob/living/proc/get_frenzy_victims(range = DEFAULT_SIGHT_DISTANCE)
	var/list/victims = list()

	for(var/obj/effect/decal/cleanable/blood/blood_decal in oview(range, src))
		victims += blood_decal


	for(var/mob/living/carbon/human/victim in oview(range, src))
		if(victim.stat == DEAD)
			continue
		victims += victim

	return victims


/mob/living/proc/get_fire_frenzy_targets(range = DEFAULT_SIGHT_DISTANCE)
	var/list/fire = list()

	for(var/obj/effect/abstract/turf_fire/flames in view(range, src))
		fire += flames

	for(var/mob/living/carbon/human/guy in view(range, src))
		if(guy.on_fire)
			fire += guy

	return fire

// A bawn is the border around a caern.
/obj/effect/realistic_fog/bawn
	name = "dizzying fog"
	alpha_lower = 20
	alpha_upper = 80
	var/linked_totem_path
	var/obj/structure/werewolf_totem/linked_totem

/obj/effect/realistic_fog/bawn/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(check_allow_through),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	return INITIALIZE_HINT_LATELOAD

/obj/effect/realistic_fog/bawn/LateInitialize()
	for(var/obj/structure/werewolf_totem/totem in GLOB.totems)
		if(istype(linked_totem, linked_totem_path))
			linked_totem = totem
			RegisterSignal(totem, COMSIG_QDELETING, PROC_REF(on_totem_death))
			break

/obj/effect/realistic_fog/bawn/proc/check_allow_through(datum/source, atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	SIGNAL_HANDLER

	if(!allow_pass(arrived))
		linked_totem.kick_out(arrived)

/obj/effect/realistic_fog/bawn/proc/allow_pass(atom/movable/mover)
	if(!isliving(mover))
		return TRUE

	if(is_friend_of_caern(mover))
		return TRUE

	for(var/mob/living/friend in range(3, mover))
		if(is_friend_of_caern(friend))
			return TRUE

	return FALSE

/obj/effect/realistic_fog/bawn/proc/is_friend_of_caern(mob/living/potential_friend)
	if(linked_totem)
		return linked_totem.is_friend_of_totem(potential_friend)

	return TRUE

/obj/effect/realistic_fog/bawn/gaia
	linked_totem_path = /obj/structure/werewolf_totem/generic/gaia

/obj/effect/realistic_fog/bawn/children_of_gaia
	linked_totem_path = /obj/structure/werewolf_totem/children_of_gaia

/obj/effect/realistic_fog/bawn/proc/on_totem_death(atom/source)
	SIGNAL_HANDLER

	qdel(src)


/// Area component that makes all movement inside get tracked by motion sensitive cameras
/datum/component/bawn_area
	dupe_mode = COMPONENT_DUPE_UNIQUE // Only one area will ever exist, so only one component will ever exist

	var/obj/structure/werewolf_totem/linked_totem

/datum/component/bawn_area/Initialize(linked_totem_path)
	// By the way, this component should be added in LateInitialize().
	if(!isarea(parent))
		return COMPONENT_INCOMPATIBLE

	for(var/obj/structure/werewolf_totem/totem in GLOB.totems)
		if(istype(totem, linked_totem_path))
			linked_totem = totem
			RegisterSignal(totem, COMSIG_QDELETING, PROC_REF(on_totem_death))
			break

	if(!linked_totem)
		return COMPONENT_INCOMPATIBLE

/datum/component/bawn_area/RegisterWithParent()
	RegisterSignal(parent, COMSIG_AREA_ENTERED, PROC_REF(on_entered))

/datum/component/bawn_area/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_AREA_ENTERED)

/datum/component/bawn_area/proc/on_entered(area/_source, atom/movable/gain, area/_old_area)
	SIGNAL_HANDLER

	if(!allow_pass(gain))
		linked_totem.kick_out(gain)

/datum/component/bawn_area/proc/on_totem_death(atom/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/component/bawn_area/proc/allow_pass(atom/movable/mover)
	if(!isliving(mover))
		return TRUE

	if(is_friend_of_caern(mover))
		return TRUE

	for(var/mob/living/friend in range(3, mover))
		if(is_friend_of_caern(friend))
			return TRUE

	return FALSE

/datum/component/bawn_area/proc/is_friend_of_caern(mob/living/potential_friend)
	if(linked_totem)
		return linked_totem.is_friend_of_totem(potential_friend)

	return TRUE


/obj/effect/landmark/bawn_entrance
	var/linked_totem_path

/obj/effect/landmark/bawn_entrance/gaia
	linked_totem_path = /obj/structure/werewolf_totem/generic/gaia

/obj/effect/landmark/bawn_entrance/gaia/children_of_gaia
	linked_totem_path = /obj/structure/werewolf_totem/children_of_gaia

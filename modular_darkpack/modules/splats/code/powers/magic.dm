// General code for detecting magic. Either for active items/effects or after its been cast.

// the "after effect" created after using most magic. To be detected by magic sensing abilties
/obj/effect/abstract/magic_after_effect
	name = "lingering magic"
	icon_state = "purplesparkles"
	anchored = TRUE
	invisibility = INVISIBILITY_MAXIMUM

	var/creation_time
	/// IF this effect can be sourced from a mob, a weakref of them.
	var/datum/weakref/creation_mob
	var/datum/magic_information/magic_info

/obj/effect/abstract/magic_after_effect/Initialize(mapload, creating_mob, magic_strength = 1, magic_type, magic_subtype)
	. = ..()
	creation_time = world.time
	if(creating_mob)
		creating_mob = WEAKREF(creating_mob)

	magic_info = new()
	magic_info.magic_strength = magic_strength
	magic_info.magic_type = magic_type
	magic_info.magic_subtype = magic_subtype

/obj/effect/abstract/magic_after_effect/get_magic_sources()
	. = ..()

	if(magic_info)
		. += magic_info

/obj/effect/abstract/magic_after_effect/proc/get_time_alive()
	return world.time - creation_time


/proc/spawn_magic_after_effect(loc, creating_mob, magic_strength, magic_type, magic_subtype)
	var/obj/effect/abstract/magic_after_effect/old_effect = locate() in loc
	if(old_effect)
		qdel(old_effect)
	var/obj/effect/abstract/magic_after_effect/new_effect = new(loc, creating_mob, magic_strength, magic_type, magic_subtype)
	return new_effect

/datum/magic_information
	/// Rough estimate of the power of the effect. Ballparked to powerscale to the rank of the gifts/discs/powers.
	var/magic_strength = 1
	var/magic_type
	var/magic_subtype


/// Returns lists of abstract information about "magic" affecting the atom (including the atom itself being said magic)
/atom/proc/get_magic_sources()
	SHOULD_CALL_PARENT(TRUE)
	. = list()
	SEND_SIGNAL(src, COMSIG_ATOM_GET_MAGIC_SOURCES, .)


/obj/item/occult_artifact/get_magic_sources()
	. = ..()
	var/datum/magic_information/magic_info = new()
	magic_info.magic_strength = rank
	magic_info.magic_type = magic_type
	. += magic_info

/obj/item/ritual_tome/get_magic_sources()
	. = ..()
	var/datum/magic_information/magic_info = new()
	magic_info.magic_type = MAGIC_TYPE_BLOOD
	. += magic_info

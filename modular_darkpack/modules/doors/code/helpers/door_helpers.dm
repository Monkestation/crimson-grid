//door helpers
/obj/effect/mapping_helpers/door
	abstract_type = /obj/effect/mapping_helpers/door
	layer = DOOR_HELPER_LAYER
	late = TRUE

/obj/effect/mapping_helpers/door/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_mapping("[src] spawned outside of mapload!")
		return

	var/obj/structure/vampdoor/door = locate(/obj/structure/vampdoor) in loc
	if(!door)
		log_mapping("[src] failed to find a door at [AREACOORD(src)]")
		return

	payload(door)

/obj/effect/mapping_helpers/door/LateInitialize()
	var/obj/structure/vampdoor/door = locate(/obj/structure/vampdoor) in loc
	if(!door)
		qdel(src)
		return

	late_payload(door)
	qdel(src)

/obj/effect/mapping_helpers/door/proc/payload(obj/structure/vampdoor/payload)
	return

/obj/effect/mapping_helpers/door/proc/late_payload(obj/structure/vampdoor/payload)
	return

/obj/effect/mapping_helpers/door/autoname
	name = "door autoname helper"
	icon_state = "airlock_autoname"

/obj/effect/mapping_helpers/door/autoname/late_payload(obj/structure/vampdoor/payload)
	. = ..()
	payload.name = get_area_name(src, TRUE)

/obj/effect/mapping_helpers/door/lock
	icon_state = "start_locked"
	icon = 'modular_darkpack/modules/doors/icons/mapping_helpers.dmi'

/obj/effect/mapping_helpers/door/lock/payload(obj/structure/vampdoor/payload)
	payload.locked = TRUE

/obj/effect/mapping_helpers/door/unlock
	icon_state = "start_unlocked"
	icon = 'modular_darkpack/modules/doors/icons/mapping_helpers.dmi'

/obj/effect/mapping_helpers/door/unlock/payload(obj/structure/vampdoor/payload)
	payload.locked = FALSE

/obj/effect/mapping_helpers/door/toggle_lock
	icon_state = "toggle_locked"
	icon = 'modular_darkpack/modules/doors/icons/mapping_helpers.dmi'

/obj/effect/mapping_helpers/door/toggle_lock/payload(obj/structure/vampdoor/payload)
	payload.locked = !payload.locked


/obj/effect/mapping_helpers/door/lock_difficulty
	icon_state = "locklevel_easy"
	icon = 'modular_darkpack/modules/doors/icons/mapping_helpers.dmi'
	var/lock_difficulty

/obj/effect/mapping_helpers/door/lock_difficulty/payload(obj/structure/vampdoor/payload)
	payload.lockpick_difficulty = lock_difficulty

/* This doesnt really exist...
/obj/effect/mapping_helpers/door/lock_difficulty/one
	icon_state = "locklevel_trivial"
	lock_difficulty = 1
*/

/obj/effect/mapping_helpers/door/lock_difficulty/two
	icon_state = "locklevel_trivial"
	lock_difficulty = 2

/obj/effect/mapping_helpers/door/lock_difficulty/three
	icon_state = "locklevel_trivial"
	lock_difficulty = 3

/obj/effect/mapping_helpers/door/lock_difficulty/four
	icon_state = "locklevel_trivial"
	lock_difficulty = 4

/obj/effect/mapping_helpers/door/lock_difficulty/five
	icon_state = "locklevel_trivial"
	lock_difficulty = 5

/obj/effect/mapping_helpers/door/lock_difficulty/six
	icon_state = "locklevel_easy"
	lock_difficulty = 6

/obj/effect/mapping_helpers/door/lock_difficulty/seven
	icon_state = "locklevel_medium"
	lock_difficulty = 7

/obj/effect/mapping_helpers/door/lock_difficulty/eight
	icon_state = "locklevel_hard"
	lock_difficulty = 8

/obj/effect/mapping_helpers/door/lock_difficulty/nine
	icon_state = "locklevel_harder"
	lock_difficulty = 9

/obj/effect/mapping_helpers/door/lock_difficulty/ten
	icon_state = "locklevel_hardest"
	lock_difficulty = 10

/obj/effect/mapping_helpers/door/bash_difficulty
	icon_state = "locklevel_easy"
	icon = 'modular_darkpack/modules/doors/icons/mapping_helpers.dmi'
	pixel_x = 6
	var/bash_difficulty

/obj/effect/mapping_helpers/door/bash_difficulty/payload(obj/structure/vampdoor/payload)
	payload.bash_difficulty = bash_difficulty

/obj/effect/mapping_helpers/door/bash_difficulty/five
	icon_state = "locklevel_trivial"
	bash_difficulty = 5

/obj/effect/mapping_helpers/door/bash_difficulty/six
	icon_state = "locklevel_easy"
	bash_difficulty = 6

/obj/effect/mapping_helpers/door/bash_difficulty/seven
	icon_state = "locklevel_medium"
	bash_difficulty = 7

/obj/effect/mapping_helpers/door/bash_difficulty/eight
	icon_state = "locklevel_hard"
	bash_difficulty = 8

/obj/effect/mapping_helpers/door/bash_difficulty/nine
	icon_state = "locklevel_harder"
	bash_difficulty = 9

/obj/effect/mapping_helpers/door/bash_difficulty/ten
	icon_state = "locklevel_hardest"
	bash_difficulty = 10

/datum/memory/key/armory_code
	var/remembered_code

/datum/memory/key/armory_code/New(
	datum/mind/memorizer_mind,
	atom/protagonist,
	atom/deuteragonist,
	atom/antagonist,
	remembered_code,
)
	src.remembered_code = remembered_code
	return ..()

/datum/memory/key/armory_code/get_names()
	return list("The armory code is [remembered_code].")

/datum/memory/key/armory_code/get_starts()
	return list(
		"[protagonist_name] screams [remembered_code], looking panicked. It's time to get the big guns!"
	)

/datum/memory/key/panic_room_code
	var/remembered_code

/datum/memory/key/panic_room_code/New(
	datum/mind/memorizer_mind,
	atom/protagonist,
	atom/deuteragonist,
	atom/antagonist,
	remembered_code,
)
	src.remembered_code = remembered_code
	return ..()

/datum/memory/key/panic_room_code/get_names()
	return list("The panic room code is [remembered_code].")

/datum/memory/key/panic_room_code/get_starts()
	return list(
		"[protagonist_name] screams [remembered_code], looking panicked. It's time to hide!"
	)

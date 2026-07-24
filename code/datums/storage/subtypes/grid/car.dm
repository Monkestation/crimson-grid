/datum/storage/grid/car
	max_specific_storage = WEIGHT_CLASS_HUGE
	screen_max_columns = 7
	screen_max_rows = 9
	animated = FALSE
	insert_on_attack = FALSE
	click_alt_open = FALSE

/datum/storage/grid/car/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound)
	. = ..()
	set_locked(STORAGE_FULLY_LOCKED)

/datum/storage/grid/car/limo
	screen_max_columns = 5
	screen_max_rows = 9

/datum/storage/grid/car/truck
	max_specific_storage = WEIGHT_CLASS_GIGANTIC
	screen_max_columns = 13
	screen_max_rows = 9

/datum/storage/grid/car/van
	max_specific_storage = WEIGHT_CLASS_GIGANTIC
	screen_max_columns = 10
	screen_max_rows = 9

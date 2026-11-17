/datum/storage/grid/holster
	screen_max_columns = 2
	screen_max_rows = 4
	open_sound = 'sound/items/handling/holster_open.ogg'
	open_sound_vary = TRUE

/datum/storage/grid/holster/New(atom/parent, max_slots, max_specific_storage, max_total_storage, rustle_sound, remove_rustle_sound, list/holdables)
	. = ..()
	if(length(holdables))
		set_holdable(holdables)
		return

	set_holdable(list(
		/obj/item/gun/ballistic/automatic/pistol,
		/obj/item/gun/ballistic/revolver,
		/obj/item/ammo_box/magazine,
		/obj/item/ammo_box/darkpack/c9mm/moonclip
	))


/datum/storage/grid/belt
	screen_max_columns = 2
	screen_max_rows = 4

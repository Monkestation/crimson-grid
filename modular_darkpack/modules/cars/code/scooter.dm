/datum/storage/car/scooter
	max_slots = 4
	max_total_storage = 10
	max_specific_storage = WEIGHT_CLASS_NORMAL

/obj/darkpack_car/scooter
	name = "scooter"
	desc = "Zippy, cheap, and offers zero protection."
	icon = 'modular_darkpack/modules/cars/icons/hondadio.dmi' // 48x48
	icon_state = "base"
	visual_offset = -8

	MAP_SWITCH(pixel_x = 0, pixel_x = -8)
	MAP_SWITCH(pixel_y = 0, pixel_y = -8)

	max_integrity = 150
	max_passengers = 0
	car_storage_type = /datum/storage/car/scooter
	lockpick_difficulty = 4
	throwforce = 40

	light_range = 4

	lock_blocks_entry = FALSE
	occupants_visible = TRUE

	paint_overlay_state = "color"
	front_overlay_state = "base_front"
	front_paint_overlay_state = "color_front_paint"
	rider_pixel_y = 6

	turn_speed_divisor = 5
	min_turn_speed = 1
	max_turn_speed = 6

	max_speed = 96
	eject_speed_threshold = 8

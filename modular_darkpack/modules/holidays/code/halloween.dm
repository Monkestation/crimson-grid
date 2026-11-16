
/datum/holiday/spooky_season
	name = SPOOKY_SEASON
	begin_day = 1
	begin_month = OCTOBER
	end_day = 2
	end_month = NOVEMBER
	holiday_colors = list(COLOR_MOSTLY_PURE_ORANGE, COLOR_PRISONER_BLACK)
	holiday_mail = list(
		/obj/item/food/cookie/sugar/spookycoffin,
		/obj/item/food/cookie/sugar/spookyskull,
		)

/datum/holiday/spooky_season/greet()
	return "Have a very spooky season!"

/obj/effect/spawner/holiday_spawner
	name = "holiday spawner"
	icon = 'modular_darkpack/modules/holidays/icons/landmarks.dmi'
	icon_state = "spawner"

/obj/effect/spawner/holiday_spawner
	var/spawn_chance = 100
	/// Assoc list of holiday defines/names to the type we spawn. Order is important for overlaping holidays.
	var/spawn_types

/obj/effect/spawner/holiday_spawner/Initialize(mapload)
	. = ..()
	var/obj/spawned_object
	if(prob(spawn_chance))
		for(var/key, value in spawn_types)
			if(check_holidays(key))
				spawned_object = new value(get_turf(src))
				break

	if(spawned_object)
		spawned_object.pixel_x = pixel_x
		spawned_object.pixel_y = pixel_y

/obj/effect/spawner/holiday_spawner/porch
	spawn_chance = 90
	spawn_types = list(SPOOKY_SEASON = /obj/item/clothing/head/utility/hardhat/pumpkinhead)

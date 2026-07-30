/datum/looping_sound/light_hum
	mid_sounds = list(
		'modular_darkpack/modules/ambience/sounds/ambient_objects/light_hum-01.ogg',
		'modular_darkpack/modules/ambience/sounds/ambient_objects/light_hum-02.ogg',
		'modular_darkpack/modules/ambience/sounds/ambient_objects/light_hum-03.ogg',
		'modular_darkpack/modules/ambience/sounds/ambient_objects/light_hum-04.ogg',
		'modular_darkpack/modules/ambience/sounds/ambient_objects/light_hum-05.ogg',
		'modular_darkpack/modules/ambience/sounds/ambient_objects/light_hum-06.ogg',
		'modular_darkpack/modules/ambience/sounds/ambient_objects/light_hum-07.ogg',
		'modular_darkpack/modules/ambience/sounds/ambient_objects/light_hum-08.ogg',
	)
	volume = 6
	falloff_exponent = 5 //Ultra quiet very fast
	extra_range = -12
	falloff_distance = 1 //Instant falloff after initial tile


/datum/looping_sound/slow_drip
	mid_sounds = list(
		'modular_darkpack/modules/ambience/sounds/ambient_objects/drip-01.ogg',
		'modular_darkpack/modules/ambience/sounds/ambient_objects/drip-02.ogg',
		'modular_darkpack/modules/ambience/sounds/ambient_objects/drip-03.ogg',
		'modular_darkpack/modules/ambience/sounds/ambient_objects/drip-04.ogg',
		'modular_darkpack/modules/ambience/sounds/ambient_objects/drip-05.ogg',
		'modular_darkpack/modules/ambience/sounds/ambient_objects/drip-06.ogg',
	)
	mid_length = 20 SECONDS
	mid_length_vary = 3 SECONDS
	volume = 45
	ignore_walls = FALSE
	falloff_distance = 5

// City
/datum/looping_sound/car_by
	mid_sounds = list(
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_by_01.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_by_02.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_by_03.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_by_04.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_by_05.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_by_06.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_by_07.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_by_08.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_by_09.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_by_11.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_by_12.ogg',
	)
	mid_length = 20 SECONDS
	mid_length_vary = 3 SECONDS


/datum/looping_sound/car_honk
	mid_sounds = list(
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_honk_01.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_honk_02.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_honk_03.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_honk_04.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_honk_05.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_honk_06.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_honk_08.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/car_honk_09.ogg',
	)
	mid_length = 30 SECONDS
	mid_length_vary = 5 SECONDS


/datum/looping_sound/plane
	mid_sounds = list(
		'modular_darkpack/modules/ambience/sounds/city_oneshots/plane_01.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/plane_02.ogg',
	)
	mid_length = 4 MINUTES
	mid_length_vary = 3 MINUTES


/datum/looping_sound/yell
	mid_sounds = list(
		'modular_darkpack/modules/ambience/sounds/city_oneshots/yell_01.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/yell_02.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/yell_03.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/yell_04.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/yell_05.ogg',
		'modular_darkpack/modules/ambience/sounds/city_oneshots/yell_06.ogg',
	)
	mid_length = 1 MINUTES
	mid_length_vary = 10 SECONDS

// Nature
/datum/looping_sound/crow_caw
	mid_sounds = list(
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_01.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_02.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_03.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_04.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_05.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_06.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_07.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_08.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_09.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_10.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_11.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_12.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_13.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_14.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_15.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_16.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/crow_caw_17.ogg',
	)
	mid_length = 1 MINUTES
	mid_length_vary = 10 SECONDS


/datum/looping_sound/dog
	mid_sounds = list(
		'modular_darkpack/modules/ambience/sounds/nature/dog_01.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/dog_02.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/dog_03.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/dog_04.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/dog_05.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/dog_06.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/dog_07.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/dog_08.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/dog_09.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/dog_10.ogg',
	)
	mid_length = 1 MINUTES
	mid_length_vary = 10 SECONDS

/datum/looping_sound/pigeons
	mid_sounds = list(
		'modular_darkpack/modules/ambience/sounds/nature/pigeons_01.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/pigeons_02.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/pigeons_03.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/pigeons_04.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/pigeons_05.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/pigeons_06.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/pigeons_07.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/pigeons_08.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/pigeons_09.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/pigeons_10.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/pigeons_11.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/pigeons_12.ogg',
	)
	mid_length = 1 MINUTES
	mid_length_vary = 10 SECONDS


/datum/looping_sound/rats
	mid_sounds = list(
		'modular_darkpack/modules/ambience/sounds/nature/rat_run.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/rat_squeak_01.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/rat_squeak_02.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/rat_squeak_03.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/rat_squeak_04.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/rat_squeak_05.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/rat_squeak_06.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/rat_squeak_07.ogg',
		'modular_darkpack/modules/ambience/sounds/nature/rat_squeak_08.ogg',
	)
	mid_length = 1 MINUTES
	mid_length_vary = 10 SECONDS

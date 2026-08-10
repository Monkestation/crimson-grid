/datum/discipline/fortitude
	name = "Fortitude"
	desc = "Boosts armor."
	icon_state = "fortitude"
	power_type = /datum/discipline_power/fortitude

/datum/discipline_power/fortitude
	name = "Fortitude power name"
	desc = "Fortitude power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/fortitude_activate.ogg'
	deactivate_sound = 'modular_darkpack/modules/powers/sounds/fortitude_deactivate.ogg'

//FORTITUDE 1
/datum/discipline_power/fortitude/one
	name = "Fortitude 1"
	desc = "Harden your muscles. Become sturdier than the bodybuilders."

	level = 1

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/four,
		/datum/discipline_power/fortitude/five
	)

/datum/discipline_power/fortitude/one/activate()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/fortitude/one)

/datum/discipline_power/fortitude/one/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/fortitude/one)

/datum/discipline_power/fortitude/one/post_gain()
	owner.st_add_stat_mod(STAT_STAMINA, 1, "Fortitude")

//FORTITUDE 2
/datum/discipline_power/fortitude/two
	name = "Fortitude 2"
	desc = "Become as stone. Let nothing breach your protections."

	level = 2

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/four,
		/datum/discipline_power/fortitude/five
	)

/datum/discipline_power/fortitude/two/activate()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/fortitude/two)

/datum/discipline_power/fortitude/two/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/fortitude/two)

/datum/discipline_power/fortitude/two/post_gain()
	owner.st_add_stat_mod(STAT_STAMINA, 2, "Fortitude")

//FORTITUDE 3
/datum/discipline_power/fortitude/three
	name = "Fortitude 3"
	desc = "Look down upon those who would try to kill you. Shrug off grievous attacks."

	level = 3

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/four,
		/datum/discipline_power/fortitude/five
	)

/datum/discipline_power/fortitude/three/activate()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/fortitude/three)

/datum/discipline_power/fortitude/three/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/fortitude/three)

/datum/discipline_power/fortitude/three/post_gain()
	owner.st_add_stat_mod(STAT_STAMINA, 3, "Fortitude")

//FORTITUDE 4
/datum/discipline_power/fortitude/four
	name = "Fortitude 4"
	desc = "Be like steel. Walk into fire and come out only singed."

	level = 4

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/five
	)

/datum/discipline_power/fortitude/four/activate()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/fortitude/four)

/datum/discipline_power/fortitude/four/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/fortitude/four)

/datum/discipline_power/fortitude/four/post_gain()
	owner.st_add_stat_mod(STAT_STAMINA, 4, "Fortitude")

//FORTITUDE 5
/datum/discipline_power/fortitude/five
	name = "Fortitude 5"
	desc = "Reach the pinnacle of toughness. Never fear anything again."

	level = 5

	check_flags = DISC_CHECK_CONSCIOUS

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/fortitude/one,
		/datum/discipline_power/fortitude/two,
		/datum/discipline_power/fortitude/three,
		/datum/discipline_power/fortitude/four
	)

/datum/discipline_power/fortitude/five/activate()
	. = ..()
	owner.apply_status_effect(/datum/status_effect/fortitude/five)

/datum/discipline_power/fortitude/five/deactivate()
	. = ..()
	owner.remove_status_effect(/datum/status_effect/fortitude/five)

/datum/discipline_power/fortitude/five/post_gain()
	owner.st_add_stat_mod(STAT_STAMINA, 5, "Fortitude")

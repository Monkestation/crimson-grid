/datum/discipline/celerity
	name = "Celerity"
	desc = "Boosts your speed. Violates Masquerade."
	icon_state = "celerity"
	power_type = /datum/discipline_power/celerity

/datum/discipline_power/celerity
	name = "Celerity power name"
	desc = "Celerity power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/celerity_activate.ogg'
	deactivate_sound = 'modular_darkpack/modules/powers/sounds/celerity_deactivate.ogg'

/datum/discipline_power/celerity/proc/temporis_explode(datum/source, datum/discipline_power/power, atom/target)
	SIGNAL_HANDLER

	if (!istype(power, /datum/discipline_power/temporis/patience_of_the_norns) && !istype(power, /datum/discipline_power/temporis/clothos_gift))
		return

	to_chat(owner, span_userdanger("You try to use Temporis, but your active Celerity accelerates your temporal field out of your control!"))
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "scream")
	addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon/human, gib)), 3 SECONDS)

	return POWER_CANCEL_ACTIVATION

//CELERITY 1
/datum/discipline_power/celerity/one
	name = "Celerity 1"
	desc = "Enhances your speed to make everything a little bit easier."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/two,
		/datum/discipline_power/celerity/three,
		/datum/discipline_power/celerity/four,
		/datum/discipline_power/celerity/five
	)

/datum/discipline_power/celerity/one/activate()
	. = ..()

	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	owner.apply_status_effect(/datum/status_effect/celerity/one)

/datum/discipline_power/celerity/one/deactivate()
	. = ..()

	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	owner.remove_status_effect(/datum/status_effect/celerity/one)

/datum/discipline_power/celerity/one/post_gain()
	owner.st_add_stat_mod(STAT_DEXTERITY, 1, "Celerity")

//CELERITY 2
/datum/discipline_power/celerity/two
	name = "Celerity 2"
	desc = "Significantly improves your speed and reaction time."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/one,
		/datum/discipline_power/celerity/three,
		/datum/discipline_power/celerity/four,
		/datum/discipline_power/celerity/five
	)

/datum/discipline_power/celerity/two/activate()
	. = ..()

	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	owner.apply_status_effect(/datum/status_effect/celerity/two)

/datum/discipline_power/celerity/two/deactivate()
	. = ..()

	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	owner.remove_status_effect(/datum/status_effect/celerity/two)

/datum/discipline_power/celerity/two/post_gain()
	owner.st_add_stat_mod(STAT_DEXTERITY, 2, "Celerity")

//CELERITY 3
/datum/discipline_power/celerity/three
	name = "Celerity 3"
	desc = "Move faster. React in less time. Your body is under perfect control."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/one,
		/datum/discipline_power/celerity/two,
		/datum/discipline_power/celerity/four,
		/datum/discipline_power/celerity/five
	)

/datum/discipline_power/celerity/three/activate()
	. = ..()

	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	owner.apply_status_effect(/datum/status_effect/celerity/three)

/datum/discipline_power/celerity/three/deactivate()
	. = ..()

	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	owner.remove_status_effect(/datum/status_effect/celerity/three)

/datum/discipline_power/celerity/three/post_gain()
	owner.st_add_stat_mod(STAT_DEXTERITY, 3, "Celerity")

//CELERITY 4
/datum/discipline_power/celerity/four
	name = "Celerity 4"
	desc = "Breach the limits of what is humanly possible. Move like a lightning bolt."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/one,
		/datum/discipline_power/celerity/two,
		/datum/discipline_power/celerity/three,
		/datum/discipline_power/celerity/five
	)

/datum/discipline_power/celerity/four/activate()
	. = ..()

	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	owner.apply_status_effect(/datum/status_effect/celerity/four)

/datum/discipline_power/celerity/four/deactivate()
	. = ..()

	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	owner.remove_status_effect(/datum/status_effect/celerity/four)

/datum/discipline_power/celerity/four/post_gain()
	owner.st_add_stat_mod(STAT_DEXTERITY, 4, "Celerity")

//CELERITY 5
/datum/discipline_power/celerity/five
	name = "Celerity 5"
	desc = "You are like light. Blaze your way through the world."

	check_flags = DISC_CHECK_LYING | DISC_CHECK_IMMOBILE

	toggled = TRUE
	duration_length = 2 TURNS

	grouped_powers = list(
		/datum/discipline_power/celerity/one,
		/datum/discipline_power/celerity/two,
		/datum/discipline_power/celerity/three,
		/datum/discipline_power/celerity/four
	)

/datum/discipline_power/celerity/five/activate()
	. = ..()

	RegisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION, PROC_REF(temporis_explode))
	owner.apply_status_effect(/datum/status_effect/celerity/five)

/datum/discipline_power/celerity/five/deactivate()
	. = ..()

	UnregisterSignal(owner, COMSIG_POWER_PRE_ACTIVATION)
	owner.remove_status_effect(/datum/status_effect/celerity/five)

/datum/discipline_power/celerity/five/post_gain()
	owner.st_add_stat_mod(STAT_DEXTERITY, 5, "Celerity")

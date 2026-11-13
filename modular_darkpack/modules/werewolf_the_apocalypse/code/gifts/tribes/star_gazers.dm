/datum/action/cooldown/power/gift/channeling
	name = "Channeling"
	desc = "The user burns 1 to 3 rage in exchange for that many bonus dice on there next roll."
	button_icon_state = "channeling"
	rank = 1
	rage_cost = 1
	handles_spend_resources = TRUE

/datum/action/cooldown/power/gift/channeling/Activate(atom/target)
	var/mob/living/caster = astype(owner)
	if(!caster)
		return

	var/static/list/radial_menu_options = list(
			"One" = icon('modular_darkpack/modules/werewolf_the_apocalypse/icons/gifts/tribes/bone_gnawers.dmi', "radial_one"),
			"Two" = icon('modular_darkpack/modules/werewolf_the_apocalypse/icons/gifts/tribes/bone_gnawers.dmi', "radial_two"),
			"Three" = icon('modular_darkpack/modules/werewolf_the_apocalypse/icons/gifts/tribes/bone_gnawers.dmi', "radial_three"),
		)

	var/pick = show_radial_menu(owner, owner, radial_menu_options)
	if(!pick)
		return

	. = ..()

	rage_cost = word_to_int(pick)

	if(can_afford(TRUE))
		spend_resources()
		caster.apply_status_effect(/datum/status_effect/channeling, rage_cost)

	rage_cost = 1
	return TRUE

/datum/status_effect/channeling
	id = "channeling"
	duration = STATUS_EFFECT_PERMANENT

	status_type = STATUS_EFFECT_UNIQUE

	alert_type = /atom/movable/screen/alert/status_effect/gift/channeling
	/// Passed in by the gift's activate
	var/value

/datum/status_effect/channeling/on_creation(mob/living/owner, value)
	src.value = value
	RegisterSignal(owner, COMSIG_LIVING_PRE_DICE_ROLLED, PROC_REF(on_dice_rolled))
	return ..()

/datum/status_effect/channeling/proc/on_dice_rolled(mob/living/roller, datum/storyteller_roll/roll_datum, atom/target, atom/using_item, bonus, difficulty)
	SIGNAL_HANDLER

	*bonus += value

	qdel(src)

/datum/status_effect/channeling/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_PRE_DICE_ROLLED)

/atom/movable/screen/alert/status_effect/gift/channeling
	name = /datum/action/cooldown/power/gift/channeling::name
	desc = "Your next roll will will get extra dice added to that roll"
	overlay_state = /datum/action/cooldown/power/gift/channeling::button_icon_state

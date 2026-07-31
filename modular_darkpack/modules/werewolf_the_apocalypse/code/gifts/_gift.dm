// Presently a dummy placeholder, might want to do stuff like flavor the ui, change the dice roll, make gifts private by default or the like
/datum/storyteller_roll/gift

/datum/action/cooldown/power/gift
	abstract_type = /datum/action/cooldown/power/gift
	background_icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/werewolf_abilities.dmi'
	background_icon_state = "bg_gift"
	button_icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/werewolf_abilities.dmi'
	//button_icon_state = ""
	overlay_icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/werewolf_abilities.dmi'

	check_flags = AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS

	var/rage_cost = 0
	var/gnosis_cost = 0

/datum/action/cooldown/power/gift/IsAvailable(feedback)
	. = ..()

	var/datum/splat/werewolf/casting_splat = get_werewolf_splat(owner)
	if(!casting_splat)
		if(feedback)
			owner.balloon_alert(owner, "not a gift user!")
		return FALSE

/datum/action/cooldown/power/gift/can_afford(feedback)
	. = ..()
	var/datum/splat/werewolf/casting_splat = get_werewolf_splat(owner)

	if(get_rage_cost())
		if(!casting_splat)
			return FALSE
		if(casting_splat.rage < get_rage_cost())
			if(feedback)
				to_chat(owner, span_warning("You don't have enough <b>RAGE</b> to do that!"))
				SEND_SOUND(owner, sound('modular_darkpack/modules/werewolf_the_apocalypse/sounds/werewolf_cast_failed.ogg', volume = 50))
			return FALSE
	if(gnosis_cost)
		if(!casting_splat)
			return FALSE
		if(casting_splat.gnosis < gnosis_cost)
			if(feedback)
				to_chat(owner, span_warning("You don't have enough <b>GNOSIS</b> to do that!"))
				SEND_SOUND(owner, sound('modular_darkpack/modules/werewolf_the_apocalypse/sounds/werewolf_cast_failed.ogg', volume = 50))
			return FALSE

/datum/action/cooldown/power/gift/spend_resources()
	. = ..()
	var/datum/splat/werewolf/casting_splat = get_werewolf_splat(owner)
	if(get_rage_cost())
		casting_splat?.adjust_rage(-get_rage_cost(), owner, FALSE)
	if(get_gnosis_cost())
		casting_splat?.adjust_gnosis(-get_gnosis_cost(), owner, FALSE)


/datum/action/cooldown/power/gift/proc/get_rage_cost()
	return rage_cost

/datum/action/cooldown/power/gift/proc/get_gnosis_cost()
	return gnosis_cost


/atom/movable/screen/alert/status_effect/gift
	icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/werewolf_abilities.dmi'
	icon_state = "bg_gift"
	overlay_icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/werewolf_abilities.dmi'

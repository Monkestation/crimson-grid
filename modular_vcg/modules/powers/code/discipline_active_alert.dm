/atom/movable/screen/alert/discipline_active
	clickable_glow = TRUE
	var/datum/weakref/power_ref

/atom/movable/screen/alert/discipline_active/proc/set_power(datum/discipline_power/power)
	if(!power?.discipline)
		return

	power_ref = WEAKREF(power)
	name = "[power.name] Active"
	desc = "Drawing on your blood to stay active. Click to switch it off."
	icon = power.discipline.icon
	icon_state = power.discipline.icon_state

/atom/movable/screen/alert/discipline_active/Click(location, control, params)
	. = ..()
	if(!.)
		return

	var/datum/discipline_power/power = power_ref?.resolve()
	if(!power)
		return

	power.try_deactivate(direct = TRUE, alert = TRUE)

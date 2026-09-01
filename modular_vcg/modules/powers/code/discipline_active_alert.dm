/atom/movable/screen/alert/discipline_active

/atom/movable/screen/alert/discipline_active/proc/set_power(datum/discipline_power/power)
	if(!power?.discipline)
		return

	name = "[power.name] Active"
	desc = "Drawing on your blood to stay active."
	icon = power.discipline.icon
	icon_state = power.discipline.icon_state

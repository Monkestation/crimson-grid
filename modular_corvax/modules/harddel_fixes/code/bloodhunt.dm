/datum/controller/subsystem/bloodhunt/proc/forget_hunted(datum/source)
	SIGNAL_HANDLER
	hunted -= source
	update_alert()

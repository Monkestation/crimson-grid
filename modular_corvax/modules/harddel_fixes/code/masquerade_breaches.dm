/datum/controller/subsystem/masquerade/proc/track_breach_party(datum/party)
	if(istype(party))
		RegisterSignal(party, COMSIG_QDELETING, PROC_REF(forget_breach_party), override = TRUE)

/// Breach records kept deleted breachers and witnesses alive, so they could only be hard deleted
/datum/controller/subsystem/masquerade/proc/forget_breach_party(datum/source)
	SIGNAL_HANDLER
	for(var/list/breach as anything in masquerade_breachers.Copy())
		var/witnesses = breach[2]
		if(breach[1] == source || witnesses == source)
			masquerade_breachers -= list(breach)
		else if(islist(witnesses))
			var/list/witness_list = witnesses
			witness_list -= source
			if(!length(witness_list))
				masquerade_breachers -= list(breach)
	GLOB.masquerade_breakers_list -= source
	GLOB.veil_breakers_list -= source
	GLOB.supernatural_breakers_list -= source

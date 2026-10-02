
/*
* Ultra lazy way to restrict police records console to only police members
* TODO: Change security records login function to use an actual username and password
*/
/datum/memory/key/police_login
	memory_flags = MEMORY_FLAG_NOMOOD|MEMORY_FLAG_NOLOCATION|MEMORY_FLAG_NOPERSISTENCE|MEMORY_SKIP_UNCONSCIOUS|MEMORY_NO_STORY

/datum/memory/key/police_login/get_names()
	return list("My login information for the CLETS computer network.")

/// Secure login
/obj/machinery/computer/records/security/allowed(mob/accessor)
	var/list/user_memories = accessor.mind?.memories
	if(user_memories && user_memories[/datum/memory/key/police_login])
		return TRUE
	. = ..()

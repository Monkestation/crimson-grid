/mob/proc/start_blood_hunt(reason)
	SSbloodhunt.hunted |= src
	SSbloodhunt.RegisterSignal(src, COMSIG_QDELETING, TYPE_PROC_REF(/datum/controller/subsystem/bloodhunt, forget_hunted), override = TRUE) // CORVAX EDIT ADD
	ADD_TRAIT(src, TRAIT_HUNTED, "bloodhunt")
	SSbloodhunt.update_alert()
	for(var/player_mob in GLOB.kindred_list)
		to_chat(player_mob, span_bold("Объявлена Кровавая Охота: [span_warning("[real_name]")] вне закона! <br>Причина: [reason]"))
		SEND_SOUND(player_mob, sound('modular_darkpack/master_files/sounds/announce.ogg'))


/mob/proc/clear_blood_hunt()
	SSbloodhunt.hunted -= src
	SSbloodhunt.UnregisterSignal(src, COMSIG_QDELETING) // CORVAX EDIT ADD
	REMOVE_TRAIT(src, TRAIT_HUNTED, "bloodhunt")
	SSbloodhunt.update_alert()
	for(var/player_mob in GLOB.kindred_list)
		to_chat(player_mob, span_bold("Кровавая Охота завершена: [span_green("[real_name]")] больше не в списке!"))
		SEND_SOUND(player_mob, sound('modular_darkpack/master_files/sounds/announce.ogg'))

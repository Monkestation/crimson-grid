/mob/living/proc/AdjustMasquerade(value, reason = "debug")
	if(ismundane(src))
		return

	switch(value)
		if(1)
			SSmasquerade.masquerade_reinforce(null, src, reason)
		if(-1)
			SSmasquerade.masquerade_breach(null, src, reason)

ADMIN_VERB(cure_breach, R_FUN, "Cure Masquerade Breach", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN)
	VERB_ARG_TYPED(breached_player, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob/living)
	var/list/breaches = list()
	for(var/list/masquerade_breach in SSmasquerade.masquerade_breachers)
		if(masquerade_breach[1] != breached_player)
			continue
		breaches += masquerade_breach[2]
	var/atom/chosen_breach_to_restore = tgui_input_list(user, "Cure Masquerade Breach", "Choose a breach source to cure", breaches)
	if(!chosen_breach_to_restore)
		return
	SEND_SIGNAL(chosen_breach_to_restore, COMSIG_MASQUERADE_REINFORCE, breached_player)

ADMIN_VERB(cure_all_breaches, R_FUN, "Cure All Masquerade Breaches", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN)
	VERB_ARG_TYPED(breached_player, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob/living)
	for(var/list/masquerade_breach in SSmasquerade.masquerade_breachers)
		if(masquerade_breach[1] != breached_player)
			continue
		var/atom/masquerade_breach_source = masquerade_breach[2]
		SEND_SIGNAL(masquerade_breach_source, COMSIG_MASQUERADE_REINFORCE, breached_player)

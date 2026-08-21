/mob/living/proc/AdjustMasquerade(value, reason = "debug")
	if(ismundane(src))
		return

	switch(value)
		if(1)
			SSmasquerade.masquerade_reinforce(null, src, reason)
		if(-1)
			SSmasquerade.masquerade_breach(null, src, reason)

//admin_verbs.dm for cure_breach and cure_all_breaches admin verbs

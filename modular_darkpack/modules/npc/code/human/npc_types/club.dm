/mob/living/carbon/human/npc/walkby/club
	staying = TRUE

/mob/living/carbon/human/npc/walkby/club/Life()
	. = ..()

	if (!staying || stat >= UNCONSCIOUS)
		return
	if (!prob(5))
		return

	INVOKE_ASYNC(src, PROC_REF(dance_at_jukebox))

/mob/living/carbon/human/npc/walkby/club/proc/dance_at_jukebox()
	var/hasjukebox = FALSE
	for (var/obj/machinery/jukebox/jukebox in range(5, src))
		hasjukebox = TRUE

		// Hacky check for if it's currently playing
		if (jukebox.static_power_usage != ACTIVE_POWER_USE)
			continue
		if (prob(50))
			dancefirst(src)
		else
			dancesecond(src)

	if (!hasjukebox)
		staying = FALSE

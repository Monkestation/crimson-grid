/obj/ritual_rune/thaumaturgy/blood_guardian
	name = "blood imp"
	desc = "thaumaturgists sometimes have need of a laboratory assistant or two to help them in their work or defenses of the Chantry. This ritual animates a humanoid made from the blood of the creator."
	icon_state = "rune1"
	word = "UR'JOLA"
	level = 3
	cost = 5

/obj/ritual_rune/thaumaturgy/blood_guardian/complete()
	. = ..()
	var/mob/living/carbon/human/H = last_activator
	H.add_beastmaster_minion(/mob/living/basic/blood_guard)
	if(length(H.beastmaster_minions) > 3+H.st_get_stat(STAT_LEADERSHIP))
		var/mob/living/basic/blood_guard/B = pick(H.beastmaster_minions)
		B.death()
	qdel(src)


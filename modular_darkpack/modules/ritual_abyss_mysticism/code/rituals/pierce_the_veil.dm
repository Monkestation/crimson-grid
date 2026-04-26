/obj/ritual_rune/abyss/pierce_the_veil
	name = "pierce the veil"
	desc = "Through the use of this ritual and by creating orbs of shadow in your hand and staring into them, your eyes turn a deep, abyssal black, giving you Darksight."
	icon_state = "rune9"
	word = "Shadow encase my sight."
	cost = 1
	level = 1

/obj/ritual_rune/abyss/pierce_the_veil/complete()
	. = ..()
	var/mob/living/carbon/human/H = last_activator
	ADD_TRAIT(H, TRAIT_TRUE_NIGHT_VISION, "pierce_the_veil")
	ADD_TRAIT(H, TRAIT_MASQUERADE_VIOLATING_EYES, "pierce_the_veil")
	to_chat(H, span_notice("Darkness floods your vision, then recedes - you can see clearly through the shadows now."))
	H.update_sight()
	qdel(src)

/obj/ritual_rune/abyss/pierce_the_veil/ritual_failure()
	. = ..()
	to_chat(last_activator, span_warning("The shadows slip through your fingers..."))
	qdel(src)

/obj/ritual_rune/abyss/pierce_the_veil/ritual_botch()
	. = ..()
	var/mob/living/carbon/human/H = last_activator
	H.become_blind("pierce_the_veil_botch")
	to_chat(H, span_userdanger("Darkness overwhelmes your vision as you mess up the ritual, causing temporary blindness!"))
	addtimer(CALLBACK(src, PROC_REF(cure_botch), H), 2 MINUTES)
	qdel(src)

/obj/ritual_rune/abyss/pierce_the_veil/proc/cure_botch(mob/living/carbon/human/H)
	if(QDELETED(H))
		return
	H.cure_blind("pierce_the_veil_botch")
	to_chat(H, span_notice("Your vision slowly returns."))

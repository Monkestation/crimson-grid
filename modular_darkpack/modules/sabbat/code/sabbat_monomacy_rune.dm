#define MONOMACY_COOLDOWN_DURATION (10 MINUTES)

/obj/sabbatrune
	name = "Monomacy Rune"
	desc = "Monomacy is the rite of resolving disputes among pack mates. Challenge that curr to a duel!"
	icon = 'modular_darkpack/modules/deprecated/icons/icons.dmi'
	icon_state = "rune9"
	color = rgb(64, 64, 64)
	anchored = TRUE
	var/activated = FALSE
	var/mob/living/last_activator
	var/list/sacrifices = list()
	var/MONOMACY_CHALLENGE_COOLDOWN

/obj/sabbatrune/attack_hand(mob/living/user)
	. = ..()

	if(!is_sabbatist(user.mind.assigned_role))
		to_chat(user, span_warning("You do not understand the power of this rune."))
		return

	if(!COOLDOWN_FINISHED(src, MONOMACY_CHALLENGE_COOLDOWN))
		to_chat(user, span_warning("The rune is still cooling down from the last challenge."))
		return

	last_activator = user
	issue_challenge(user)

/obj/sabbatrune/proc/issue_challenge(mob/living/challenger)
	var/challenged_name = tgui_input_text(challenger, "Enter the name of the person you wish to challenge to Monomacy:", "Monomacy Challenge")
	if(!challenged_name)
		return

	var/mob/living/target = null
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		// if the target is not dead, is the challenger isnt targeting themselves, if the target is a sabbatist, and if one of the name datums match the name input
		if(H.stat != DEAD && H != challenger && is_sabbatist(H.mind?.assigned_role) && (findtext(H.real_name, challenged_name) || findtext(H.name, challenged_name)))
			target = H

	if(!target)
		to_chat(challenger, span_cult("Could not find anyone with that name to challenge! Only members of the Sabbat may engage in Monomacy."))
		return


	to_chat(challenger, span_cult("You have challenged [target.real_name] to a duel of Monomacy!"))
	SEND_SOUND(challenger, sound('modular_darkpack/master_files/sounds/announce.ogg'))

	to_chat(target, span_cult("[challenger.real_name] challenges you to a duel of Monomacy! Return to the lair at once!"))
	SEND_SOUND(target, sound('modular_darkpack/master_files/sounds/announce.ogg'))

	for(var/mob/living/carbon/human/M in viewers(7, src))
		if(M != challenger && M != target)
			to_chat(M, span_cult("[challenger.real_name] has challenged [target.real_name] to a duel of Monomacy!"))
			SEND_SOUND(M, sound('modular_darkpack/master_files/sounds/announce.ogg'))

	for(var/mob/living/carbon/human/priest in GLOB.player_list)
		if(is_sabbat_priest(priest))
			to_chat(priest, span_cult("[challenger.real_name] has challenged [target.real_name] to a duel of Monomacy! Return to the lair at once to ensure Caine's will is done."))
			SEND_SOUND(priest, sound('modular_darkpack/master_files/sounds/announce.ogg'))

	animate(src, color = rgb(192, 192, 192), time = 2)
	animate(color = rgb(64, 64, 64), time = 3)
	playsound(src, 'sound/effects/magic/smoke.ogg', 20, TRUE)

	COOLDOWN_START(src, MONOMACY_CHALLENGE_COOLDOWN, MONOMACY_COOLDOWN_DURATION)

	log_game("[key_name(challenger)] has challenged [key_name(target)] to Monomacy via sabbatrune.")

#undef MONOMACY_COOLDOWN_DURATION

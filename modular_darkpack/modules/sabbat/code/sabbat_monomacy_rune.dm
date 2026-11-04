#define MONOMACY_COOLDOWN_DURATION (10 MINUTES)

/obj/sabbatrune
	name = "Monomacy Rune"
	desc = "Мономахия - обряд, которым в стае решают споры. Вызовите эту шавку на поединок!"
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
		to_chat(user, span_warning("Сила этой руны вам непонятна."))
		return

	if(!COOLDOWN_FINISHED(src, MONOMACY_CHALLENGE_COOLDOWN))
		to_chat(user, span_warning("Руна ещё не остыла после прошлого вызова."))
		return

	remember_activator(user) // CORVAX EDIT CHANGE - ORIGINAL: last_activator = user
	issue_challenge(user)

/obj/sabbatrune/proc/issue_challenge(mob/living/challenger)
	var/challenged_name = tgui_input_text(challenger, "Назовите имя того, кого вызываете на Мономахию:", "Вызов на Мономахию")
	if(!challenged_name)
		return

	var/mob/living/target = null
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		// if the target is not dead, is the challenger isnt targeting themselves, if the target is a sabbatist, and if one of the name datums match the name input
		if(H.stat != DEAD && H != challenger && is_sabbatist(H.mind?.assigned_role) && (findtext(H.real_name, challenged_name) || findtext(H.name, challenged_name)))
			target = H

	if(!target)
		to_chat(challenger, span_cult("Вызывать некого: никого с таким именем не нашлось! Сходиться в Мономахии могут только члены Шабаша."))
		return


	to_chat(challenger, span_cult("[target.real_name] получает ваш вызов на Мономахию!"))
	SEND_SOUND(challenger, sound('modular_darkpack/master_files/sounds/announce.ogg'))

	to_chat(target, span_cult("[challenger.real_name] вызывает вас на Мономахию! Немедленно возвращайтесь в логово!"))
	SEND_SOUND(target, sound('modular_darkpack/master_files/sounds/announce.ogg'))

	for(var/mob/living/carbon/human/M in viewers(7, src))
		if(M != challenger && M != target)
			to_chat(M, span_cult("Вызов на Мономахию! Бросает [challenger.real_name], отвечает [target.real_name]!"))
			SEND_SOUND(M, sound('modular_darkpack/master_files/sounds/announce.ogg'))

	for(var/mob/living/carbon/human/priest in GLOB.player_list)
		if(is_sabbat_priest(priest))
			to_chat(priest, span_cult("Вызов на Мономахию! Бросает [challenger.real_name], отвечает [target.real_name]! Немедленно возвращайтесь в логово и проследите, чтобы свершилась воля Каина."))
			SEND_SOUND(priest, sound('modular_darkpack/master_files/sounds/announce.ogg'))

	animate(src, color = rgb(192, 192, 192), time = 2)
	animate(color = rgb(64, 64, 64), time = 3)
	playsound(src, 'sound/effects/magic/smoke.ogg', 20, TRUE)

	COOLDOWN_START(src, MONOMACY_CHALLENGE_COOLDOWN, MONOMACY_COOLDOWN_DURATION)

	log_game("[key_name(challenger)] has challenged [key_name(target)] to Monomacy via sabbatrune.")

#undef MONOMACY_COOLDOWN_DURATION

/obj/ritual_rune/necromancy/zombie
	name = "daemonic possession"
	ru_name = "Потусторонняя одержимость"
	desc = "Вселяет призрака в мёртвое тело и поднимает его разумным зомби."
	icon_state = "rune7"
	word = "GI'TI FOA'HP"
	level = 5
	var/duration_length = 15 SECONDS

/obj/ritual_rune/necromancy/zombie/complete()

	var/list/valid_bodies = list()

	for(var/mob/living/carbon/human/targetbody in loc)
		if(targetbody == usr)
			to_chat(usr, span_warning("Этот ритуал нельзя провести над самим собой."))
			return
		else if(targetbody.stat == DEAD)
			valid_bodies += targetbody
		else
			to_chat(usr, span_warning("Цель ещё жива!"))
			return

	if(valid_bodies.len < 1)
		to_chat(usr, span_warning("Здесь нет тела, пригодного для этого ритуала."))
		return

	usr.visible_message(span_notice("[capitalize(usr.declent_ru(NOMINATIVE))] начинает нараспев читать что-то на мерзких наречиях..."), span_notice("Вы начинаете ритуал воскрешения."))
	playsound(loc, 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy2.ogg', 50, FALSE)

	if(do_after(usr, duration_length, usr))

		activated = TRUE
		remember_activator(usr) // CORVAX EDIT CHANGE - ORIGINAL: last_activator = usr

		var/mob/living/target_body = pick(valid_bodies)

		var/old_name = target_body.real_name

		// Transform the body into a zombie
		if(!target_body || QDELETED(target_body) || target_body.stat > DEAD)
			return

		// Remove any vampiric actions
		for(var/datum/action/A in target_body.actions)
			if(A.vampiric)
				A.Remove(target_body)

		var/original_location = get_turf(target_body)

		// Revive the specimen and turn them into a zombie
		target_body.revive(HEAL_ALL)
		target_body.apply_status_effect(/datum/status_effect/zombie)
		target_body.real_name = old_name // the ritual for some reason is deleting their old name and replacing it with a random name.
		target_body.name = old_name
		target_body.update_name()

		if(target_body.loc != original_location)
			target_body.forceMove(original_location)

		playsound(loc, 'modular_darkpack/modules/powers/sounds/necromancy.ogg', 50, FALSE)

		// Handle key assignment
		if(!target_body.key)
			target_body.AddComponent(\
				/datum/component/ghost_direct_control,\
				poll_candidates = TRUE,\
				role_name = "разумного зомби",\
				poll_length = 30 SECONDS,\
				assumed_control_message = "Вы - разумный зомби: призрак, которому хозяин милостиво позволил вселиться в чужую плоть. Служите ему верно и наслаждайтесь вкусом жизни, которую у вас отняли.",\
				after_assumed_control = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(necromancy_zombie_possessed), target_body),\
			)
			qdel(src)
			return

		target_body.visible_message(span_ghostalert("[capitalize(target_body.declent_ru(NOMINATIVE))] вздрагивает и пробуждается к не-жизни!"))
		qdel(src)

// CORVAX EDIT CHANGE START - the callback kept the deleted rune alive until someone took the body. ORIGINAL: rune procs on_zombie_possess and ask_zombie_name
/proc/necromancy_zombie_possessed(mob/living/carbon/human/zombie)
	zombie.visible_message(span_ghostalert("В труп вселяется призрак: [zombie.declent_ru(NOMINATIVE)] вздрагивает и пробуждается к не-жизни!"))
	necromancy_ask_zombie_name(zombie)

/proc/necromancy_ask_zombie_name(mob/living/carbon/human/zombie)
// CORVAX EDIT CHANGE END
	var/choice = tgui_alert(zombie, "Хотите выбрать себе новое имя зомби?", "Имя зомби", list("Да", "Нет"), 10 SECONDS)
	if(choice == "Да")
		var/chosen_zombie_name = tgui_input_text(zombie, "Каким будет ваше новое имя?", "Имя зомби")
		if(chosen_zombie_name)
			zombie.real_name = chosen_zombie_name
			zombie.name = chosen_zombie_name
			zombie.update_name()
	else
		return

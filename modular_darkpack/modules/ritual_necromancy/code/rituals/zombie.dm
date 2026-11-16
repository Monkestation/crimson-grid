/obj/ritual_rune/necromancy/zombie
	name = "daemonic possession"
	desc = "Place a wraith inside of a dead body and raise it as a sentient zombie."
	icon_state = "rune7"
	word = "GI'TI FOA'HP"
	level = 5
	var/duration_length = 15 SECONDS

/obj/ritual_rune/necromancy/zombie/complete()

	var/list/valid_bodies = list()

	for(var/mob/living/carbon/human/targetbody in loc)
		if(targetbody == usr)
			to_chat(usr, span_warning("You cannot invoke this ritual upon yourself."))
			return
		else if(targetbody.stat == DEAD)
			valid_bodies += targetbody
		else
			to_chat(usr, span_warning("The target lives still!"))
			return

	if(valid_bodies.len < 1)
		to_chat(usr, span_warning("There is no body that can undergo this Ritual."))
		return

	usr.visible_message(span_notice("[usr] begins chanting in vile tongues..."), span_notice("You begin the resurrection ritual."))
	playsound(loc, 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy2.ogg', 50, FALSE)

	if(do_after(usr, duration_length, usr))

		activated = TRUE
		last_activator = usr

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
				role_name = "a Sentient Zombie",\
				poll_length = 30 SECONDS,\
				assumed_control_message = "You are a Sentient Zombie, a Wraith who has been mercifully granted a skinride by your master. Serve them well, and enjoy your taste of a life taken from you.",\
				after_assumed_control = CALLBACK(src, PROC_REF(on_zombie_possess), target_body),\
			)
			qdel(src)
			return

		target_body.visible_message(span_ghostalert("[target_body.name] twitches to unlife!"))
		qdel(src)

/obj/ritual_rune/necromancy/zombie/proc/on_zombie_possess(mob/living/carbon/human/zombie)
	zombie.visible_message(span_ghostalert("A Wraith posesses the corpse, [zombie.name] twitches to unlife!"))
	ask_zombie_name(zombie)
	qdel(src)

/obj/ritual_rune/necromancy/zombie/proc/ask_zombie_name(mob/living/carbon/human/zombie)
	var/choice = tgui_alert(zombie, "Do you want to pick a new name as a Zombie?", "Zombie Choose Name", list("Yes", "No"), 10 SECONDS)
	if(choice == "Yes")
		var/chosen_zombie_name = tgui_input_text(zombie, "What is your new name as a Zombie?", "Zombie Name Input")
		if(chosen_zombie_name)
			zombie.real_name = chosen_zombie_name
			zombie.name = chosen_zombie_name
			zombie.update_name()
	else
		return

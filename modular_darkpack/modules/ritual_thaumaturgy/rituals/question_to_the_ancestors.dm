/obj/ritual_rune/thaumaturgy/question
	name = "question to the ancestors"
	desc = "Summon souls from the dead. Ask a question and get answers. Requires a bloodpack."
	icon_state = "rune5"
	word = "VOCA-ANI'MA"
	level = 3
	sacrifices = list(/obj/item/reagent_containers/blood)

/mob/living/basic/ghost/tremere
	maxHealth = 1
	health = 1
	melee_damage_lower = 1
	melee_damage_upper = 1
	faction = list(VAMPIRE_CLAN_TREMERE)
	icon = 'modular_darkpack/modules/npc/icons/necromancy_zombies.dmi'
	icon_state = "ghost_animated"
	icon_living = "ghost_animated"

/obj/ritual_rune/thaumaturgy/question/complete()
	. = ..()
	var/text_question = tgui_input_text(usr, "Enter your question to the Ancestors:", "Question to Ancestors")
	if(!text_question)
		return

	visible_message(span_notice("A call rings out to the dead from the [src.name] rune..."))

	var/mob/living/basic/ghost/tremere/TR = new(loc)

	TR.AddComponent(\
		/datum/component/ghost_direct_control,\
		poll_candidates = TRUE,\
		role_name = "an Ancestor Spirit",\
		poll_length = 30 SECONDS,\
		poll_question = "Do you wish to answer a question?\nThe question is: [text_question]",\
		assumed_control_message = "You are an Ancestor Spirit summoned to answer: [text_question]",\
		after_assumed_control = CALLBACK(src, PROC_REF(ghost_name_prompt), TR)\
	)

	qdel(src)

/obj/ritual_rune/thaumaturgy/question/proc/ghost_name_prompt(mob/living/basic/ghost/tremere/ghost_mob)
	message_admins("[key_name_admin(ghost_mob)] has become a Tremere Ghost.")

	var/choice = tgui_alert(ghost_mob, "Do you want to pick a new name as a Ghost?", "Ghost Choose Name", list("Yes", "No"), 10 SECONDS)
	if(choice == "Yes")
		var/chosen_ghost_name = tgui_input_text(ghost_mob, "What is your new name as a Ghost?", "Ghost Name Input")
		if(chosen_ghost_name)
			ghost_mob.real_name = chosen_ghost_name
			ghost_mob.name = chosen_ghost_name

	//poll_ignore_key = POLL_IGNORE_ANCESTOR_SPIRIT,

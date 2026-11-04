/obj/ritual_rune/thaumaturgy/question
	name = "question to the ancestors"
	ru_name = "Вопрос предкам"
	desc = "Призывает душу умершего. Задайте вопрос и получите ответ. Требуется пакет с кровью."
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
	var/text_question = tgui_input_text(usr, "Задайте вопрос предкам:", "Вопрос предкам")
	if(!text_question)
		return

	visible_message(span_notice("От руны к мёртвым уносится зов..."))

	var/mob/living/basic/ghost/tremere/TR = new(loc)

	TR.AddComponent(\
		/datum/component/ghost_direct_control,\
		poll_candidates = TRUE,\
		role_name = "духа предка",\
		poll_length = 30 SECONDS,\
		poll_question = "Хотите ответить на вопрос?\nВопрос: [text_question]",\
		assumed_control_message = "Вы - дух предка, призванный ответить на вопрос: [text_question]",\
		after_assumed_control = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(ancestor_ghost_name_prompt), TR)\
	)

	qdel(src)

// CORVAX EDIT CHANGE - the callback kept the deleted rune alive until someone took the ghost. ORIGINAL: /obj/ritual_rune/thaumaturgy/question/proc/ghost_name_prompt(mob/living/basic/ghost/tremere/ghost_mob)
/proc/ancestor_ghost_name_prompt(mob/living/basic/ghost/tremere/ghost_mob)
	message_admins("[key_name_admin(ghost_mob)] has become a Tremere Ghost.")

	var/choice = tgui_alert(ghost_mob, "Хотите выбрать себе новое имя призрака?", "Имя призрака", list("Да", "Нет"), 10 SECONDS)
	if(choice == "Да")
		var/chosen_ghost_name = tgui_input_text(ghost_mob, "Каким будет ваше новое имя?", "Имя призрака")
		if(chosen_ghost_name)
			ghost_mob.ru_names_rename(null)
			ghost_mob.real_name = chosen_ghost_name
			ghost_mob.name = chosen_ghost_name

	//poll_ignore_key = POLL_IGNORE_ANCESTOR_SPIRIT,

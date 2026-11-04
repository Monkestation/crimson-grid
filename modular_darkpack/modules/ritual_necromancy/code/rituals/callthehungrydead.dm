/obj/ritual_rune/necromancy/question //No bloodpack requirement, but the wraiths aren't implied to owe answers.
	name = "call the hungry dead"
	ru_name = "Зов голодных мертвецов"
	desc = "Призывает из Земель Теней призрака для беседы."
	icon_state = "rune4"
	word = "METEH' GHM'IEN"
	level = 2

/mob/living/basic/ghost/giovanni
	maxHealth = 100 //Can be annoying right back if they're pestered for nothing.
	health = 100
	melee_damage_lower = 30
	melee_damage_upper = 30
	faction = list(VAMPIRE_CLAN_GIOVANNI)

/obj/ritual_rune/necromancy/question/complete()
	var/text_question = tgui_input_text(last_activator, "Обратитесь к призракам:", "Зов голодных мертвецов", encode = FALSE)
	visible_message(span_notice("От руны к мёртвым уносится зов..."))
	var/mob/living/basic/ghost/TR = new(loc)
	TR.AddComponent(\
		/datum/component/ghost_direct_control,\
		poll_candidates = TRUE,\
		role_name = "связанного призрака",\
		poll_length = 30 SECONDS,\
		poll_question = "Хотите поговорить с некромантом?\nЕго призыв: [text_question]",\
		assumed_control_message = "Вы - призрак, которого призвал некромант: [text_question]",\
		after_assumed_control = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(necromancy_ghost_name_prompt), TR)\
	)
	//TR.key = TR.key
	//TR.name = TR.name
	playsound(loc, 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy2.ogg', 50, FALSE)
	visible_message(span_notice("Над руной медленно проступает [TR.declent_ru(NOMINATIVE)]..."))
	qdel(src)

// CORVAX EDIT CHANGE - the callback kept the deleted rune alive until someone took the ghost. ORIGINAL: /obj/ritual_rune/necromancy/question/proc/ghost_name_prompt(mob/living/basic/ghost/tremere/ghost_mob)
/proc/necromancy_ghost_name_prompt(mob/living/basic/ghost/tremere/ghost_mob)
	message_admins("[key_name_admin(ghost_mob)] has become a Bound Wraith.")

	var/choice = tgui_alert(ghost_mob, "Хотите выбрать себе новое имя призрака?", "Имя призрака", list("Да", "Нет"), 10 SECONDS)
	if(choice == "Да")
		var/chosen_ghost_name = tgui_input_text(ghost_mob, "Каким будет ваше новое имя?", "Имя призрака")
		if(chosen_ghost_name)
			ghost_mob.ru_names_rename(null)
			ghost_mob.real_name = chosen_ghost_name
			ghost_mob.name = chosen_ghost_name

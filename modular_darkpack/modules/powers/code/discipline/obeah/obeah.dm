/datum/discipline/obeah
	name = "Обеа"
	desc = {"Третий глаз помогает вам исцелять и защищать.
● Биение жизни: Восприятие + Эмпатия (сложность 7)
●● Обезболивающее касание: Воля (сложность 8, если цель против)
●●● Корпоре сано: без проверки
●●●● Око пастыря: без проверки
●●●●● Менс сана: Интеллект + Эмпатия (сложность 8)"}
	icon_state = "obeah"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/obeah

/datum/discipline_power/obeah
	name = "Valeren power name"
	desc = "Valeren power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/obeah.ogg'

/datum/discipline_power/obeah/sense_vitality
	name = "Биение жизни"
	desc = "Позволяет узнать, сколько жизни осталось в цели."
	level = 1
	check_flags = DISC_CHECK_CAPABLE
	target_type = TARGET_HUMAN | TARGET_SELF
	range = 1
	cooldown_length = 3 TURNS
	duration_length = 1 TURNS
	activate_sound = null
	vitae_cost = 0
	var/successes = 0

	var/msg_creature = "" // what kinda phreak they is
	var/msg_damage = ""
	var/msg_blood = ""
	var/msg_disease = ""
	var/msg_mental = ""
	var/datum/storyteller_roll/sense_vitality/vitality_roll // defined in valeren.dm

/datum/discipline_power/obeah/sense_vitality/pre_activation_checks(mob/living/target)
	. = ..()
	if(!vitality_roll)
		vitality_roll = new()
	successes = vitality_roll.st_roll(owner, target)
	if(successes >= 1)
		return TRUE
	else
		return FALSE

/datum/discipline_power/obeah/sense_vitality/proc/blood_read(mob/living/carbon/human/target)
	var/blood_volume = target.get_blood_volume(apply_modifiers = TRUE)
	switch(blood_volume)
		if(BLOOD_VOLUME_EXCESS to INFINITY)
			return "Вены вздуты так, что вот-вот лопнут."
		if(BLOOD_VOLUME_MAXIMUM to BLOOD_VOLUME_EXCESS)
			return "Тело сильно переполнено кровью."
		if(BLOOD_VOLUME_SAFE to BLOOD_VOLUME_MAXIMUM)
			return "Крови в теле в достатке."
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			return "Крови меньше нормы."
		if(BLOOD_VOLUME_RISKY to BLOOD_VOLUME_OKAY)
			return "Крови опасно мало."
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_RISKY)
			return "Крови критически мало."
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			return "Крови почти не осталось. Без немедленной помощи смерть уже близка."
		else
			return "Тело полностью обескровлено."

/datum/discipline_power/obeah/sense_vitality/proc/damage_severity(damage)
	if(damage < 30)
		return "слабые"
	if(damage < 50)
		return "умеренные"
	return "сильные"

/datum/discipline_power/obeah/sense_vitality/ui_state(mob/user)
	return GLOB.always_state

/datum/discipline_power/obeah/sense_vitality/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	var/datum/asset/valeren_files = get_asset_datum(/datum/asset/simple/valeren_assets)
	if(user.client)
		valeren_files.send(user.client)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new /datum/tgui(user, src, "Valeren")
		ui.open()

/datum/discipline_power/obeah/sense_vitality/ui_data(mob/living/user)
	var/list/data = list()
	data["creature"] = msg_creature
	data["damage"] = msg_damage
	data["blood"] = msg_blood
	data["disease"] = msg_disease
	data["mental"] = msg_mental
	return data

/datum/discipline_power/obeah/sense_vitality/activate(mob/living/target)
	. = ..()
	msg_creature = ""
	msg_damage = ""
	msg_blood = ""
	msg_disease = ""
	msg_mental = ""

	// on one success, identify their splat
	var/creature_type = "из смертных"
	if(get_kindred_splat(target))
		creature_type = "из Сородичей"
	else if(get_ghoul_splat(target))
		creature_type = "из гулей"
	else if(isavatar(target) || isobserver(target)) // because salubri spend all their time in the clinic anyway. they'll use this on ghosts
		creature_type = "из призраков"
	msg_creature = "[capitalize(target.declent_ru(NOMINATIVE))] - [creature_type]."

	// on two successes, identify their damage
	if(successes >= 2)
		var/brute = target.get_brute_loss()
		var/burn = target.get_fire_loss()
		var/tox = target.get_tox_loss()
		var/oxy = target.get_oxy_loss()
		var/agg = target.get_agg_loss()
		var/list/damage_parts = list()
		if(brute > 0)
			damage_parts += "[damage_severity(brute)] ушибы"
		if(burn > 0)
			damage_parts += "[damage_severity(burn)] ожоги"
		if(tox > 0)
			damage_parts += "[damage_severity(tox)] следы отравления"
		if(oxy > 0)
			damage_parts += "[damage_severity(oxy)] признаки удушья"
		if(agg > 0)
			damage_parts += "[damage_severity(agg)] сверхъестественные раны"
		msg_damage = length(damage_parts) ? "На теле [english_list(damage_parts)]." : "Повреждений не видно."

	// on three successes, detect their bloodpool, if any exists
	if(successes >= 3)
		msg_blood = "[blood_read(target)] Запас крови: осталось [round(target.bloodpool / target.maxbloodpool * 100)]%."

	// on four, display any diseases they might have
	if(successes >= 4)
		var/list/datum/disease/diseases = target.get_static_viruses()
		if(LAZYLEN(diseases))
			var/list/disease_names = list()
			for(var/datum/disease/D in diseases)
				disease_names += D.name
			msg_disease = "В крови обнаружено: [english_list(disease_names)]."
		else
			msg_disease = "Болезней в крови не обнаружено."
		var/list/mental_conditions = list()
		if(target.has_quirk(/datum/quirk/insanity))
			mental_conditions += "безумие"
		if(target.has_quirk(/datum/quirk/darkpack/derangement))
			mental_conditions += "неизлечимое психическое расстройство"
		if(length(mental_conditions))
			msg_mental = "Разум затуманен: [english_list(mental_conditions)]."

	ui_interact(owner)
	to_chat(owner, span_notice("[msg_creature] \n[msg_damage] \n[msg_blood] \n[msg_disease] \n[msg_mental]"))

/datum/discipline_power/obeah/sense_vitality/deactivate()
	. = ..()

/datum/discipline_power/obeah/anesthetic_touch
	name = "Обезболивающее касание"
	desc = "Уймите боль пациента или погрузите смертного в безмятежный сон."
	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND
	target_type = TARGET_LIVING
	range = 1
	cooldown_length = 3 TURNS
	var/sleep_duration_length = 10 TURNS
	var/soothe_duration_length = 1 SCENES
	var/successes = 0
	var/datum/storyteller_roll/anesthetic_touch/touch_roll // these are defined in valeren.dm
	var/datum/storyteller_roll/anesthetic_touch/unwilling/touch_roll_unwilling
	frenzy_usable = FALSE

/datum/discipline_power/obeah/anesthetic_touch/pre_activation_checks(mob/living/target)
	. = ..()
	var/datum/storyteller_roll/anesthetic_touch/roll_to_use
	if(target.combat_mode)
		if(!touch_roll_unwilling)
			touch_roll_unwilling = new()
		roll_to_use = touch_roll_unwilling
	else
		if(!touch_roll)
			touch_roll = new()
		roll_to_use = touch_roll
	successes = roll_to_use.st_roll(owner, target)
	if(successes >= 1)
		return TRUE
	else
		return FALSE

/datum/discipline_power/obeah/anesthetic_touch/activate(mob/living/target)
	. = ..()
	var/list/choices = list(
		"Унять боль" = icon('icons/mob/actions/actions_spells.dmi', "statue"),
		"Усыпить" = icon('icons/mob/actions/actions_spells.dmi', "blind"),
	)
	var/chosen_option = show_radial_menu(owner, target, choices, radius = 38, require_near = TRUE)
	switch(chosen_option)
		if("Унять боль")
			target.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown) // CORVAX EDIT CHANGE - ORIGINAL: owner.add_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
			ADD_TRAIT(target, TRAIT_ANALGESIA, type)
			addtimer(CALLBACK(src, PROC_REF(end_soothe_pain), target), (successes TURNS) + soothe_duration_length)
		if("Усыпить")
			if(get_kindred_splat(target))
				to_chat(owner, span_warning("Сородича этой силой не усыпить!"))
				return TRUE
			target.SetSleeping(sleep_duration_length + (successes TURNS)) // 50 seconds + successes in turns
			target.adjust_blood_pool(1) // restores a BP to the target, but if this gets abused, maybe make this depend on successes
	return TRUE

/datum/discipline_power/obeah/anesthetic_touch/proc/end_soothe_pain(mob/living/target)
	target.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown) // CORVAX EDIT CHANGE - ORIGINAL: owner.remove_movespeed_mod_immunities(type, /datum/movespeed_modifier/damage_slowdown)
	REMOVE_TRAIT(target, TRAIT_ANALGESIA, type)

/datum/discipline_power/obeah/corpore_sano
	name = "Корпоре сано"
	desc = "Возложите руки на пациента и исцелите его раны."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB // CRIMSON EDIT CHANGE - Healer Buff PR (Salubri and Theurges) - Original: target_type = TARGET_LIVING
	range = 1
	frenzy_usable = FALSE

	violates_masquerade = TRUE
	cooldown_length = 1 TURNS

/datum/discipline_power/obeah/corpore_sano/activate(atom/target)
	. = ..()
	var/mob/living/living_target = target
	if(living_target.get_agg_loss() && (owner.bloodpool >= 1))
		owner.adjust_blood_pool(-1)
		living_target.heal_storyteller_health(dots_to_heal = 4, heal_aggravated = TRUE, heal_scars = TRUE, heal_blood = TRUE, heal_burn = TRUE) // CRIMSON EDIT CHANGE - Healer Buff PR (Salubri and Theurges) - Original: living_target.heal_storyteller_health(dots_to_heal = 1, heal_aggravated = TRUE, heal_scars = TRUE, heal_blood = TRUE)
	else
		living_target.heal_storyteller_health(dots_to_heal = 4, heal_aggravated = FALSE, heal_scars = TRUE, heal_blood = TRUE, heal_burn = TRUE) // CRIMSON EDIT CHANGE - Healer Buff PR (Salubri and Theurges)  - Original: living_target.heal_storyteller_health(dots_to_heal = 4, heal_aggravated = FALSE, heal_scars = TRUE, heal_blood = TRUE, heal_burn = TRUE)

// Radius - the length of the line you draw from the central point of a circle towards any point of the outer boundary, which in geometry is called the circumference.
#define SHEPHERDS_WATCH_RADIUS 3
/datum/discipline_power/obeah/shepherds_watch
	name = "Око пастыря"
	desc = "Создайте сверхъестественную преграду, которая убережёт вас от вреда."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	violates_masquerade = TRUE
	cooldown_length = 1 TURNS
	duration_length = 1 TURNS
	willpower_cost = 2
	cancelable = TRUE
	var/datum/proximity_monitor/advanced/shepherds_watch/area_of_effect
	frenzy_usable = FALSE

/datum/discipline_power/obeah/shepherds_watch/activate(atom/target)
	. = ..()
	area_of_effect = new(owner, SHEPHERDS_WATCH_RADIUS)
	for(var/mob/living/mob_living in range(SHEPHERDS_WATCH_RADIUS, owner))
		area_of_effect.ignored_mobs |= mob_living

/datum/discipline_power/obeah/shepherds_watch/duration_expire(atom/target)
	clear_duration_timer()
	owner.update_action_buttons()
	if(!check_discipline_flags())
		deactivate(owner, FALSE)
		return
	do_duration(owner)

/datum/discipline_power/obeah/shepherds_watch/deactivate(atom/target, direct)
	. = ..()
	QDEL_NULL(area_of_effect)

#undef SHEPHERDS_WATCH_RADIUS

/datum/discipline_power/obeah/mens_sana
	name = "Менс сана"
	desc = "Этой силой салюбри исцеляет безумие: усмиряет внутренних демонов и дарует душе покой."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	violates_masquerade = TRUE
	cooldown_length = 1 TURNS
	vitae_cost = 2
	target_type = TARGET_LIVING
	range = 1
	var/datum/storyteller_roll/mens_sana/discipline_roll
	frenzy_usable = FALSE

/datum/storyteller_roll/mens_sana
	bumper_text = "менс сана"
	applicable_stats = list(STAT_INTELLIGENCE, STAT_EMPATHY)
	difficulty = 8
	roll_output_type = ROLL_FLAG_ROLLER|ROLL_FLAG_TARGET

/datum/discipline_power/obeah/mens_sana/activate(atom/target)
	. = ..()
	var/mob/living/carbon/carbon_target = target
	if(!carbon_target)
		return
	var/obj/item/organ/brain/target_brain = carbon_target.get_organ_by_type(/obj/item/organ/brain)
	var/list/gotten_traumas = target_brain.traumas
	if(carbon_target.has_quirk(/datum/quirk/darkpack/derangement))
		gotten_traumas += "Психическое расстройство"
	var/chosen_derangement = tgui_input_list(owner, "Выберите, какую травму исцелить", "Травмы", gotten_traumas)
	if(!chosen_derangement)
		to_chat(owner, span_notice("Никаких травм найти не удаётся."))
		return
	var/datum/storyteller_roll/mens_sana/discipline_roll = new()
	var/success = discipline_roll.st_roll(owner, target)
	switch(success)
		if(ROLL_BOTCH)
			var/obj/item/organ/brain/owner_brain = owner.get_organ_by_type(/obj/item/organ/brain)
			if(chosen_derangement == "Психическое расстройство")
				owner.add_quirk(/datum/quirk/darkpack/derangement)
			else
				owner_brain.gain_trauma_type(chosen_derangement, TRAUMA_RESILIENCE_MAGIC)
			to_chat(owner, span_bolddanger("Вам не удаётся избавить [target.declent_ru(ACCUSATIVE)] от недуга ([chosen_derangement]), и он переходит на ваш собственный разум!"))
		if(ROLL_FAILURE)
			to_chat(owner, span_danger("Вам не удаётся избавить [target.declent_ru(ACCUSATIVE)] от недуга ([chosen_derangement])."))
		if(ROLL_SUCCESS)
			if(chosen_derangement == "Психическое расстройство")
				carbon_target.remove_quirk(/datum/quirk/darkpack/derangement)
			else
				target_brain.cure_trauma_type(chosen_derangement, TRAUMA_RESILIENCE_MAGIC)
			to_chat(owner, span_notice("Вы избавляете [target.declent_ru(ACCUSATIVE)] от недуга ([chosen_derangement])."))


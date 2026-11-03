//discipline stuff
GLOBAL_LIST_INIT(rare_discipline_types, list(
	/datum/discipline/quietus,
	/datum/discipline/temporis,
	/datum/discipline/serpentis,
	/datum/discipline/dementation,
	/datum/discipline/obtenebration,
	/datum/discipline/thaumaturgy,
	/datum/discipline/necromancy,
	/datum/discipline/valeren,
	/datum/discipline/obeah,
	/datum/discipline/daimonion,
	/datum/discipline/melpominee,
))

// warns a player if they have no discipline dots assigned before joining
// returns TRUE if they want to proceed, FALSE if they want to go back and fix their disciplines
/mob/dead/new_player/proc/check_discipline_warning()
	if(!client?.prefs)
		return TRUE
	var/splat = client.prefs.read_preference(/datum/preference/choiced/splats)
	if(!ispath(splat, /datum/splat/vampire))
		return TRUE

	// check for at least one discipline, store how many discipline points spent, count how many disciplines they have
	var/discipline_count
	var/discipline_points_spent
	var/has_any_discipline = FALSE
	for(var/disc in client.prefs.discipline_levels)
		var/level = client.prefs.discipline_levels[disc]
		discipline_points_spent += level
		discipline_count++
		if(level > 0 && !has_any_discipline)
			has_any_discipline = TRUE

	var/discipline_points_budget
	if(ispath(splat, /datum/splat/vampire/kindred))
		var/immortal_age = client.prefs.read_preference(/datum/preference/numeric/immortal_age)
		discipline_points_budget = get_discipline_point_budget(immortal_age)["points"]
	else if(ispath(splat, /datum/splat/vampire/ghoul))
		discipline_points_budget = get_ghoul_discipline_budget(discipline_count)["points"]

	// we are assuming that diablerists gain discipline points or disciplines.
	if(discipline_points_spent > discipline_points_budget && !client.prefs.read_preference(/datum/preference/toggle/diablerist))
		tgui_alert(src, "На Дисциплины потрачено пунктов: [discipline_points_spent], а вашему персонажу доступно только [discipline_points_budget]! Исправьте настройки персонажа, прежде чем входить в игру.", "Перерасход пунктов Дисциплин", list("ОК"))
		return FALSE

	// CORVAX EDIT CHANGE START
	if(!has_any_discipline)
		var/choice = tgui_alert(src, "Вы не распределили ни одной точки Дисциплин! Персонаж появится в игре без Дисциплин (кроме врождённых). Вы уверены?", "Дисциплины не настроены", list("Да, войти", "Назад"))
		return choice == "Да, войти"
	// CORVAX EDIT CHANGE END
	return TRUE

// discipline weights (trusted players arent affected by these)
// 5 possible total disciplines
// no greater than 2 non-clan rare disciplines
// 1 rare in addition to non-clan means you get max 1 common additional on top of that
// no rare additionals means you get a max of 2 common additionals
/proc/validate_discipline_sheet(list/discipline_levels, list/clan_disciplines, is_trusted = FALSE)
	var/list/result = list()
	var/list/violations = list()
	var/total = 0
	var/additional = 0
	var/additional_rare = 0

	for(var/disc_path in discipline_levels)
		if(!discipline_levels[disc_path])
			continue
		total++
		if(!(disc_path in clan_disciplines))
			additional++
			if(text2path(disc_path) in GLOB.rare_discipline_types)
				additional_rare++

	if(!is_trusted)
		if(total > 5)
			violations += "Дисциплин слишком много: [total] при пределе в 5."
		if(additional_rare > 2)
			violations += "Редких неклановых Дисциплин: [additional_rare]! Игрокам без статуса доверенного доступно не больше 2.\n"
		else if(additional_rare == 1 && additional > 2)
			violations += "При одной редкой неклановой Дисциплине разрешена только одна обычная неклановая (сейчас обычных: [additional - 1]).\n"
		else if(additional_rare == 0 && additional > 2)
			violations += "Обычных неклановых Дисциплин: [additional]! Игрокам без статуса доверенного доступно не больше 2, если нет редкой."

	result["total"] = total
	result["additional"] = additional
	result["additional_rare"] = additional_rare
	result["valid"] = !length(violations)
	result["violations"] = violations
	return result

// for validating a mob's sheet before teaching them a new one
// validated against the above criteria
/proc/validate_mob_sheet(mob/living/carbon/human/human, discipline_type_to_add = null)
	var/datum/splat/vampire/vamp_splat = get_splat_with_discipline(human)
	if(!vamp_splat)
		return null

	var/list/discipline_levels = list()
	for(var/datum/action/discipline/disc_action as anything in vamp_splat.powers)
		var/datum/discipline/disc = disc_action.discipline
		if(!disc?.selectable)
			continue
		if(ispath(disc.type, /datum/discipline/path))
			continue
		discipline_levels["[disc.type]"] = disc.level

	if(discipline_type_to_add)
		var/disc_key = "[discipline_type_to_add]"
		if(!discipline_levels[disc_key])
			discipline_levels[disc_key] = 1

	var/list/clan_disciplines = list()
	var/datum/subsplat/vampire_clan/clan = human.get_clan()
	if(clan)
		for(var/disc_type in clan.clan_disciplines)
			if(ispath(disc_type, /datum/discipline))
				clan_disciplines += "[disc_type]"

	var/is_trusted = human.client?.prefs?.discipline_trusted || FALSE

	return validate_discipline_sheet(discipline_levels, clan_disciplines, is_trusted)

/datum/preference_middleware/disciplines
	action_delegations = list(
		"set_discipline_level" = PROC_REF(set_discipline_level),
		"clear_discipline_levels" = PROC_REF(clear_discipline_levels)
	)

/datum/preference_middleware/disciplines/get_ui_data(mob/user)
	if(preferences.current_window != PREFERENCE_TAB_CHARACTER_PREFERENCES)
		return list()

	var/list/data = list()
	data["discipline_levels"] = list()
	var/points_spent = 0
	for(var/discipline in preferences.discipline_levels)
		var/level = preferences.discipline_levels[discipline]
		data["discipline_levels"]["[discipline]"] = level
		points_spent += level

	var/is_ghoul = ispath(preferences.read_preference(/datum/preference/choiced/splats), /datum/splat/vampire/ghoul)
	data["clan_disciplines"] = list()
	data["clan_name"] = null
	var/clan_value = preferences.read_preference(/datum/preference/choiced/subsplat/vampire_clan)

	var/discipline_count = 0
	var/list/counted_discs = list()
	for(var/disc in preferences.discipline_levels)
		if(preferences.discipline_levels[disc] > 0)
			discipline_count++
			counted_discs[disc] = TRUE

	if(is_ghoul && clan_value)
		var/datum/subsplat/vampire_clan/ghoul_clan_datum = get_vampire_clan(clan_value)
		if(ghoul_clan_datum)
			for(var/disc_type in ghoul_clan_datum.clan_disciplines)
				if(ispath(disc_type, /datum/discipline) && !("[disc_type]" in counted_discs))
					discipline_count++

	var/immortal_age = preferences.read_preference(/datum/preference/numeric/immortal_age)
	var/list/budget_info = is_ghoul ? get_ghoul_discipline_budget(discipline_count) : get_discipline_point_budget(immortal_age)
	data["discipline_points_available"] = budget_info["points"]
	data["discipline_points_spent"] = points_spent
	data["discipline_tier"] = budget_info["tier"]
	data["discipline_tier_details"] = budget_info["details"]
	data["is_trusted"] = preferences?.has_whitelist(WHITELIST_TRUSTED)
	data["max_trusted_generation"] = MAX_TRUSTED_GENERATION
	data["max_public_generation"] = MAX_PUBLIC_GENERATION
	data["highest_generation_limit"] = HIGHEST_GENERATION_LIMIT

	var/generation = preferences.read_preference(/datum/preference/numeric/generation) // CORVAX EDIT ADD
	data["max_immortal_age"] = get_max_immortal_age_for_generation(isnum(generation) ? generation : HIGHEST_GENERATION_LIMIT) // CORVAX EDIT ADD
	// CORVAX EDIT ADD START
	data["generation_locked"] = preferences.is_generation_locked()
	data["diablerist_locked"] = preferences.is_diablerist_locked()
	data["player_min_generation"] = get_player_min_generation(preferences)
	// CORVAX EDIT END
	return data

/proc/get_discipline_point_budget(immortal_age)
	if(immortal_age <= 10)
		return list(
			"points" = DISCIPLINE_BUDGET_FLEDGLING,
			"tier" = "Птенец",
			"details" ="Вы птенец: только учитесь владеть новыми силами и справляться с новыми бедами. К добру или к худу, вы почти тот же человек, каким были до Становления. В поговорке \"жизнь - дерьмо, а потом ты умираешь\" ничего не сказано о том, каково быть мёртвым, но это вы уже начинаете узнавать на собственной шкуре. Возможно, вас недавно признали погибшим или объявили в розыск, и теперь вы по кусочкам собираете не-жизнь без тех, на кого опирались при жизни. Правил и обычаев, о которых вы не имеете понятия, великое множество, а Сородичи постарше смотрят на вас свысока. Может быть, вы в одиночку прячетесь после череды убийств, которые совершили сразу после Становления и которыми привлекли внимание полиции и Камарильи. А может быть, учитесь держать себя в руках под крылом и бдительным присмотром сира. В любом случае без чужой помощи вам во всём этом не разобраться.")
	if(immortal_age <= 100)
		return list(
			"points" = DISCIPLINE_BUDGET_NEONATE,
			"tier" = "Неонат",
			"details" = "Вы неонат и уже начинаете осваиваться в не-жизни. Вы научились сдерживать свои порывы настолько, что вас по большей части предоставили самому себе, но Сородичи постарше по-прежнему чуют вашу неопытность за версту. Друзья и родные, которых вы знали, стареют и умирают своей смертью, и каждая такая потеря оставляет в душе незаживающий шрам. Те, с кем вы ещё общаетесь, но кому не рассказали о Становлении, наверняка уже удивляются, почему вы не стареете и никогда не показываетесь днём. Поэтому вы привыкли сохранять самообладание и держать карты при себе, особенно когда имеете дело с людом. Смертных, которые связывают вас с прежней жизнью, остаётся всё меньше, и вам придётся искать утешения в ком-то другом... иначе вместе с ними начнёт угасать и ваша Человечность.")
	if(immortal_age <= 200)
		return list(
			"points" = DISCIPLINE_BUDGET_ANCILLAE,
			"tier" = "Анцилла",
			"details" = "Вы анцилла, уважаемый член общества Сородичей. По меркам анархов вы древность, по меркам Камарильи - вампир средних лет. Нити, связывавшие вас с прежней жизнью, истлели больше века назад, когда умерли ваши близкие. За эти годы у вас появилась новая семья: собственные потомки или друзья, дружба с которыми прошла через десятилетия. Вы зрелый, уравновешенный вампир, и к вам часто обращаются, когда решение требует ещё одного мнения или когда нужно сделать что-то важное.")
	return list("points" = DISCIPLINE_BUDGET_ELDER,
			"tier" = "Старейшина",
			"details" = "Вы старейшина своего клана, ходячий учебник истории. Вы привыкли помалкивать о своём истинном возрасте и происхождении и наверняка успели нажить целую котерию врагов, часть которых ещё жива, а часть уже нет. Вы ползёте сквозь время, как извилистая многоножка, из века в век, которых не узнаёте, и каждый раз заново учитесь и приспосабливаетесь к переменчивым нравам. Быть может, вы очнулись от торпора после битвы, которую то ли помните, то ли нет, и оказались в совершенно незнакомом мире. Скорее всего, за вами тянется слава, добрая или дурная, за что-то, что вы совершили (или не совершали) сотни лет назад. Кого-то ваше общество утешает, потому что вы хоть одно знакомое лицо, а кто-то мечтает обратить вас в пепел за мелкую обиду, нанесённую много жизней назад. Если ваш истинный возраст раскроется, Камарилья наверняка попытается приставить вас к делу как силовика... или же какой-нибудь честолюбивый упырь явится совершить над вами диаблери и забрать вашу силу себе. Вы дожили до этих ночей, потому что стары, хитры и осторожны. Вы дорожите заведённым порядком и по возможности держитесь подальше от мелочных дрязг молодых Сородичей.")

/proc/get_ghoul_discipline_budget(discipline_count = 0)
	return list(
		"points" = max(3, discipline_count), // pool expands for each additional discipline they've been taught, but they can never assign more than 1 per
		"tier" = "Гуль",
		"details" = "Вы гуль, рабочий класс общества Сородичей. Уже не смертный, но и не Сородич: чужой в обоих мирах. Возможно, у вас есть домитор или, скажем так, \"работодатель\": Сородич, который регулярно поит вас своей кровью, а она дарит вам долгую жизнь без старости и сверхъестественные способности. Реже встречаются гули-одиночки, которые добывают кровь Сородичей где придётся. На такое смотрят крайне косо, и если об этом узнает Камарилья, дело может кончиться вашей смертью. Вы стараетесь не высовываться и делаете что велено: один косой взгляд, и вас убьют, а убийце это обойдётся разве что в мелкую услугу тому Сородичу, который держит ваш поводок. Вы можете выполнять поручения домитора днём и пользоваться простейшими проявлениями сил, которые получаете с выпитой кровью... но пока вы её пьёте, вместе с ней вам достаётся и проклятие клана.")

/datum/preference_middleware/disciplines/get_constant_data()
	var/list/data = list()

	for(var/discipline_type in subtypesof(/datum/discipline))
		var/datum/discipline/discipline = new discipline_type

		if(!discipline.selectable) // default disciplines like bloodheal arent selectable, and dont belong here
			qdel(discipline)
			continue

		if(ispath(discipline_type, /datum/discipline/path)) // avoids giving tremere 50 different discs because thaum has like 50 subtypes
			qdel(discipline)
			continue

		var/list/disc_data = list()
		disc_data["name"] = discipline.name
		disc_data["desc"] = discipline.desc
		disc_data["max_level"] = discipline.max_selectable_level || length(discipline.all_powers)
		disc_data["icon"] = initial(discipline.icon)
		disc_data["icon_state"] = discipline.icon_state
		disc_data["rarity"] = (discipline_type in GLOB.rare_discipline_types) ? "rare" : "common"
		data["[discipline_type]"] = disc_data
		qdel(discipline)

	return data


// sets the character's level in a given discipline
// if you dont put any dots in it, aka level 0, it means you don't spawn in with that discipline
/datum/preference_middleware/disciplines/proc/set_discipline_level(list/params, mob/user)
	SHOULD_NOT_SLEEP(TRUE)

	if(!isnewplayer(user) && ("[user.client.prefs.default_slot]" in user.persistent_client.joined_as_slots))
		to_chat(user, span_warning("Нельзя менять точки Дисциплин у персонажа, который уже играл в этом раунде.")) // so people dont mess up their saves
		return FALSE

	var/discipline = params["discipline"]
	var/new_level = text2num(params["level"])

	if(!discipline || isnull(new_level))
		return FALSE

	new_level = round(new_level)

	if(new_level < 0 || new_level > 9)
		return FALSE

	if(new_level > 5)
		var/gen = preferences.read_preference(/datum/preference/numeric/generation)
		if(isnull(gen) || gen > 7)
			to_chat(user, span_warning("Только Сородичи 7-го поколения и ниже (сильнее кровью) могут владеть Дисциплинами выше 5-го уровня."))
			return FALSE

	if(ispath(preferences.read_preference(/datum/preference/choiced/splats), /datum/splat/vampire/ghoul) && new_level > 1)
		var/clan_value = preferences.read_preference(/datum/preference/choiced/subsplat/vampire_clan)
		var/datum/subsplat/vampire_clan/clan_datum = clan_value ? get_vampire_clan(clan_value) : null
		if(clan_datum)
			for(var/disc_type in clan_datum.clan_disciplines)
				if("[disc_type]" == discipline)
					return FALSE

	var/immortal_age = preferences.read_preference(/datum/preference/numeric/immortal_age)
	var/list/budget_info = get_discipline_point_budget(immortal_age)
	var/point_budget = budget_info["points"]
	var/old_level = preferences.discipline_levels[discipline] || 0
	var/current_total = 0

	for(var/disc in preferences.discipline_levels)
		current_total += preferences.discipline_levels[disc]
	var/new_total = current_total - old_level + new_level

	if(new_level > old_level && new_total > point_budget) // you can go down, but not up, if you're overbudget. for when adminbus gives you more than you can chew
		return FALSE

	preferences.discipline_levels[discipline] = new_level

	preferences.save_character()
	return TRUE

/datum/preference_middleware/disciplines/proc/clear_discipline_levels(list/params, mob/user)
	SHOULD_NOT_SLEEP(TRUE)

	if(!isnewplayer(user) && ("[user.client.prefs.default_slot]" in user.persistent_client.joined_as_slots))
		to_chat(user, span_warning("Нельзя менять точки Дисциплин у персонажа, который уже играл в этом раунде."))
		return FALSE
	var/clan_value = preferences.read_preference(/datum/preference/choiced/subsplat/vampire_clan)
	if(!clan_value)
		return FALSE
	preferences.discipline_levels = list() // restore them to default
	var/datum/subsplat/vampire_clan/clan_datum = get_vampire_clan(clan_value) // then give them their default clan discs. clear_discipline_levels fires from changing clans
	if(clan_datum)
		// CORVAX EDIT CHANGE START
		for(var/disc_type in clan_datum.clan_disciplines)
			if(ispath(disc_type, /datum/discipline))
				preferences.discipline_levels["[disc_type]"] = 0
		// CORVAX EDIT CHANGE END
	preferences.save_character()
	return TRUE

/datum/preferences/apply_prefs_to(mob/living/carbon/human/character, icon_updates = TRUE, list/do_not_apply)
	if(!isnull(character))
		RegisterSignal(character, COMSIG_HUMAN_PREFS_APPLIED, PROC_REF(on_prefs_applied_disciplines), override = TRUE)
	. = ..()

/datum/preferences/proc/on_prefs_applied_disciplines(mob/living/carbon/human/character)
	SIGNAL_HANDLER
	UnregisterSignal(character, COMSIG_HUMAN_PREFS_APPLIED)

	if(isdummy(character))
		return

	var/datum/splat/vampire/vampire_splat = get_splat_with_discipline(character)

	if(!vampire_splat)
		return

	// CORVAX EDIT CHANGE START
	for(var/disc_path in discipline_levels)
		var/level = discipline_levels[disc_path]
		if(!level)
			continue
		var/discipline = text2path(disc_path)
		if(!discipline)
			continue
		if(character.get_splat(/datum/splat/vampire/ghoul))
			level = 2
		var/result = character.change_st_power_level(discipline, level)
		if(!result)
			character.give_st_power(discipline, level)
	// CORVAX EDIT CHANGE END
	return

/datum/preferences/proc/save_disciplines(mob/living/carbon/human/character)
	if(QDELETED(character))
		return

	var/datum/splat/vampire/vampire_splat = get_splat_with_discipline(character)
	if(!vampire_splat)
		return

	var/changed = FALSE
	for(var/datum/action/discipline/disc_action as anything in vampire_splat.powers)
		var/datum/discipline/disc = disc_action.discipline
		if(!disc?.selectable)
			continue
		if(ispath(disc.type, /datum/discipline/path))
			continue
		var/disc_key = "[disc.type]"
		var/in_game_level = disc.level
		var/prefs_level = discipline_levels[disc_key] || 0
		if(in_game_level > prefs_level)
			discipline_levels[disc_key] = in_game_level
			changed = TRUE

	if(changed)
		save_character()

/datum/job/vampire/sabbatductus
	title = JOB_SABBAT_DUCTUS
	faction = FACTION_SABBAT
	total_positions = 1
	spawn_positions = 1
	supervisors = "Каином"
	config_tag = "SABBAT_DUCTUS"
	outfit = /datum/outfit/job/vampire/sabbatductus
	allowed_splats = list(SPLAT_KINDRED)
	job_flags = CITY_JOB_FLAGS
	departments_list = list(
		/datum/job_department/sabbat,
	)

	tgui_icon = FA_ICON_CROSS

	exp_requirements = EXP_REQ_HEAD
	exp_required_type_department = EXP_TYPE_SABBAT

	description = "Вы Дуктус, вожак своей стаи Шабаша. Ваш долг - бунт против старейшин и Камарильи, против Извечной Борьбы, против Маскарада и Традиций. Ваш долг - признать Каина истинным Тёмным Отцом всех каинитов. ВНИМАНИЕ: ВЫБИРАЯ ЭТУ РОЛЬ, ВЫ ПОДТВЕРЖДАЕТЕ, ЧТО ПРОЧЛИ ПРАВИЛА СЕРВЕРА ОБ ЭСКАЛАЦИИ ДЛЯ АНТАГОНИСТОВ И СОГЛАСНЫ С НИМИ. ДЕЛАЙТЕ ИГРУ ИНТЕРЕСНОЙ И УВЛЕКАТЕЛЬНОЙ ДЛЯ ОБЕИХ СТОРОН. ЗА УБИЙСТВО ИГРОКОВ ПРОСТО ПОТОМУ, ЧТО ВЫ МОЖЕТЕ, МОЖНО ПОЛУЧИТЬ БАН РОЛИ."
	minimum_masquerade = 0
	desensitized_base = DESENSITIZED_THRESHOLD // CRIMSON EDIT ADDITION - JOB MOOD
	display_order = JOB_DISPLAY_ORDER_SABBATDUCTUS
	whitelisted = TRUE

	allowed_clans = list(VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_TZIMISCE, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_HARBINGER, VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_MALKAVIAN) // CORVAX EDIT v20

	known_contacts = list(
		JOB_SABBAT_PACK,
		JOB_SABBAT_PRIEST
	)

/datum/antagonist/sabbatist/ductus
	antag_hud_name = "ductus"

/datum/outfit/job/vampire/sabbatductus
	name = JOB_SABBAT_DUCTUS
	jobtype = /datum/job/vampire/sabbatductus
	l_pocket = /obj/item/smartphone/sabbat_ductus
	r_pocket = /obj/item/vamp/keys/sabbat
	uses_default_clan_clothes = TRUE
	backpack_contents = list(/obj/item/card/credit=1)

/datum/outfit/job/vampire/sabbatductus/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/sabbatist/ductus)

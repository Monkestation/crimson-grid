/datum/job/vampire/sabbatpack
	title = JOB_SABBAT_PACK
	faction = FACTION_SABBAT
	total_positions = 5
	spawn_positions = 5
	supervisors = "Каином"
	config_tag = "SABBAT_PACK"
	outfit = /datum/outfit/job/vampire/sabbatpack
	job_flags = CITY_JOB_FLAGS
	allowed_splats = list(SPLAT_KINDRED)
	departments_list = list(
		/datum/job_department/sabbat,
	)

	tgui_icon = FA_ICON_CROSS

	description = "Вы состоите в Шабаше. Ваш долг - бунт против старейшин и Камарильи, против Извечной Борьбы, против Маскарада и Традиций. Ваш долг - признать Каина истинным Тёмным Отцом всех каинитов. ВНИМАНИЕ: ВЫБИРАЯ ЭТУ РОЛЬ, ВЫ ПОДТВЕРЖДАЕТЕ, ЧТО ПРОЧЛИ ПРАВИЛА СЕРВЕРА ОБ ЭСКАЛАЦИИ ДЛЯ АНТАГОНИСТОВ И СОГЛАСНЫ С НИМИ. ДЕЛАЙТЕ ИГРУ ИНТЕРЕСНОЙ И УВЛЕКАТЕЛЬНОЙ ДЛЯ ОБЕИХ СТОРОН. ЗА УБИЙСТВО ИГРОКОВ ПРОСТО ПОТОМУ, ЧТО ВЫ МОЖЕТЕ, МОЖНО ПОЛУЧИТЬ БАН РОЛИ."
	maximal_generation = 9
	maximum_immortal_age = 200
	minimum_masquerade = 0
	desensitized_base = DESENSITIZED_THRESHOLD // CRIMSON EDIT ADDITION - JOB MOOD
	display_order = JOB_DISPLAY_ORDER_SABBATPACK
	whitelisted = TRUE

	known_contacts = list(
		JOB_SABBAT_DUCTUS,
		JOB_SABBAT_PRIEST
	)

/datum/outfit/job/vampire/sabbatpack
	name = JOB_SABBAT_PACK
	jobtype = /datum/job/vampire/sabbatpack
	l_pocket = /obj/item/smartphone/sabbat_pack
	r_pocket = /obj/item/vamp/keys/sabbat
	uses_default_clan_clothes = TRUE
	backpack_contents = list(/obj/item/card/credit=1)

/datum/outfit/job/vampire/sabbatpack/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/sabbatist)


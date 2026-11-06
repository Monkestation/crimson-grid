/datum/job/vampire/sabbatpriest
	title = JOB_SABBAT_PRIEST
	faction = FACTION_SABBAT
	total_positions = 2
	spawn_positions = 2
	supervisors = "Каином"
	config_tag = "SABBAT_PRIEST"
	outfit = /datum/outfit/job/vampire/sabbatpriest
	allowed_splats = list(SPLAT_KINDRED)
	job_flags = CITY_JOB_FLAGS

	departments_list = list(
		/datum/job_department/sabbat,
	)

	tgui_icon = FA_ICON_CROSS

	description = "Вы духовник стаи Шабаша. На вас надзор за обрядами стаи, и вы в ней второй после Дуктуса. Освящайте обряд Братания для новых шабашитов, ищите в своей книге обряды, которые помогут стае, и следите, чтобы Шабаш и впредь жил в милости Каина. ВНИМАНИЕ: ВЫБИРАЯ ЭТУ РОЛЬ, ВЫ ПОДТВЕРЖДАЕТЕ, ЧТО ПРОЧЛИ ПРАВИЛА СЕРВЕРА ОБ ЭСКАЛАЦИИ ДЛЯ АНТАГОНИСТОВ И СОГЛАСНЫ С НИМИ. ДЕЛАЙТЕ ИГРУ ИНТЕРЕСНОЙ И УВЛЕКАТЕЛЬНОЙ ДЛЯ ОБЕИХ СТОРОН. ЗА УБИЙСТВО ИГРОКОВ ПРОСТО ПОТОМУ, ЧТО ВЫ МОЖЕТЕ, МОЖНО ПОЛУЧИТЬ БАН РОЛИ."
	minimum_masquerade = 0
	desensitized_base = DESENSITIZED_THRESHOLD // CRIMSON EDIT ADDITION - JOB MOOD
	display_order = JOB_DISPLAY_ORDER_SABBATPRIEST
	whitelisted = TRUE

	allowed_clans = list(VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_TZIMISCE, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_HARBINGER, VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_MALKAVIAN) // CORVAX EDIT v20

	known_contacts = list(
		JOB_SABBAT_DUCTUS,
		JOB_SABBAT_PACK
	)

/datum/outfit/job/vampire/sabbatpriest
	name = JOB_SABBAT_PRIEST
	jobtype = /datum/job/vampire/sabbatpriest
	l_pocket = /obj/item/smartphone/sabbat_priest
	r_pocket = /obj/item/vamp/keys/sabbat
	suit = /obj/item/clothing/suit/vampire/noddist
	head = /obj/item/clothing/head/vampire/noddist_mask
	uses_default_clan_clothes = TRUE
	backpack_contents = list(/obj/item/card/credit=1)

/datum/outfit/job/vampire/sabbatpriest/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/sabbatist/priest)

/datum/antagonist/sabbatist/priest
	antag_hud_name = "priest"

/obj/item/sabbat_priest_tome
	name = "Sabbat Priest's Tome"
	desc = "Книга, украшенная символом Шабаша."
	icon = 'modular_darkpack/modules/jobs/icons/sabbat.dmi'
	icon_state = "sabbat-tome"

/datum/sabbat_ritae/ritae_description
	var/name = "Описание обряда"
	var/desc = "Описание обряда"

/datum/sabbat_ritae/ritae_description/pack_credo
	name = "Кредо стаи"
	desc = "Мы - Меч Каина. Мы не склоняемся перед Маскарадом. Мы не рабы старейшин и не орудия Патриархов. Кровью и огнём мы готовимся к Геенне. Мы действуем не тайком, а силой, едины как одна стая. Смерть предателям. Смерть тиранам. Такова воля Каина.\n"

/datum/sabbat_ritae/ritae_description/vaulderie_info
	name = "Обряд Братания"
	desc = "Обряд Братания создаёт в стае братские узы: слабые общие узы крови между всеми участниками. Он разрывает прежние узы крови и напоминает каждому каиниту, что тот свободен от старейшин, отнявших у Каина его место. Обряд проводят с чашей Братания или серебряным кубком. Каждый член стаи проливает в чашу свою витэ, после чего её пьют все участники.\n"

/datum/sabbat_ritae/ritae_description/shovelhead_info
	name = "Обряд Возведения"
	desc = "Обряд Возведения, за который нас так часто поносят. Каинит входит в ряды Истинного Шабаша, когда побеждает страх перед огнём и смертью: в нашем логове он проходит прямо сквозь костёр. Но в отчаянные времена, особенно когда нужно дать Становление многим сразу, мы прибегаем к \"методу лопаты\": даём новым каинитам Становление и закапываем их в неглубокую могилу, пробуждая в них безумие, Зверя, их подлинную природу... \n"

/datum/sabbat_ritae/ritae_description/monomacy_info
	name = "Мономахия"
	desc = "Мономахия - обряд, который сводит двух каинитов Шабаша в поединке, когда они не могут уладить спор ни миром, ни доводами рассудка. Бросающий вызов призывает противника на бой через руну Мономахии в нашем логове, а тот волен принять вызов или отказаться. Стоит ли спор Мономахии, решает духовник. Условия поединка выбирает вызванный: оружие, дозволенные Дисциплины, до торпора или до Окончательной смерти, место... Последнее слово в обрядах, как и в стае, всегда за духовником, и он вправе объявить любой поединок недействительным.\n"

/datum/sabbat_ritae/ritae_description/bloodbath_info
	name = "Кровавая купель"
	desc = "Кровавая купель - обряд, которым духовник избирает нового Дуктуса, обычно после того, как прежнего вызвали на Мономахию. Каждый каинит Шабаша, готовый служить новому Дуктусу, подходит к нашей купели и ритуальным ножом отдаёт ей щедрую долю своей витэ. Затем новый Дуктус погружается в кровь признавшей его стаи, и духовник касается купели своей книгой. Когда Дуктус выйдет из купели, духовник зачерпывает кровь чашей Братания, и её пьют все, освящая братские узы обновлённой стаи. \n"

/datum/sabbat_ritae/ritae_description/war_party_hunt_info
	name = "Боевой поход"
	desc = "Обряд Боевого похода начинают с помощью тотема Боевого похода, сделанного из черепа каинита-старейшины. Его тёмная сила велит всем в городе, кто прошёл обряд Братания, вернуться в наше логово и обсудить Боевой поход: удар по еретикам, самозванцам и трусам, что прячутся за Маскарадом. Старейшины предали Каина, и мы - его месть, облечённая в плоть.\n"

/datum/sabbat_ritae/ritae_description/blood_feast_info
	name = "Кровавый пир"
	desc = "Кровавый пир - праздничный обряд стаи, который обычно устраивают по случаю любого торжественного сбора. Все наши каиниты (участвовать ли самому, духовник решает сам) расходятся на охоту и состязаются в ней. Горе каиниту, который приволочёт грязного попрошайку с кровью, отдающей землёй. Этот обряд - состязание: кто принесёт стае самый достойный кусок, будь то чересчур любопытный полицейский, отступник Шабаша или еретик-каинит, годный для диаблери. Стая покажет свою силу, и этой ночью пировать будем мы все. \n"

/datum/sabbat_ritae/ritae_description/wild_hunt_info
	name = "Дикая охота"
	desc = "Никто не смеет идти против Каина, и уж тем более тот, кто прошёл обряд Братания! Предателей и перебежчиков, отрёкшихся от Каина и Шабаша, настигнет праведный боевой поход, как и всех, кто знает об их измене. Перед казнью их ждёт диаблери, ритуальный костёр с колом в гнилом сердце или увечья. Никто не смеет идти против Каина, и никто не уйдёт от его мести: ни старейшины Камарильи, ни предатели стаи.\n "

/obj/item/sabbat_priest_tome/attack_self(mob/living/carbon/human/user)
	. = ..()
	if(!user.mind || !is_sabbatist(user.mind.assigned_role))
		to_chat(user, "Вы касаетесь книги и ничего не чувствуете.")
		return

	var/is_priest = is_sabbat_priest(user.mind.assigned_role)

	var/original_icon_state = icon_state
	icon_state = "[original_icon_state]-open"
	addtimer(CALLBACK(src, PROC_REF(close_book)), 10 SECONDS)

	to_chat(user, "Вот священные обряды, дарованные вам Каином.")

	// Define all ritae datums
	var/list/ritae_datums = list(
		"Кредо стаи" = new /datum/sabbat_ritae/ritae_description/pack_credo(),
		"Обряд Братания" = new /datum/sabbat_ritae/ritae_description/vaulderie_info(),
		"Обряд Возведения" = new /datum/sabbat_ritae/ritae_description/shovelhead_info(),
		"Мономахия" = new /datum/sabbat_ritae/ritae_description/monomacy_info(),
		"Кровавая купель" = new /datum/sabbat_ritae/ritae_description/bloodbath_info(),
		"Боевой поход" = new /datum/sabbat_ritae/ritae_description/war_party_hunt_info(),
		"Кровавый пир" = new /datum/sabbat_ritae/ritae_description/blood_feast_info(),
		"Дикая охота" = new /datum/sabbat_ritae/ritae_description/wild_hunt_info()
	)

	var/list/ritae_options = list()

	// Everyone can see "Pack Credo"
	if(is_priest)
		ritae_options += "Кредо стаи (изменить)"
	else
		ritae_options += "Кредо стаи"

	// Only Priests can see other ritae
	if(is_priest)
		for(var/name in ritae_datums)
			if(name != "Кредо стаи")
				ritae_options += name

	var/choice = tgui_input_list(user, "Выберите обряд, о котором хотите узнать:", "Обряды Шабаша", ritae_options)
	if(!choice)
		return

	if(choice == "Кредо стаи (изменить)")
		var/datum/sabbat_ritae/ritae_description/pack_credo/credo = ritae_datums["Кредо стаи"]
		to_chat(user, span_cult("<b>Кредо стаи:</b>"))
		to_chat(user, span_cult("[credo.desc]"))

		var/new_credo = tgui_input_text(user, "Изложите, как ваша стая понимает цели Шабаша:", "Изменить кредо стаи", credo.desc)
		if(new_credo && new_credo != credo.desc)
			credo.desc = new_credo
			to_chat(user, span_cult("Вы переписываете кредо своей стаи."))
		return

	var/datum/sabbat_ritae/ritae_description/ritus = ritae_datums[choice]
	if(ritus)
		to_chat(user, span_cult("<b>[ritus.name]:</b>"))
		to_chat(user, span_cult("[ritus.desc]"))

/obj/item/sabbat_priest_tome/proc/close_book()
	icon_state = initial(icon_state)

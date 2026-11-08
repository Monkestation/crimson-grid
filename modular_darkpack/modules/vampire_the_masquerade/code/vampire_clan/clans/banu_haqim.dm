/datum/subsplat/vampire_clan/banu_haqim
	name = "Banu Haqim Warrior"
	ru_name = "Воины Бану Хаким"
	id = VAMPIRE_CLAN_BANU_HAQIM
	desc = "Западные Сородичи привыкли видеть в Бану Хаким, известных также как ассамиты, опасных убийц и диаблеристов, но на деле это стражи, воины и учёные, которые стараются держаться в стороне от Извечной Борьбы. Бану Хаким - самый молодой клан Камарильи: их приняли после глубокого раскола, вызванного пробуждением мафусаила Ур-Шульги. В обществе Сородичей они остаются чужаками и с трудом нащупывают прочную политическую опору, хотя порой и удерживают шаткое место Примогена, главным образом при поддержке Вентру. Каста воинов - судьи, убийцы и солдаты клана. Во многих городах на воинов-перебежчиков, примкнувших к Камарилье, смотрят как на чужих: они разрываются между верностью клану и неприятием непримиримых воззрений Ур-Шульги. Как и у всех Бану Хаким, изъян искажает их отношение к витэ Сородичей: противоестественная жажда крови других вампиров нередко доводит их до диаблери."
	icon = "banu_haqim"
	curse = "Проклятие Тремер."
	roleplay_level = "Средний"
	sense_the_sin_text = "мнит себя высшим судом."
	clan_disciplines = list(
		/datum/discipline/celerity,
		/datum/discipline/obfuscate,
		/datum/discipline/quietus
	)
	subsplat_traits = list(
		TRAIT_VITAE_ADDICTION
	)
	male_clothes = /obj/item/clothing/under/vampire/bandit
	female_clothes = /obj/item/clothing/under/vampire/bandit
	subsplat_keys = /obj/item/vamp/keys/banuhaqim

/datum/subsplat/vampire_clan/banu_haqim/psychomania_effect(mob/living/target, mob/living/owner)
	to_chat(target, span_cult("Вокруг меня сгущается чьё-то всеподавляющее присутствие..."))
	new /obj/effect/client_image_holder/baali_demon/banu(get_turf(target), list(target))

/datum/subsplat/vampire_clan/banu_haqim/vizier
	name = "Banu Haqim Vizier"
	ru_name = "Визири Бану Хаким"
	desc = "Бану Хаким - самый молодой клан Камарильи: их приняли после глубокого раскола, вызванного пробуждением мафусаила Ур-Шульги. В Сан-Франциско они остаются чужаками и с трудом нащупывают прочную политическую опору, хотя и удерживают шаткое место Примогена, главным образом при поддержке Вентру. Визири - учёные, дипломаты и советники клана, которые ценят ум и взвешенное суждение выше открытого насилия. Среди Бану Хаким, перешедших в Камарилью, много визирей: их пугает фанатизм Ур-Шульги. Как и все Бану Хаким, они несут бремя опасной жажды крови Сородичей и искушения диаблери, а изъян их касты вдобавок заставляет с головой уходить в свои изыскания, ремёсла или личные увлечения."
	id = VAMPIRE_CLAN_BANU_HAQIM_VIZIER
	icon = "banu_haqim_vizier"
	roleplay_level = "Высокий"
	curse = "Одержимость своим делом."
	clan_disciplines = list(
		/datum/discipline/celerity,
		/datum/discipline/auspex,
		/datum/discipline/quietus
	)
	subsplat_traits =  list()

/datum/subsplat/vampire_clan/banu_haqim/on_join_round(mob/living/carbon/human/joining)
	. = ..()
	joining.grant_language(/datum/language/arabic)

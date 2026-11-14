//CRIMSON GRID ADDITION: Jazz Club Servant, To Help Host Ventrue Jazz Club Parties

/datum/job/vampire/jazz_servant
	title = JOB_JAZZ_SERVANT
	faction = FACTION_CAMARILLA
	total_positions = 2
	spawn_positions = 2
	supervisors = "Primogen Ventrue"
	config_tag = "JAZZ_SERVANT"

	description = "A servant of the local Jazz Club hosted by the Camarilla. You are a conscious servant of the Jazz Club, be it because of your clan allegiance, or because you were put into servitude. Aside from the usual responsabilities, you can enjoy a lavish lifestyle at the local Jazz Club."
	maximal_generation = 9
	maximum_immortal_age = 200
	minimum_masquerade = 5

	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/jazz_servant

	display_order = JOB_DISPLAY_ORDER_JAZZ_SERVANT
	departments_list = list(
		/datum/job_department/camarilla,
	)

	alt_titles = list(
		"Waiter",
		"Servant",
		"Maître d'",
		"Vallet",
		"Sommelier",
		"Major-Domo",
	)

	tgui_icon = FA_ICON_WINE_GLASS_EMPTY

	known_contacts = list(
		JOB_TOWERWORK,
		JOB_PRIMOGEN_VENTRUE,
	)

	allowed_splats = list(SPLAT_KINDRED, SPLAT_GHOUL, SPLAT_KINFOLK, SPLAT_NONE)
	allowed_clans = list(VAMPIRE_CLAN_DAUGHTERS_OF_CACOPHONY, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_BANU_HAQIM_VIZIER, VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_TLACIQUE, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_GARGOYLE, VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_CAPPADOCIAN, VAMPIRE_CLAN_TZIMISCE, VAMPIRE_CLAN_SAMEDI, VAMPIRE_CLAN_NAGARAJA)

/datum/outfit/job/vampire/jazz_servant
	name = JOB_JAZZ_SERVANT
	jobtype = /datum/job/vampire/jazz_servant

	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire
	r_pocket = /obj/item/vamp/keys/jazz_servant
	l_pocket = /obj/item/smartphone/jazz_servant
	backpack_contents = list(/obj/item/card/credit=1)

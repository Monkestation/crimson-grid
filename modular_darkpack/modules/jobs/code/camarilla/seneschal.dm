/datum/job/vampire/clerk
	title = JOB_SENESCHAL
	description = "You are the right hand man or woman of the most powerful vampire in the city. The Camarilla trusts you to run the city, even in their stead."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_CAMARILLA
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_PRINCE
	req_admin_notify = 1
	minimal_player_age = 10
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CAMARILLA
	exp_required_type_department = EXP_TYPE_CAMARILLA
	exp_granted_type = EXP_TYPE_CAMARILLA
	config_tag = "SENESCHAL"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/clerk

	display_order = JOB_DISPLAY_ORDER_CLERK
	departments_list = list(
		/datum/job_department/camarilla,
	)

	minimal_generation = 12
	minimum_masquerade = 5
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_DAUGHTERS_OF_CACOPHONY, VAMPIRE_CLAN_TRUE_BRUJAH, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_BANU_HAQIM_VIZIER, VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_TLACIQUE, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_GARGOYLE, VAMPIRE_CLAN_KIASYD)

	known_contacts = list(
		JOB_PRINCE,
		JOB_SHERIFF,
		JOB_CHANTRY_REGENT,
		JOB_DEALER,
		JOB_EMISSARY,
		JOB_BARON,
		JOB_PRIMOGEN_BANU_HAQIM,
		JOB_PRIMOGEN_TOREADOR,
		JOB_PRIMOGEN_LASOMBRA,
		JOB_PRIMOGEN_MALKAVIAN,
		JOB_PRIMOGEN_VENTRUE,
		JOB_PRIMOGEN_NOSFERATU
	)

/datum/outfit/job/vampire/clerk
	name = JOB_SENESCHAL
	jobtype = /datum/job/vampire/clerk

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/clerk
	uniform = /obj/item/clothing/under/vampire/clerk
	shoes = /obj/item/clothing/shoes/vampire/brown
	l_pocket = /obj/item/smartphone/seneschal
	r_pocket = /obj/item/vamp/keys/clerk
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/card/credit/seneschal=1)

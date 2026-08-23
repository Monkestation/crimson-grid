/datum/job/vampire/primogen_toreador
	title = JOB_PRIMOGEN_TOREADOR
	description = "Offer your infinite knowledge to Prince of the City. Take care of the Strip Club and its Elysium, for it is your domain and a social center within the city."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_CAMARILLA
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_TRADITIONS
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CAMARILLA
	exp_required_type_department = EXP_TYPE_CAMARILLA
	exp_granted_type = EXP_TYPE_CAMARILLA
	config_tag = "PRIMOGEN_TOREADOR"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/toreador

	display_order = JOB_DISPLAY_ORDER_TOREADOR
	departments_list = list(
		/datum/job_department/strip_club,
		/datum/job_department/camarilla,
	)

	minimal_generation = 12
	minimum_immortal_age = 50
	minimum_masquerade = 5
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_TOREADOR)

	known_contacts = list(
		JOB_PRINCE,
		JOB_SHERIFF,
		JOB_SENESCHAL,
		JOB_HARPY,
		JOB_CLUB_WORKER,
		JOB_PRIMOGEN_BANU_HAQIM,
		JOB_PRIMOGEN_LASOMBRA,
		JOB_PRIMOGEN_MALKAVIAN,
		JOB_PRIMOGEN_VENTRUE,
		JOB_PRIMOGEN_NOSFERATU,
		JOB_CHANTRY_REGENT
	)

/datum/outfit/job/vampire/toreador
	name = JOB_PRIMOGEN_TOREADOR
	jobtype = /datum/job/vampire/primogen_toreador

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/primogen
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/primogen_toreador
	suit = /obj/item/clothing/suit/vampire/trench/alt
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/smartphone/toreador_primo
	backpack_contents = list(/obj/item/vamp/keys/toreador/primogen=1, /obj/item/card/credit/elder=1, /obj/item/card/whip, /obj/item/card/steward, /obj/item/card/myrmidon, /obj/item/gun/ballistic/automatic/pistol/darkpack/beretta/toreador=1, /obj/item/ammo_box/magazine/semi9mm/toreador=1)

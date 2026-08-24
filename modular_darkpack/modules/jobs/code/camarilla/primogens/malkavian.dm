/datum/job/vampire/primogen_malkavian
	title = JOB_PRIMOGEN_MALKAVIAN
	description = "Offer your infinite knowledge to Prince of the City. You likely have a hold over the local hospital, make good use of it and ensure the blood bags remain available."
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
	config_tag = "PRIMOGEN_MALKAVIAN"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/malkav

	display_order = JOB_DISPLAY_ORDER_MALKAVIAN
	departments_list = list(
		/datum/job_department/clinic,
		/datum/job_department/camarilla,
	)

	minimal_generation = 12
	minimum_immortal_age = 5 // Actually Malkavian Primo is whoever showed for work that day. Crazy bunch.
	minimum_masquerade = 5
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN)

	known_contacts = list(
		JOB_PRINCE,
		JOB_SHERIFF,
		JOB_SENESCHAL,
		JOB_HARPY,
		JOB_PRIMOGEN_BANU_HAQIM,
		JOB_PRIMOGEN_TOREADOR,
		JOB_PRIMOGEN_LASOMBRA,
		JOB_PRIMOGEN_VENTRUE,
		JOB_PRIMOGEN_NOSFERATU,
		JOB_CHANTRY_REGENT
	)

/datum/outfit/job/vampire/malkav
	name = JOB_PRIMOGEN_MALKAVIAN
	jobtype = /datum/job/vampire/primogen_malkavian

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/primogen
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/primogen_malkavian
	suit = /obj/item/clothing/suit/vampire/trench/malkav
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	head = /obj/item/clothing/head/vampire/malkav
	l_pocket = /obj/item/smartphone/malkavian_primo
	backpack_contents = list(/obj/item/vamp/keys/malkav/primogen=1, /obj/item/card/credit/elder=1, /obj/item/card/whip, /obj/item/card/steward, /obj/item/card/myrmidon)

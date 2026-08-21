/datum/job/vampire/primogen_nosferatu
	title = JOB_PRIMOGEN_NOSFERATU
	description = "Offer your infinite knowledge to Prince of the City, and run the warren, your domain watches over the sewers."
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
	config_tag = "PRIMOGEN_NOSFERATU"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/nosferatu

	display_order = JOB_DISPLAY_ORDER_NOSFERATU
	departments_list = list(
		/datum/job_department/camarilla,
		/datum/job_department/city_services
	)

	minimal_generation = 12
	minimum_immortal_age = 15
	minimum_masquerade = 5
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_NOSFERATU)

	known_contacts = list(
		JOB_PRINCE,
		JOB_SHERIFF,
		JOB_SENESCHAL,
		JOB_HARPY,
		JOB_PRIMOGEN_BANU_HAQIM,
		JOB_PRIMOGEN_TOREADOR,
		JOB_PRIMOGEN_LASOMBRA,
		JOB_PRIMOGEN_MALKAVIAN,
		JOB_PRIMOGEN_VENTRUE
	)

/datum/outfit/job/vampire/nosferatu
	name = JOB_PRIMOGEN_NOSFERATU
	jobtype = /datum/job/vampire/primogen_nosferatu

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/primogen
	mask = /obj/item/clothing/mask/vampire/shemagh
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/smartphone/nosferatu_primo
	backpack_contents = list(/obj/item/vamp/keys/nosferatu/primogen=1, /obj/item/card/credit/elder=1, /obj/item/card/whip, /obj/item/card/steward, /obj/item/card/myrmidon)

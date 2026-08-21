/datum/job/vampire/primogen_banu
	title = JOB_PRIMOGEN_BANU_HAQIM
	description = "Offer your infinite knowledge to Prince of the City, while overseeing the Banu Haqim in the city. Monitor their contracts and ensure they remain true to the ways of the Clan. You have an official cover with the Police Department as a local civilian consultant, ensure things run smoothly, on either end."
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
	config_tag = "PRIMOGEN_BANU_HAQIM"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/banuprim

	display_order = JOB_DISPLAY_ORDER_BANU
	departments_list = list(
		/datum/job_department/camarilla,
	)

	minimal_generation = 12
	minimum_immortal_age = 50
	minimum_masquerade = 5
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_BANU_HAQIM_VIZIER)

	known_contacts = list(
		JOB_PRINCE,
		JOB_SHERIFF,
		JOB_SENESCHAL,
		JOB_HARPY,
		JOB_PRIMOGEN_TOREADOR,
		JOB_PRIMOGEN_LASOMBRA,
		JOB_PRIMOGEN_MALKAVIAN,
		JOB_PRIMOGEN_VENTRUE,
		JOB_PRIMOGEN_NOSFERATU
	)

/datum/outfit/job/vampire/banuprim
	name = JOB_PRIMOGEN_BANU_HAQIM
	jobtype = /datum/job/vampire/primogen_banu

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/primogen
	glasses = /obj/item/clothing/glasses/vampire/yellow
	uniform = /obj/item/clothing/under/vampire/turtleneck_navy
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/smartphone/banu_primo
	backpack_contents = list(/obj/item/vamp/keys/banuhaqim/primogen=1, /obj/item/card/credit/elder=1, /obj/item/card/whip, /obj/item/card/steward, /obj/item/card/myrmidon)

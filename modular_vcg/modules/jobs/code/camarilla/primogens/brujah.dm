/datum/job/vampire/primogen_brujah
	title = JOB_PRIMOGEN_BRUJAH
	description = "Offer your infinite knowledge to Prince of the City. Ensure that your clan does not cause too much trouble and too many fights with the local authorities. Your cover identity as the owner of the local gym has remained steady for now, ensure that it stays that way."
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
	config_tag = "PRIMOGEN_BRUJAH"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/brujahprim

	display_order = JOB_DISPLAY_ORDER_BRUJAH
	departments_list = list(
		/datum/job_department/camarilla,
	)

	minimal_generation = 10
	minimum_immortal_age = 100
	minimum_masquerade = 5
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_BRUJAH)

	known_contacts = list(
		JOB_PRINCE,
		JOB_SHERIFF,
		JOB_SENESCHAL,
		JOB_HARPY,
		JOB_PRIMOGEN_BANU_HAQIM,
		JOB_PRIMOGEN_TOREADOR,
		JOB_PRIMOGEN_LASOMBRA,
		JOB_PRIMOGEN_MALKAVIAN,
		JOB_PRIMOGEN_VENTRUE,
		JOB_PRIMOGEN_NOSFERATU
	)

/datum/outfit/job/vampire/brujahprim
	name = JOB_PRIMOGEN_BRUJAH
	jobtype = /datum/job/vampire/primogen_brujah

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/primogen
	glasses = /obj/item/clothing/glasses/vampire/yellow
	uniform = /obj/item/clothing/under/vampire/punk
	suit = /obj/item/clothing/suit/vampire/jacket/punk
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/smartphone/brujah_primo
	backpack_contents = list(/obj/item/vamp/keys/brujah/primogen=1, /obj/item/card/credit/elder=1, /obj/item/instrument/eguitar=1, /obj/item/card/whip, /obj/item/card/steward, /obj/item/card/myrmidon)

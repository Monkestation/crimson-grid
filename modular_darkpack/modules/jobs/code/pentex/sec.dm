/datum/job/vampire/pentex_sec
	title = JOB_PENTEX_SEC
	description = "You are an acting security for " + MAIN_EVIL_COMPANY + ", operating out of San Francisco. Under the chief of security's direction, your job is to keep the complex free of nosy meddlers, pick up contract violators, and to assist the chief in tackling threats to corporate assets."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_CITY
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Board, Branch Lead, and Chief of Security"
	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 100
	exp_required_type = EXP_TYPE_SPIRAL
	exp_required_type_department = EXP_TYPE_SPIRAL
	exp_granted_type = EXP_TYPE_SPIRAL
	config_tag = "PENTEX_SEC"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/pentex_sec

	allowed_tribes = list(TRIBE_BLACK_SPIRAL_DANCERS, TRIBE_RONIN)
	minimal_masquerade = 3

	display_order = JOB_DISPLAY_ORDER_PENTEX_SEC
	department_for_prefs = /datum/job_department/pentex
	departments_list = list(
		/datum/job_department/pentex,
	)

	known_contacts = list(
		JOB_PENTEX_LEAD,
		JOB_PENTEX_EXEC,
		JOB_PENTEX_AFFAIRS,
		JOB_PENTEX_SEC_CHIEF
	)

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

/datum/outfit/job/vampire/pentex_sec
	name = JOB_PENTEX_SEC
	jobtype = /datum/job/vampire/pentex_sec

//	ears = /obj/item/p25radio
	id = /obj/item/card/pentex/sec
	uniform =  /obj/item/clothing/under/vampire/pentex_shortsleeve
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	gloves = /obj/item/clothing/gloves/vampire/work
	suit = /obj/item/clothing/suit/vampire/vest
	belt = /obj/item/storage/belt/holster/detective/darkpack/endron
	l_pocket = /obj/item/smartphone // /sec - todo subtype
	r_pocket = /obj/item/vamp/keys/pentex
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/card/credit=1)

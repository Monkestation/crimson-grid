/datum/job/vampire/secchief
	title = JOB_PENTEX_SEC_CHIEF
	description = "You are an acting chief of security for the Endron Oil Refinery, operating out of San Francisco. With discretion to the Branch Leader, your job is to keep the complex and it's proprietary information with the help of your security team, and to turn over contract violators to internal affairs or the executives."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_CITY
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Board and the Branch Lead"
	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 150
	exp_required_type = EXP_TYPE_SPIRAL
	exp_required_type_department = EXP_TYPE_SPIRAL
	exp_granted_type = EXP_TYPE_SPIRAL
	config_tag = "PENTEX_SECCHIEF"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/secchief

	allowed_splats = list(SPLAT_GAROU, SPLAT_KINDRED)
	minimal_masquerade = 4
	// minimal_renown_rank = 3
	allowed_tribes = list(TRIBE_BLACK_SPIRAL_DANCERS, TRIBE_RONIN)

	display_order = JOB_DISPLAY_ORDER_SECCHIEF
	department_for_prefs = /datum/job_department/pentex
	departments_list = list(
		/datum/job_department/pentex,
	)

	known_contacts = list(
		JOB_PENTEX_LEAD,
		JOB_PENTEX_EXEC,
		JOB_PENTEX_AFFAIRS
	)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

/datum/outfit/job/vampire/secchief
	name = "Endron Chief of Security"
	jobtype = /datum/job/vampire/secchief

//	ears = /obj/item/p25radio
	id = /obj/item/card/pentex/secchief
	uniform =  /obj/item/clothing/under/vampire/pentex_turtleneck
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	gloves = /obj/item/clothing/gloves/vampire/work
	head = /obj/item/clothing/head/vampire/pentex_beret
	suit = /obj/item/clothing/suit/vampire/vest
	belt = /obj/item/storage/belt/holster/detective/darkpack/endron
	glasses = /obj/item/clothing/glasses/vampire/sun
	l_pocket = /obj/item/smartphone // /secchief - todo subtype
	r_pocket = /obj/item/vamp/keys/pentex
	backpack_contents = list(/obj/item/gun/ballistic/automatic/pistol/darkpack/deagle=1, /obj/item/phone_book=1, /obj/item/veil_contract, /obj/item/card/credit/rich=1)

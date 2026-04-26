/datum/job/vampire/executive
	title = JOB_PENTEX_EXEC
	description = "You are an acting executive for " + MAIN_EVIL_COMPANY + " operating out of San Francisco. With discretion to the Branch Leader, a position you may aim for, your job is to fuel production and expand operations."
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
	config_tag = "PENTEX_EXECUTIVE"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/executive

	alt_titles = list(
		"Endron Executive",
		"Endron Regional Manager",
		"Endron Manager",
		"Endron Marketing Director",
		"Endron Public Relations Manager",
		"Endron Deputy Branch Director",
		"Endron Chief Innovation Officer",
		"Endron Chief Science Officer",
		"Endron Chief Financial Officer"
	)

	allowed_splats = list(SPLAT_GAROU, SPLAT_KINDRED)
	minimal_masquerade = 4
	// minimal_renown_rank = 3
	allowed_tribes = list(TRIBE_BLACK_SPIRAL_DANCERS, TRIBE_RONIN)

	display_order = JOB_DISPLAY_ORDER_EXECUTIVE
	department_for_prefs = /datum/job_department/pentex
	departments_list = list(
		/datum/job_department/pentex,
	)

	known_contacts = list(
		JOB_PENTEX_LEAD,
		JOB_PENTEX_AFFAIRS,
		JOB_PENTEX_SEC_CHIEF
	)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

/datum/outfit/job/vampire/executive
	name = JOB_PENTEX_EXEC
	jobtype = /datum/job/vampire/executive

//	ears = /obj/item/p25radio
	id = /obj/item/card/pentex/executive
	uniform =  /obj/item/clothing/under/vampire/pentex_executive_suit
	shoes = /obj/item/clothing/shoes/vampire/businessblack
	l_pocket = /obj/item/smartphone // /pentex_exec - todo: subtype
	r_pocket = /obj/item/vamp/keys/pentex
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/card/credit/seneschal=1)

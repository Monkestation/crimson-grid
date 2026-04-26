/datum/job/vampire/employee
	title = JOB_PENTEX_EMPLOYEE
	description = "You are an employee for " + MAIN_EVIL_COMPANY + ", operating out of San Francisco. Your bosses can be a little strange; give credence to the security team and executives for tasks on the night shift, and avoid getting negative attention from the branch manager or internal affairs."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_CITY
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Board and the Branch Lead"
	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 50
	exp_required_type = EXP_TYPE_SPIRAL
	exp_required_type_department = EXP_TYPE_SPIRAL
	exp_granted_type = EXP_TYPE_SPIRAL
	config_tag = "PENTEX_EMPLOYEE"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/employee

	alt_titles = list(
		"Endron Employee",
		"Endron Janitor",
		"Endron Secretary",
		"Endron Researcher",
		"Endron Labourer"
	)

	allowed_tribes = list(TRIBE_BLACK_SPIRAL_DANCERS, TRIBE_RONIN)
	minimal_masquerade = 3

	display_order = JOB_DISPLAY_ORDER_EMPLOYEE
	department_for_prefs = /datum/job_department/pentex
	departments_list = list(
		/datum/job_department/pentex,
	)

	known_contacts = list(
		JOB_PENTEX_LEAD,
		JOB_PENTEX_EXEC,
		JOB_PENTEX_AFFAIRS
	)

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_LAW_ENFORCEMENT_METABOLISM)

/datum/outfit/job/vampire/employee
	name = JOB_PENTEX_EMPLOYEE
	jobtype = /datum/job/vampire/employee

//	ears = /obj/item/p25radio
	id = /obj/item/card/pentex
	uniform = /obj/item/clothing/under/vampire/pentex_longleeve
	gloves = /obj/item/clothing/gloves/vampire/work
	shoes = /obj/item/clothing/shoes/vampire
	r_pocket = /obj/item/vamp/keys/pentex
	l_pocket = /obj/item/smartphone // /employee - todo subtype
	backpack_contents = list(/obj/item/card/credit=1)

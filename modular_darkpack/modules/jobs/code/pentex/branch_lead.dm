/datum/job/vampire/branch_lead
	title = JOB_PENTEX_LEAD
	description = "You are the current branch leader for " + MAIN_EVIL_COMPANY + " , operating out of San Francisco. Your job is to fuel production and keep your clowns in line."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_CITY
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Board"
	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 180
	exp_required_type = EXP_TYPE_SPIRAL
	exp_required_type_department = EXP_TYPE_SPIRAL
	exp_granted_type = EXP_TYPE_SPIRAL
	config_tag = "PENTEX_BRANCH_LEAD"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/branch_lead

	alt_titles = list(
		"Endron Branch Lead",
		"Endron Branch Director",
		"Endron Regional Director",
		"Endron Operations Director"
	)

	minimal_masquerade = 5
	// minimal_renown_rank = 4
	allowed_tribes = list(TRIBE_BLACK_SPIRAL_DANCERS, TRIBE_RONIN)

	display_order = JOB_DISPLAY_ORDER_BRANCH_LEAD
	department_for_prefs = /datum/job_department/pentex
	departments_list = list(
		/datum/job_department/pentex,
	)

	known_contacts = list(
		JOB_PENTEX_EXEC,
		JOB_PENTEX_AFFAIRS,
		JOB_PENTEX_SEC_CHIEF
	)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

/datum/outfit/job/vampire/branch_lead
	name = MAIN_EVIL_COMPANY + " Branch Lead"
	jobtype = /datum/job/vampire/branch_lead

//	ears = /obj/item/p25radio
	id = /obj/item/card/pentex/branch_lead
	uniform =  /obj/item/clothing/under/vampire/pentex_executive_suit
	shoes = /obj/item/clothing/shoes/vampire/businessblack
	suit = /obj/item/clothing/suit/vampire/pentex_labcoat_alt
	l_pocket = /obj/item/smartphone // /branch_lead - TODO: phone subtype
	r_pocket = /obj/item/vamp/keys/pentex
	backpack_contents = list(/obj/item/gun/ballistic/automatic/pistol/darkpack/deagle=1, /obj/item/phone_book=1, /obj/item/card/credit/prince=1)

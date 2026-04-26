/datum/job/vampire/affairs
	title = JOB_PENTEX_AFFAIRS
	description = "You are the internal affairs agent operating for " + MAIN_EVIL_COMPANY + ". You know the bloody and vile needs commanded of destruction will lead to jeopardy, and your duty is to see excellence on task rewarded and acknowledged, and curb the invariable atrocities that could endanger the greater plans of Pentex."
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
	config_tag = "PENTEX_AFFAIRS"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/affairs

	allowed_splats = list(SPLAT_GAROU)
	minimal_masquerade = 5
	// minimal_renown_rank = 3
	allowed_tribes = list(TRIBE_BLACK_SPIRAL_DANCERS, TRIBE_RONIN)

	display_order = JOB_DISPLAY_ORDER_AFFAIRS
	department_for_prefs = /datum/job_department/pentex
	departments_list = list(
		/datum/job_department/pentex,
	)

	known_contacts = list(
		JOB_PENTEX_LEAD,
		JOB_PENTEX_EXEC,
		JOB_PENTEX_SEC_CHIEF
	)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

/datum/outfit/job/vampire/affairs
	name = JOB_PENTEX_AFFAIRS
	jobtype = /datum/job/vampire/affairs

//	ears = /obj/item/p25radio
	id = /obj/item/card/pentex/affairs
	uniform =  /obj/item/clothing/under/vampire/pentex_suit
	shoes = /obj/item/clothing/shoes/vampire/businessblack
	l_pocket = /obj/item/smartphone // /affairsagent - todo subtype
	r_pocket = /obj/item/vamp/keys/pentex
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/veil_contract, /obj/item/card/credit/rich=1)

/datum/job/vampire/affairs
	title = JOB_PENTEX_AFFAIRS
	description = "Вы агент внутренних расследований \"Эндрон Интернейшнл\". Вы знаете: дело разрушения требует крови и грязи, а это всегда риск. Ваш долг - следить, чтобы образцовую работу замечали и вознаграждали, и пресекать неизбежные зверства, способные поставить под удар большие замыслы \"Пентекс\"."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_PENTEX
	total_positions = 1
	spawn_positions = 1
	supervisors = "советом директоров и главой филиала"
	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = EXP_REQ_MINOR
	exp_required_type_department = EXP_TYPE_SPIRAL
	config_tag = "PENTEX_AFFAIRS"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/affairs

	allowed_splats = list(SPLAT_GAROU)
	minimum_masquerade = 5
	// minimal_renown_rank = 3
	allowed_tribes = list(TRIBE_BLACK_SPIRAL_DANCERS, TRIBE_RONIN)
	desensitized_base = DESENSITIZED_THRESHOLD // CRIMSON EDIT ADDITION - JOB MOOD
	display_order = JOB_DISPLAY_ORDER_AFFAIRS
	departments_list = list(
		/datum/job_department/pentex,
	)

	tgui_icon = FA_ICON_BRIEFCASE

	known_contacts = list(
		JOB_PENTEX_LEAD,
		JOB_PENTEX_EXEC,
		JOB_PENTEX_SEC_CHIEF,
		JOB_PENTEX_EMPLOYEE,
		JOB_PENTEX_SEC
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
	l_pocket = /obj/item/smartphone/endron_affairs
	r_pocket = /obj/item/vamp/keys/pentex
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/veil_contract, /obj/item/card/credit/rich=1)

/datum/job/vampire/pentex_sec
	title = JOB_PENTEX_SEC
	description = "Вы агент службы безопасности филиала \"Эндрон Интернейшнл\" в Сан-Франциско. По указаниям начальника службы вы не пускаете на территорию комплекса любопытных, задерживаете нарушителей контракта и помогаете устранять угрозы имуществу корпорации."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_PENTEX
	total_positions = 2
	spawn_positions = 2
	supervisors = "советом директоров, главой филиала и начальником службы безопасности"
	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = EXP_REQ_MINOR
	config_tag = "PENTEX_SEC"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/pentex_sec

	allowed_tribes = list(TRIBE_BLACK_SPIRAL_DANCERS, TRIBE_RONIN)
	maximal_generation = 9
	maximum_immortal_age = 200
	minimum_masquerade = 3
	desensitized_base = DESENSITIZED_THRESHOLD // CRIMSON EDIT ADDITION - JOB MOOD
	display_order = JOB_DISPLAY_ORDER_PENTEX_SEC
	departments_list = list(
		/datum/job_department/pentex,
	)

	tgui_icon = FA_ICON_SHIELD_VIRUS

	known_contacts = list(
		JOB_PENTEX_LEAD,
		JOB_PENTEX_EXEC,
		JOB_PENTEX_AFFAIRS,
		JOB_PENTEX_SEC_CHIEF,
		JOB_PENTEX_EMPLOYEE,
		JOB_PENTEX_SEC
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
	l_pocket = /obj/item/smartphone/endron_security
	r_pocket = /obj/item/vamp/keys/pentex
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/card/credit=1, /obj/item/clothing/mask/gas/darkpack/military/pentex=1)

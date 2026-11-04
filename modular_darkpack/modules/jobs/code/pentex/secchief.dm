/datum/job/vampire/secchief
	title = JOB_PENTEX_SEC_CHIEF
	description = "Вы начальник службы безопасности нефтеперерабатывающего завода \"Эндрон\" в Сан-Франциско. Последнее слово остаётся за главой филиала, а ваша задача - силами своих людей охранять комплекс и его коммерческие тайны, а нарушителей контракта передавать отделу внутренних расследований или руководству."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_PENTEX
	total_positions = 1
	spawn_positions = 1
	supervisors = "советом директоров и главой филиала"
	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = EXP_REQ_MINOR
	exp_required_type_department = EXP_TYPE_SPIRAL
	config_tag = "PENTEX_SECCHIEF"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/secchief

	allowed_splats = list(SPLAT_GAROU, SPLAT_KINDRED)
	minimum_masquerade = 4
	// minimal_renown_rank = 3
	allowed_tribes = list(TRIBE_BLACK_SPIRAL_DANCERS, TRIBE_RONIN)
	desensitized_base = DESENSITIZED_THRESHOLD // CRIMSON EDIT ADDITION - JOB MOOD
	display_order = JOB_DISPLAY_ORDER_SECCHIEF
	departments_list = list(
		/datum/job_department/pentex,
	)

	tgui_icon = FA_ICON_SHIELD_VIRUS

	known_contacts = list(
		JOB_PENTEX_LEAD,
		JOB_PENTEX_EXEC,
		JOB_PENTEX_AFFAIRS,
		JOB_PENTEX_EMPLOYEE,
		JOB_PENTEX_SEC
	)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

/datum/outfit/job/vampire/secchief
	name = JOB_PENTEX_SEC_CHIEF
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
	l_pocket = /obj/item/smartphone/endron_sec_chief
	r_pocket = /obj/item/vamp/keys/pentex
	backpack_contents = list(/obj/item/gun/ballistic/automatic/pistol/darkpack/deagle=1, /obj/item/phone_book=1, /obj/item/veil_contract, /obj/item/card/credit/rich=1, /obj/item/clothing/mask/gas/darkpack/military/pentex=1)

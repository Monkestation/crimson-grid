/datum/job/vampire/abbe
	title = JOB_ABBE
	description = "Вы аббат Общества Леопольда. Вы держите ответ перед провинциалом этих земель и опекаете местный ценакул инквизиторов. Инквизиция поручила вам следить, чтобы ценакул ни в чём не нуждался и никто из братьев не пропал из виду, а ещё искоренять ересь и выявлять лазутчиков. Ведите инквизиторов за собой, ибо Господь велел вам быть сторожем брату своему."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	faction = FACTION_CITY
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_SOCIETY_OF_LEOPOLD
	minimal_player_age = 7
	config_tag = "ABBE"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/abbe

	exp_requirements = EXP_REQ_HEAD
	exp_required_type_department = EXP_TYPE_SOCIETY_OF_LEOPOLD
	desensitized_base = DESENSITIZED_THRESHOLD // CRIMSON EDIT ADDITION - JOB MOOD
	display_order = JOB_DISPLAY_ORDER_ABBE
	departments_list = list(
		/datum/job_department/society_of_leopold,
	)

	known_contacts = list(
		JOB_CONDOTTIERI,
		JOB_INQUISITOR,
		JOB_NOVICE
	)

	allowed_splats = list(SPLAT_NONE)

	tgui_icon = FA_ICON_CROSS

/datum/outfit/job/vampire/abbe
	name = JOB_ABBE
	jobtype = /datum/job/vampire/abbe

	id = /obj/item/card/hunter
	uniform = /obj/item/clothing/under/vampire/suit
	gloves = /obj/item/clothing/gloves/vampire/work
	suit = /obj/item/clothing/suit/vampire/orthodox
	shoes = /obj/item/clothing/shoes/vampire
	glasses = /obj/item/clothing/glasses/vampire/perception
	r_pocket = /obj/item/vamp/keys/hunter
	l_pocket = /obj/item/smartphone/abbe
	backpack_contents = list(/obj/item/vampire_stake=1, /obj/item/intel_report=1, /obj/item/vampirebook/bible=1, /obj/item/card/credit=1)

/datum/outfit/job/vampire/abbe/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.mind.set_holy_role(HOLY_ROLE_HIGHPRIEST)

/datum/outfit/job/vampire/abbe/post_equip(mob/living/carbon/human/H)
	. = ..()
	H.grant_language(/datum/language/latin, source = "job")
	H.grant_language(/datum/language/italian, source = "job")

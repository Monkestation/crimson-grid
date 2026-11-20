/datum/job/vampire/hos_executive
	title = JOB_HOS_EXECUTIVE
	faction = FACTION_HOS
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_CORAX_HOS
	config_tag = "JOB_HOS_EXECUTIVE"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/hos_executive

	display_order = JOB_DISPLAY_ORDER_EXECUTIVE
	exp_required_type_department = EXP_TYPE_HOS
	departments_list = list(
		/datum/job_department/hos,
	)

	tgui_icon = FA_ICON_CROW


	known_contacts = list(
		JOB_HOS_GARRISON,
		JOB_DEALER,
        JOB_HOS_COORDINATOR,
        JOB_HOS_EXECUTIVE,
	)
	allowed_splats = list(SPLAT_CORAX)
	description = "You are the Executive Manager of Helios Overnight Services. It is your job to assist the Lead Coordinator in all tasks and duties relating to the business, whether it be dispatching enemies or dispatching personnel and packages."
	minimum_masquerade = 3

/datum/outfit/job/vampire/hos_executive
	name = JOB_HOS_EXECUTIVE
	jobtype = /datum/job/vampire/hos_executive
	uniform = /obj/item/clothing/under/vampire/turtleneck_navy
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/smartphone/hos_executive
	r_pocket = /obj/item/vamp/keys/hos
	backpack_contents = list(
        /obj/item/card/credit/rich=1,
        /obj/item/phone_book=1,
        /obj/item/flashlight/seclite=1,
        /obj/item/restraints/handcuffs = 1,
    )

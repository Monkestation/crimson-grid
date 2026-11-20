/datum/job/vampire/hos_garrison
	title = JOB_HOS_GARRISON
	faction = FACTION_HOS
	total_positions = 5
	spawn_positions = 5
	supervisors = SUPERVISOR_HOS
	config_tag = "JOB_HOS_GARRISON"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/hos_garrison

	display_order = JOB_DISPLAY_ORDER_GARRISON
	exp_required_type_department = EXP_TYPE_HOS
	departments_list = list(
		/datum/job_department/hos,
	)

	tgui_icon = FA_ICON_CROW

	known_contacts = list(
        JOB_HOS_EXECUTIVE,
        JOB_HOS_COORDINATOR,
		JOB_HOS_GARRISON
	)

	allowed_splats = list(SPLAT_CORAX, SPLAT_KINFOLK)
	description = "You are a Garrison of Helios Overnight Services. It is your job to serve under your superiors, and as a family of Helios Overnight Services."
	minimum_masquerade = 3

/datum/outfit/job/vampire/hos_garrison
	name = JOB_HOS_GARRISON
	jobtype = /datum/job/vampire/hos_garrison
	uniform = /obj/item/clothing/under/vampire/turtleneck_navy
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/smartphone/hos_garrison
	r_pocket = /obj/item/vamp/keys/hos
	backpack_contents = list(
        /obj/item/card/credit=1,
        /obj/item/phone_book=1,
        /obj/item/flashlight/seclite=1,
    )

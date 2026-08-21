/datum/job/vampire/dispatcher
	title = JOB_EMERGENCY_DISPATCHER
	faction = FACTION_CITY
	total_positions = 2
	spawn_positions = 2
	supervisors = " the SF local government."
	config_tag = "DISPATCHER"
	outfit = /datum/outfit/job/vampire/dispatcher
	job_flags = CITY_JOB_FLAGS
	display_order = JOB_DISPLAY_ORDER_DISPATCHER
	exp_required_type_department = EXP_TYPE_POLICE
	departments_list = list(
		/datum/job_department/police,
		/datum/job_department/clinic,
	)

	allowed_splats = list(SPLAT_GHOUL, SPLAT_KINFOLK, SPLAT_NONE)
	splat_slots = list(SPLAT_GHOUL = 1, SPLAT_KINFOLK = 1)

	description = "Report emergencies to the correct emergency service."
	minimum_masquerade = 0
	known_contacts = list(
		JOB_POLICE_CAPTAIN,
		JOB_POLICE_SERGEANT,
		JOB_POLICE_OFFICER,
		JOB_EMERGENCY_DISPATCHER
	)

/datum/outfit/job/vampire/dispatcher
	name = JOB_EMERGENCY_DISPATCHER
	jobtype = /datum/job/vampire/dispatcher
	uniform = /obj/item/clothing/under/vampire/office
	ears = /obj/item/radio/headset/darkpack
	shoes = /obj/item/clothing/shoes/vampire/businessblack
	id = /obj/item/card/government
	l_pocket = /obj/item/smartphone/dispatch
	r_pocket = /obj/item/vamp/keys/dispatch
	backpack_contents = list(/obj/item/card/credit=1)

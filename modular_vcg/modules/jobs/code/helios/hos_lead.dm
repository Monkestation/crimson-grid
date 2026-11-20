/datum/job/vampire/hos_lead
	title = JOB_HOS_COORDINATOR
	faction = FACTION_HOS
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_HOS
	config_tag = "JOB_HOS_COORDINATOR"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/hos_lead

	display_order = JOB_DISPLAY_ORDER_COORDINATOR
	exp_required_type_department = EXP_TYPE_HOS
	departments_list = list(
		/datum/job_department/hos,
	)

	tgui_icon = FA_ICON_CROW

	known_contacts = list(
		JOB_HOS_GARRISON,
		JOB_DEALER,
        JOB_HOS_EXECUTIVE,
        JOB_GAROU_COUNCIL,
        JOB_HOS_COORDINATOR
	)

	allowed_splats = list(SPLAT_CORAX)
	description = "You are the Lead Coordinator of Helios Overnight Services. It is your job to organize all of the comings and goings at the business, making sure that everything is handled and sorted. Nothing must escape your gaze."
	minimum_masquerade = 3

/datum/outfit/job/vampire/hos_lead
	name = JOB_HOS_COORDINATOR
	jobtype = /datum/job/vampire/hos_lead
	uniform = /obj/item/clothing/under/vampire/turtleneck_navy
	shoes = /obj/item/clothing/shoes/vampire/jackboots/work
	l_pocket = /obj/item/smartphone/hos_lead
	r_pocket = /obj/item/vamp/keys/hos_lead
	backpack_contents = list(
        /obj/item/card/credit/rich=1,
        /obj/item/phone_book=1,
        /obj/item/flashlight/seclite=1,
        /obj/item/melee/baton/vamp = 1,
        /obj/item/restraints/handcuffs = 1,
    )

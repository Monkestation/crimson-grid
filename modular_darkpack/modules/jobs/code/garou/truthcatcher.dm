/datum/job/vampire/truthcatcher
	title = JOB_GAROU_TRUTHCATCHER
	description = "You are the most highly regarded Philodox within the Sept, granted the honor of being the ultimate arbitrator. It is your duty to meditate matters within the Sept. Enact your judgement upon anyone who violates the Litany."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	faction = FACTION_GAIA
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_LITANY
	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 100
	exp_required_type = EXP_TYPE_GAIA
	exp_required_type_department = EXP_TYPE_GAIA
	exp_granted_type = EXP_TYPE_GAIA
	config_tag = "TRUTHCATCHER"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/truthcatcher

	allowed_splats = list(SPLAT_GAROU)
	allowed_tribes = TRIBE_LIST_GAIA
	allowed_auspice = list(AUSPICE_PHILODOX)

	display_order = JOB_DISPLAY_ORDER_TRUTHCATCHER
	departments_list = list(
		/datum/job_department/gaia,
	)

	known_contacts = list(
		JOB_GAROU_COUNCIL,
		JOB_GAROU_WARDER,
		JOB_GAROU_WYRMFOE,
		JOB_GAROU_GUARDIAN
	)

/datum/outfit/job/vampire/truthcatcher
	name = JOB_GAROU_TRUTHCATCHER
	jobtype = /datum/job/vampire/truthcatcher

	id = /obj/item/card/park_ranger/guide
	uniform =  /obj/item/clothing/under/vampire/office
	suit = /obj/item/clothing/suit/vampire/coat/winter/alt
	gloves = /obj/item/clothing/gloves/vampire/work
	shoes = /obj/item/clothing/shoes/vampire/jackboots/work
	l_pocket = /obj/item/smartphone/garou_truthcatcher
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/veil_contract, /obj/item/card/credit/rich=1)


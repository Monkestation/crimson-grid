/datum/job/vampire/keeper
	title = JOB_GAROU_KEEPER
	description = "You are the bottom of the Sept's pecking order, keeper of the Sept and its surrounding bawn. Ensure that it is clean and tidy for the spirits, and maintain your tribe's caern."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	faction = FACTION_GAIA
	total_positions = 5
	spawn_positions = 5
	supervisors = /datum/job/vampire/councillor
	req_admin_notify = 1
	minimal_player_age = 15
	exp_requirements = 50
	exp_required_type = EXP_TYPE_GAIA
	exp_required_type_department = EXP_TYPE_GAIA
	exp_granted_type = EXP_TYPE_GAIA
	config_tag = "KEEPER"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/keeper

	allowed_splats = list(SPLAT_GAROU, SPLAT_KINFOLK)
	allowed_tribes = TRIBE_LIST_GAIA

	display_order = JOB_DISPLAY_ORDER_KEEPER
	departments_list = list(
		/datum/job_department/gaia,
	)

	known_contacts = list(
		JOB_GAROU_COUNCIL,
		JOB_GAROU_TRUTHCATCHER,
		JOB_GAROU_WARDER,
		JOB_GAROU_WYRMFOE,
		JOB_GAROU_GUARDIAN,
		JOB_GAROU_KEEPER
	)

/datum/outfit/job/vampire/keeper
	name = JOB_GAROU_KEEPER
	jobtype = /datum/job/vampire/keeper

	id = /obj/item/card/park_ranger/staff
	uniform =  /obj/item/clothing/under/vampire/office
	suit = /obj/item/clothing/suit/vampire/coat/winter/alt
	gloves = /obj/item/clothing/gloves/vampire/work
	shoes = /obj/item/clothing/shoes/vampire/jackboots/work
	l_pocket = /obj/item/smartphone/garou_keeper
	r_pocket = /obj/item/vamp/keys/nps
	backpack_contents = list(/obj/item/card/credit=1)

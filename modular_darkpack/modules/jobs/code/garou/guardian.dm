/datum/job/vampire/guardian
	title = JOB_GAROU_GUARDIAN
	description = "You are the bottom of the Sept's pecking order, but also the frontline offense and defense, serving directly under the Warder and Wyrmfoe to ensure the caern's safety and well-being."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	faction = FACTION_CITY
	total_positions = 3
	spawn_positions = 3
	supervisors = /datum/job/vampire/warder
	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 50
	exp_required_type = EXP_TYPE_GAIA
	exp_required_type_department = EXP_TYPE_GAIA
	exp_granted_type = EXP_TYPE_GAIA
	config_tag = "GUARDIAN"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/guardian

	allowed_splats = list(SPLAT_GAROU)
	allowed_tribes = TRIBE_LIST_GAIA

	display_order = JOB_DISPLAY_ORDER_GUARDIAN
	department_for_prefs = /datum/job_department/gaia
	departments_list = list(
		/datum/job_department/gaia,
	)

	known_contacts = list(
		"Councillor",
		"Truthcatcher",
		"Warder",
		"Wyrmfoe"
	)

/datum/outfit/job/vampire/guardian
	name = "Sept Guardian"
	jobtype = /datum/job/vampire/guardian

	id = /obj/item/card/park_ranger
	uniform =  /obj/item/clothing/under/vampire/biker
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	head = /obj/item/clothing/head/vampire/baseballcap
	belt = /obj/item/melee/baton/vamp
	gloves = /obj/item/clothing/gloves/vampire/leather
	suit = /obj/item/clothing/suit/vampire/jacket
	l_pocket = /obj/item/smartphone
	backpack_contents = list(/obj/item/card/credit=1)

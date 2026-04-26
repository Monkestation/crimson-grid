/datum/job/vampire/warder
	title = JOB_GAROU_WARDER
	description = "You are the most respected Ahroun within the" + SEPT_NAME + ", granted the honor of coordinating the caern's security. The Wyrmfoe and Guardians answer to you."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	faction = FACTION_CITY
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_LITANY
	req_admin_notify = 1
	minimal_player_age = 25
	exp_requirements = 100
	exp_required_type = EXP_TYPE_GAIA
	exp_required_type_department = EXP_TYPE_GAIA
	exp_granted_type = EXP_TYPE_GAIA
	config_tag = "WARDER"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/warder

	allowed_splats = list(SPLAT_GAROU)
	allowed_tribes = TRIBE_LIST_GAIA
	allowed_auspice = list(AUSPICE_AHROUN)

	display_order = JOB_DISPLAY_ORDER_WARDER
	department_for_prefs = /datum/job_department/gaia
	departments_list = list(
		/datum/job_department/gaia,
	)

	known_contacts = list(
		"Councillor",
		"Truthcatcher",
		"Wyrmfoe",
		"Guardian"
	)

/datum/outfit/job/vampire/warder
	name = "Sept Warder"
	jobtype = /datum/job/vampire/warder

	id = /obj/item/card/park_ranger/leader
	uniform =  /obj/item/clothing/under/vampire/biker
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	gloves = /obj/item/clothing/gloves/vampire/work
	head = /obj/item/clothing/head/vampire/cowboy
	belt = /obj/item/storage/belt/sheath/vamp/sabre
	suit = /obj/item/clothing/suit/vampire/vest/medieval
	glasses = /obj/item/clothing/glasses/vampire/sun
	l_pocket = /obj/item/smartphone
	backpack_contents = list(/obj/item/gun/ballistic/automatic/pistol/darkpack/deagle=1, /obj/item/veil_contract, /obj/item/card/credit/rich=1)

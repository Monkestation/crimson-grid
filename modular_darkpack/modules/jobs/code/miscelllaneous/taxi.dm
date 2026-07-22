/datum/job/vampire/taxi
	title = JOB_TAXI_DRIVER
	faction = FACTION_CITY
	total_positions = 3
	spawn_positions = 3
	supervisors = "your cab service"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/taxi
	config_tag = "TAXI_DRIVER"
	display_order = JOB_DISPLAY_ORDER_TAXI
	exp_required_type_department = EXP_TYPE_SERVICES
	department_for_prefs = /datum/job_department/city_services
	departments_list = list(
		/datum/job_department/city_services,
	)

	description = "Drive people in the city."
	minimal_masquerade = 0

/datum/outfit/job/vampire/taxi
	name = JOB_TAXI_DRIVER
	jobtype = /datum/job/vampire/taxi

	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/smartphone
	r_pocket = /obj/item/vamp/keys/taxi
	backpack_contents = list(/obj/item/card/credit=1, /obj/item/melee/vamp/tire=1)

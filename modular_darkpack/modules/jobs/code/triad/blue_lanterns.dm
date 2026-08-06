/datum/job/vampire/blue_lantern
	title = JOB_TRIAD_BLUE_LANTERNS
	faction = FACTION_CITY
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Deputy Mountain Master"
	config_tag = "BLUE_LANTERN"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/blue_lantern

	display_order = JOB_DISPLAY_ORDER_TRIAD_BLUE_LANTERNS
	exp_required_type_department = EXP_TYPE_TRIAD
	departments_list = list(
		/datum/job_department/triad,
	)

	known_contacts = list(
		JOB_MOUNTAIN_MASTER,
		JOB_DEPUTY_MOUNTAIN_MASTER,
		JOB_TRIAD_RED_POLE,
		JOB_TRIAD_BLUE_LANTERNS
	)
	allowed_splats = list(SPLAT_NONE)
	description = "You are a loyal follower of the Triad, assisting in their operations and maintaining order."
	minimum_masquerade = 0

/datum/outfit/job/vampire/blue_lantern
	name = JOB_TRIAD_BLUE_LANTERNS
	jobtype = /datum/job/vampire/blue_lantern
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/smartphone/blue_lantern
	r_pocket = /obj/item/vamp/keys/triads
	backpack_contents = list(/obj/item/card/credit=1, /obj/item/knife/vamp)

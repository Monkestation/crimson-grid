/datum/job/vampire/red_pole
	title = JOB_TRIAD_RED_POLE
	faction = FACTION_CITY
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Deputy Mountain Master"
	config_tag = "RED_POLE"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/red_pole

	display_order = JOB_DISPLAY_ORDER_TRIAD_RED_POLE
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
	description = "You are an enforcer of the Triad, ensure the Mountain Master is pleased."
	minimum_masquerade = 2

/datum/outfit/job/vampire/red_pole
	name = JOB_TRIAD_RED_POLE
	jobtype = /datum/job/vampire/red_pole
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/smartphone/red_pole
	r_pocket = /obj/item/vamp/keys/triads
	backpack_contents = list(/obj/item/card/credit=1, /obj/item/knife/vamp)

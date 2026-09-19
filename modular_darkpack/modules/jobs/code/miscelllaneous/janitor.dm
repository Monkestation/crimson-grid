/datum/job/vampire/janitor
	title = JOB_STREET_JANITOR
	faction = FACTION_CITY
	total_positions = 6
	spawn_positions = 6
	supervisors = SUPERVISOR_CAMARILLA
	config_tag = "JANITOR"
	outfit = /datum/outfit/job/vampire/janitor
	job_flags = CITY_JOB_FLAGS
	departments_list = list(
		/datum/job_department/city_services,
	)
	display_order = JOB_DISPLAY_ORDER_STREETJAN
	description = "Keep the streets clean. You are paid to keep your mouth shut about the things you see."
	maximal_generation = 8 // Crimson Grid Edit - Lock Adjustments - Was 11S
	maximum_immortal_age = 100
	minimum_masquerade = 0

	known_contacts = list(
		JOB_STREET_JANITOR
	)

/datum/outfit/job/vampire/janitor
	name = JOB_STREET_JANITOR
	jobtype = /datum/job/vampire/janitor

	id = /obj/item/card/cleaning
	uniform = /obj/item/clothing/under/vampire/janitor
	l_pocket = /obj/item/smartphone/janitor
	r_pocket = /obj/item/vamp/keys/cleaning
	shoes = /obj/item/clothing/shoes/vampire/jackboots/work
	gloves = /obj/item/clothing/gloves/vampire/cleaning
	backpack_contents = list(/obj/item/vamp/keys/hack=1, /obj/item/card/credit=1)

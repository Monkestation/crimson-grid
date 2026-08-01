/datum/job/vampire/gang // Human only gang grunt
	title = JOB_GANG
	faction = FACTION_GANG
	description = "You are a low level gang member tasked with production, packaging and distribution of the gang's signature product. Follow the boss's orders."
	total_positions = 10
	spawn_positions = 10
	supervisors = SUPERVISOR_GANG
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/gang
	allowed_splats = list(SPLAT_NONE)
	minimum_masquerade = 5 // nobody is gonna start a gang when theres swat in the city
	departments_list = list(
		/datum/job_department/gang,
	)

	known_contacts = list(
		"Street Boss",
		"Enforcer",
		"Associate",
		"Dealer",
	)

	alt_titles = list(
		"Associate",
		"Pusher",
		"Grower",
	)

/datum/outfit/job/vampire/gangunderboss
	name = JOB_GANG
	jobtype = /datum/job/vampire/gang

	uniform = /obj/item/clothing/under/vampire/bandit
	shoes = /obj/item/clothing/shoes/vampire/sneakers/red
	l_pocket = /obj/item/smartphone
	backpack_contents = list(/obj/item/card/credit, /obj/item/knife/vamp=1, /obj/item/food/grown/cannabis=1)


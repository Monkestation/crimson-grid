/datum/job/vampire/gangsoldier // Human only gang grunt
	title = JOB_GANG_SOLDIER
	faction = FACTION_GANG
	description = "You are a mid level gang member tasked with ensuring the security and secrecy of gang operations."
	total_positions = 5
	spawn_positions = 5
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
		"Enforcer",
		"Pusher",
		"Grower",
	)

/datum/outfit/job/vampire/gangunderboss
	name = JOB_GANG_SOLDIER
	jobtype = /datum/job/vampire/gang

	l_pocket = /obj/item/smartphone
	backpack_contents = list(/obj/item/card/credit)

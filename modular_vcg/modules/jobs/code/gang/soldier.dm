/datum/job/vampire/gangsoldier // Human only gang grunt
	title = JOB_GANG_SOLDIER
	faction = FACTION_GANG
	description = "You are a mid level gang member tasked with ensuring the security and secrecy of gang operations. Follow the boss's orders."
	total_positions = 5
	spawn_positions = 5
	supervisors = SUPERVISOR_GANG
	job_flags = CITY_JOB_FLAGS
	display_order = JOB_DISPLAY_ORDER_GANG_SOLDIER
	config_tag = "GANG_SOLDIER"
	outfit = /datum/outfit/job/vampire/gang
	allowed_splats = list(SPLAT_NONE)
	minimum_masquerade = 5 // nobody is gonna start a gang when theres swat in the city
	departments_list = list(
		/datum/job_department/gang,
	)

	known_contacts = list(
		JOB_GANG_BOSS,
		JOB_GANG_SOLDIER,
		JOB_GANG,
		JOB_GANG_UNDERBOSS,
	)

	alt_titles = list(
		"Enforcer",
		"Thug",
		"Soldier",
	)

/datum/outfit/job/vampire/gangsoldier
	name = JOB_GANG_SOLDIER
	jobtype = /datum/job/vampire/gang

	head = /obj/item/clothing/head/vampire/bandana/red
	uniform = /obj/item/clothing/under/vampire/bandit
	shoes = /obj/item/clothing/shoes/vampire/sneakers/red
	l_pocket = /obj/item/smartphone
	backpack_contents = list(/obj/item/card/credit, /obj/item/gun/ballistic/automatic/pistol/darkpack/m1911=1, /obj/item/melee/baton/security/handtaser=1)

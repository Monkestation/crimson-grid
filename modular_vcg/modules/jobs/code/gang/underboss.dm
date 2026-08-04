/datum/job/vampire/gangunderboss // Human only gang second in command
	title = JOB_GANG_UNDERBOSS
	faction = FACTION_GANG
	description = "You are the second in command and right hand to the Street Boss. Communicate with the Street Boss before any big moves, ensure the enforcers are controlling your turf and associates moving product."
	total_positions = 1
	spawn_positions = 1
	display_order = JOB_DISPLAY_ORDER_GANG_UNDERBOSS
	config_tag = "GANG_UNDERBOSS"
	supervisors = SUPERVISOR_GANG
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/gangunderboss
	allowed_splats = list(SPLAT_NONE)
	departments_list = list(
		/datum/job_department/gang,
	)

	known_contacts = list(
		JOB_GANG_BOSS,
		JOB_GANG_SOLDIER,
		JOB_GANG,
		JOB_DEALER,
	)

/datum/outfit/job/vampire/gangunderboss
	name = "Underboss"
	jobtype = /datum/job/vampire/gangunderboss

	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/fancy_red
	suit = /obj/item/clothing/suit/vampire/fancy_red
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/smartphone
	r_pocket = /obj/item/vamp/keys/gang
	backpack_contents = list(/obj/item/gun/ballistic/automatic/darkpack/uzi=1, /obj/item/card/credit, /obj/item/reagent_containers/cup/glass/baggie/meth/cocaine=1,)

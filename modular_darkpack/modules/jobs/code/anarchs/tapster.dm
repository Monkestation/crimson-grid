/datum/job/vampire/tapster
	title = JOB_TAPSTER
	faction = FACTION_ANARCHS
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_BARON_PUBLIC
	config_tag = "TAPSTER"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/tapster

	display_order = JOB_DISPLAY_ORDER_TAPSTER
	departments_list = list(
		/datum/job_department/anarch,
	)

	alt_titles = list(
		"Bartender",
		"Barkeeper",
		"Tapster",
		"Server",
		"Soda Jerk", //I always loved this as a title and I am mad it isn't in common use anymore.
		"Waiter",
		"Waitress"
	)

	known_contacts = list(
		JOB_BARON,
		JOB_BRUISER,
		JOB_EMISSARY,
		JOB_SWEEPER,
		JOB_TAPSTER
	)
	allowed_splats = list(SPLAT_NONE, SPLAT_GHOUL)
	splat_slots = list(SPLAT_NONE = 2, SPLAT_GHOUL = 2)
	description = "You are a bartender of the local biker hangout. Serve the eclectic clients that pass through, and try not to ask too many questions."
	minimum_masquerade = 0

/datum/outfit/job/vampire/tapster
	name = JOB_TAPSTER
	jobtype = /datum/job/vampire/tapster

	id = /obj/item/card/tapster
	uniform = /obj/item/clothing/under/vampire/bouncer
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/anarch_limited
	l_pocket = /obj/item/smartphone/tapster
	r_hand = /obj/item/melee/baseball_bat/vamp
	backpack_contents = list(/obj/item/vamp/keys/hack=1, /obj/item/card/credit=1)

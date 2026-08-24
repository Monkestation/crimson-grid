/datum/job/vampire/club_worker
	title = JOB_CLUB_WORKER
	faction = FACTION_CITY
	total_positions = 4
	spawn_positions = 4
	supervisors = SUPERVISOR_CLUB_DIRECTOR
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/club_worker
	config_tag = "CLUB_WORKER"
	display_order = JOB_DISPLAY_ORDER_STRIP
	exp_required_type_department = EXP_TYPE_CLUB
	departments_list = list(
		/datum/job_department/strip_club
	)

	known_contacts = list(
		JOB_CLUB_WORKER,
		JOB_PRIMOGEN_TOREADOR
	)

	alt_titles = list(
		"Club Worker",
		"Stripper",
		"Club Bouncer",
		"Club Bartender",
		"Club Attendant"
	)

	allowed_splats = list(SPLAT_KINDRED, SPLAT_GHOUL, SPLAT_KINFOLK, SPLAT_NONE)

	maximal_generation = 8 // Crimson Grid Edit - Lock Adjustments - Was 9
	maximum_immortal_age = 200
	description = "Offer strip club services. Some of your clientele may be... Unusual, but you are either addicted to vampire bites, or bribed to listen little and say even less."
	minimum_masquerade = 3

/datum/outfit/job/vampire/club_worker
	name = JOB_CLUB_WORKER
	jobtype = /datum/job/vampire/citizen
	l_pocket = /obj/item/smartphone/club_worker
	r_pocket = /obj/item/vamp/keys/strip
	backpack_contents = list(/obj/item/card/credit=1)
	uses_default_clan_clothes = TRUE

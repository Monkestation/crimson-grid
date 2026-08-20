/datum/job/vampire/citizen
	title = JOB_CITIZEN
	description = "Obey the authorities... Or don't. You are up late tonight for one reason or another."
	faction = FACTION_CITY
	total_positions = -1
	spawn_positions = -1
	outfit = /datum/outfit/job/vampire/citizen
	exp_granted_type = EXP_TYPE_KINDRED
	config_tag = "CITIZEN"
	display_order = JOB_DISPLAY_ORDER_CITIZEN
	departments_list = list(
		/datum/job_department/citizen
	)
	job_flags = CITY_JOB_FLAGS
	maximal_generation = 8 // Crimson Grid Edit - Lock Adjustments - Was 11
	maximum_immortal_age = 100
	minimum_masquerade = 0
	alt_titles = list(
		"Citizen",
		"Private Investigator",
		"Private Security",
		"Tourist",
		"Visitor",
		"Entertainer",
		"Entrepreneur",
		"Contractor",
		"Fixer",
		"Lawyer",
		"Attorney",
		"Paralegal",
	)


/datum/outfit/job/vampire/citizen
	name = JOB_CITIZEN
	jobtype = /datum/job/vampire/citizen
	l_pocket = /obj/item/smartphone
	backpack_contents = list(/obj/item/card/credit)
	uses_default_clan_clothes = TRUE

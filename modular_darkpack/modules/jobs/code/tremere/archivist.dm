/datum/job/vampire/archivist
	title = JOB_CHANTRY_ARCHIVIST
	faction = FACTION_CAMARILLA
	total_positions = 4
	spawn_positions = 4
	supervisors = SUPERVISOR_REGENT
	config_tag = "CHANTRY_ARCHIVIST"
	outfit = /datum/outfit/job/vampire/archivist
	job_flags = CITY_JOB_FLAGS
	exp_required_type_department = EXP_TYPE_CHANTRY
	departments_list = list(
		/datum/job_department/chantry,
	)
	display_order = JOB_DISPLAY_ORDER_ARCHIVIST

	description = "Keep a census of events and provide information to neonates. Listen to the Regent Carefully. Study blood magic and protect the chantry."
	maximal_generation = 8 // Crimson Grid Edit - Lock Adjustments - Was 9
	maximum_immortal_age = 200
	minimum_masquerade = 3
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_TREMERE)
	known_contacts = list(
		JOB_CHANTRY_REGENT,
		JOB_CHANTRY_ARCHIVIST,
		JOB_CHANTRY_GARGOYLE
	)

/datum/outfit/job/vampire/archivist
	name = JOB_CHANTRY_ARCHIVIST
	jobtype = /datum/job/vampire/archivist

	id = /obj/item/card/archive
	glasses = /obj/item/clothing/glasses/vampire/perception
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform = /obj/item/clothing/under/vampire/archivist
	belt = /obj/item/scythe/vamp
	r_pocket = /obj/item/vamp/keys/archive
	l_pocket = /obj/item/smartphone/archivist
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(/obj/item/ritual_tome/arcane=1, /obj/item/card/credit=1)

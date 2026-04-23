/datum/job/vampire/regent
	title = JOB_CHANTRY_REGENT
	faction = FACTION_CITY
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_CAMARILLA
	config_tag = "CHANTRY_REGENT"
	outfit = /datum/outfit/job/vampire/regent
	job_flags = CITY_JOB_FLAGS
	exp_required_type_department = EXP_TYPE_CHANTRY
	department_for_prefs = /datum/job_department/chantry
	departments_list = list(
		/datum/job_department/chantry,
	)
	display_order = JOB_DISPLAY_ORDER_REGENT

	description = "Lead the Chantry. You serve as both the Regent and Tremere Primogen. You report to the Tremere Lord of this region first, Prince second."
	minimal_masquerade = 4
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_TREMERE)

	known_contacts = list("Prince")

/datum/outfit/job/vampire/regent
	name = "Chantry Regent"
	jobtype = /datum/job/vampire/regent

	id = /obj/item/card/regent
	glasses = /obj/item/clothing/glasses/vampire/perception
	suit = /obj/item/clothing/suit/vampire/trench/archive
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform = /obj/item/clothing/under/vampire/archivist
	r_pocket = /obj/item/vamp/keys/regent
	l_pocket = /obj/item/smartphone/tremere_regent
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/ritual_tome/arcane=1, /obj/item/card/credit/elder=1, /obj/item/scythe/vamp=1)


//CRIMSON GRID ADDITION

/datum/job/vampire/clinic_police
	title = JOB_CLINIC_ORDERLY
	faction = FACTION_CITY
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Clinic Director first but the Police Captain above all"
	config_tag = "CLINIC_ORDERLY"
	outfit = /datum/outfit/job/vampire/clinic_police
	job_flags = CITY_JOB_FLAGS
	display_order = JOB_DISPLAY_ORDER_CLINIC_ORDERLY
	exp_required_type_department = EXP_TYPE_POLICE
	departments_list = list(
		/datum/job_department/clinic,
		/datum/job_department/police,
	)

	alt_titles = list(
		"Clinic Orderly",
		"Clinic-Assigned Police Officer",
		"Clinic Police",
		"Clinic Security",
	)

	allowed_splats = list(SPLAT_GHOUL, SPLAT_KINFOLK, SPLAT_NONE)
	splat_slots = list(SPLAT_GHOUL = 1, SPLAT_KINFOLK = 1)

	description = "A member from the police department. Assigned to the Hospital in order to ensure its safety. Your loyalty aligns with the Police Department first, but prioritize the safety of the Hospital."
	minimum_masquerade = 0

	known_contacts = list("Police Captain", "Clinic Director")

/datum/outfit/job/vampire/clinic_police
	name = "Clinic Police"
	jobtype = /datum/job/vampire/clinic_police

	ears = /obj/item/radio/headset/darkpack/police
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police
	belt = /obj/item/storage/belt/security/police
	id = /obj/item/card/police
	gloves = /obj/item/clothing/gloves/vampire/latex
	l_pocket = /obj/item/smartphone
	r_pocket = /obj/item/vamp/keys/clinic
	backpack_contents = list(/obj/item/card/credit=1, /obj/item/ammo_box/darkpack/c9mm = 1, /obj/item/storage/medkit/darkpack/ifak = 1, /obj/item/vamp/keys/police = 1, /obj/item/clothing/accessory/armband/medblue = 1)

/datum/outfit/job/vampire/police_officer/post_equip(mob/living/carbon/human/H)
	..()
	H.ignores_warrant = TRUE

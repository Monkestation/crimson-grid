/datum/job/vampire/clinic_guard
	title = JOB_CLINIC_GUARD
	faction = FACTION_CITY
	total_positions = 3
	spawn_positions = 3
	supervisors = SUPERVISOR_CLINIC_DIRECTOR
	config_tag = "CLINIC_GUARD"
	outfit = /datum/outfit/job/vampire/clinic_guard
	job_flags = CITY_JOB_FLAGS
	display_order = JOB_DISPLAY_ORDER_CLINIC_GUARD
	departments_list = list(
		/datum/job_department/clinic,
	)

	alt_titles = list(
		"Clinic Orderly",
		"Hospise Orderly",
	)

	allowed_splats = list(SPLAT_GHOUL, SPLAT_KINFOLK, SPLAT_NONE, SPLAT_GAROU, SPLAT_KINDRED)
	splat_slots = list(SPLAT_GHOUL = 2, SPLAT_KINFOLK = 2)

	description = "As an Orderly for the Hospital your main job is ensuring the security of medical staff, patients, and equipment."
	minimum_masquerade = 0
	maximal_generation = 8
	maximum_immortal_age = 200

	known_contacts = list(
		JOB_CLINIC_DIRECTOR,
		JOB_DOCTOR,
		JOB_EMERGENCY_DISPATCHER
	)

/datum/outfit/job/vampire/clinic_guard
	name = JOB_CLINIC_GUARD
	jobtype = /datum/job/vampire/clinic_guard

	ears = /obj/item/radio/headset/darkpack
	uniform = /obj/item/clothing/under/vampire/guard
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	belt = /obj/item/storage/belt/security/police
	id = /obj/item/card/clinic
	l_pocket = /obj/item/smartphone/clinic_officer
	r_pocket = /obj/item/vamp/keys/clinics_director
	backpack_contents = list(/obj/item/card/credit=1, /obj/item/ammo_box/darkpack/c9mm = 1, /obj/item/ammo_box/magazine/glock9mm = 2)


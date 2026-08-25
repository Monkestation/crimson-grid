/datum/job/vampire/doctor
	title = JOB_DOCTOR
	faction = FACTION_CITY
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Clinic Director"
	exp_required_type_department = EXP_TYPE_CLINIC
	config_tag = "DOCTOR"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/clinic_doctor

	display_order = JOB_DISPLAY_ORDER_DOCTOR
	departments_list = list(
		/datum/job_department/clinic,
	)

	known_contacts = list(
		JOB_CLINIC_DIRECTOR,
		JOB_DOCTOR,
		JOB_PRIMOGEN_MALKAVIAN
	)

	description = "Help your fellow kindred in all matters medicine related. Sell blood. Keep your human colleagues ignorant."
	maximal_generation = 8 // Crimson Grid Edit - Lock Adjustments - Was 9
	maximum_immortal_age = 200
	allowed_splats = list(SPLAT_KINDRED, SPLAT_GHOUL, SPLAT_KINFOLK, SPLAT_NONE)
	allowed_clans = list(VAMPIRE_CLAN_DAUGHTERS_OF_CACOPHONY, VAMPIRE_CLAN_HEALER_SALUBRI, VAMPIRE_CLAN_BAALI, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_VENTRUE_ANTITRIBU, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_BANU_HAQIM_VIZIER, VAMPIRE_CLAN_GIOVANNI, VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_TLACIQUE, VAMPIRE_CLAN_TZIMISCE, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_CAITIFF, VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_NAGARAJA)
	known_contacts = list("Clinic Director")

	alt_titles = list(
		"Doctor",
		"Medical Student",
		"Intern",
		"Nurse",
		"Resident",
		"General Practitioner",
		"Surgeon",
		"Physician",
		"Paramedic",
		"EMT",
	)


/datum/outfit/job/vampire/clinic_doctor
	name = JOB_DOCTOR
	jobtype = /datum/job/vampire/doctor

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/clinic
	uniform = /obj/item/clothing/under/vampire/nurse
	shoes = /obj/item/clothing/shoes/vampire/white
	suit =  /obj/item/clothing/suit/vampire/labcoat
	gloves = /obj/item/clothing/gloves/vampire/latex
	l_pocket = /obj/item/smartphone/doctor
	r_pocket = /obj/item/vamp/keys/clinic
	backpack_contents = list(/obj/item/card/credit=1, /obj/item/storage/medkit/darkpack/doctor=1)

	skillchips = list(/obj/item/skillchip/entrails_reader)

/datum/job/vampire/clinic_director
	title = JOB_CLINIC_DIRECTOR
	faction = FACTION_CITY
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Hospital Administrator"
	exp_required_type_department = EXP_TYPE_CLINIC
	config_tag = "CLINIC_DIRECTOR"
	outfit = /datum/outfit/job/vampire/clinic_director
	job_flags = CITY_JOB_FLAGS
	display_order = JOB_DISPLAY_ORDER_CLINICS_DIRECTOR
	departments_list = list(
		/datum/job_department/clinic,
	)

	known_contacts = list(
		JOB_DOCTOR,
		JOB_PRIMOGEN_MALKAVIAN
	)

	description = "Keep Saint John's clinic up and running. Collect blood by helping mortals at the Clinic."
	allowed_splats = list(SPLAT_KINDRED, SPLAT_GHOUL, SPLAT_NONE)
	allowed_clans = list(VAMPIRE_CLAN_DAUGHTERS_OF_CACOPHONY, VAMPIRE_CLAN_HEALER_SALUBRI, VAMPIRE_CLAN_BAALI, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_GIOVANNI, VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_TZIMISCE, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_CAITIFF, VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_NAGARAJA)

/datum/outfit/job/vampire/clinic_director
	name = JOB_CLINIC_DIRECTOR
	jobtype = /datum/job/vampire/clinic_director

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/clinic/director
	uniform = /obj/item/clothing/under/vampire/nurse
	shoes = /obj/item/clothing/shoes/vampire/white
	suit =  /obj/item/clothing/suit/vampire/labcoat/director
	gloves = /obj/item/clothing/gloves/vampire/latex
	l_pocket = /obj/item/smartphone/clinic_director
	r_pocket = /obj/item/vamp/keys/clinics_director
	backpack_contents = list(/obj/item/card/credit=1, /obj/item/storage/medkit/darkpack/doctor=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	skillchips = list(/obj/item/skillchip/entrails_reader)

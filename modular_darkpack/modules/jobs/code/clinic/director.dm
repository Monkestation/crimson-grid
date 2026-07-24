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

	known_contacts = list(JOB_DOCTOR)

	description = "Keep Saint John's clinic up and running. Collect blood by helping mortals at the Clinic."
	allowed_splats = list(SPLAT_GHOUL, SPLAT_NONE, SPLAT_KINFOLK) // Removed kindred, clinic director should be human as agreed by impromptu poll in #general. Head of the clinic, should be impartial etc etc.

/datum/outfit/job/vampire/clinic_director
	name = JOB_CLINIC_DIRECTOR
	jobtype = /datum/job/vampire/clinic_director

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/clinic/director
	uniform = /obj/item/clothing/under/vampire/nurse
	shoes = /obj/item/clothing/shoes/vampire/white
	suit =  /obj/item/clothing/suit/vampire/labcoat/director
	gloves = /obj/item/clothing/gloves/vampire/latex
	l_pocket = /obj/item/smartphone
	r_pocket = /obj/item/vamp/keys/clinics_director
	backpack_contents = list(/obj/item/card/credit=1, /obj/item/storage/medkit/darkpack/doctor=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

	skillchips = list(/obj/item/skillchip/entrails_reader)

/datum/job/vampire/clinic_lawyer
	title = JOB_CLINIC_LAWYER
	faction = FACTION_CITY
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_CLINIC_DIRECTOR
	config_tag = "CLINIC_LAWYER"
	outfit = /datum/outfit/job/vampire/clinic_lawyer
	job_flags = CITY_JOB_FLAGS

	exp_required_type_department = EXP_TYPE_CLINIC
	exp_requirements = EXP_REQ_HEAD
	desensitized_base = DESENSITIZED_THRESHOLD // CRIMSON EDIT ADDITION - JOB MOOD
	display_order = JOB_DISPLAY_ORDER_CLINIC_LAWYER
	departments_list = list(
		/datum/job_department/clinic,
	)

	alt_titles = list(
		JOB_CLINIC_LAWYER,
		"Hospital Attorney",
	)

	known_contacts = list(
		JOB_CLINIC_DIRECTOR,
		JOB_DOCTOR,
		JOB_CLINIC_GUARD,
		JOB_PRIMOGEN_MALKAVIAN,
	)

	description = "Ensure Saint John's Clinic keeps itself afloat legally and monetarily. Handle malpractice cases, influence the Director to favor you."
	allowed_splats = null

	job_tone = "objection"
	tgui_icon = FA_ICON_GAVEL

/datum/outfit/job/vampire/clinic_lawyer
	name = JOB_CLINIC_LAWYER
	jobtype = /datum/job/vampire/clinic_lawyer

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/clinic/lawyer
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/smartphone/clinic_lawyer
	r_pocket = /obj/item/vamp/keys/clinic_guard
	backpack_contents = list(/obj/item/card/credit=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

/obj/item/card/clinic/lawyer
	name = "general councel's badge"
	desc = "A badge which shows authority over the clinic in matters of the law."

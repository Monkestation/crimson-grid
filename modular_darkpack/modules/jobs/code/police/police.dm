/datum/job/vampire/police_officer
	title = JOB_POLICE_OFFICER
	faction = FACTION_CITY
	total_positions = 5
	spawn_positions = 5
	supervisors = SUPERVISOR_POLICE_CAPTAIN_AND_SERGEANT
	config_tag = "POLICE_OFFICER"
	outfit = /datum/outfit/job/vampire/police_officer
	job_flags = CITY_JOB_FLAGS
	display_order = JOB_DISPLAY_ORDER_POLICE
	exp_required_type_department = EXP_TYPE_POLICE
	departments_list = list(
		/datum/job_department/police,
	)

	alt_titles = list(
		"Police Officer",
		"Police Cadet",
		"Senior Police Officer",
	)

	allowed_splats = list(SPLAT_GHOUL, SPLAT_KINFOLK, SPLAT_NONE)
	splat_slots = list(SPLAT_GHOUL = 2, SPLAT_KINFOLK = 2)

	description = "Enforce the Law."
	minimum_masquerade = 0

	known_contacts = list("Police Captain")

/datum/outfit/job/vampire/police_officer
	name = "Police Officer"
	jobtype = /datum/job/vampire/police_officer

	ears = /obj/item/radio/headset/darkpack/police
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police
	belt = /obj/item/storage/belt/security/police
	id = /obj/item/card/police
	l_pocket = /obj/item/smartphone
	r_pocket = /obj/item/vamp/keys/police
	backpack_contents = list(/obj/item/card/credit=1, /obj/item/ammo_box/darkpack/c9mm = 1, /obj/item/storage/medkit/darkpack/ifak = 1, /obj/item/bodycam_upgrade = 1)

/datum/outfit/job/vampire/police_officer/post_equip(mob/living/carbon/human/H)
	..()
	H.ignores_warrant = TRUE

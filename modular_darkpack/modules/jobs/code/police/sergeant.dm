/datum/job/vampire/police_sergeant
	title = JOB_POLICE_SERGEANT
	faction = FACTION_CITY
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_POLICE_CAPTAIN
	config_tag = "POLICE_SERGEANT"
	outfit = /datum/outfit/job/vampire/police_sergeant
	job_flags = CITY_JOB_FLAGS
	display_order = JOB_DISPLAY_ORDER_POLICE_SERGEANT
	exp_required_type_department = EXP_TYPE_POLICE
	department_for_prefs = /datum/job_department/police
	departments_list = list(
		/datum/job_department/police,
	)

	alt_titles = list(
		"Police Sergeant",
		"Police Supervisor",
		"Training Officer",
		"Detective",
	)

	allowed_splats = list(SPLAT_GHOUL, SPLAT_NONE)

	description = "Enforce the law. Keep the officers in line. Follow what the Captain says."
	minimal_masquerade = 0

	known_contacts = list("Police Captain")

/datum/outfit/job/vampire/police_sergeant
	name = "Police Sergeant"
	jobtype = /datum/job/vampire/police_sergeant

	ears = /obj/item/radio/headset/darkpack/police
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police/sergeant
	belt = /obj/item/storage/belt/holster/detective/darkpack/officer
	id = /obj/item/card/police/sergeant
	l_pocket = /obj/item/smartphone
	r_pocket = /obj/item/vamp/keys/police/secure
	backpack_contents = list(/obj/item/card/credit=1, /obj/item/ammo_box/darkpack/c9mm = 1, /obj/item/restraints/handcuffs = 1, /obj/item/melee/baton/vamp = 1, /obj/item/storage/medkit/darkpack/ifak = 1)

/datum/outfit/job/vampire/police_sergeant/post_equip(mob/living/carbon/human/H)
	..()
	H.ignores_warrant = TRUE

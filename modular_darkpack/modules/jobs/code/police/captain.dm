/datum/job/vampire/police_captain
	title = JOB_POLICE_CAPTAIN
	faction = FACTION_CITY
	total_positions = 1
	spawn_positions = 1
	supervisors = "the SFPD Chief"
	config_tag = "POLICE_CAPTAIN"
	outfit = /datum/outfit/job/vampire/police_captain
	job_flags = CITY_JOB_FLAGS
	display_order = JOB_DISPLAY_ORDER_POLICE_CAPTAIN
	exp_required_type_department = EXP_TYPE_POLICE
	departments_list = list(
		/datum/job_department/police,
	)

	allowed_splats = list(SPLAT_NONE)

	description = "Underpaid, overworked, and understrength. Do your best to keep the order in " + CITY_NAME + ". Keep the officers in line."
	minimum_masquerade = 0

	known_contacts = list(
		JOB_POLICE_SERGEANT,
		JOB_EMERGENCY_DISPATCHER,
		JOB_FEDERAL_INVESTIGATOR
	)

/datum/outfit/job/vampire/police_captain
	name = JOB_POLICE_CAPTAIN
	jobtype = /datum/job/vampire/police_captain

	ears = /obj/item/radio/headset/darkpack/police
	uniform = /obj/item/clothing/under/vampire/police
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest/police/captain
	belt = /obj/item/storage/belt/holster/detective/darkpack/officer
	id = /obj/item/card/police/captain
	l_pocket = /obj/item/smartphone/police_captain
	r_pocket = /obj/item/vamp/keys/police/secure/captain
	backpack_contents = list(
		/obj/item/card/credit = 1,
		/obj/item/ammo_box/darkpack/c9mm = 1,
		/obj/item/restraints/handcuffs = 1,
		/obj/item/melee/baton/vamp = 1,
		/obj/item/storage/medkit/darkpack/ifak = 1,
		/obj/item/bodycam_upgrade = 1
	)

/datum/outfit/job/vampire/police_captain/post_equip(mob/living/carbon/human/H)
	. = ..()
	var/datum/martial_art/martial_art = new /datum/martial_art/cqc
	H.ignores_warrant = TRUE
	martial_art.teach(H)

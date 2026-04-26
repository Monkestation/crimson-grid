/datum/job/vampire/fbi
	title = JOB_FEDERAL_INVESTIGATOR
	faction = FACTION_CITY
	total_positions = 2
	spawn_positions = 2
	supervisors = " the FBI"
	config_tag = "FEDERAL_AGENT"
	outfit = /datum/outfit/job/vampire/fbi
	job_flags = CITY_JOB_FLAGS
	display_order = JOB_DISPLAY_ORDER_FBI
	exp_required_type_department = EXP_TYPE_NATIONAL_SECURITY
	department_for_prefs = /datum/job_department/police
	departments_list = list(
		/datum/job_department/police,
	)

	allowed_splats = list(SPLAT_NONE)
	description = "Enforce the Law."
	minimal_masquerade = 0

	known_contacts = list("Police Captain")

/datum/outfit/job/vampire/fbi
	name = "Federal Investigator"
	jobtype = /datum/job/vampire/fbi

	ears = /obj/item/radio/headset/darkpack/police
	uniform = /obj/item/clothing/under/vampire/office
	shoes = /obj/item/clothing/shoes/vampire
	suit = /obj/item/clothing/suit/vampire/jacket/fbi
	belt = /obj/item/storage/belt/holster/detective/darkpack/fbi
	id = /obj/item/card/police/fbi
	gloves = /obj/item/clothing/gloves/vampire/investigator
	l_pocket = /obj/item/smartphone
	r_pocket = /obj/item/vamp/keys/police/federal
	backpack_contents = list(/obj/item/card/police/sergeant=1, /obj/item/camera/detective=1, /obj/item/camera_film=1, /obj/item/taperecorder=1, /obj/item/tape=1, /obj/item/card/credit=1, /obj/item/ammo_box/darkpack/c45acp/hp=1, /obj/item/storage/medkit/darkpack/ifak=1)

/datum/outfit/job/vampire/fbi/post_equip(mob/living/carbon/human/agent)
	..()
	agent.ignores_warrant = TRUE

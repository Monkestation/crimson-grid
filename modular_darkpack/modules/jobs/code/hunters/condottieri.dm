/datum/job/vampire/condottieri
	title = JOB_CONDOTTIERI
	description = "You are a Condottieri for the Society of Leopold - assigned to this Cenacle to protect the Inquisitors and the Novices undergoing their Novitiate. Your role is closer to defense than it is the actual completion of offensive missions undertaken by the other Inquisitors - however, the Condottieri remain highly respected as an elite and deadly subdivision of the Society of Leopold."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	faction = FACTION_CITY
	total_positions = 2
	spawn_positions = 2
	supervisors = SUPERVISOR_SOCIETY_OF_LEOPOLD
	minimal_player_age = 7

	config_tag = "CONDOTTIERI"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/condottieri

	display_order = JOB_DISPLAY_ORDER_CONDOTTIERI
	departments_list = list(
		/datum/job_department/society_of_leopold,
	)

	known_contacts = list(
		JOB_ABBE,
		JOB_INQUISITOR,
		JOB_NOVICE,
		JOB_CONDOTTIERI
	)

	allowed_splats = list(SPLAT_NONE)

/datum/outfit/job/vampire/condottieri
	name = JOB_CONDOTTIERI
	jobtype = /datum/job/vampire/condottieri

	id = /obj/item/card/hunter
	uniform = /obj/item/clothing/under/vampire/black
	gloves = /obj/item/clothing/gloves/vampire/leather
	suit = /obj/item/clothing/suit/vampire/vest/medieval
	head = /obj/item/clothing/head/vampire/helmet/spain
	shoes = /obj/item/clothing/shoes/jackboots
	glasses = /obj/item/clothing/glasses/vampire/sun
	r_pocket = /obj/item/vamp/keys/hunter
	l_pocket = /obj/item/smartphone/condottieri
	backpack_contents = list(/obj/item/vampire_stake=1,  /obj/item/intel_report=1, /obj/item/card/credit=1, /obj/item/vampirebook/bible=1)

/datum/outfit/job/vampire/condottieri/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.mind.set_holy_role(HOLY_ROLE_PRIEST)

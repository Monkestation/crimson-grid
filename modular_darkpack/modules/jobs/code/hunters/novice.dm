/datum/job/vampire/novice
	title = JOB_NOVICE
	description = "You are Novice who is undergoing, or a Tertiary who has just passed, their Novitiate in the Inquisition's organization The Society of Saint Leopold. Whether you were a lay-person or undergoing official clerical or religious training, your main task in the Society is now to study, scout, document, and be educated on the various supernatural creatures that threaten God's kingdom and it's balance - as well as remaining prepared for when your name is called."
	faction = FACTION_CITY
	total_positions = 3
	spawn_positions = 3
	supervisors = SUPERVISOR_SOCIETY_OF_LEOPOLD
	minimal_player_age = 7

	config_tag = "NOVICE"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/novice

	display_order = JOB_DISPLAY_ORDER_NOVICE
	departments_list = list(
		/datum/job_department/society_of_leopold,
	)

	known_contacts = list(
		JOB_ABBE,
		JOB_CONDOTTIERI,
		JOB_INQUISITOR,
		JOB_NOVICE
	)

	allowed_splats = list(SPLAT_NONE)


/datum/outfit/job/vampire/novice
	name = JOB_NOVICE
	jobtype = /datum/job/vampire/novice

	id = /obj/item/card/hunter
	uniform = /obj/item/clothing/under/vampire/turtleneck_white
	suit = /obj/item/clothing/suit/vampire/labcoat
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/hunter
	l_pocket = /obj/item/smartphone/novice
	backpack_contents = list(/obj/item/camera=1, /obj/item/vampirebook/bible=1, /obj/item/card/credit=1)


/datum/outfit/job/vampire/novice/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.mind.set_holy_role(HOLY_ROLE_DEACON)

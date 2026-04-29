/datum/job/vampire/novice
	title = JOB_NOVICE
	description = "You are Novice who is undergoing, or a Tertiary who has just passed, their Novitiate in the Inquisition's organization The Society of Saint Leopold. Whether you were a lay-person or undergoing official clerical or religious training, your main task in the Society is now to study, scout, document, and be educated on the various supernatural creatures that threaten God's kingdom and it's balance - as well as remaining prepared for when your name is called."
	faction = FACTION_CITY
	total_positions = 5
	spawn_positions = 5
	supervisors = SUPERVISOR_SOCIETY_OF_LEOPOLD
	minimal_player_age = 7

	config_tag = "NOVICE"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/novice

	display_order = JOB_DISPLAY_ORDER_NOVICE
	department_for_prefs = /datum/job_department/society_of_leopold
	departments_list = list(
		/datum/job_department/society_of_leopold,
	)

	minimal_masquerade = 3
	allowed_splats = list(SPLAT_NONE)


/datum/outfit/job/vampire/novice
	name = "Novice"
	jobtype = /datum/job/vampire/novice

	id = /obj/item/card/hunter
	uniform = /obj/item/clothing/under/vampire/turtleneck_white
	suit = /obj/item/clothing/suit/vampire/labcoat
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/hunter
	l_pocket = /obj/item/smartphone/novice
	backpack_contents = list(/obj/item/camera=1, /obj/item/vampirebook/bible=1, /obj/item/card/credit=1)

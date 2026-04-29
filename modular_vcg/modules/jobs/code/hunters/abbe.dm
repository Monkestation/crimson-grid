/datum/job/vampire/abbe
	title = JOB_ABBE
	description = "You are an Abbé for the Society of Leopold who answers to the Provincial of this region, and who serves the local Cenacle of Inquisitors beneath you. You're tasked by the Inquisition in ensuring the Cenaculum are well-supplied and accounted for, as well as rooting out any heresy or infiltration. Act as the leaders of the Inquisitors, as your Lord has commanded you to be your brother's keeper."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	faction = FACTION_CITY
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_SOCIETY_OF_LEOPOLD
	minimal_player_age = 7
	config_tag = "ABBE"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/abbe

	display_order = JOB_DISPLAY_ORDER_ABBE
	department_for_prefs = /datum/job_department/society_of_leopold
	departments_list = list(
		/datum/job_department/society_of_leopold,
	)
	allowed_splats = list(SPLAT_NONE)

/datum/outfit/job/vampire/abbe
	name = "Abbe"
	jobtype = /datum/job/vampire/abbe

	id = /obj/item/card/hunter
	uniform = /obj/item/clothing/under/vampire/suit
	gloves = /obj/item/clothing/gloves/vampire/work
	suit = /obj/item/clothing/suit/vampire/orthodox
	shoes = /obj/item/clothing/shoes/vampire
	glasses = /obj/item/clothing/glasses/vampire/perception
	r_pocket = /obj/item/vamp/keys/hunter
	l_pocket = /obj/item/smartphone/abbe
	backpack_contents = list(/obj/item/vampire_stake=1, /obj/item/vampirebook/bible=1, /obj/item/card/credit=1)

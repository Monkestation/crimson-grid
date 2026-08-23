/datum/job/vampire/prince
	title = JOB_PRINCE
	description = "You are the top dog of this city. You hold Praxis over " + CITY_NAME + ", and your word is law. Make sure the Masquerade is upheld, and your status is respected."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_CAMARILLA
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_TRADITIONS
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CAMARILLA
	exp_required_type_department = EXP_TYPE_CAMARILLA
	exp_granted_type = EXP_TYPE_CAMARILLA
	config_tag = "PRINCE"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/prince

	display_order = JOB_DISPLAY_ORDER_PRINCE
	departments_list = list(
		/datum/job_department/camarilla,
	)

	minimal_generation = 10
	minimum_immortal_age = 75
	minimum_masquerade = 5
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_BANU_HAQIM_VIZIER)

	known_contacts = list(
		JOB_SHERIFF,
		JOB_SENESCHAL,
		JOB_HARPY,
		JOB_DEALER,
		JOB_CHANTRY_REGENT,
		JOB_PRIMOGEN_BANU_HAQIM,
		JOB_PRIMOGEN_TOREADOR,
		JOB_PRIMOGEN_LASOMBRA,
		JOB_PRIMOGEN_MALKAVIAN,
		JOB_PRIMOGEN_VENTRUE,
		JOB_PRIMOGEN_NOSFERATU,
		JOB_BARON,
		JOB_VOIVODE
	)

/datum/job/vampire/prince/get_captaincy_announcement(mob/living/captain)
	return "Prince [captain.real_name] is in the city!"

/datum/outfit/job/vampire/prince
	name = JOB_PRINCE
	jobtype = /datum/job/vampire/prince

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/prince
	glasses = /obj/item/clothing/glasses/vampire/sun
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform =  /obj/item/clothing/under/vampire/prince
	suit = /obj/item/clothing/suit/vampire/trench/alt
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/smartphone/prince
	r_pocket = /obj/item/vamp/keys/prince
	backpack_contents = list(/obj/item/gun/ballistic/automatic/pistol/darkpack/deagle=1, /obj/item/phone_book=1, /obj/item/masquerade_contract=1, /obj/item/card/credit/prince=1)

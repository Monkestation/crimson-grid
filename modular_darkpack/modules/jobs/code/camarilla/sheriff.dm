/datum/job/vampire/sheriff
	title = JOB_SHERIFF
	description = "Protect the Prince and the Masquerade. You are their sword."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	faction = FACTION_CAMARILLA
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_PRINCE
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 120
	exp_required_type = EXP_TYPE_CAMARILLA
	exp_required_type_department = EXP_TYPE_CAMARILLA
	exp_granted_type = EXP_TYPE_CAMARILLA
	config_tag = "SHERIFF"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/sheriff

	display_order = JOB_DISPLAY_ORDER_SHERIFF
	departments_list = list(
		/datum/job_department/camarilla,
	)

	minimal_generation = 12
	minimum_masquerade = 5
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_TRUE_BRUJAH, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_BANU_HAQIM_VIZIER, VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_TLACIQUE, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_SAMEDI, VAMPIRE_CLAN_NAGARAJA)

	known_contacts = list(
		JOB_PRINCE,
		JOB_SENESCHAL,
		JOB_DEALER,
		JOB_HARPY,
		JOB_HOUND
	)

/datum/outfit/job/vampire/sheriff
	name = JOB_SHERIFF
	jobtype = /datum/job/vampire/sheriff

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/sheriff
	uniform = /obj/item/clothing/under/vampire/sheriff
	belt = /obj/item/storage/belt/sheath/vamp/rapier
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	suit = /obj/item/clothing/suit/vampire/vest
	gloves = /obj/item/clothing/gloves/vampire/leather
	glasses = /obj/item/clothing/glasses/vampire/sun
	r_pocket = /obj/item/vamp/keys/sheriff
	l_pocket = /obj/item/smartphone/sheriff
	backpack_contents = list(/obj/item/gun/ballistic/automatic/pistol/darkpack/deagle=1, /obj/item/vampire_stake=3, /obj/item/masquerade_contract=1, /obj/item/card/credit/elder=1)

/datum/outfit/job/vampire/sheriff/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.ignores_warrant = TRUE

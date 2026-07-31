/datum/job/vampire/hound
	title = JOB_HOUND
	description = "You are the Prince's enforcer. You report to the Sheriff and uphold the Traditions."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	faction = FACTION_CAMARILLA
	total_positions = 7
	spawn_positions = 7
	supervisors = SUPERVISOR_SHERIFF
	minimal_player_age = 7
	exp_requirements = 20
	exp_required_type = EXP_TYPE_CAMARILLA
	exp_required_type_department = EXP_TYPE_CAMARILLA
	exp_granted_type = EXP_TYPE_CAMARILLA
	config_tag = "HOUND"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/hound

	display_order = JOB_DISPLAY_ORDER_HOUND
	departments_list = list(
		/datum/job_department/camarilla,
	)

	maximal_generation = 9
	maximum_immortal_age = 200
	minimum_masquerade = 3
	allowed_splats = list(SPLAT_KINDRED, SPLAT_GHOUL)
	allowed_clans = list(VAMPIRE_CLAN_TRUE_BRUJAH, VAMPIRE_CLAN_DAUGHTERS_OF_CACOPHONY, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_BANU_HAQIM_VIZIER, VAMPIRE_CLAN_TLACIQUE, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_GARGOYLE, VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_CAPPADOCIAN, VAMPIRE_CLAN_TZIMISCE, VAMPIRE_CLAN_SAMEDI, VAMPIRE_CLAN_NAGARAJA)

	known_contacts = list("Prince", "Sheriff")

/datum/outfit/job/vampire/hound
	name = "Hound"
	jobtype = /datum/job/vampire/hound

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/camarilla
	uniform = /obj/item/clothing/under/vampire/hound
	gloves = /obj/item/clothing/gloves/vampire/work
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	r_pocket = /obj/item/vamp/keys/camarilla
	l_pocket = /obj/item/smartphone/hound
	backpack_contents = list(/obj/item/vampire_stake=3, /obj/item/masquerade_contract=1, /obj/item/vamp/keys/hack=1, /obj/item/card/credit=1)

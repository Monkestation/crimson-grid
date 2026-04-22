/datum/job/vampire/towerwork
	title = JOB_TOWERWORK
	faction = FACTION_CITY
	total_positions = 4
	spawn_positions = 4
	supervisors = SUPERVISOR_SENESCHAL_PUBLIC
	exp_granted_type = EXP_TYPE_CAMARILLA
	config_tag = "TOWER_EMPLOYEE"
	outfit = /datum/outfit/job/vampire/towerwork
	job_flags = CITY_JOB_FLAGS
	display_order = JOB_DISPLAY_ORDER_TOWERWORK
	department_for_prefs = /datum/job_department/camarilla
	departments_list = list(
		/datum/job_department/camarilla,
	)

	alt_titles = list(
		"Tower Employee",
		"Tower Cleaner",
		"Tower Assistant",
		"Tower Security Guard",
		"Tower Personal Driver",
		"Tower Personal Attendant"
	)

	known_contacts = list("Prince", "Sheriff", "Seneschal")
	allowed_splats = list(SPLAT_NONE, SPLAT_GHOUL, SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_TRUE_BRUJAH, VAMPIRE_CLAN_DAUGHTERS_OF_CACOPHONY, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_BANU_HAQIM_VIZIER, VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_TLACIQUE, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_GARGOYLE, VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_CAPPADOCIAN, VAMPIRE_CLAN_TZIMISCE, VAMPIRE_CLAN_SAMEDI, VAMPIRE_CLAN_NAGARAJA)
	description = "You work directly for the Millenium Tower and its administrative staff in a variety of ways, you may even be a personal retainer of one of the top three, to the point that any oddities that you may see over night or hear are either things you are already aware or you simply laugh them off and try not to think about it."
	minimal_masquerade = 4

/datum/outfit/job/vampire/towerwork
	name = "Tower Employee"
	jobtype = /datum/job/vampire/towerwork

	id = /obj/item/card/tower_employee
	uniform = /obj/item/clothing/under/vampire/hound
	gloves = /obj/item/clothing/gloves/vampire/work
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	r_pocket = /obj/item/vamp/keys/camarilla/ghoul
	l_pocket = /obj/item/smartphone/tower_employee
	backpack_contents = list(/obj/item/card/credit=1)

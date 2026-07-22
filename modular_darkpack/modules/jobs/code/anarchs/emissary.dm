/datum/job/vampire/emissary
	title = JOB_EMISSARY
	faction = FACTION_ANARCHS
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_BARON
	config_tag = "EMISSARY"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/emissary

	display_order = JOB_DISPLAY_ORDER_EMISSARY
	department_for_prefs = /datum/job_department/anarch
	departments_list = list(
		/datum/job_department/anarch,
	)

	known_contacts = list("Baron", "Bouncer", "Emissary", "Sweeper", "Prince", "Sheriff")
	allowed_clans = list(VAMPIRE_CLAN_DAUGHTERS_OF_CACOPHONY, VAMPIRE_CLAN_TRUE_BRUJAH, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_TZIMISCE, VAMPIRE_CLAN_CAITIFF, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_GARGOYLE, VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_CAPPADOCIAN, VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_HEALER_SALUBRI, VAMPIRE_CLAN_SAMEDI, VAMPIRE_CLAN_NAGARAJA)
	allowed_splats = list(SPLAT_KINDRED)
	description = "You are a diplomat for the anarchs. Make deals, keep the peace, all through words, not violence. But the latter may come to pass if the former fails."
	minimal_masquerade = 2

/datum/outfit/job/vampire/emissary
	name = "emissary"
	jobtype = /datum/job/vampire/emissary

	id = /obj/item/card/emissary
	ears = /obj/item/radio/headset/darkpack
	uniform = /obj/item/clothing/under/vampire/bouncer
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/anarch
	l_pocket = /obj/item/smartphone/emissary
	backpack_contents = list(/obj/item/vamp/keys/hack=1, /obj/item/card/credit/rich=1)

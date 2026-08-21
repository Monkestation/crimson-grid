/datum/job/vampire/baron
	title = JOB_BARON
	faction = FACTION_ANARCHS
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Anarchs and the Traditions"
	config_tag = "BARON"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/baron

	display_order = JOB_DISPLAY_ORDER_BARON
	departments_list = list(
		/datum/job_department/anarch,
	)

	known_contacts = list(
		JOB_BRUISER,
		JOB_EMISSARY,
		JOB_SWEEPER,
		JOB_TAPSTER,
		JOB_PRINCE,
		JOB_SHERIFF,
		JOB_SENESCHAL,
		JOB_HARPY,
		JOB_DEALER
	)
	allowed_clans = list(VAMPIRE_CLAN_DAUGHTERS_OF_CACOPHONY, VAMPIRE_CLAN_BAALI, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_CAITIFF, VAMPIRE_CLAN_TRUE_BRUJAH, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_GARGOYLE, VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_SAMEDI, VAMPIRE_CLAN_NAGARAJA)
	allowed_splats = list(SPLAT_KINDRED)
	description = "You lead the Anarchs in the City. A Camarilla faction that values freedom and individuality. While not a fan of the traditions, you still respect the Masquerade."
	minimum_masquerade = 3

/datum/outfit/job/vampire/baron
	name = JOB_BARON
	jobtype = /datum/job/vampire/baron

	id = /obj/item/card/baron
	ears = /obj/item/radio/headset/darkpack
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/bar
	suit = /obj/item/clothing/suit/vampire/jacket/better
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/work
	l_pocket = /obj/item/smartphone/baron
	r_pocket = /obj/item/vamp/keys/baron
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/card/credit=1, /obj/item/clothing/gloves/vampire/brassknuckles/spiked=1)

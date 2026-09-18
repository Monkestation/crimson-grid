/datum/job/vampire/sweeper
	title = JOB_SWEEPER
	faction = FACTION_ANARCHS
	total_positions = 3
	spawn_positions = 3
	supervisors = SUPERVISOR_BARON
	config_tag = "SWEEPER"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/sweeper

	display_order = JOB_DISPLAY_ORDER_SWEEPER
	departments_list = list(
		/datum/job_department/anarch,
	)

	known_contacts = list(
		JOB_BARON,
		JOB_BRUISER,
		JOB_EMISSARY,
		JOB_TAPSTER,
		JOB_SWEEPER
	)
	allowed_clans = list(VAMPIRE_CLAN_DAUGHTERS_OF_CACOPHONY, VAMPIRE_CLAN_TRUE_BRUJAH, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_TZIMISCE, VAMPIRE_CLAN_CAITIFF, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_GARGOYLE, VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_CAPPADOCIAN, VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_HEALER_SALUBRI, VAMPIRE_CLAN_SAMEDI, VAMPIRE_CLAN_NAGARAJA)
	allowed_splats = list(SPLAT_KINDRED)
	description = "You are the observer of the anarchs. You watch out for any new kindred, suspicious individuals, and any new rumors near the anarch turf, and then report it to your anarchs."
	minimum_masquerade = 2

/datum/outfit/job/vampire/sweeper
	name = JOB_SWEEPER
	jobtype = /datum/job/vampire/sweeper

	id = /obj/item/card/sweeper
	ears = /obj/item/radio/headset/darkpack
	uniform = /obj/item/clothing/under/vampire/bouncer
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/anarch
	l_pocket = /obj/item/smartphone/sweeper
	backpack_contents = list(/obj/item/vamp/keys/hack=1, /obj/item/card/credit=1, /obj/item/binoculars = 1)

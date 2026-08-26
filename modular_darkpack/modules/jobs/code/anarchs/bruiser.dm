/datum/job/vampire/bruiser
	title = JOB_BRUISER
	faction = FACTION_ANARCHS
	total_positions = 7
	spawn_positions = 7
	supervisors = SUPERVISOR_BARON
	config_tag = "BRUISER"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/bruiser

	display_order = JOB_DISPLAY_ORDER_BRUISER
	departments_list = list(
		/datum/job_department/anarch,
	)

	alt_titles = list(
	"Bouncer",
	"Coyote",
	"Piper",
	"Rotten Apple",
	"Houdini",
	"Prospect",
	"Cleaver",
	"Molotov",
	)

	known_contacts = list(
		JOB_BARON,
		JOB_TAPSTER,
		JOB_EMISSARY,
		JOB_SWEEPER,
		JOB_BRUISER
	)
	allowed_clans = list(VAMPIRE_CLAN_DAUGHTERS_OF_CACOPHONY, VAMPIRE_CLAN_TRUE_BRUJAH, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_TZIMISCE, VAMPIRE_CLAN_CAITIFF, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_GARGOYLE, VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_CAPPADOCIAN, VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_HEALER_SALUBRI, VAMPIRE_CLAN_SAMEDI, VAMPIRE_CLAN_NAGARAJA)
	allowed_splats = list(SPLAT_KINDRED)
	maximal_generation = 8 // Crimson Grid Edit - Lock Adjustments - Was 9
	maximum_immortal_age = 200
	description = "You are the enforcer of the Anarchs. The baron is always in need of muscle power. Enforce the Traditions - in the anarch way."
	minimum_masquerade = 2

/datum/outfit/job/vampire/bruiser
	name = JOB_BRUISER
	jobtype = /datum/job/vampire/bruiser

	id = /obj/item/card/bruiser
	ears = /obj/item/radio/headset/darkpack
	uniform = /obj/item/clothing/under/vampire/bouncer
	suit = /obj/item/clothing/suit/vampire/jacket
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	r_pocket = /obj/item/vamp/keys/anarch
	l_pocket = /obj/item/smartphone/bruiser
	r_hand = /obj/item/melee/baseball_bat/vamp
	backpack_contents = list(/obj/item/vampire_stake=3, /obj/item/vamp/keys/hack=1, /obj/item/card/credit=1)

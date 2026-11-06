/datum/job/vampire/harpy
	title = JOB_HARPY
	description = "Вы знаток ночной жизни общества Сородичей. В том, что касается долгов и дипломатии, вы один из главных советников, и Князь во многом полагается на ваше суждение. Не растратьте это доверие впустую."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_CAMARILLA
	total_positions = 3
	spawn_positions = 3
	supervisors = SUPERVISOR_PRINCE
	config_tag = "HARPY"
	req_admin_notify = 1
	minimal_player_age = 10

	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/harpy

	display_order = JOB_DISPLAY_ORDER_HARPY
	departments_list = list(
		/datum/job_department/camarilla,
	)

	tgui_icon = FA_ICON_WINE_GLASS_EMPTY

	minimal_generation = 12	//Uncomment when players get exp enough
	maximal_generation = 9
	maximum_immortal_age = 200
	minimum_masquerade = 5

	allowed_splats = list(SPLAT_KINDRED)

	known_contacts = list(
		JOB_PRINCE,
		JOB_SHERIFF,
		JOB_SENESCHAL,
		JOB_CHANTRY_REGENT,
		JOB_DEALER,
		JOB_EMISSARY,
		JOB_BARON,
		JOB_PRIMOGEN_BANU_HAQIM,
		JOB_PRIMOGEN_TOREADOR,
		JOB_PRIMOGEN_LASOMBRA,
		JOB_PRIMOGEN_MALKAVIAN,
		JOB_PRIMOGEN_VENTRUE,
		JOB_PRIMOGEN_NOSFERATU,
		JOB_PRIMOGEN_BRUJAH, // CORVAX EDIT ADD
	)

	allowed_clans = list(VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN) // CORVAX EDIT v20

/datum/outfit/job/vampire/harpy
	name = JOB_HARPY
	jobtype = /datum/job/vampire/harpy

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/clerk/harpy
	uniform = /obj/item/clothing/under/vampire/clerk
	shoes = /obj/item/clothing/shoes/vampire/brown
	l_pocket = /obj/item/smartphone/harpy
	r_pocket = /obj/item/vamp/keys/clerk
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/card/credit/seneschal=1)

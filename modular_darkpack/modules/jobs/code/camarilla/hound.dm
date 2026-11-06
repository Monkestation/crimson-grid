/datum/job/vampire/hound
	title = JOB_HOUND
	description = "Вы проводите волю Князя силой. Вы подчиняетесь Шерифу и следите за соблюдением Традиций."
	auto_deadmin_role_flags = DEADMIN_POSITION_SECURITY
	faction = FACTION_CAMARILLA
	total_positions = 7
	spawn_positions = 7
	supervisors = SUPERVISOR_SHERIFF
	minimal_player_age = 7
	config_tag = "HOUND"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/hound
	desensitized_base = DESENSITIZED_THRESHOLD // CRIMSON EDIT ADDITION - JOB MOOD
	display_order = JOB_DISPLAY_ORDER_HOUND
	departments_list = list(
		/datum/job_department/camarilla,
	)

	tgui_icon = FA_ICON_SHIELD_HALVED

	maximal_generation = 9
	maximum_immortal_age = 200
	minimum_masquerade = 3
	allowed_splats = list(SPLAT_KINDRED, SPLAT_GHOUL)
	allowed_clans = list(VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN) // CORVAX EDIT v20

	known_contacts = list(
		JOB_PRINCE,
		JOB_SHERIFF,
		JOB_SENESCHAL,
		JOB_HOUND
	)

/datum/outfit/job/vampire/hound
	name = JOB_HOUND
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

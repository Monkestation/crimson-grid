/datum/job/vampire/harpy
	title = JOB_HARPY
	description = "You are an expert on the nightlife of Cainite society. Acting as one of the chief advisors on all things related to boons and diplomacy, the Prince defers quite the amount of judgement to you. Don't squander it."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_CAMARILLA
	total_positions = 3
	spawn_positions = 3
	supervisors = SUPERVISOR_PRINCE
	config_tag = "HARPY"
	req_admin_notify = 1
	minimal_player_age = 10
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CAMARILLA
	exp_required_type_department = EXP_TYPE_CAMARILLA
	exp_granted_type = EXP_TYPE_CAMARILLA
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/harpy

	display_order = JOB_DISPLAY_ORDER_HARPY
	departments_list = list(
		/datum/job_department/camarilla,
	)

	minimal_generation = 12	//Uncomment when players get exp enough
	maximal_generation = 9
	maximum_immortal_age = 200
	minimum_masquerade = 5

	allowed_splats = list(SPLAT_KINDRED)

	known_contacts = list("Prince","Sheriff","Tremere Regent","Dealer","Emissary","Baron","Primogens")

	allowed_clans = list(VAMPIRE_CLAN_DAUGHTERS_OF_CACOPHONY, VAMPIRE_CLAN_TRUE_BRUJAH, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_BANU_HAQIM_VIZIER, VAMPIRE_CLAN_TZIMISCE, VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_TLACIQUE, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_GARGOYLE, VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_SAMEDI, VAMPIRE_CLAN_NAGARAJA)

/datum/outfit/job/vampire/harpy
	name = "Harpy"
	jobtype = /datum/job/vampire/harpy

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/clerk/harpy
	uniform = /obj/item/clothing/under/vampire/clerk
	shoes = /obj/item/clothing/shoes/vampire/brown
	l_pocket = /obj/item/smartphone/harpy
	r_pocket = /obj/item/vamp/keys/clerk
	backpack_contents = list(/obj/item/phone_book=1, /obj/item/card/credit/seneschal=1)

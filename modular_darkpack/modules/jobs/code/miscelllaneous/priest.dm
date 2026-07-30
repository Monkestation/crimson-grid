/datum/job/vampire/priest
	title = JOB_PRIEST
	faction = FACTION_CITY
	total_positions = 2
	spawn_positions = 2
	supervisors = "your faith"
	config_tag = "PRIEST"
	outfit = /datum/outfit/job/vampire/priest
	job_flags = CITY_JOB_FLAGS
	display_order = JOB_DISPLAY_ORDER_PRIEST
	exp_required_type_department = EXP_TYPE_CHURCH
	departments_list = list(
		/datum/job_department/church,
	)
	allowed_splats = list(SPLAT_NONE, SPLAT_GHOUL, SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_CAPPADOCIAN, VAMPIRE_CLAN_BANU_HAQIM_VIZIER) //Each have pretty big religious influences, so!
	maximal_generation = 11
	maximum_immortal_age = 100
	description = "Be the shepherd of the flock in " + CITY_NAME + ", lead them to salvation, piety and righteousness."

	alt_titles = list(
		"Priest",
		"Nun",
		"Mother",
		"Father",
		"Imam",
		"Monk",
		"Reverend",
		"Preacher",
		"Rabbi",
	)

/datum/outfit/job/vampire/priest
	name = "Priest"
	jobtype = /datum/job/vampire/priest

	uniform = /obj/item/clothing/under/vampire/graveyard
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	id = /obj/item/card/hunter
	l_pocket = /obj/item/smartphone
	r_pocket = /obj/item/flashlight
	l_hand = /obj/item/vamp/keys/church
	back = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/card/credit=1)

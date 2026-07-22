/datum/job/vampire/graveyard
	title = JOB_GRAVEYARD_KEEPER
	faction = FACTION_CITY
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Camarilla or the Anarchs"
	exp_required_type_department = EXP_TYPE_SERVICES
	config_tag = "GRAVEYARD_KEEPER"
	outfit = /datum/outfit/job/vampire/graveyard
	job_flags = CITY_JOB_FLAGS
	display_order = JOB_DISPLAY_ORDER_GRAVEYARD
	department_for_prefs = /datum/job_department/city_services
	departments_list = list(
		/datum/job_department/city_services,
	)
	description = "A vile curse has gripped the dead of this city. You must keep the graveyard clean and the Masquerade intact."
	minimal_masquerade = 0
	allowed_splats = list(SPLAT_KINDRED, SPLAT_GHOUL)

/datum/outfit/job/vampire/graveyard
	name = JOB_GRAVEYARD_KEEPER
	jobtype = /datum/job/vampire/graveyard

	id = /obj/item/card/graveyard
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/vampire/graveyard
	suit = /obj/item/clothing/suit/vampire/trench
	glasses = /obj/item/clothing/glasses/vampire/yellow
	gloves = /obj/item/clothing/gloves/vampire/work
	l_pocket = /obj/item/smartphone
	r_pocket = /obj/item/vamp/keys/graveyard
	r_hand = /obj/item/shovel/vamp
	belt = /obj/item/scythe/vamp
	backpack_contents = list(/obj/item/card/credit=1)

	backpack = /obj/item/storage/backpack
	satchel = /obj/item/storage/backpack/satchel
	duffelbag = /obj/item/storage/backpack/duffelbag

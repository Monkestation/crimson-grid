/datum/job/vampire/supply
	title = "Supply Technician"
	faction = FACTION_CITY
	total_positions = 8
	spawn_positions = 8
	supervisors = "the Dealer"
	config_tag = "SUPPLY"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/supply_tech

	display_order = JOB_DISPLAY_ORDER_SUPPLY
	exp_required_type_department = EXP_TYPE_WAREHOUSE
	departments_list = list(
		/datum/job_department/supply,
	)


	description = "You work at the warehouse, moving boxes and selling not-quite legal goods to anyone who has the money."
	maximal_generation = 9
	maximum_immortal_age = 200
	minimum_masquerade = 0

/datum/outfit/job/vampire/supply_tech
	name = "Supply Technician"
	jobtype = /datum/job/vampire/supply
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	id = /obj/item/card/supplytech
	l_pocket = /obj/item/smartphone/supply_tech
	r_pocket = /obj/item/vamp/keys/supply
	backpack_contents = list(/obj/item/card/credit=1, /obj/item/clothing/mask/vampire/balaclava =1, /obj/item/gun/ballistic/automatic/pistol/darkpack/beretta=2,/obj/item/ammo_box/magazine/semi9mm=2, /obj/item/knife/vamp)

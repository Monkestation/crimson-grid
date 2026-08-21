/datum/job/vampire/dealer
	title = "Dealer"
	faction = FACTION_CITY
	total_positions = 2
	spawn_positions = 2
	supervisors = "nobody. You are beholden only to yourself."
	config_tag = "DEALER"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/dealer

	display_order = JOB_DISPLAY_ORDER_DEALER
	exp_required_type_department = EXP_TYPE_WAREHOUSE
	departments_list = list(
		/datum/job_department/supply,
	)

	known_contacts = list(
		JOB_PRINCE,
		JOB_SENESCHAL,
		JOB_SHERIFF,
		JOB_BARON,
		JOB_SUPPLY_TECH,
		JOB_HARPY,
		JOB_EMISSARY
	)
	allowed_splats = list(SPLAT_KINDRED, SPLAT_GHOUL, SPLAT_GAROU, SPLAT_NONE)
	splat_slots = list(SPLAT_NONE = 1)
	description = "You provide both legal and illegal supplies to those that get busy during the night. You are your own person yet you know people are out for you. Time to buckle in..."
	minimum_masquerade = 0

/datum/outfit/job/vampire/dealer
	name = JOB_DEALER
	jobtype = /datum/job/vampire/dealer
	uniform = /obj/item/clothing/under/vampire/suit
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	id = /obj/item/card/dealer
	l_pocket = /obj/item/smartphone/dealer
	r_pocket = /obj/item/vamp/keys/supply
	backpack_contents = list(/obj/item/card/credit/rich=1, /obj/item/hatchet)

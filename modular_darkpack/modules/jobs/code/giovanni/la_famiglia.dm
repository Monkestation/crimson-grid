/datum/job/vampire/famiglia
	title = JOB_LA_FAMIGLIA
	faction = FACTION_GIOVANNI
	total_positions = 10
	spawn_positions = 10
	supervisors = "the Family"
	config_tag = "LA_FAMIGLIA"
	outfit = /datum/outfit/job/vampire/famiglia
	job_flags = CITY_JOB_FLAGS
	display_order = 2
	exp_required_type_department = EXP_TYPE_GIOVANNI
	departments_list = list(
		/datum/job_department/giovanni,
	)

	allowed_splats = list(SPLAT_GHOUL, SPLAT_NONE, SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_CAITIFF)
	maximal_generation = 9
	maximum_immortal_age = 200
	description = "Your family is a strange one. Maybe you are strange too, because sitting next to your great uncles as an equal is something you are greatly interested in."
	minimum_masquerade = 0

/datum/outfit/job/vampire/famiglia
	name = "La Famiglia"
	jobtype = /datum/job/vampire/famiglia
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/smartphone/giovanni_famiglia
	r_pocket = /obj/item/vamp/keys/giovanni
	backpack_contents = list(/obj/item/card/credit=1)

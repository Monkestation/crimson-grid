/datum/job/vampire/nonni
	title = JOB_I_NONNI
	faction = FACTION_GIOVANNI
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Family and the Traditions"
	config_tag = "NONNI"
	outfit = /datum/outfit/job/vampire/nonni
	job_flags = CITY_JOB_FLAGS
	display_order = 2
	exp_required_type_department = EXP_TYPE_GIOVANNI
	departments_list = list(
		/datum/job_department/giovanni,
	)

	allowed_splats = list(SPLAT_GHOUL, SPLAT_NONE, SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_GIOVANNI)
	minimal_generation = 10
	minimum_immortal_age = 200
	required_character_age = 80
	description = "Your long tenure has made you an honorary head of household. Use your wisdom to guide the Family, teach the Traditions and family trades, and advise the Capo."
	minimum_masquerade = 0

/datum/outfit/job/vampire/nonni
	name = "I Nonni"
	jobtype = /datum/job/vampire/nonni
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/smartphone/giovanni_nonni
	r_pocket = /obj/item/vamp/keys/giovanni
	backpack_contents = list(/obj/item/card/credit=1)

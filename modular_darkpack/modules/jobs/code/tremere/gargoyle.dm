/datum/job/vampire/gargoyle
	title = JOB_CHANTRY_GARGOYLE
	faction = FACTION_CAMARILLA
	total_positions = 5
	spawn_positions = 5
	supervisors = SUPERVISOR_REGENT
	config_tag = "CHANTRY_GARGOYLE"
	outfit = /datum/outfit/job/vampire/gargoyle
	job_flags = CITY_JOB_FLAGS
	exp_required_type_department = EXP_TYPE_CHANTRY
	departments_list = list(
		/datum/job_department/chantry,
	)
	display_order = JOB_DISPLAY_ORDER_GARGOYLE

	description = "You serve the local Chantry as either a guard dog, enforcer, or scout, a shock troop for the Mages of Clan Tremere. You serve the Tremere still, despise most of your kind being freed long ago, whether thats out of duty, mental enslavement, or having nowhere else to go. Among your Masters you are a second class citizen - yet you remain. Guard the Chantry and the Masters as your people always have."
	maximal_generation = 8 // Crimson Grid Edit - Lock Adjustments - Was 9
	maximum_immortal_age = 842 // Crimson Grid Edit - Lock Adjustments - Gargoyles were first made in 1167 after all - Was 200
	minimum_masquerade = 3
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_GARGOYLE)
	known_contacts = list(
		JOB_CHANTRY_REGENT,
		JOB_CHANTRY_ARCHIVIST,
		JOB_CHANTRY_GARGOYLE
	)

/datum/outfit/job/vampire/gargoyle
	name = JOB_CHANTRY_GARGOYLE
	jobtype = /datum/job/vampire/gargoyle
	id = /obj/item/card/archive
	glasses = /obj/item/clothing/glasses/vampire/red
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/work
	uniform = /obj/item/clothing/under/vampire/turtleneck_black
	suit = /obj/item/clothing/suit/hooded/robes/tremere
	mask = /obj/item/clothing/mask/vampire/venetian_mask
	belt = /obj/item/scythe/vamp
	r_pocket = /obj/item/vamp/keys/archive
	l_pocket = /obj/item/smartphone/gargoyle
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(
		/obj/item/ritual_tome/arcane = 1,
		/obj/item/card/credit = 1,
	)

/datum/job/vampire/primogen_ventrue
	title = JOB_PRIMOGEN_VENTRUE
	description = "Offer your infinite knowledge to Prince of the City. Maintain the local Jazz Club, in front of the Tower, and its Elysium."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_CAMARILLA
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_TRADITIONS
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CAMARILLA
	exp_required_type_department = EXP_TYPE_CAMARILLA
	exp_granted_type = EXP_TYPE_CAMARILLA
	config_tag = "PRIMOGEN_VENTRUE"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/ventrue

	display_order = JOB_DISPLAY_ORDER_VENTRUE
	departments_list = list(
		/datum/job_department/jazz_club,
		/datum/job_department/camarilla,
	)

	minimal_generation = 12
	minimum_immortal_age = 50
	minimum_masquerade = 5
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_VENTRUE)

	known_contacts = list("Prince")

/datum/outfit/job/vampire/ventrue
	name = "Primogen Ventrue"
	jobtype = /datum/job/vampire/primogen_ventrue

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/primogen
	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/smartphone/ventrue_primo
	backpack_contents = list(/obj/item/vamp/keys/ventrue/primogen=1, /obj/item/card/credit/elder=1, /obj/item/card/whip, /obj/item/card/steward, /obj/item/card/myrmidon)

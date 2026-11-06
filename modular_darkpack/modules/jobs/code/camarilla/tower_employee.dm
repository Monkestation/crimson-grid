/datum/job/vampire/towerwork
	title = JOB_TOWERWORK
	faction = FACTION_CAMARILLA
	total_positions = 4
	spawn_positions = 4
	supervisors = SUPERVISOR_SENESCHAL_PUBLIC
	config_tag = "TOWER_EMPLOYEE"
	outfit = /datum/outfit/job/vampire/towerwork
	job_flags = CITY_JOB_FLAGS
	display_order = JOB_DISPLAY_ORDER_TOWERWORK
	departments_list = list(
		/datum/job_department/camarilla,
	)

	tgui_icon = FA_ICON_PAPERCLIP

	alt_titles = list(
		"Tower Employee",
		"Tower Cleaner",
		"Tower Assistant",
		"Tower Security Guard",
		"Tower Personal Driver",
		"Tower Personal Attendant"
	)

	maximal_generation = 9
	maximum_immortal_age = 200
	known_contacts = list(
		JOB_PRINCE,
		JOB_SHERIFF,
		JOB_SENESCHAL,
		JOB_HOUND,
		JOB_TOWERWORK
	)
	allowed_splats = list(SPLAT_NONE, SPLAT_GHOUL, SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN) // CORVAX EDIT v20
	description = "Вы работаете в Башне Миллениум и так или иначе обслуживаете её администрацию, а может, и вовсе состоите в личных слугах у кого-то из трёх первых лиц. К странностям, которые случается увидеть или услышать по ночам, вы давно привыкли: либо вы и так в курсе дела, либо отшучиваетесь и стараетесь о них не думать."
	minimum_masquerade = 4

/datum/outfit/job/vampire/towerwork
	name = JOB_TOWERWORK
	jobtype = /datum/job/vampire/towerwork

	id = /obj/item/card/tower_employee
	uniform = /obj/item/clothing/under/vampire/hound
	gloves = /obj/item/clothing/gloves/vampire/work
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	r_pocket = /obj/item/vamp/keys/camarilla/ghoul
	l_pocket = /obj/item/smartphone/tower_employee
	backpack_contents = list(/obj/item/card/credit=1)

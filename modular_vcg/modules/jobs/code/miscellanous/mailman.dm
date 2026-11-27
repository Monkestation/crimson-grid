// Crimson Grid Addition: A City Services Project for more City Workers, This one adds Mail Officers for deliveries

/datum/job/vampire/mailman
	title = JOB_CITY_MAILMAN
	faction = FACTION_CITY
	total_positions = 3
	spawn_positions = 3
	supervisors = SUPERVISOR_MAIL
	config_tag = "JOB_CITY_MAILMAN"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/mailman

	display_order = JOB_DISPLAY_ORDER_CITY_MAILMAN
	exp_required_type_department = EXP_TYPE_HOS
	departments_list = list(
		/datum/job_department/city_services,
	)

	tgui_icon = FA_ICON_CAR

	known_contacts = list(
		JOB_CITY_MAILMAN,
		JOB_TAXI_DRIVER,
		JOB_DEALER,
		JOB_SUPPLY_TECH,
		JOB_STREET_JANITOR,
	)

	allowed_splats = list(SPLAT_GHOUL, SPLAT_KINFOLK, SPLAT_NONE, SPLAT_GAROU, SPLAT_CORAX, SPLAT_KINDRED)
	allowed_tribes = list(TRIBE_GLASS_WALKERS, TRIBE_RONIN, TRIBE_STARGAZERS)
	description = "You are a Mail Officer of the Federal Government. Your duty is to deliver products safely and on time. Your federal post grants you no authority over the city and no immunity from its laws. Respect the local government and law enforcement like any other citizen."
	minimum_masquerade = 3
	maximal_generation = 11
	maximum_immortal_age = 100
	minimum_masquerade = 2


/datum/outfit/job/vampire/mailman
	name = JOB_CITY_MAILMAN
	jobtype = /datum/job/vampire/mailman
	uniform = /obj/item/clothing/under/vampire/turtleneck_white
	shoes = /obj/item/clothing/shoes/vampire/brown
	l_pocket = /obj/item/smartphone/mailman
	r_pocket = /obj/item/vamp/keys/mail_office
	backpack_contents = list(
		/obj/item/card/credit=1,
	)

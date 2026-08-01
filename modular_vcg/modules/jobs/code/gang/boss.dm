/datum/job/vampire/gangboss // Human only gang leader
	title = JOB_GANG_BOSS
	faction = FACTION_GANG
	description = "You are the leader of a gang in " + CITY_NAME + ", to your underlings, your word is above the law. Ensure the product stays moving, without getting your hands dirty."
	total_positions = 1
	spawn_positions = 1
	supervisors = ".. Yourself.."
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/gangboss
	allowed_splats = list(SPLAT_NONE)
	minimum_masquerade = 5 // nobody is gonna start a gang when theres swat in the city
	departments_list = list(
		/datum/job_department/gang,
	)

	known_contacts = list(
		"Underboss",
		"Enforcer",
		"Dealer",
	)

/datum/outfit/job/vampire/gangboss
	name = "Street Boss"
	jobtype = /datum/job/vampire/gangboss

	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform =  /obj/item/clothing/under/vampire/fancy_gray
	suit = /obj/item/clothing/suit/vampire/fancy_gray
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/smartphone
	r_pocket = /obj/item/vamp/keys/gang
	backpack_contents = list(/obj/item/gun/ballistic/automatic/darkpack/uzi=1, /obj/item/card/credit, /obj/item/reagent_containers/cup/glass/baggie/meth/cocaine=1,)

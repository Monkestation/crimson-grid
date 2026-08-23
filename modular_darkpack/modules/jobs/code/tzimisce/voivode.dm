/datum/job/vampire/voivode
	title = JOB_VOIVODE
	faction = FACTION_SABBAT
	total_positions = 1
	spawn_positions = 1
	supervisors = " the Laws of Hospitality"
	config_tag = "VOIVODE"
	outfit = /datum/outfit/job/vampire/voivode
	job_flags = CITY_JOB_FLAGS
	exp_required_type_department = EXP_TYPE_MANOR
	departments_list = list(
		/datum/job_department/manor,
	)
	display_order = JOB_DISPLAY_ORDER_VOIVODE

	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_TZIMISCE)

	description = "You are a Childe of the Voivode-in-Waiting, the ancient Tzimisce Elder who has rested beneath the Earth for an age longer than the city that now rests on their bones. Honor them in all your actions, and remember that you walk with their favor."
	minimum_masquerade = 2

	known_contacts = list(
		JOB_PRINCE,
		JOB_BARON,
		JOB_SHERIFF,
		JOB_BOGATYR,
		JOB_ZADRUGA
	)

/datum/outfit/job/vampire/voivode
	name = JOB_VOIVODE
	jobtype = /datum/job/vampire/voivode
	id = /obj/item/card/voivode
	glasses = /obj/item/clothing/glasses/vampire/yellow
	uniform = /obj/item/clothing/under/vampire/voivode
	suit = /obj/item/clothing/suit/vampire/trench/voivode
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	belt = /obj/item/storage/belt/sheath/vamp/sword
	l_pocket = /obj/item/smartphone/voivode
	backpack_contents = list(/obj/item/vamp/keys/old_clan_tzimisce=1, /obj/item/instrument/eguitar/vamp=1, /obj/item/card/credit/elder=1)

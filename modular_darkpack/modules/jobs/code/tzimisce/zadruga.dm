/datum/job/vampire/zadruga
	title = JOB_ZADRUGA
	faction = FACTION_SABBAT
	total_positions = 2
	spawn_positions = 2
	supervisors = " the Laws of Hospitality"
	config_tag = "ZADRUGA"
	outfit = /datum/outfit/job/vampire/zadruga
	job_flags = CITY_JOB_FLAGS
	exp_required_type_department = EXP_TYPE_MANOR
	departments_list = list(
		/datum/job_department/manor,
	)
	display_order = JOB_DISPLAY_ORDER_ZADRUGA

	allowed_splats = list(SPLAT_GHOUL)
	description = "You were born in servitude to the Master of the Manor: your father served the Voivode, as did his father. Now, you carry their blood, and with it their responsibilities."
	minimum_masquerade = 2

	known_contacts = list(
		JOB_PRINCE,
		JOB_BARON,
		JOB_SHERIFF,
		JOB_BOGATYR,
		JOB_VOIVODE
	)

/datum/outfit/job/vampire/zadruga
	name = JOB_ZADRUGA
	jobtype = /datum/job/vampire/zadruga
	id = /obj/item/card/bogatyr
	glasses = /obj/item/clothing/glasses/vampire/yellow
	uniform = /obj/item/clothing/under/vampire/bogatyr
	suit = /obj/item/clothing/suit/vampire/jacket/punk
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/smartphone/zadruga
	backpack_contents = list(/obj/item/vamp/keys/old_clan_tzimisce=1, /obj/item/card/credit=1)

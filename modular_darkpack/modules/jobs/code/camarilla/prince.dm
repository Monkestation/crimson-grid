/datum/job/vampire/prince
	title = JOB_PRINCE
	description = "You are the top dog of this city. You hold Praxis over " + CITY_NAME + ", and your word is law. Make sure the Masquerade is upheld, and your status is respected."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	faction = FACTION_CAMARILLA
	total_positions = 1
	spawn_positions = 1
	supervisors = SUPERVISOR_TRADITIONS
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = EXP_REQ_CRITICAL
	exp_required_type_department = EXP_TYPE_CAMARILLA
	config_tag = "PRINCE"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/prince

	display_order = JOB_DISPLAY_ORDER_PRINCE
	departments_list = list(
		/datum/job_department/camarilla,
	)

	tgui_icon = FA_ICON_CROWN

	minimal_generation = 10
	minimum_immortal_age = 75
	minimum_masquerade = 5
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_BANU_HAQIM_VIZIER)

	known_contacts = list(
		JOB_SHERIFF,
		JOB_SENESCHAL,
		JOB_HARPY,
		JOB_DEALER,
		JOB_CHANTRY_REGENT,
		JOB_PRIMOGEN_BANU_HAQIM,
		JOB_PRIMOGEN_TOREADOR,
		JOB_PRIMOGEN_LASOMBRA,
		JOB_PRIMOGEN_MALKAVIAN,
		JOB_PRIMOGEN_VENTRUE,
		JOB_PRIMOGEN_NOSFERATU,
		JOB_BARON,
		JOB_VOIVODE
	)

/datum/job/vampire/prince/get_captaincy_announcement(mob/living/captain)
	return "Prince [captain.real_name] is in the city!"

/datum/outfit/job/vampire/prince
	name = JOB_PRINCE
	jobtype = /datum/job/vampire/prince

	ears = /obj/item/radio/headset/darkpack
	id = /obj/item/card/prince
	glasses = /obj/item/clothing/glasses/vampire/sun
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform =  /obj/item/clothing/under/vampire/prince
	suit = /obj/item/clothing/suit/vampire/trench/alt
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/smartphone/prince
	r_pocket = /obj/item/vamp/keys/prince
	backpack_contents = list(/obj/item/gun/ballistic/automatic/pistol/darkpack/deagle=1, /obj/item/phone_book=1, /obj/item/masquerade_contract=1, /obj/item/card/credit/prince=1)

/// Start Crimson Grid Addition - Remembering Tower Armory And Safe Room Codes
/datum/memory/key/armory_code
	var/remembered_code

/datum/memory/key/armory_code/New(
	datum/mind/memorizer_mind,
	atom/protagonist,
	atom/deuteragonist,
	atom/antagonist,
	remembered_code,
)
	src.remembered_code = remembered_code
	return ..()

/datum/memory/key/armory_code/get_names()
	return list("The armory code is [remembered_code].")

/datum/memory/key/armory_code/get_starts()
	return list(
		"[protagonist_name] screams [remembered_code], looking panicked. It's time to get the big guns!"
	)

/datum/job/vampire/prince/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	var/obj/keypad/armory/door = locate() in GLOB.vault_doors
	if(door)
		spawned.mind.add_memory(/datum/memory/key/armory_code, remembered_code = door.pincode)

/datum/memory/key/panic_room_code
	var/remembered_code

/datum/memory/key/panic_room_code/New(
	datum/mind/memorizer_mind,
	atom/protagonist,
	atom/deuteragonist,
	atom/antagonist,
	remembered_code,
)
	src.remembered_code = remembered_code
	return ..()

/datum/memory/key/panic_room_code/get_names()
	return list("The panic room code is [remembered_code].")

/datum/memory/key/panic_room_code/get_starts()
	return list(
		"[protagonist_name] screams [remembered_code], looking panicked. It's time to hide!"
	)

/datum/job/vampire/prince/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	var/obj/keypad/panic_room/door = locate() in GLOB.vault_doors
	if(door)
		spawned.mind.add_memory(/datum/memory/key/panic_room_code, remembered_code = door.pincode)
/// End Crimson Grid Addition - Fixing Tower Armory And Safe Room Codes

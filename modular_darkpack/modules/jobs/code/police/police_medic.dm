//CRIMSON GRID ADDITION

/datum/job/vampire/police_medic
	title = JOB_POLICE_MEDIC
	faction = FACTION_CITY
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Police Captain first but the Clinic Director above all"
	exp_required_type_department = EXP_TYPE_CLINIC
	config_tag = "DOCTOR"
	job_flags = CITY_JOB_FLAGS
	outfit = /datum/outfit/job/vampire/police_medic

	display_order = JOB_DISPLAY_ORDER_POLICE_MEDIC
	departments_list = list(
		/datum/job_department/police,
		/datum/job_department/clinic,
	)

	description = "A member from the local Hospital. Ensure the safety and treat the members of the Police Department."
	maximal_generation = 9
	maximum_immortal_age = 200
	allowed_splats = list(SPLAT_KINDRED, SPLAT_GHOUL, SPLAT_KINFOLK, SPLAT_NONE, SPLAT_GAROU, SPLAT_CORAX)
	allowed_clans = list(VAMPIRE_CLAN_DAUGHTERS_OF_CACOPHONY, VAMPIRE_CLAN_HEALER_SALUBRI, VAMPIRE_CLAN_BAALI, VAMPIRE_CLAN_BRUJAH, VAMPIRE_CLAN_TREMERE, VAMPIRE_CLAN_VENTRUE, VAMPIRE_CLAN_VENTRUE_ANTITRIBU, VAMPIRE_CLAN_NOSFERATU, VAMPIRE_CLAN_GANGREL, VAMPIRE_CLAN_CITY_GANGREL, VAMPIRE_CLAN_TOREADOR, VAMPIRE_CLAN_MALKAVIAN, VAMPIRE_CLAN_DOMINATE_MALKAVIAN, VAMPIRE_CLAN_BANU_HAQIM, VAMPIRE_CLAN_BANU_HAQIM_VIZIER, VAMPIRE_CLAN_GIOVANNI, VAMPIRE_CLAN_SETITE, VAMPIRE_CLAN_TLACIQUE, VAMPIRE_CLAN_TZIMISCE, VAMPIRE_CLAN_LASOMBRA, VAMPIRE_CLAN_CAITIFF, VAMPIRE_CLAN_KIASYD, VAMPIRE_CLAN_NAGARAJA)
	known_contacts = list("Clinic Director", "Police Chief")

	alt_titles = list(
		"Police Medic",
		"Medical Officer",
		"Police-Attache Medical Liaison"
	)


/datum/outfit/job/vampire/police_medic
	name = "Police Medic"
	jobtype = /datum/job/vampire/police_medic

	ears = /obj/item/radio/headset/darkpack/police
	id = /obj/item/card/clinic
	uniform = /obj/item/clothing/under/rank/medical/paramedic
	shoes = /obj/item/clothing/shoes/vampire/white
	suit = /obj/item/clothing/suit/toggle/labcoat/paramedic
	belt = /obj/item/storage/belt/medical/paramedic
	gloves = /obj/item/clothing/gloves/vampire/latex
	l_pocket = /obj/item/smartphone
	r_pocket = /obj/item/vamp/keys/clinic
	backpack_contents = list(/obj/item/card/credit=1, /obj/item/storage/medkit/darkpack/doctor=1, /obj/item/vamp/keys/police)

	skillchips = list(/obj/item/skillchip/entrails_reader)

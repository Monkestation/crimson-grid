/datum/job/vampire/squadra
	title = JOB_LA_SQUADRA
	faction = FACTION_GIOVANNI
	total_positions = 10
	spawn_positions = 10
	supervisors = "the Family and the Traditions"
	config_tag = "LA_SQUADRA"
	outfit = /datum/outfit/job/vampire/squadra
	job_flags = CITY_JOB_FLAGS
	display_order = 3
	exp_required_type_department = EXP_TYPE_GIOVANNI
	departments_list = list(
		/datum/job_department/giovanni,
	)

	known_contacts = list(
		JOB_LA_FAMIGLIA,
		JOB_CAPO,
		JOB_LA_SQUADRA
	)

	description = "Whether born or Embraced into the family, you are one of the Giovanni. Be you a necromancer, financier or lowly fledgling, remember that so long as you stand with your family, they too will stand with you."
	maximal_generation = 8 // Crimson Grid Edit - Lock Adjustments - Was 9
	maximum_immortal_age = 200
	minimum_masquerade = 0
	allowed_splats = list(SPLAT_KINDRED)
	allowed_clans = list(VAMPIRE_CLAN_GIOVANNI)

/datum/outfit/job/vampire/squadra
	name = JOB_LA_SQUADRA
	jobtype = /datum/job/vampire/squadra

	glasses = /obj/item/clothing/glasses/vampire/sun
	uniform = /obj/item/clothing/under/vampire/suit
	suit = /obj/item/clothing/suit/vampire/trench
	shoes = /obj/item/clothing/shoes/vampire
	l_pocket = /obj/item/smartphone/giovanni_squadra
	r_pocket = /obj/item/vamp/keys/giovanni
	backpack_contents = list(/obj/item/card/credit/rich=1, /obj/item/ritual_tome/necromancy=1, /obj/item/vamp/keys/graveyard = 1)


/datum/job/vampire/squadra/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	var/obj/structure/vaultdoor/pincode/bank/door = locate() in GLOB.vault_doors
	if(door)
		spawned.mind.add_memory(/datum/memory/key/bank_vault_code, remembered_code = door.pincode)


/datum/job/vampire/sabbatductus
	title = JOB_SABBAT_DUCTUS
	faction = FACTION_SABBAT
	total_positions = 1
	spawn_positions = 1
	supervisors = "Caine"
	config_tag = "SABBAT_DUCTUS"
	outfit = /datum/outfit/job/vampire/sabbatductus
	allowed_splats = list(SPLAT_KINDRED)
	job_flags = CITY_JOB_FLAGS
	departments_list = list(
		/datum/job_department/sabbat,
	)

	exp_requirements = EXP_REQ_HEAD
	exp_required_type_department = EXP_TYPE_SABBAT

	description = "You are a Ductus and Pack Leader of your Sabbat pack. You are charged with rebellion against the Elders and the Camarilla, against the Jyhad, against the Masquerade and the Traditions, and the recognition of Caine as the true Dark Father of all Kindred kind. NOTE: BY PLAYING THIS ROLE YOU AGREE TO AND HAVE READ THE SERVER'S RULES ON ESCALATION FOR ANTAGS. KEEP THINGS INTERESTING AND ENGAGING FOR BOTH SIDES. KILLING PLAYERS JUST BECAUSE YOU CAN MAY RESULT IN A ROLEBAN."
	minimum_masquerade = 0
	display_order = JOB_DISPLAY_ORDER_SABBATDUCTUS
	whitelisted = TRUE

	known_contacts = list(
		JOB_SABBAT_PACK,
		JOB_SABBAT_PRIEST
	)

/datum/antagonist/sabbatist/ductus
	antag_hud_name = "ductus" // CRIMSON EDIT - Sabbat Rank Icons - Original: "ductus_priest"

/datum/outfit/job/vampire/sabbatductus
	name = JOB_SABBAT_DUCTUS
	jobtype = /datum/job/vampire/sabbatductus
	l_pocket = /obj/item/smartphone/sabbat_ductus
	r_pocket = /obj/item/vamp/keys/sabbat
	uses_default_clan_clothes = TRUE
	backpack_contents = list(/obj/item/card/credit=1)

/datum/outfit/job/vampire/sabbatductus/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.mind.add_antag_datum(/datum/antagonist/sabbatist/ductus)

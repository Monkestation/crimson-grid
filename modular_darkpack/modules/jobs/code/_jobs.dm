// Default vampire base type.
/datum/job
	///Minimum vampire Generation necessary to do this job.
	var/minimal_generation = HIGHEST_GENERATION_LIMIT
	///Minimum Masquerade level necessary to do this job.
	var/minimal_masquerade = 0
	/// Character must be at least this age (in years) since embrace (chronological_age - age) to join as role.
	var/minimum_immortal_age = 0

	/// The list of alternative job titles people can pick from, null by default.
	var/list/alt_titles = null // ALTERNATIVE_JOB_TITLES

	///List of splats that are allowed to do this job.
	var/list/allowed_splats
	///List of species that are limited to a certain amount of that species doing this job. e.g: list(SPLAT_NONE = -1, SPLAT_GHOUL = -1, SPLAT_KINDRED = -1)
	var/list/splat_slots
	///List of Clans that are allowed to do this job.
	var/list/allowed_clans
	///List of Clans that are disallowed to do this job.
	var/list/disallowed_clans
	///If this job requires whitelisting before it can be selected for characters.
	var/whitelisted = FALSE

	// Only for display in memories
	var/list/known_contacts = null

	///Guestbook flags, to establish who knowns who etc
	var/guestbook_flags = NONE

// Default vampire job outfits.
/datum/outfit/job/vampire
	uniform = /obj/item/clothing/under/vampire/sport
	id = null
	ears = null
	belt = null
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/vampire
	box = null
	pda_slot = null
	var/uses_default_clan_clothes = FALSE

/datum/outfit/job/vampire/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	if(uses_default_clan_clothes == TRUE && uniform == initial(uniform))
		var/datum/splat/vampire/kindred/kindred = get_kindred_splat(H)
		if(kindred)
			if(H.jumpsuit_style == PREF_SUIT)
				if(!shoes)
					shoes = /obj/item/clothing/shoes/vampire
				if(kindred.clan.male_clothes && !uniform)
					uniform = kindred.clan.male_clothes
			else
				if(!shoes)
					shoes = /obj/item/clothing/shoes/vampire/heels
				if(kindred.clan.female_clothes && !uniform)
					uniform = kindred.clan.female_clothes
		else
			if(H.jumpsuit_style == PREF_SKIRT)
				if(!shoes)
					shoes = /obj/item/clothing/shoes/vampire
				if(!uniform)
					uniform = /obj/item/clothing/under/vampire/red
			else
				if(!shoes)
					shoes = /obj/item/clothing/shoes/vampire/heels
				if(!uniform)
					uniform = /obj/item/clothing/under/vampire/sport

/datum/outfit/job/vampire/post_equip(mob/living/carbon/human/user, visuals_only = FALSE)
	. = ..()
	var/obj/item/smartphone/phone = locate() in user.contents
	if(phone)
		phone.owner_weakref = WEAKREF(user)
		phone.update_initialized_contacts()

/datum/job/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	if(!(guestbook_flags & GUESTBOOK_FORGETMENOT))
		for(var/mob/player_mob as anything in GLOB.player_list)
			if((player_mob == spawned) || !player_mob.mind?.assigned_role)
				continue
			var/datum/job/player_mob_job = player_mob.mind.assigned_role
			var/list/common_departments = player_mob_job.departments_list & departments_list //wonky
			//if we satisfy at least one condition, add us to their guestbook
			if(player_mob_job.guestbook_flags & GUESTBOOK_OMNISCIENT || \
				((player_mob_job.guestbook_flags & GUESTBOOK_JOB) && (player_mob_job.type == src.type)) || \
				((player_mob_job.guestbook_flags & GUESTBOOK_DEPARTMENT) && length(common_departments)))
				player_mob.mind.guestbook.add_guest(player_mob, spawned, spawned.mind.name, spawned.mind.name, silent = TRUE)
			//if we satisfy at least one condition, add them to our guestbook
			if(guestbook_flags & GUESTBOOK_OMNISCIENT || \
				((guestbook_flags & GUESTBOOK_JOB) && (src.type == player_mob_job.type)) || \
				((guestbook_flags & GUESTBOOK_DEPARTMENT) && length(common_departments)))
				spawned.mind.guestbook.add_guest(spawned, player_mob, player_mob.mind.name, player_mob.mind.name, silent = TRUE)

/**
 * This type is used to indicate a lack of a job.
 * The mind variable assigned_role will point here by default.
 * As any other job datum, this is a singleton.
 **/

/datum/job/vampire/unassigned
	title = JOB_ORDINARY_CITIZEN
	rpg_title = "Peasant"


/// Returns information pertaining to this job's radio.
/datum/job/vampire/get_radio_information()
	return

// Default vampire base type.
/datum/job
	/// The list of alternative job titles people can pick from, null by default.
	var/list/alt_titles = null // ALTERNATIVE_JOB_TITLES

	///List of splats that are allowed to do this job.
	var/list/allowed_splats
	///List of species that are limited to a certain amount of that species doing this job. e.g: list(SPLAT_NONE = -1, SPLAT_GHOUL = -1, SPLAT_KINDRED = -1)
	var/list/splat_slots

	// VTM
	///Minimum vampire Generation necessary to do this job.
	var/minimal_generation = HIGHEST_GENERATION_LIMIT
	//Maximum vampire generation to play the job.
	var/maximal_generation = LOWEST_GENERATION_LIMIT
	///Minimum Masquerade level necessary to do this job.
	var/minimum_masquerade = 0
	/// Character must be at least this age (in years) since embrace (chronological_age - age) to join as role.
	var/minimum_immortal_age = 0
	/// Character must not be over this age (in years) since embrace (chronological_age - age) to join as role. (Defaults null, set to desired age.)
	var/maximum_immortal_age = null
	///List of Clans that are allowed to do this job.
	var/list/allowed_clans
	///List of Clans that are disallowed to do this job.
	var/list/disallowed_clans

	// WTA
	///Minimum Renown Rank necessary to do this job.
	var/minimal_renown_rank
	///List of Tribes that are allowed to do this job.
	var/list/allowed_tribes
	var/list/disallowed_tribes
	///List of Auspices that are allowed to do this job.
	var/list/allowed_auspice
	var/list/disallowed_auspice


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
	var/list/wallet_contents = list()
	var/no_wallet = FALSE
	var/no_credit_card = FALSE

/datum/outfit/job/vampire/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	// fuck editing all these jobs manually goddamn kiss my ass
	var/assigned_wallet = FALSE
	if(!id)
		id = /obj/item/storage/wallet/darkpack
		assigned_wallet = TRUE
	else if(id == /obj/item/storage/wallet/darkpack)
		assigned_wallet = TRUE
	if(r_pocket && ispath(r_pocket, /obj/item/vamp/keys) && !assigned_wallet)
		wallet_contents += r_pocket
		r_pocket = /obj/item/storage/wallet/darkpack
		assigned_wallet = TRUE
	else if(r_pocket == /obj/item/storage/wallet/darkpack)
		assigned_wallet = TRUE
	if(l_pocket && ispath(l_pocket, /obj/item/vamp/keys) && !assigned_wallet)
		wallet_contents += l_pocket
		l_pocket = /obj/item/storage/wallet/darkpack
		assigned_wallet = TRUE
	else if(l_pocket == /obj/item/storage/wallet/darkpack)
		assigned_wallet = TRUE
	if(!assigned_wallet)
		CRASH("[src] doesn't have a spot for a wallet! Check their configuration, please.")
	for(var/path in backpack_contents)
		if(ispath(path, /obj/item/vamp/keys) || ispath(path, /obj/item/card))
			wallet_contents += path
			backpack_contents -= path
			continue
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
	var/obj/item/smartphone/phone = locate() in user.gather_belongings()
	if(phone)
		phone.owner_weakref = WEAKREF(user)
		phone.update_initialized_contacts()
	// CRIMSON GRID EDIT BEGIN - Wallets and money splits, and identification.
	var/obj/item/storage/wallet/darkpack/wallet = locate() in user.gather_belongings()
	if(wallet && !no_wallet)
		if(wallet_contents)
			for(var/path in wallet_contents)
				var/number = wallet_contents[path]
				if(!isnum(number))//Default to 1
					number = 1
				for(var/i in 1 to number)
					SSwardrobe.provide_type(path, wallet)
		var/finance = user.st_get_stat(STAT_FINANCE)
		var/streetwise = user.st_get_stat(STAT_STREETWISE)
		var/obj/item/stack/dollar/cash_money = SSwardrobe.provide_type(/obj/item/stack/dollar, wallet)
		var/obj/item/card/credit/card = locate() in user.gather_belongings()
		if(!no_credit_card && !card)
			card = SSwardrobe.provide_type(/obj/item/card/credit, wallet) // make one
		if(card && card.has_checked == FALSE)
			card.registered_name = user.real_name
			var/datum/bank_account/account = SSeconomy.bank_accounts_by_id["[user.account_id]"]
			if(!account)
				account = new /datum/bank_account()
			card.set_account(account)

		var/datum/bank_account/bank_account = card?.registered_account
		var/streetwise_mult
		var/total_money
		if(card.min_starting_wealth && card.max_starting_wealth)
			total_money = rand(card.min_starting_wealth, card.max_starting_wealth)
		switch(streetwise)
			if(0)
				streetwise_mult = 0
			if(1)
				streetwise_mult = 0.2
			if(2)
				streetwise_mult = 0.4
			if(3)
				streetwise_mult = 0.6
			if(4)
				streetwise_mult = 0.8
			if(5)
				streetwise_mult = 0.9
		switch(finance)
			if(0)
				if(!CONFIG_GET(flag/punishing_zero_dots))
					total_money += rand(50, 100)
					if(bank_account)
						bank_account.paycheck_amount = 15
				else
					total_money += 50
					if(bank_account)
						bank_account.paycheck_amount = 10
			if(1)
				total_money += rand(100, 200)
				if(bank_account)
					bank_account.paycheck_amount = 40
			if(2)
				total_money += rand(300, 600)
				if(bank_account)
					bank_account.paycheck_amount = 80
			if(3)
				total_money += rand(800, 1200)
				if(bank_account)
					bank_account.paycheck_amount = 120
			if(4)
				total_money += rand(1200, 1600)
				if(bank_account)
					bank_account.paycheck_amount = 160
			if(5)
				total_money += rand(2000, 3000)
				if(bank_account)
					bank_account.paycheck_amount = 250
		if(bank_account)
			bank_account.account_balance = total_money * streetwise_mult
			cash_money.add(total_money * (1 - streetwise_mult))
		else
			cash_money.add(total_money) // no bank accounts somehow
		var/country_of_origin = user.dna.country_of_origin
		if(!country_of_origin)
			return
		var/driving_skill = user.st_get_stat(STAT_DRIVE)
		var/obj/item/card/drivers_license/license
		if(wallet && !no_wallet)
			if(country_of_origin == "United States")
				if(!driving_skill)
					license = new /obj/item/card/drivers_license/state_issued_id(wallet)
				else
					license = new /obj/item/card/drivers_license(wallet)
				license.link_human(user)
			else
				if(driving_skill)
					license = new /obj/item/card/drivers_license/international(wallet)
					license.link_human(user)
				var/obj/item/passport/passport = new /obj/item/passport(wallet)
				passport.link_human(user)

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

/datum/job/vampire/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	spawned.add_faction(faction)

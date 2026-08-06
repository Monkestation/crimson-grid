// /card/ is a bit of a weird path but it allows us to inherit behavoir for wallet code.
/obj/item/card/credit
	name = "debit card"
	desc = "Used to access bank money."
	icon = 'modular_darkpack/modules/deprecated/icons/items.dmi'
	icon_state = "card1"
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF | ACID_PROOF
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/deprecated/icons/onfloor.dmi')
	slot_flags = NONE

	var/registered_name
	var/datum/bank_account/registered_account
	var/has_checked = FALSE
	var/min_starting_wealth = 0
	var/max_starting_wealth = 0

/obj/item/card/credit/prince
	icon_state = "card2"
	min_starting_wealth = 10000
	max_starting_wealth = 15000

/obj/item/card/credit/seneschal
	icon_state = "card2"
	min_starting_wealth = 4000
	max_starting_wealth = 8000

/obj/item/card/credit/elder
	icon_state = "card3"
	min_starting_wealth = 3000
	max_starting_wealth = 7000

/obj/item/card/credit/giovanniboss
	icon_state = "card2"
	min_starting_wealth = 8000
	max_starting_wealth = 15000

/obj/item/card/credit/rich
	min_starting_wealth = 1000
	max_starting_wealth = 4000

/obj/item/card/credit/Initialize(mapload)
	. = ..()
	var/datum/bank_account/blank_bank_account = new("Unassigned", SSjob.get_job_type(/datum/job/unassigned), player_account = FALSE)
	set_account(blank_bank_account)
	registered_account.replaceable = TRUE

	/*
	if(ishuman(loc)) // In pockets
		user = loc
	else if(ishuman(loc?.loc)) // In backpack
		user = loc
	if(user && user.account_id)
		registered_account = SSeconomy.bank_accounts_by_id["[user.account_id]"]
	if(!registered_account)
		registered_account = new /datum/bank_account()
	if(!isnull(user))
		registered_name = user.real_name
	registered_account.account_balance = rand(min_starting_wealth, max_starting_wealth)
	*/

/obj/item/card/credit/Destroy(force)
	clear_account()
	return ..()

/obj/item/card/credit/examine(mob/user)
	. = ..()
	if(registered_name)
		. += span_notice("The card bears a name: [registered_name].")

/obj/item/card/credit/GetCreditCard()
	return src

/// Sets the bank account for the ID card.
/obj/item/card/credit/proc/set_account(datum/bank_account/account, transfer_funds = FALSE)
	if(registered_account == account)
		return
	if(!isnull(registered_account))
		if(transfer_funds)
			account?.transfer_money(registered_account, registered_account.account_balance, "Account transfer")
		clear_account()
	if(isnull(account))
		return

	if(src in account.bank_cards)
		stack_trace("Despite [src] not being registered to [account], the account already has it within the bank_cards list.")

	registered_account = account
	LAZYOR(registered_account.bank_cards, src)
	registered_account.civilian_bounty?.on_selected(src)

/// Clears the economy account from the ID card.
/obj/item/card/credit/proc/clear_account()
	if(isnull(registered_account))
		return

	registered_account.civilian_bounty?.on_reset(src)
	LAZYREMOVE(registered_account.bank_cards, src)
	registered_account = null
/* CRIMSON GRID EDIT - moved to other post_equip
/datum/outfit/job/vampire/post_equip(mob/living/carbon/human/user, visuals_only = FALSE)
	. = ..()

	var/obj/item/storage/backpack/b = locate() in user
	if(b)
		var/obj/item/card/credit/card = locate() in b.contents
		if(card && card.has_checked == FALSE)
			card.registered_name = user.real_name

			//card.update_label()
			//card.update_icon()
			var/datum/bank_account/account = SSeconomy.bank_accounts_by_id["[user.account_id]"]

			if(account && account.account_id == user.account_id)
				card.set_account(account)
*/

/obj/item/proc/GetCreditCard()
	return null

/obj/item/storage/wallet/GetCreditCard()
	return locate(/obj/item/card/credit) in contents


/mob/proc/get_creditcard(hand_first)
	return

/mob/living/get_creditcard(hand_first)
	if(!length(held_items)) //Early return for mobs without hands.
		return
	//Check hands
	var/obj/item/held_item = get_active_held_item()
	if(held_item) //Check active hand
		. = held_item.GetCreditCard()
	if(!.) //If there is no id, check the other hand
		held_item = get_inactive_held_item()
		if(held_item)
			. = held_item.GetCreditCard()

/mob/living/proc/get_creditcard_in_hand()
	var/obj/item/held_item = get_active_held_item()
	if(!held_item)
		return
	return held_item.GetCreditCard()


///Helper to create a typepath to be used in the UI
#define SANITIZED_PATH(path)(replacetext(replacetext("[path]", "/obj/item/", ""), "/", "-"))

/obj/structure/retail
	abstract_type = /obj/structure/retail
	name = "retail outlet"
	desc = "A counter for partaking in wretched capitalism. Takes cash or card."
	icon = 'modular_darkpack/modules/retail/icons/vendors_shops.dmi'
	icon_state = "register"
	density = FALSE
	anchored = TRUE
	anchored_tabletop_offset = 6
	var/owner_needed = TRUE //Does an npc need to be here for this
	var/mob/living/carbon/human/npc/my_owner //tracks existence of owner
	var/payment_department = ACCOUNT_SRV

	var/list/datum/data/vending_product/products_list = list()
	// Equivlenet to products list if you dont need to pass args. Will likely phase out the evil news in our type path definitions
	var/list/product_types = list()

/obj/structure/retail/Initialize(mapload)
	. = ..()
	if(owner_needed == TRUE)
		my_owner = locate(/mob/living/carbon/human/npc) in range(2, src)
		if(my_owner)
			RegisterSignal(my_owner, COMSIG_QDELETING, PROC_REF(cleanup_owner))
	build_inventory()

/obj/structure/retail/proc/cleanup_owner()
	SIGNAL_HANDLER

	my_owner = null

//whether or not the user can shop at this store.
/obj/structure/retail/proc/can_shop(mob/user)
	return TRUE

/obj/structure/retail/can_interact(mob/user)
	. = ..()
	if(!. || !can_shop(user))
		return FALSE

/obj/structure/retail/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(can_shop(user))
		if(owner_needed == TRUE && (!my_owner || (get_dist(src, my_owner) > 4) || (my_owner.stat >= HARD_CRIT)))
			to_chat(user, span_alert("There's no teller here to sell you things..."))
			return
		else if(owner_needed == TRUE && my_owner && get_dist(src, my_owner) <= 4)
			my_owner.say(pick(my_owner.socialrole.random_phrases))
		ui_interact(user)

/obj/structure/retail/proc/build_inventory()
	for(var/product_path in product_types)
		products_list += new /datum/data/vending_product(path = product_path)
	for(var/datum/data/vending_product/product in products_list)
		if(!product)
			CRASH("Null retail product loaded in initialization of [src]. This should not happen!")
		//GLOB.vending_products[product.product_path] = 1

/obj/structure/retail/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/vending),
	)

/obj/structure/retail/ui_interact(mob/user, datum/tgui/ui)
	if(owner_needed == TRUE)
		if(!my_owner)
			return
		if(get_dist(src, my_owner) > 4)
			return
		if(my_owner.stat >= HARD_CRIT)
			return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		if(owner_needed && my_owner)
			my_owner.face_atom(user)
			my_owner.realistic_say(pick(my_owner.socialrole.random_phrases))
		ui = new(user, src, "RetailVendor", name)
		ui.open()

/obj/structure/retail/ui_static_data(mob/user)
	. = list()
	.["product_records"] = list()
	for(var/datum/data/vending_product/product in products_list)
		var/list/product_data = list(
			path = SANITIZED_PATH(product.product_path),
			name = product.name,
			price = product.price,
			stock = product.amount,
			dimensions = product.icon_dimension,
			ref = REF(product)
		)
		.["product_records"] += list(product_data)

		var/atom/printed = product.product_path
		// If it's not GAGS and has no innate colors we have to care about, we use DMIcon
		if(ispath(printed, /atom) \
			&& (!initial(printed.greyscale_config) || !initial(printed.greyscale_colors)) \
			&& !initial(printed.color) \
		)
			product_data["icon"] = initial(printed.icon)
			product_data["icon_state"] = initial(printed.icon_state)
	.["money_symbol"] = MONEY_SYMBOL

/obj/structure/retail/ui_data(mob/user)
	. = list()
	.["user"] = list()
	.["user"]["money"] = 0
	.["user"]["is_card"] = 0

	var/list/held_items = list()
	if(user.get_active_held_item())
		held_items += user.get_active_held_item()
	if(user.get_inactive_held_item())
		held_items += user.get_inactive_held_item()

	for(var/obj/item/held_item in held_items)
		if(is_creditcard(held_item))
			.["user"]["is_card"] = 1
			.["user"]["payment_item"] = REF(held_item)
			break
		else if(istype(held_item, /obj/item/stack/dollar))
// CRIMSON EDIT START - Cash Purchase Update
//			var/obj/item/money = held_item
//			.["user"]["money"] = money.get_item_credit_value()
			for(var/obj/item/stack/dollar/money in user.get_all_contents_type(/obj/item/stack/dollar))
				.["user"]["money"] += money.get_item_credit_value()
// CRIMSON EDIT END - Cash Purchase Update
			.["user"]["payment_item"] = REF(held_item)
			break
	return

/obj/structure/retail/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(owner_needed == TRUE && (!my_owner || (get_dist(src, my_owner) > 4) || (my_owner.stat >= HARD_CRIT)))
		to_chat(usr, span_alert("There's no teller here to sell you things..."))
		return

	switch(action)
		if("purchase")
			if(!isliving(usr))
				return
			var/mob/living/user = usr

			var/datum/data/vending_product/product = locate(params["ref"]) in products_list
			if(!product)
				to_chat(usr, span_alert("Error: Invalid choice!"))
				return

			var/obj/item/held_item = locate(params["payment_item"]) in user
			if(!held_item)
				to_chat(usr, span_alert("Error: Payment method not found!"))
				return

			if(product.amount == 0)
				to_chat(usr, span_alert("Error: Product is out of stock!"))
				return

			if(product.price > 0)
				//get the money
				if(is_creditcard(held_item))
					var/obj/item/card/credit/creditcard = held_item
					var/datum/bank_account/used_account = creditcard.registered_account
					if(!used_account)
						to_chat(user, span_alert("The [creditcard] has no linked account."))
						return
					if(!used_account.check_pin(user, product.price, creditcard))
						return
					if(!used_account.adjust_money(-1 * product.price))
						to_chat(user, span_alert("The transaction is declined - Insufficient funds."))
						return
					//used_account.process_credit_fraud(user, product.price)
				else if(istype(held_item, /obj/item/stack/dollar))
// CRIMSON EDIT START - Cash Purchase Update
//					if(!held_item.use(product.price))
//						to_chat(user, span_alert("You don't have enough money in your hand."))
//						return
					var/list/carried_money = user.get_all_contents_type(/obj/item/stack/dollar)
					var/total_money = 0
					for(var/obj/item/stack/dollar/money in carried_money)
						total_money += money.get_item_credit_value()
					if(total_money < product.price)
						to_chat(user, span_alert("You don't have enough money on you."))
						return
					var/remaining_price = product.price
					for(var/obj/item/stack/dollar/money in carried_money)
						var/to_spend = min(remaining_price, money.get_item_credit_value())
						money.use(to_spend)
						remaining_price -= to_spend
						if(!remaining_price)
							break
// CRIMSON EDIT END - Cash Purchase Update
				else
					return // We have nothing we can pay with.

			playsound(get_turf(src), 'sound/effects/cashregister.ogg', 50, TRUE)
			new product.product_path(loc)
			if(product.amount > 0)
				--product.amount
				update_static_data(usr)
			SSblackbox.record_feedback("nested tally", "retail_item_bought", 1, list("[type]", "[product.product_path]"))
			. = TRUE

#undef SANITIZED_PATH

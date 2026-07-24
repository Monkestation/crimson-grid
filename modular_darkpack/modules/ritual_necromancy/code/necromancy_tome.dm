/obj/item/ritual_tome/necromancy
	name = "necromancy tome"
	desc = "An old tome bound in peculiar leather."
	icon_state = "necronomicon"
	icon = 'modular_darkpack/modules/ritual_necromancy/icons/necromancy_tome.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/ritual_necromancy/icons/necromancy_tome_onfloor.dmi')
	rune_type = /obj/ritual_rune/necromancy
	var/list/products_list = list(
		// placeholder, idea is that its similar to thaumaturgy archives
		new /datum/data/vending_product("graveyard keys", /obj/item/vamp/keys/graveyard, 1),
		new /datum/data/vending_product("obolus", /obj/item/coin/iron/obolus, 2)
	)
	discipline_type = /datum/discipline/necromancy

/obj/item/ritual_tome/necromancy/Initialize(mapload)
	. = ..()
	for(var/datum/data/vending_product/prize in products_list)
		prize.amount = 1
		prize.max_amount = 10

/obj/item/ritual_tome/necromancy/attack_self(mob/user)
	var/mob/living/living_user = astype(user)
	if(!living_user || !living_user.get_discipline(/datum/discipline/necromancy))
		to_chat(user, span_cult("A Grimoire that contains etchings of many rituals and procedures. Sadly, you don't understand much of it."))
		return
	ui_interact(user)
	. = ..()

// NecromancyVendor.jsx in tgui/interfaces
/obj/item/ritual_tome/necromancy/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NecromancyVendor", name)
		ui.open()

/obj/item/ritual_tome/necromancy/ui_data(mob/user)
	. = list()
	.["user"] = list()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		.["user"]["souls"] = H.collected_souls
		.["user"]["name"] = "[H.name]"
		.["user"]["job"] = "[H.mind?.assigned_role?.title]"
		.["user"]["has_necromancy"] = !!H.get_discipline(/datum/discipline/necromancy)
	else if(isliving(user))
		var/mob/living/L = user
		.["user"]["souls"] = L.collected_souls
		.["user"]["name"] = "[L.name]"
		.["user"]["job"] = "Unknown"
		.["user"]["has_necromancy"] = FALSE
	else
		.["user"]["souls"] = 0
		.["user"]["name"] = "Unknown"
		.["user"]["job"] = "Unknown"
		.["user"]["has_necromancy"] = FALSE

	.["product_records"] = list()
	for(var/datum/data/vending_product/prize in products_list)
		var/stock_count = prize.amount
		var/obj/item/product_item = prize.product_path
		var/list/product_data = list(
			path = replacetext(replacetext("[prize.product_path]", "/obj/item/", ""), "/", "-"),
			name = prize.name,
			price = prize.price,
			ref = REF(prize),
			stock = stock_count,
			available = (stock_count > 0),
			icon = initial(product_item.icon),
			icon_state = initial(product_item.icon_state)
		)
		.["product_records"] += list(product_data)

/obj/item/ritual_tome/necromancy/ui_act(action, params)
	if(action != "purchase")
		return ..()

	var/mob/living/user = astype(usr)
	if(!user || !user.get_discipline(/datum/discipline/necromancy))
		return FALSE

	var/datum/data/vending_product/prize = locate(params["ref"]) in products_list

	if(!prize)
		return FALSE

	if(prize.amount <= 0)
		to_chat(user, span_alert("Error: [prize.name] is out of stock!"))
		return FALSE
	if(prize.price > user.collected_souls)
		to_chat(user, span_alert("Error: Insufficient souls for [prize.name]! You need [prize.price] souls."))
		return FALSE

	user.collected_souls -= prize.price
	prize.amount -= 1
	to_chat(user, span_notice("The necromancy tome resonates with dark energy as it dispenses [prize.name]!"))
	new prize.product_path(get_turf(user))
	return TRUE

/datum/crafting_recipe/necrotome
	name = "Necromantic Ritualism Tome"
	time = 10 SECONDS
	reqs = list(/obj/item/paper = 3, /obj/item/ectoplasm = 1)
	result = /obj/item/ritual_tome/necromancy
	category = CAT_MISC
	skill_required_for_use = STAT_OCCULT
	skill_dots_minimum = 1

/datum/crafting_recipe/necrotome/is_recipe_available(mob/user)
	. = ..()
	var/mob/living/living_user = astype(user)
	if(!living_user?.get_discipline(/datum/discipline/necromancy))
		return FALSE

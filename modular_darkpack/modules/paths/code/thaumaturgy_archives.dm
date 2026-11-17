/obj/structure/retail/occult
	icon_state = "menu"
	owner_needed = FALSE
	desc = "Use your occult research to reap the benefits of safeguarded knowledge and artifacts."

	products_list = list(
	// SPELLBOOKS
	new /datum/data/vending_product("Lure of Flames Spellbook (Level I)",	/obj/item/path_spellbook/lure_of_flames/level1,	130),
	new /datum/data/vending_product("Lure of Flames Spellbook (Level II)",	/obj/item/path_spellbook/lure_of_flames/level2,	180),
	new /datum/data/vending_product("Lure of Flames Spellbook (Level III)",	/obj/item/path_spellbook/lure_of_flames/level3,	210),
	new /datum/data/vending_product("Lure of Flames Spellbook (Level IV)",	/obj/item/path_spellbook/lure_of_flames/level4,	240),
	new /datum/data/vending_product("Lure of Flames Spellbook (Level V)",	/obj/item/path_spellbook/lure_of_flames/level5,	270),

	new /datum/data/vending_product("Levinbolt Spellbook (Level I)",	/obj/item/path_spellbook/levinbolt/level1,	130),
	new /datum/data/vending_product("Levinbolt Spellbook (Level II)",	/obj/item/path_spellbook/levinbolt/level2,	180),
	new /datum/data/vending_product("Levinbolt Spellbook (Level III)",	/obj/item/path_spellbook/levinbolt/level3,	210),
	new /datum/data/vending_product("Levinbolt Spellbook (Level IV)",	/obj/item/path_spellbook/levinbolt/level4,	240),
	new /datum/data/vending_product("Levinbolt Spellbook (Level V)",	/obj/item/path_spellbook/levinbolt/level5, 270),

	// ARTIFACTS
	// Lower tier artifacts
	new /datum/data/vending_product("Weekapaug Thistle", /obj/item/occult_artifact/vampire/weekapaug_thistle, 75),
	new /datum/data/vending_product("Mummywrap Fetish", /obj/item/occult_artifact/vampire/mummywrap_fetish, 70),
	new /datum/data/vending_product("Galdjum", /obj/item/occult_artifact/vampire/galdjum, 70),
	new /datum/data/vending_product("Bloodstar", /obj/item/occult_artifact/vampire/bloodstar, 70),

	// Mid tier artifacts
	new /datum/data/vending_product("Fae Charm", /obj/item/occult_artifact/vampire/fae_charm, 120),
	new /datum/data/vending_product("Daimonori", /obj/item/occult_artifact/vampire/daimonori, 120),
	new /datum/data/vending_product("Key of Alamut", /obj/item/occult_artifact/vampire/key_of_alamut, 130),
	new /datum/data/vending_product("Heart of Eliza", /obj/item/occult_artifact/vampire/heart_of_eliza, 140),
	new /datum/data/vending_product("Bloodstone", /obj/item/occult_artifact/vampire/bloodstone, 140),

	// High tier artifacts
	new /datum/data/vending_product("Odious Chalice", /obj/item/occult_artifact/vampire/odious_chalice, 180),

)

/obj/structure/retail/occult/New()
	. = ..()
	//each item starts with 2 in stock
	for(var/datum/data/vending_product/prize in products_list)
		prize.amount = 2
		prize.max_amount = 10

// are they antitribu?
/obj/structure/retail/occult/proc/has_purchase_privileges(datum/job/job)
	return is_type_in_list(job, list(
		/datum/job/vampire/regent,
		/datum/job/vampire/archivist,
		/datum/job/vampire/hound,
		/datum/job/vampire/sheriff,
		/datum/job/vampire/clerk,
		/datum/job/vampire/prince)
	)

// find the regent
/obj/structure/retail/occult/proc/find_regent()
	for(var/mob/living/carbon/human/human_user in GLOB.human_list)
		if(istype(human_user.mind?.assigned_role, /datum/job/vampire/regent))
			return human_user
	return null

// find all archivists
/obj/structure/retail/occult/proc/find_archivists()
	var/list/archivists = list()
	for(var/mob/living/carbon/human/human_user in GLOB.human_list)
		if(istype(human_user.mind?.assigned_role, /datum/job/vampire/archivist))
			archivists += human_user
	return archivists

// Non-Chantry non-Camarilla Tremeres, when spending their research points, give 30% of their purchase to the Regent, or distributed among all archivists
/obj/structure/retail/occult/proc/distribute_research_points(amount, purchaser_name, item_name)
	var/tribute_amount = round(amount * 0.3)
	var/mob/living/carbon/human/regent = find_regent()

	if(regent)
		regent.research_points += tribute_amount
		to_chat(regent, span_notice("The Archives channel [tribute_amount] research points to you from [purchaser_name]'s purchase of [item_name]."))
		return

	var/list/archivists = find_archivists()
	if(archivists.len > 0)
		var/points_per_archivist = round(tribute_amount / archivists.len)
		var/remaining_points = tribute_amount - (points_per_archivist * archivists.len)

		for(var/mob/living/carbon/human/archivist in archivists)
			var/points_to_give = points_per_archivist
			if(remaining_points > 0)
				points_to_give++
				remaining_points--
			archivist.research_points += points_to_give
			to_chat(archivist, span_notice("The Archives distribute [points_to_give] research points to you from [purchaser_name]'s purchase of [item_name]."))

/obj/structure/retail/occult/proc/increment_stock(item_path)
	for(var/datum/data/vending_product/prize in products_list)
		if(prize.product_path == item_path)
			prize.amount = min(prize.amount + 1, prize.max_amount)
			return

// SpellbookVendor.jsx in tgui/interfaces
/obj/structure/retail/occult/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpellbookVendor", name)
		ui.open()

/obj/structure/retail/occult/ui_data(mob/user)
	. = list()
	.["user"] = list()
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		.["user"]["points"] = human_user.research_points
		.["user"]["name"] = "[human_user.real_name]"
		.["user"]["job"] = "[human_user.mind?.assigned_role.title]"
		.["user"]["has_thaumaturgy"] = !!human_user.get_discipline(/datum/discipline/thaumaturgy)
		.["user"]["has_necromancy"] = !!human_user.get_discipline(/datum/discipline/necromancy)
		.["user"]["is_regent"] = istype(human_user.mind?.assigned_role, /datum/job/vampire/regent)
		.["user"]["has_privileges"] = has_purchase_privileges(human_user.mind?.assigned_role)
	else
		.["user"]["points"] = 0
		.["user"]["name"] = "Unknown"
		.["user"]["job"] = "Unknown"
		.["user"]["has_thaumaturgy"] = FALSE
		.["user"]["has_necromancy"] = FALSE
		.["user"]["is_regent"] = FALSE
		.["user"]["has_privileges"] = FALSE

	.["tremere_members"] = list()
	for(var/mob/living/carbon/human/tremere_member in GLOB.human_list)
		if(!tremere_member.mind)
			continue
		var/datum/job/role = tremere_member.mind.assigned_role
		if(is_type_in_list(role, list(/datum/job/vampire/archivist, /datum/job/vampire/gargoyle, /datum/job/vampire/regent)))
			.["tremere_members"] += list(list(
				"name" = tremere_member.real_name,
				"role" = role.title,
				"points" = tremere_member.research_points,
				"ref" = "\ref[tremere_member]"
			))


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

/obj/structure/retail/occult/ui_act(action, params)
	if(action == "transfer_points")
		return handle_point_transfer(action, params)
	if(action == "seize_points")
		return handle_point_seizure(action, params)
	if(action != "purchase")
		return ..()

	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/human_user = usr

	if(!get_kindred_splat(usr))
		return

	var/datum/data/vending_product/prize = locate(params["ref"]) in products_list
	var/current_stock = prize.amount
	if(current_stock <= 0)
		to_chat(usr, span_alert("Error: [prize.name] is out of stock!"))
		return

	if(prize.price > human_user.research_points)
		to_chat(usr, span_alert("Error: Insufficient research points for [prize.name]! You need [prize.price] research points."))
		return

	human_user.research_points -= prize.price

	// Check if user is loyal to the chantry/camarilla - if not, award 30% tribute to leadership
	var/datum/job/user_role = human_user.mind?.assigned_role
	var/has_privileges = has_purchase_privileges(user_role)

	if(!has_privileges)
		distribute_research_points(prize.price, human_user.real_name, prize.name)
		to_chat(usr, span_notice("A portion of your research points flow through the Archives to the Chantry leadership as tribute."))

	prize.amount -= 1

	to_chat(usr, span_notice("The Archives emanate dark energy as it dispenses [prize.name]!"))
	new prize.product_path(loc)
	return TRUE

//transfer research points
/obj/structure/retail/occult/proc/handle_point_transfer(action, params)
	if(!ishuman(usr))
		return FALSE

	var/mob/living/carbon/human/sender = usr
	var/target_ref = params["target_ref"]
	var/amount = text2num(params["amount"])

	if(!target_ref || !amount || amount <= 0)
		to_chat(sender, span_alert("Error: Invalid transfer parameters!"))
		return FALSE

	if(amount > sender.research_points)
		to_chat(sender, span_alert("You don't have enough research points!"))
		return FALSE

	var/mob/living/carbon/human/target = locate(target_ref)

	sender.research_points -= amount
	target.research_points += amount

	to_chat(sender, span_notice("You transfer [amount] research points to [target.real_name] through the Archives' dark conduits."))
	to_chat(target, span_notice("The Archives whisper to you... [sender.real_name] has sent you [amount] research points."))

	return TRUE

//research point seizure
/obj/structure/retail/occult/proc/handle_point_seizure(action, params)
	if(!ishuman(usr))
		return FALSE

	var/mob/living/carbon/human/regent = usr

	if(!istype(regent.mind?.assigned_role, /datum/job/vampire/regent))
		to_chat(regent, span_alert("Only the Regent may exercise such authority!"))
		return FALSE

	var/target_ref = params["target_ref"]
	var/amount = text2num(params["amount"])

	if(!target_ref || !amount || amount <= 0)
		to_chat(regent, span_alert("Error: Invalid seizure parameters!"))
		return FALSE

	var/mob/living/carbon/human/target = locate(target_ref)

	var/actual_amount = min(amount, target.research_points)

	if(actual_amount <= 0)
		to_chat(regent, span_alert("Target has no research points to seize!"))
		return FALSE

	target.research_points -= actual_amount
	regent.research_points += actual_amount

	to_chat(regent, span_notice("By your authority as Regent, you seize [actual_amount] research points from [target.real_name] through the Archives."))
	to_chat(target, span_warning("The Archives grow cold... Regent [regent.real_name] has seized [actual_amount] of your research points by right of authority."))

	return TRUE

//offer artifacts to the shop for research points AND increment stock
/obj/structure/retail/occult/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(istype(tool, /obj/item/occult_artifact))
		var/obj/item/occult_artifact/artifact = tool

		if(!ishuman(user))
			return ITEM_INTERACT_BLOCKING

		var/mob/living/carbon/human/human_user = user

		if(artifact.research_value <= 0)
			to_chat(user, span_warning("The Archives find no value in this artifact."))
			return ITEM_INTERACT_BLOCKING

		human_user.research_points += artifact.research_value

		increment_stock(artifact.type)

		//when donating an artifact, increase stock of a random spellbook
		increment_stock(pick(
			/obj/item/path_spellbook/lure_of_flames/level1,
			/obj/item/path_spellbook/lure_of_flames/level2,
			/obj/item/path_spellbook/lure_of_flames/level3,
			/obj/item/path_spellbook/lure_of_flames/level4,
			/obj/item/path_spellbook/lure_of_flames/level5,
			/obj/item/path_spellbook/levinbolt/level1,
			/obj/item/path_spellbook/levinbolt/level2,
			/obj/item/path_spellbook/levinbolt/level3,
			/obj/item/path_spellbook/levinbolt/level4,
			/obj/item/path_spellbook/levinbolt/level5))

		if(artifact.research_value >= 20)
			to_chat(user, span_nicegreen("The Archives hungrily consume the powerful artifact, granting you [artifact.research_value] research points and adding it to their collection!"))
		else if(artifact.research_value >= 10)
			to_chat(user, span_notice("The Archives absorb the artifact's essence, granting you [artifact.research_value] research points and cataloging its knowledge."))
		else
			to_chat(user, span_notice("The Archives reluctantly accept the minor artifact, granting you [artifact.research_value] research points and filing it away."))

		qdel(artifact)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/path_spellbook))
		var/obj/item/path_spellbook/spellbook = tool

		if(!ishuman(user))
			return ITEM_INTERACT_BLOCKING

		var/mob/living/carbon/human/human_user = user

		var/research_reward = 5 // base reward modified by spellbook
		human_user.research_points += research_reward

		increment_stock(spellbook.type)

		to_chat(user, span_notice("The Archives accept your spellbook, granting you [research_reward] research points and adding its knowledge to the collection."))

		qdel(spellbook)
		return ITEM_INTERACT_SUCCESS


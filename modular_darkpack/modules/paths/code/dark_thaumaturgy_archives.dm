/obj/structure/retail/occult/baali
	icon = 'modular_darkpack/modules/deprecated/icons/64x64.dmi'
	icon_state = "baali"
	pixel_w = -16
	pixel_z = -16
	owner_needed = FALSE
	desc = "Use your demonic knowledge to ask for favors of Infernal."

	products_list = list(
	// SPELLBOOKS
	new /datum/data/vending_product("Path of Pain Spellbook (Level I)",	/obj/item/path_spellbook/path_of_pain/level1,	130),
	new /datum/data/vending_product("Path of Pain Spellbook (Level II)",	/obj/item/path_spellbook/path_of_pain/level2,	180),
	new /datum/data/vending_product("Path of Pain Spellbook (Level III)",	/obj/item/path_spellbook/path_of_pain/level3,	210),
	new /datum/data/vending_product("Path of Pain Spellbook (Level IV)",	/obj/item/path_spellbook/path_of_pain/level4,	240),
	new /datum/data/vending_product("Path of Pain Spellbook (Level V)",	/obj/item/path_spellbook/path_of_pain/level5,	270),

	new /datum/data/vending_product("Fires of Inferno Spellbook (Level I)",	/obj/item/path_spellbook/fires_of_inferno/level1,	130),
	new /datum/data/vending_product("Fires of Inferno Spellbook (Level II)",	/obj/item/path_spellbook/fires_of_inferno/level2,	180),
	new /datum/data/vending_product("Fires of Inferno Spellbook (Level III)",	/obj/item/path_spellbook/fires_of_inferno/level3,	210),
	new /datum/data/vending_product("Fires of Inferno Spellbook (Level IV)",	/obj/item/path_spellbook/fires_of_inferno/level4,	240),
	new /datum/data/vending_product("Fires of Inferno Spellbook (Level V)",	/obj/item/path_spellbook/fires_of_inferno/level5, 270),

	new /datum/data/vending_product("Taking of Spirit Spellbook (Level I)",	/obj/item/path_spellbook/taking_of_spirit/level1,	130),
	new /datum/data/vending_product("Taking of Spirit Spellbook (Level II)",	/obj/item/path_spellbook/taking_of_spirit/level2,	180),
	new /datum/data/vending_product("Taking of Spirit Spellbook (Level III)",	/obj/item/path_spellbook/taking_of_spirit/level3,	210),
	new /datum/data/vending_product("Taking of Spirit Spellbook (Level IV)",	/obj/item/path_spellbook/taking_of_spirit/level4,	240),
	new /datum/data/vending_product("Taking of Spirit Spellbook (Level V)",	/obj/item/path_spellbook/taking_of_spirit/level5, 270),

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

// are they antitribu?
/obj/structure/retail/occult/baali/has_purchase_privileges(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		return human_user.get_discipline(/datum/discipline/dark_thaumaturgy)

/obj/structure/retail/occult/baali/proc/calculate_favor(mob/living/carbon/human/sacrificed)
	if(get_kindred_splat(sacrificed))
		return (GHOUL_GENERATION - sacrificed.get_generation()) * 5
	if(get_garou_splat(sacrificed) || get_corax_splat(sacrificed))
		return 30
	if(get_ghoul_splat(sacrificed))
		return 5
	return 3

/obj/structure/retail/occult/baali/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(can_shop(user))
		var/sacrifice = FALSE
		if(ishuman(user))
			var/mob/living/carbon/human/human_user = user
			for(var/mob/living/carbon/human/sacrificed_human in get_turf(src))
				if(sacrificed_human.stat != DEAD)
					continue
				human_user.infernal_favor += calculate_favor(sacrificed_human)
				sacrificed_human.gib(DROP_ALL_REMAINS)
				sacrifice = TRUE
		if(sacrifice)
			playsound(get_turf(src), 'sound/effects/magic/demon_dies.ogg', 100, TRUE)
			animate(src, color = initial(color), time = 0.5 SECONDS)
			addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 0.5 SECONDS)
		else
			ui_interact(user)

// BaaliSpellbookVendor.jsx in tgui/interfaces
/obj/structure/retail/occult/baali/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BaaliSpellbookVendor", name)
		ui.open()

/obj/structure/retail/occult/baali/ui_data(mob/user)
	. = list()
	.["user"] = list()
	if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		.["user"]["points"] = human_user.infernal_favor
		.["user"]["name"] = "[human_user.real_name]"
		.["user"]["has_dark_thaumaturgy"] = !!human_user.get_discipline(/datum/discipline/dark_thaumaturgy)
		.["user"]["has_privileges"] = has_purchase_privileges(human_user)
	else
		.["user"]["points"] = 0
		.["user"]["name"] = "Unknown"
		.["user"]["has_dark_thaumaturgy"] = FALSE
		.["user"]["has_privileges"] = FALSE

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

/obj/structure/retail/occult/baali/ui_act(action, params)
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

	if(prize.price > human_user.infernal_favor)
		to_chat(usr, span_alert("Error: Insufficient amount of favor for [prize.name]! You need [prize.price] favor."))
		return

	human_user.infernal_favor -= prize.price

	prize.amount -= 1

	to_chat(usr, span_notice("The infernal rune emanates demonic energies as it materializes [prize.name]!"))
	new prize.product_path(loc)
	return TRUE

//offer artifacts to the shop for research points AND increment stock
/obj/structure/retail/occult/baali/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(istype(tool, /obj/item/occult_artifact))
		var/obj/item/occult_artifact/artifact = tool

		if(!ishuman(user))
			return ITEM_INTERACT_BLOCKING

		var/mob/living/carbon/human/human_user = user

		if(artifact.research_value <= 0)
			to_chat(user, span_warning("The Infernal find no value in this artifact."))
			return ITEM_INTERACT_BLOCKING

		human_user.infernal_favor += artifact.research_value

		increment_stock(artifact.type)

		//when donating an artifact, increase stock of a random spellbook
		increment_stock(pick(
			/obj/item/path_spellbook/path_of_pain/level1,
			/obj/item/path_spellbook/path_of_pain/level2,
			/obj/item/path_spellbook/path_of_pain/level3,
			/obj/item/path_spellbook/path_of_pain/level4,
			/obj/item/path_spellbook/path_of_pain/level5,
			/obj/item/path_spellbook/fires_of_inferno/level1,
			/obj/item/path_spellbook/fires_of_inferno/level2,
			/obj/item/path_spellbook/fires_of_inferno/level3,
			/obj/item/path_spellbook/fires_of_inferno/level4,
			/obj/item/path_spellbook/fires_of_inferno/level5,
			/obj/item/path_spellbook/taking_of_spirit/level1,
			/obj/item/path_spellbook/taking_of_spirit/level2,
			/obj/item/path_spellbook/taking_of_spirit/level3,
			/obj/item/path_spellbook/taking_of_spirit/level4,
			/obj/item/path_spellbook/taking_of_spirit/level5))

		if(artifact.research_value >= 20)
			to_chat(user, span_nicegreen("The Infernal hungrily consume the powerful artifact, granting you [artifact.research_value] favor and adding it to their collection!"))
		else if(artifact.research_value >= 10)
			to_chat(user, span_notice("The Infernal absorb the artifact's essence, granting you [artifact.research_value] favor and storing its knowledge."))
		else
			to_chat(user, span_notice("The Infernal reluctantly accept the minor artifact, granting you [artifact.research_value] favor and filing it away."))

		qdel(artifact)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/path_spellbook))
		var/obj/item/path_spellbook/spellbook = tool

		if(!ishuman(user))
			return ITEM_INTERACT_BLOCKING

		var/mob/living/carbon/human/human_user = user

		var/research_reward = 5 // base reward modified by spellbook
		human_user.infernal_favor += research_reward

		increment_stock(spellbook.type)

		to_chat(user, span_notice("The Infernal accept your spellbook, granting you [research_reward] favor and adding its knowledge to the collection."))

		qdel(spellbook)
		return ITEM_INTERACT_SUCCESS

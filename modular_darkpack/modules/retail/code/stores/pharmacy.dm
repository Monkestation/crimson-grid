/obj/structure/retail/pharmacy
	product_types = list(
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/ointment,
		/obj/item/stack/medical/wrap/gauze,
		/obj/item/stack/medical/suture,
		/obj/item/stack/medical/mesh,
	)
	products_list = list(
		new /datum/data/vending_product("potassium iodide pill bottle", /obj/item/storage/pill_bottle/potassiodide),
		new /datum/data/vending_product("latex gloves", /obj/item/clothing/gloves/vampire/latex, 150),
		new /datum/data/vending_product("iron pill bottle", /obj/item/storage/pill_bottle/iron, 150),
		new /datum/data/vending_product("inhaler canister", /obj/item/reagent_containers/inhaler_canister/albuterol/asthma, 150),
		new /datum/data/vending_product("ephedrine pill bottle", /obj/item/storage/pill_bottle/ephedrine),
		new /datum/data/vending_product("box of syringes", /obj/item/storage/box/syringes, 300),
		new /datum/data/vending_product("inhaler", /obj/item/inhaler/albuterol/asthma, 400)
	)

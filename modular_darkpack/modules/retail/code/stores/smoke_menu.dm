// Use /obj/structure/retail/gas_station unless you really only want smokes
/obj/structure/retail/smoke_menu
	products_list = list(
		new /datum/data/vending_product("malboro", /obj/item/storage/fancy/cigarettes/cigpack_robust, 50),
		new /datum/data/vending_product("newport", /obj/item/storage/fancy/cigarettes/cigpack_xeno, 30),
		new /datum/data/vending_product("camel", /obj/item/storage/fancy/cigarettes/dromedaryco, 30),
		new /datum/data/vending_product("rolling paper", /obj/item/rollingpaper, 10),
		new /datum/data/vending_product("\"Vase\"", /obj/item/bong, 50),
		new /datum/data/vending_product("zippo lighter", /obj/item/lighter, 20),
		new /datum/data/vending_product("lighter", /obj/item/lighter/greyscale, 10)
	)

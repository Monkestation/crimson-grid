// Use /obj/structure/retail/gas_station unless you really only want smokes
/obj/structure/retail/smoke_menu
	products_list = list(
		new /datum/data/vending_product("malboro", /obj/item/storage/fancy/cigarettes/cigpack_robust, 50),
		new /datum/data/vending_product("malboro gold", /obj/item/storage/fancy/cigarettes/cigpack_robustgold),
		new /datum/data/vending_product("newport", /obj/item/storage/fancy/cigarettes/cigpack_xeno, 30),
		new /datum/data/vending_product("camel", /obj/item/storage/fancy/cigarettes/dromedaryco, 30),
		new /datum/data/vending_product("premium cigar case", /obj/item/storage/fancy/cigarettes/cigars),
		new /datum/data/vending_product("premium Cohiba Robusto cigar case", /obj/item/storage/fancy/cigarettes/cigars/cohiba),
		new /datum/data/vending_product("premium Havanian cigar case", /obj/item/storage/fancy/cigarettes/cigars/havana),
		new /datum/data/vending_product("rolling paper", /obj/item/rollingpaper, 10),
		// CRIMSON EDIT ADD START - vapes!! why cant i buy vapes from the smoke store?!!
		new /datum/data/vending_product("vape", /obj/item/vape, 150),
		new /datum/data/vending_product("red vape", /obj/item/vape/red, 170), // special colors are gonna cost ya more
		new /datum/data/vending_product("blue vape", /obj/item/vape/blue, 170),
		new /datum/data/vending_product("purple vape", /obj/item/vape/purple, 170),
		new /datum/data/vending_product("green vape", /obj/item/vape/green, 170),
		new /datum/data/vending_product("yellow vape", /obj/item/vape/yellow, 170),
		new /datum/data/vending_product("orange vape", /obj/item/vape/orange, 170), // Ja- ORANGE!
		new /datum/data/vending_product("black vape", /obj/item/vape/black, 170),
		new /datum/data/vending_product("white vape", /obj/item/vape/white, 170),
		// CRIMSON EDIT ADD END
		new /datum/data/vending_product("\"Vase\"", /obj/item/bong, 50),
		new /datum/data/vending_product("zippo lighter", /obj/item/lighter, 20),
		new /datum/data/vending_product("lighter", /obj/item/lighter/greyscale, 10),
		new /datum/data/vending_product("matchbox",/obj/item/storage/box/matches),
		new /datum/data/vending_product("ashtray",/obj/item/storage/ashtray),
	)

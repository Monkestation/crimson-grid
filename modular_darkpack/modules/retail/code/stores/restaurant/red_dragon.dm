/obj/structure/retail/red_dragon_menu
	product_types = list(
		/obj/item/food/salad/eggbowl,
		/obj/item/food/salad/ricepork,
		/obj/item/food/onigiri,
		/obj/item/food/boiledrice,
		/obj/item/food/springroll,
		/obj/item/food/crab_rangoon,
		/obj/item/food/fortunecookie,
		/obj/item/reagent_containers/cup/glass/vampirecola,
		/obj/item/reagent_containers/cup/soda_cans/vampirecola
	)

// CRIMSON EDIT ADD START - Shop Inventories Additions
	products_list = list( //Added for prices
		new /datum/data/vending_product("dumpling", /obj/item/food/khinkali/dumpling, 2),
		new /datum/data/vending_product("chow mein", /obj/item/food/spaghetti/chowmein, 2),
		new /datum/data/vending_product("beef noodle", /obj/item/food/spaghetti/beefnoodle, 3),
		new /datum/data/vending_product("chicken noodle soup", /obj/item/food/bowled/chicken_noodle, 3),
		new /datum/data/vending_product("cup ramen", /obj/item/reagent_containers/cup/glass/dry_ramen, 2),
		new /datum/data/vending_product("rice beer", /obj/item/reagent_containers/cup/soda_cans/beer/rice, 3),
		new /datum/data/vending_product("jasmine tea", /obj/item/reagent_containers/cup/glass/mug/tea/jasmine, 2),
	)
// CRIMSON EDIT ADD END - Shop Inventories Additions

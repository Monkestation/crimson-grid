/obj/structure/retail/bacotell_menu
	product_types = list(
		/obj/item/food/taco,
		/obj/item/food/taco/plain,
		/obj/item/food/taco/fish,
		/obj/item/food/nachos,
		/obj/item/food/cheesynachos,
//		/obj/item/food/pizzaslice/square, // CRIMSON EDIT REMOVAL - Shop Inventories Additions
		/obj/item/reagent_containers/cup/glass/vampirecola,
		/obj/item/reagent_containers/cup/soda_cans/vampirecola,
		/obj/item/reagent_containers/cup/soda_cans/summer_thaw,
		/obj/item/reagent_containers/cup/soda_cans/thaw_club
	)
// CRIMSON EDIT ADD START - Shop Inventories Additions
	products_list = list( //Added for prices
		new /datum/data/vending_product("burrito", /obj/item/food/burrito, 3),
		new /datum/data/vending_product("cheesy burrito", /obj/item/food/cheesyburrito, 3),
		new /datum/data/vending_product("carne burrito", /obj/item/food/carneburrito, 4),
		new /datum/data/vending_product("fuego burrito", /obj/item/food/fuegoburrito, 4),
	)
// CRIMSON EDIT ADD END - Shop Inventories Additions

/obj/structure/retail/techshop
	desc = "A techshop for all your tech needs."
	owner_needed = FALSE
	products_list = list(
		new /datum/data/vending_product("prepaid cell phone", /obj/item/smartphone),
		new /datum/data/vending_product("home computer", /obj/machinery/computer/pc/unanchored, 1000),
		new /datum/data/vending_product("printer", /obj/machinery/pc_printer, 500),
		new /datum/data/vending_product("home server", /obj/item/flatpack/pc_server, 2000),
		new /datum/data/vending_product("multi purpose tool", /obj/item/multitool, 200),
		new /datum/data/vending_product("laptop", /obj/item/laptop, 1500),
		new /datum/data/vending_product("compact disc", /obj/item/pc_cd, 100),
	)

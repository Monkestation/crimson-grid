/obj/structure/retail/general
	desc = "A general store for general needs."
	products_list = list(
		new /datum/data/vending_product("damp cleaning rag", /obj/item/rag),
		new /datum/data/vending_product("cassette tapes", /obj/item/tape),
		new /datum/data/vending_product("flashlight", /obj/item/flashlight),
		new /datum/data/vending_product("cleaning mop", /obj/item/mop),
		new /datum/data/vending_product("plastic bucket", /obj/item/reagent_containers/cup/bucket),
		new /datum/data/vending_product("push broom", /obj/item/pushbroom),
		new /datum/data/vending_product("plastic trash bags", /obj/item/storage/bag/trash),
		new /datum/data/vending_product("screwdriver", /obj/item/screwdriver),
		new /datum/data/vending_product("crowbar", /obj/item/crowbar),
		new /datum/data/vending_product("wrench", /obj/item/wrench),
		new /datum/data/vending_product("wirecutters", /obj/item/wirecutters),
		new /datum/data/vending_product("handheld welder", /obj/item/weldingtool),
		new /datum/data/vending_product("toner cartridge", /obj/item/toner/large),
		new /datum/data/vending_product("construction hard hat", /obj/item/clothing/head/vampire/hardhat),
		new /datum/data/vending_product("shaving razor", /obj/item/razor),
		new /datum/data/vending_product("tape recorder", /obj/item/taperecorder),
		new /datum/data/vending_product("baseball bat", /obj/item/melee/baseball_bat/vamp),
		new /datum/data/vending_product("prepaid cell phone", /obj/item/smartphone),
		new /datum/data/vending_product("box of light bulbs", /obj/item/storage/box/lights/mixed, 100), // price is different between hardware and general store
		new /datum/data/vending_product("insulated gloves", /obj/item/clothing/gloves/color/yellow),
// CRIMSON EDIT ADD START - Shop Inventories Additions
		new /datum/data/vending_product("bruise pack", /obj/item/stack/medical/bruise_pack),
		new /datum/data/vending_product("coal", /obj/item/stack/sheet/mineral/coal, 10),
		new /datum/data/vending_product("cloth", /obj/item/stack/sheet/cloth, 5),
		new /datum/data/vending_product("door repair kit", /obj/item/door_repair_kit, 300),
		new /datum/data/vending_product("wooden plank", /obj/item/stack/sheet/mineral/wood, 10),
		new /datum/data/vending_product("iron sheet", /obj/item/stack/sheet/iron, 10),
		new /datum/data/vending_product("glass sheet", /obj/item/stack/sheet/glass, 10),
		new /datum/data/vending_product("plastic sheet", /obj/item/stack/sheet/plastic, 10),
		new /datum/data/vending_product("cardboard sheet", /obj/item/stack/sheet/cardboard, 10),
		new /datum/data/vending_product("iron rods", /obj/item/stack/rods/ten, 30),
		new /datum/data/vending_product("cable coil", /obj/item/stack/cable_coil/thirty, 30),
// CRIMSON EDIT ADD END - Shop Inventories Additions
	)

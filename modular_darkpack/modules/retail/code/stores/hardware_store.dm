/obj/structure/retail/hardware_store
	products_list = list(
		new /datum/data/vending_product("full gas can", /obj/item/gas_can/full),
		new /datum/data/vending_product("tire iron", /obj/item/melee/vamp/tire, 50),
		new /datum/data/vending_product("lockpick", /obj/item/vamp/keys/hack, 50),
		new /datum/data/vending_product("respirator", /obj/item/clothing/mask/gas/vampire),
		new /datum/data/vending_product("baseball bat", /obj/item/melee/baseball_bat/vamp, 200),
		new /datum/data/vending_product("knife", /obj/item/knife/vamp, 100),
		new /datum/data/vending_product("stake", /obj/item/vampire_stake, 100),
		new /datum/data/vending_product("scythe", /obj/item/scythe/vamp, 2000),
		new /datum/data/vending_product("shovel", /obj/item/shovel/vamp, 800),
		new /datum/data/vending_product("box of light bulbs", /obj/item/storage/box/lights/mixed, 80),
// CRIMSON EDIT ADD START - Shop Inventories Additions
		new /datum/data/vending_product("door repair kit", /obj/item/door_repair_kit, 300),
		new /datum/data/vending_product("wooden plank", /obj/item/stack/sheet/mineral/wood, 10),
		new /datum/data/vending_product("iron sheet", /obj/item/stack/sheet/iron, 10),
		new /datum/data/vending_product("glass sheet", /obj/item/stack/sheet/glass, 10),
		new /datum/data/vending_product("plastic sheet", /obj/item/stack/sheet/plastic, 10),
		new /datum/data/vending_product("cardboard sheet", /obj/item/stack/sheet/cardboard, 10),
		new /datum/data/vending_product("iron rods", /obj/item/stack/rods/ten, 30),
		new /datum/data/vending_product("cable coil", /obj/item/stack/cable_coil/thirty, 30),
		new /datum/data/vending_product("carpet", /obj/item/stack/tile/carpet/fifty, 100),
		new /datum/data/vending_product("black carpet", /obj/item/stack/tile/carpet/black/fifty, 100),
		new /datum/data/vending_product("blue carpet", /obj/item/stack/tile/carpet/blue/fifty, 100),
		new /datum/data/vending_product("cyan carpet", /obj/item/stack/tile/carpet/cyan/fifty, 100),
		new /datum/data/vending_product("green carpet", /obj/item/stack/tile/carpet/green/fifty, 100),
		new /datum/data/vending_product("orange carpet", /obj/item/stack/tile/carpet/orange/fifty, 100),
		new /datum/data/vending_product("purple carpet", /obj/item/stack/tile/carpet/purple/fifty, 100),
		new /datum/data/vending_product("red carpet", /obj/item/stack/tile/carpet/red/fifty, 100),
		new /datum/data/vending_product("royal black carpet", /obj/item/stack/tile/carpet/royalblack/fifty, 100),
		new /datum/data/vending_product("royal blue carpet", /obj/item/stack/tile/carpet/royalblue/fifty, 100),
		new /datum/data/vending_product("executive carpet", /obj/item/stack/tile/carpet/executive/thirty, 75),
		new /datum/data/vending_product("stellar carpet", /obj/item/stack/tile/carpet/stellar/thirty, 75),
		new /datum/data/vending_product("neon carpet", /obj/item/stack/tile/carpet/neon/thirty, 75),
// CRIMSON EDIT ADD END - Shop Inventories Additions
		new /datum/data/vending_product("construction vest", /obj/item/clothing/suit/hazardvest, 80)
	)
	product_types = list(
		/obj/item/fishing_rod,
		/obj/item/storage/toolbox/fishing,
		/obj/item/storage/box/fishing_lures
	)

/obj/structure/retail/antique
	desc = "A store where antique weapons are sold. Fedoras not included."
	products_list = list(
		new /datum/data/vending_product("katana", /obj/item/katana/vamp),
		new /datum/data/vending_product("rapier", /obj/item/storage/belt/sheath/vamp/rapier),
		new /datum/data/vending_product("spear", /obj/item/darkpack/spear),
		new /datum/data/vending_product("sabre", /obj/item/storage/belt/sheath/vamp/sabre),
		new /datum/data/vending_product("longsword", /obj/item/storage/belt/sheath/vamp/sword),
		// Crimson Grid Addition - Knight Armor
		new /datum/data/vending_product("Plate Armor (Green)", /obj/item/clothing/suit/armor/riot/knight, 2500),
		new /datum/data/vending_product("Plate Helmet (Green)", /obj/item/clothing/head/helmet/knight, 500),
		new /datum/data/vending_product("Plate Armor (Blue)", /obj/item/clothing/suit/armor/riot/knight/blue, 2500),
		new /datum/data/vending_product("Plate Helmet (Blue)", /obj/item/clothing/head/helmet/knight/blue, 500),
		new /datum/data/vending_product("Plate Armor (Yellow)", /obj/item/clothing/suit/armor/riot/knight/yellow, 2500),
		new /datum/data/vending_product("Plate Helmet (Yellow)", /obj/item/clothing/head/helmet/knight/yellow, 500),
		new /datum/data/vending_product("Plate Armor (Red)", /obj/item/clothing/suit/armor/riot/knight/red, 2500),
		new /datum/data/vending_product("Plate Helmet (Red)", /obj/item/clothing/head/helmet/knight/red, 500)
		// Crimson Grid Addition End - Knight Armor
	)

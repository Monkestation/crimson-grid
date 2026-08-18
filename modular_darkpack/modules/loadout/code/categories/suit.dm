/datum/loadout_category/suits
	category_name = "Outerwear"
	category_ui_icon = FA_ICON_USER_SECRET
	type_to_generate = /datum/loadout_item/suit
	tab_order = /datum/loadout_category/head::tab_order + 10

/*
/datum/loadout_item/suit
	abstract_type = /datum/loadout_item/suit

/datum/loadout_item/suit/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only, loadout_placement_preference)
	if(outfit.suit)
		LAZYADD(outfit.backpack_contents, outfit.suit)
	outfit.suit = item_path
*/

// Coats
/datum/loadout_item/suit/coat
	abstract_type = /datum/loadout_item/suit/coat

/datum/loadout_item/suit/coat/slickbackcoat
	name = "Coat (Purple Fur)"
	item_path = /obj/item/clothing/suit/vampire/slickbackcoat

/datum/loadout_item/suit/coat/labcoat
	name = "Labcoat"
	item_path = /obj/item/clothing/suit/vampire/labcoat

/datum/loadout_item/suit/coat/brown
	name = "Coat (Brown)"
	item_path = /obj/item/clothing/suit/vampire/coat

/datum/loadout_item/suit/coat/green
	name = "Coat (Green)"
	item_path = /obj/item/clothing/suit/vampire/coat/alt

/datum/loadout_item/suit/coat/black
	name = "Coat (Black)"
	item_path = /obj/item/clothing/suit/vampire/coat/winter

/datum/loadout_item/suit/coat/red
	name = "Coat (Red)"
	item_path = /obj/item/clothing/suit/vampire/coat/winter/alt

/datum/loadout_item/suit/coat/leopardcoat
	item_path = /obj/item/clothing/suit/vampire/coat/leopard

// Jackets
/datum/loadout_item/suit/jacket
	abstract_type = /datum/loadout_item/suit/jacket

/datum/loadout_item/suit/jacket/majima_jacket
	name = "Fancy Jacket (Majima)"
	item_path = /obj/item/clothing/suit/vampire/majima_jacket

/datum/loadout_item/suit/jacket/fancy_gray
	name = "Fancy Jacket (Gray)"
	item_path = /obj/item/clothing/suit/vampire/fancy_gray

/datum/loadout_item/suit/jacket/fancy_red
	name = "Fancy Jacket (Red)"
	item_path = /obj/item/clothing/suit/vampire/fancy_red

/datum/loadout_item/suit/jacket/black_leather
	name = "Leather Jacket"
	item_path = /obj/item/clothing/suit/vampire/jacket

/datum/loadout_item/suit/jacket/military
	name = "Jacket (Military)"
	item_path = /obj/item/clothing/suit/jacket/miljacket

/datum/loadout_item/suit/jacket/black_suit
	name = "Jacket (Black Suit)"
	item_path = /obj/item/clothing/suit/toggle/lawyer/black

/datum/loadout_item/suit/jacket/bomber_classic
	name = "Classic Bomber Jacket"
	item_path = /obj/item/clothing/suit/vampire/bomber_jacket_classic

/datum/loadout_item/suit/jacket/bomber_gray
	name = "Gray Bomber Jacket"
	item_path = /obj/item/clothing/suit/vampire/bomber_jacket_gray

// Trenchcoats
/datum/loadout_item/suit/trenchcoat
	abstract_type = /datum/loadout_item/suit/trenchcoat

/datum/loadout_item/suit/trenchcoat/black
	name = "Trenchcoat (Black)"
	item_path = /obj/item/clothing/suit/vampire/trench

/datum/loadout_item/suit/trenchcoat/brown
	name = "Trenchcoat (Brown)"
	item_path = /obj/item/clothing/suit/vampire/trench/alt

/datum/loadout_item/suit/trenchcoat/burgundy
	name = "Trenchcoat (Burgundy)"
	item_path = /obj/item/clothing/suit/vampire/trench/archive

// Hoodies
/datum/loadout_item/suit/hoodie
	item_path = /obj/item/clothing/suit/hooded/hoodie

/datum/loadout_item/suit/hoodiezim
	item_path = /obj/item/clothing/suit/hooded/hoodie/hoodie_pim

// Misc
/datum/loadout_item/suit/kasaya
	name = "Kasaya"
	item_path = /obj/item/clothing/suit/vampire/kasaya

/datum/loadout_item/suit/imam
	name = "Imam Robe"
	item_path = /obj/item/clothing/suit/vampire/imam

/datum/loadout_item/suit/orthodox
	name = "Orthodox Robe"
	item_path = /obj/item/clothing/suit/vampire/orthodox

/datum/loadout_item/suit/letterman_red
	name = "Letterman (Red)"
	item_path = /obj/item/clothing/suit/jacket/letterman_syndie

// Robes
/datum/loadout_item/suit/robes
	abstract_type = /datum/loadout_item/suit/robes

/datum/loadout_item/suit/robes/white
	name = "Robes (White)"
	item_path = /obj/item/clothing/suit/hooded/robes

/datum/loadout_item/suit/robes/black
	name = "Robes (Black)"
	item_path = /obj/item/clothing/suit/hooded/robes/black

/datum/loadout_item/suit/robes/grey
	name = "Robes (Grey)"
	item_path = /obj/item/clothing/suit/hooded/robes/grey

/datum/loadout_item/suit/robes/darkred
	name = "Robes (Dark Red)"
	item_path = /obj/item/clothing/suit/hooded/robes/darkred

/datum/loadout_item/suit/robes/yellow
	name = "Robes (Yellow)"
	item_path = /obj/item/clothing/suit/hooded/robes/yellow

/datum/loadout_item/suit/robes/green
	name = "Robes (Green)"
	item_path = /obj/item/clothing/suit/hooded/robes/green

/datum/loadout_item/suit/robes/Red
	name = "Robes (Red)"
	item_path = /obj/item/clothing/suit/hooded/robes/red

/datum/loadout_item/suit/robes/purple
	name = "Robes (Purple)"
	item_path = /obj/item/clothing/suit/hooded/robes/purple

/datum/loadout_item/suit/robes/blue
	name = "Robes (Blue)"
	item_path = /obj/item/clothing/suit/hooded/robes/blue


/// Shawls
/datum/loadout_item/suit/shawl
	abstract_type = /datum/loadout_item/suit/shawl

/datum/loadout_item/suit/shawl/black
	name = "Black Shawl"
	item_path = /obj/item/clothing/suit/vampire/shawl_black

/datum/loadout_item/suit/shawl/white
	name = "White Shawl"
	item_path = /obj/item/clothing/suit/vampire/shawl_white

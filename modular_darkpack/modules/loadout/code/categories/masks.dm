/datum/loadout_category/mask
	category_name = "Masks"
	category_ui_icon = FA_ICON_MASK
	type_to_generate = /datum/loadout_item/mask
	tab_order = /datum/loadout_category/head::tab_order + 4

/datum/loadout_item/mask
	abstract_type = /datum/loadout_item/mask

/datum/loadout_item/mask/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(outfit.mask)
		LAZYADD(outfit.backpack_contents, outfit.mask)
	outfit.mask = item_path

/datum/loadout_item/mask/work
	group = "Profession Masks"
	abstract_type = /datum/loadout_item/mask/work

/datum/loadout_item/mask/work/balaclava
	name = "Balaclava"
	item_path = /obj/item/clothing/mask/vampire/balaclava

/datum/loadout_item/mask/work/respirator
	name = "Respirator Mask"
	item_path = /obj/item/clothing/mask/gas/vampire

/datum/loadout_item/mask/work/lucha
	name = "Gold Luchador Mask"
	item_path = /obj/item/clothing/mask/luchador

/datum/loadout_item/mask/work/lucha/green
	name = "Green Luchador Mask"
	item_path = /obj/item/clothing/mask/luchador/tecnicos

/datum/loadout_item/mask/work/lucha/Red
	name = "Red Luchador Mask"
	item_path = /obj/item/clothing/mask/luchador/rudos

/datum/loadout_item/mask/work/shemagh
	name = "Shemagh"
	item_path = /obj/item/clothing/mask/vampire/shemagh

/datum/loadout_item/mask/work/surgical
	name = "Sterile Mask"
	item_path = /obj/item/clothing/mask/surgical

//Animal Masks
/datum/loadout_item/mask/animal
	group = "Animal Masks"
	abstract_type = /datum/loadout_item/mask/animal

/datum/loadout_item/mask/animal/policeofficer
	name = "Pig Mask"
	item_path = /obj/item/clothing/mask/animal/pig

/datum/loadout_item/mask/animal/frog
	name = "Frog Mask"
	item_path = /obj/item/clothing/mask/animal/frog

/datum/loadout_item/mask/animal/cow
	name = "Cow Mask"
	item_path = /obj/item/clothing/mask/animal/cowmask

/datum/loadout_item/mask/animal/honse
	name = "Horse Mask"
	item_path = /obj/item/clothing/mask/animal/horsehead

/datum/loadout_item/mask/animal/rat
	name = "Rat Mask"
	item_path = /obj/item/clothing/mask/animal/small/rat

/datum/loadout_item/mask/animal/fox
	name = "Fox Mask"
	item_path = /obj/item/clothing/mask/animal/small/fox

/datum/loadout_item/mask/animal/kitsune
	name = "Kistune Mask"
	item_path = /obj/item/clothing/mask/kitsune

/datum/loadout_item/mask/animal/bee
	name = "Bee Mask"
	item_path = /obj/item/clothing/mask/animal/small/bee

/datum/loadout_item/mask/animal/bear
	name = "Bear Mask"
	item_path = /obj/item/clothing/mask/animal/small/bear

/datum/loadout_item/mask/animal/man //Is he stupid?
	name = "Bat Mask"
	item_path = /obj/item/clothing/mask/animal/small/bat

/datum/loadout_item/mask/animal/raven
	name = "Raven Mask"
	item_path = /obj/item/clothing/mask/animal/small/raven

/datum/loadout_item/mask/animal/jackal
	name = "Jackal Mask"
	item_path = /obj/item/clothing/mask/animal/small/jackal

//Fancy dress masks that aren't costumes.

/datum/loadout_item/mask/fancy
	group = "Masquerade Masks"
	abstract_type = /datum/loadout_item/mask/fancy

/datum/loadout_item/mask/fancy/tragedy
	name = "Tragedy Mask"
	item_path = /obj/item/clothing/mask/vampire/tragedy

/datum/loadout_item/mask/fancy/comedy
	name = "Comedy Mask"
	item_path = /obj/item/clothing/mask/vampire/comedy

/datum/loadout_item/mask/fancy/venetian
	name = "Venetian Mask"
	item_path = /obj/item/clothing/mask/vampire/venetian_mask

/datum/loadout_item/mask/fancy/venetian/fancy
	name = "Fancy Venetian Mask"
	item_path = /obj/item/clothing/mask/vampire/venetian_mask/fancy

/datum/loadout_item/mask/fancy/venetian/jester
	name = "Jester Mask"
	item_path = /obj/item/clothing/mask/vampire/venetian_mask/jester

/datum/loadout_item/mask/fancy/venetian/bloody
	name = "Bloody Venetian Mask"
	item_path = /obj/item/clothing/mask/vampire/venetian_mask/scary

//Fancy dress masks that ARE costumes!

/datum/loadout_item/mask/costume
	group = "Fancy Dress Masks"
	abstract_type = /datum/loadout_item/mask/costume

/datum/loadout_item/mask/costume/scarecrow
	name = "Scarecrow Mask"
	item_path = /obj/item/clothing/mask/scarecrow

/datum/loadout_item/mask/costume/mummy
	name = "Mummy Mask"
	item_path = /obj/item/clothing/mask/mummy

// Bandanas
/datum/loadout_item/mask/bandana
	group = "Bandanas"
	abstract_type = /datum/loadout_item/mask/bandana

/datum/loadout_item/mask/bandana/normal_greyscale
	name = "Bandana (Colorable)"
	item_path = /obj/item/clothing/mask/bandana/vampire

/datum/loadout_item/mask/bandana/striped_greyscale
	name = "Bandana (Colorable, Striped)"
	item_path = /obj/item/clothing/mask/bandana/striped/vampire

/datum/loadout_item/mask/bandana/skull_greyscale
	name = "Bandana (Colorable, Skull)"
	item_path = /obj/item/clothing/mask/bandana/skull/vampire

//Making this a bandana to group them together.
/datum/loadout_item/mask/bandana/facescarf_greyscale
	name = "Facescarf (Colorable)"
	item_path = /obj/item/clothing/mask/facescarf/vampire

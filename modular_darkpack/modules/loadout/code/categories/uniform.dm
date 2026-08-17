/datum/loadout_category/uniform
	category_name = "Uniform"
	category_ui_icon = FA_ICON_SHIRT
	type_to_generate = /datum/loadout_item/uniform
	tab_order = /datum/loadout_category/head::tab_order + 9

/datum/loadout_item/uniform
	abstract_type = /datum/loadout_item/uniform

/datum/loadout_item/uniform/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only, loadout_placement_preference)
	if(outfit.uniform)
		LAZYADD(outfit.backpack_contents, outfit.uniform)
	outfit.uniform = item_path

// Suit and Suitskirts
/datum/loadout_item/uniform/suit
	abstract_type = /datum/loadout_item/uniform/suit

/datum/loadout_item/uniform/suit/fancy_gray
	name = "Suit (Luxury, Red)"
	item_path = /obj/item/clothing/under/vampire/fancy_gray

/datum/loadout_item/uniform/suit/fancy_red
	name = "Suit (Luxury, Gray)"
	item_path = /obj/item/clothing/under/vampire/fancy_red

/datum/loadout_item/uniform/suit/fancy_black
	name = "Suit (Luxury, Black)"
	item_path = /obj/item/clothing/under/vampire/ventrue

/datum/loadout_item/uniform/suit/fancy_black_skirt
	name = "Dress (Luxury, Black)"
	item_path = /obj/item/clothing/under/vampire/ventrue/female

/datum/loadout_item/uniform/suit/formal_white
	name = "Suit (White)"
	item_path = /obj/item/clothing/under/vampire/office

/datum/loadout_item/uniform/suit/plain_black
	name = "Suit (Plain, Black)"
	item_path = /obj/item/clothing/under/vampire/suit

/datum/loadout_item/uniform/suit/plain_black_skirt
	name = "Suit (Plain, Skirt, Black)"
	item_path = /obj/item/clothing/under/vampire/suit/female

/datum/loadout_item/uniform/suit/plain_red
	name = "Suit (Plain, Red)"
	item_path = /obj/item/clothing/under/vampire/sheriff

/datum/loadout_item/uniform/suit/plain_red_skirt
	name = "Suit (Plain, Skirt, Red)"
	item_path = /obj/item/clothing/under/vampire/sheriff/female

/datum/loadout_item/uniform/suit/plain_blue
	name = "Suit (Blue)"
	item_path = /obj/item/clothing/under/vampire/clerk

/datum/loadout_item/uniform/suit/plain_blue_skirt
	name = "Suit (Skirt, Blue)"
	item_path = /obj/item/clothing/under/vampire/clerk/female

/datum/loadout_item/uniform/suit/plain_brown
	name = "Suit (Brown)"
	item_path = /obj/item/clothing/under/vampire/archivist

/datum/loadout_item/uniform/suit/plain_brown_skirt
	name = "Suit (Skirt, Brown)"
	item_path = /obj/item/clothing/under/vampire/archivist/female

/datum/loadout_item/uniform/suit/prince
	name = "Suit (Princely)"
	item_path = /obj/item/clothing/under/vampire/prince

/datum/loadout_item/uniform/suit/prince_skirt
	name = "Suit (Princely, Skirt)"
	item_path = /obj/item/clothing/under/vampire/prince/female

// Skirts
/datum/loadout_item/uniform/skirt
	abstract_type = /datum/loadout_item/uniform/skirt

/datum/loadout_item/uniform/skirt/pentagram
	name = "Pentagram Shirt (Skirt)"
	item_path = /obj/item/clothing/under/vampire/baali/female

// Turtleneck
/datum/loadout_item/uniform/turtleneck
	abstract_type = /datum/loadout_item/uniform/turtleneck

/datum/loadout_item/uniform/turtleneck/black
	name = "Turtleneck (Black)"
	item_path = /obj/item/clothing/under/vampire/turtleneck_black

/datum/loadout_item/uniform/turtleneck/navy
	name = "Turtleneck (Navy)"
	item_path = /obj/item/clothing/under/vampire/turtleneck_navy

/datum/loadout_item/uniform/turtleneck/red
	name = "Turtleneck (Red)"
	item_path = /obj/item/clothing/under/vampire/turtleneck_red

/datum/loadout_item/uniform/turtleneck/white
	name = "Turtleneck (White)"
	item_path = /obj/item/clothing/under/vampire/turtleneck_white

// Pants
/datum/loadout_item/uniform/pants
	abstract_type = /datum/loadout_item/uniform/pants

/datum/loadout_item/uniform/pants/leather
	name = "Pants (Leather)"
	item_path = /obj/item/clothing/under/vampire/leatherpants

// Bloodlines clan outfits
/datum/loadout_item/uniform/flamboyant
	name = "Dress Shirt (Red)"
	item_path = /obj/item/clothing/under/vampire/toreador

/datum/loadout_item/uniform/flamboyant_female
	name = "Crop Top (Purple)"
	item_path = /obj/item/clothing/under/vampire/toreador/female

/datum/loadout_item/uniform/punk
	name = "Dress Shirt (Gray)"
	item_path = /obj/item/clothing/under/vampire/brujah

/datum/loadout_item/uniform/punk_female
	name = "Crop Top (White)"
	item_path = /obj/item/clothing/under/vampire/brujah/female

/datum/loadout_item/uniform/gimp
	name = "Gimp Outfit"
	item_path = /obj/item/clothing/under/vampire/nosferatu

/datum/loadout_item/uniform/gimp_female
	name = "Gimp Outfit (Bra)"
	item_path = /obj/item/clothing/under/vampire/nosferatu/female

/datum/loadout_item/uniform/gangrel
	name = "Rugged Clothes (Red)"
	item_path = /obj/item/clothing/under/vampire/gangrel

/datum/loadout_item/uniform/gangrel_female
	name = "Rugged Clothes (Blue)"
	item_path = /obj/item/clothing/under/vampire/gangrel/female

/datum/loadout_item/uniform/pants/grimey
	name = "Pants (Grimey)"
	item_path = /obj/item/clothing/under/vampire/malkavian

/datum/loadout_item/uniform/schoolgirl
	name = "Goth Schoolgirl Outfit"
	item_path = /obj/item/clothing/under/vampire/malkavian/female

/datum/loadout_item/uniform/suit/formal_burgundy
	name = "Suit (Burgundy)"
	item_path = /obj/item/clothing/under/vampire/tremere

/datum/loadout_item/uniform/suit/formal_burgundy_skirt
	name = "Suit (Skirt, Burgundy)"
	item_path = /obj/item/clothing/under/vampire/tremere/female


//Dresses
/datum/loadout_item/uniform/dress
	name = "Dress (Black)"
	item_path = /obj/item/clothing/under/vampire/business

/datum/loadout_item/uniform/dress_red
	name = "Dress (Red)"
	item_path = /obj/item/clothing/under/vampire/primogen_toreador/female

/datum/loadout_item/uniform/maid
	name = "Maid Outfit"
	item_path = /obj/item/clothing/under/costume/maid

//Dress Shirts
/datum/loadout_item/uniform/emo
	name = "Dress Shirt (Black)"
	item_path = /obj/item/clothing/under/vampire/emo

/datum/loadout_item/uniform/messy
	name = "Dress Shirt (White)"
	item_path = /obj/item/clothing/under/vampire/bouncer

/datum/loadout_item/uniform/biker
	name = "Dress Shirt (Brown)"
	item_path = /obj/item/clothing/under/vampire/biker

//Scene
/datum/loadout_item/uniform/scenepink
	item_path = /obj/item/clothing/under/vampire/scenepink

/datum/loadout_item/uniform/scenemoody
	item_path = /obj/item/clothing/under/vampire/scenemoody

/datum/loadout_item/uniform/sceneleopard
	item_path = /obj/item/clothing/under/vampire/sceneleopard

/datum/loadout_item/uniform/scenezim
	item_path = /obj/item/clothing/under/vampire/scenezim

//Other
/datum/loadout_item/uniform/baron
	name = "Bartender Outfit"
	item_path = /obj/item/clothing/under/vampire/bar

/datum/loadout_item/uniform/baron_female
	name = "Bartender Outfit (Skirt)"
	item_path = /obj/item/clothing/under/vampire/bar/female

/datum/loadout_item/uniform/sleeveless_yellow
	name = "Tank Top (Yellow)"
	item_path = /obj/item/clothing/under/vampire/larry

/datum/loadout_item/uniform/sleeveless_white
	name = "Tank Top (White)"
	item_path = /obj/item/clothing/under/vampire/bandit

/datum/loadout_item/uniform/hipster
	name = "Crop Top (Red)"
	item_path = /obj/item/clothing/under/vampire/red

/datum/loadout_item/uniform/black_grunge
	name = "Crop Top (Black)"
	item_path = /obj/item/clothing/under/vampire/black


/datum/loadout_item/uniform/burlesque
	name = "Burlesque Outfit"
	item_path = /obj/item/clothing/under/vampire/burlesque

/datum/loadout_item/uniform/daisyd
	name = "Daisy Dukes"
	item_path = /obj/item/clothing/under/vampire/burlesque/daisyd

/datum/loadout_item/uniform/overalls
	name = "Overalls"
	item_path = /obj/item/clothing/under/vampire/mechanic

/datum/loadout_item/uniform/black_overcoat
	name = "Overcoat (Black)"
	item_path = /obj/item/clothing/under/vampire/rich

/datum/loadout_item/uniform/gown_black
	name = "black gown"
	item_path = /obj/item/clothing/under/vampire/gown_black

/datum/loadout_item/uniform/gown_white
	name = "white gown"
	item_path = /obj/item/clothing/under/vampire/gown_white

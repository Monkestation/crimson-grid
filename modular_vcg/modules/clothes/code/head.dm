/obj/item/clothing/head/fedora/vampire  // Da High-Rollahs
	name = "grey fedora"
	desc = "a classy hat usually worn by wise guys."
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "fedora_grey"
	hair_mask = /datum/hair_mask/standard_hat_low

/obj/item/clothing/head/fedora/vampire/Initialize(mapload)
	. = ..()

/obj/item/clothing/head/fedora/vampire/tan
	name = "tan fedora"
	icon_state = "fedora_tan"
	inhand_icon_state = null

/obj/item/clothing/head/fedora/vampire/sage
	name = "sage fedora"
	icon_state = "fedora_sage"
	inhand_icon_state = null

/obj/item/clothing/head/flathat/vampire  //Da GOONS
	name = "grey flatcap"
	desc = "a flat hat usually worn by tough guys."
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "flatcap_grey"
	hair_mask = /datum/hair_mask/standard_hat_low

/obj/item/clothing/head/flathat/vampire/Initialize(mapload)
	. = ..()

/obj/item/clothing/head/flathat/vampire/tan
	name = "tan flatcap"
	icon_state = "flatcap_tan"
	inhand_icon_state = null

/obj/item/clothing/head/flathat/vampire/sage
	name = "sage flatcap"
	icon_state = "flatcap_sage"
	inhand_icon_state = null

/obj/item/clothing/head/baseballcap/vampire  //For yall
	name = "red baseball cap"
	desc = "a baseball cap worn by the average sports fan."
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "baseball_red"
	hair_mask = /datum/hair_mask/standard_hat_low

/obj/item/clothing/head/baseballcap/vampire/blue
	name = "blue baseball cap"
	icon_state = "baseball_blue"
	inhand_icon_state = null

/obj/item/clothing/head/baseballcap/vampire/green
	name = "green baseball cap"
	icon_state = "baseball_green"
	inhand_icon_state = null

/// ARMOR

/obj/item/clothing/head/vampire/bikehelmet
	name = "black bike helmet"
	desc = "A black helmet.. Deja Vu?.. "
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR
	armor_type = /datum/armor/bike_helmet
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	icon = 'modular_vcg/modules/clothes/icons/clothing.dmi'
	worn_icon = 'modular_vcg/modules/clothes/icons/worn.dmi'
	icon_state = "black_bikehelmet"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/clothes/icons/clothing_onfloor.dmi')
	custom_price = 200

/datum/armor/bike_helmet
	melee = 30
	bullet = 20
	laser = 20
	energy = 20
	bomb = 20
	fire = 10
	acid = 30
	wound = 25

/obj/item/clothing/head/vampire/bikehelmet/white
	name = "white bike helmet"
	desc = "A white helmet.. Deja Vu?.. "
	icon_state = "white_bikehelmet"

/obj/item/clothing/head/vampire/bikehelmet/yellow
	name = "yellow bike helmet"
	desc = "A yellow helmet.. Deja Vu?.. "
	icon_state = "yellow_bikehelmet"

/obj/item/clothing/head/vampire/bikehelmet/red
	name = "red bike helmet"
	desc = "A red helmet.. Deja Vu?.. "
	icon_state = "red_bikehelmet"

/obj/item/clothing/head/vampire/bikehelmet/blue
	name = "blue bike helmet"
	desc = "A blue helmet.. Deja Vu?.. "
	icon_state = "blue_bikehelmet"

/obj/item/clothing/head/vampire/bikehelmet/raceblue
	name = "blue race helmet"
	desc = "A blue race helmet.. Deja Vu?.. "
	icon_state = "blue_racehelmet"

/obj/item/clothing/head/vampire/bikehelmet/racewhite
	name = "white race helmet"
	desc = "A white race helmet.. Deja Vu?.. "
	icon_state = "white_racehelmet"

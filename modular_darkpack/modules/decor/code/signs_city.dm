//Considering having a subtype of this for "hanging" signs
/obj/structure/sign/city
	icon = 'modular_darkpack/modules/decor/icons/city_sign.dmi'

/obj/structure/sign/city/get_turfs_to_mount_on()
	return list(get_step(src, dir))

/obj/structure/sign/city/police_department
	name = "\improper " + CITY_POLICE_DEPARTMENT + " sign"
	desc = "Stop right there you criminal scum! Nobody can break the law on my watch!!"
	icon_state = "police1"
	pixel_z = 4

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/police_department, 32)

/obj/structure/sign/city/order
	name = "order sign"
	icon_state = "order"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/order, 32)

/obj/structure/sign/city/hotel
	name = "sign"
	desc = "It says H O T E L."
	icon_state = "hotel"
	//plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/hotel, 0)

/obj/structure/sign/city/hotel/Initialize(mapload)
	. = ..()
	set_light(3, 3, "#8e509e")
	if(check_holidays(FESTIVE_SEASON))
		var/area/my_area = get_area(src)
		if(istype(my_area) && my_area.outdoors)
			icon_state = "[initial(icon_state)]-snow"

/obj/structure/sign/city/millenium
	name = "sign"
	desc = "It says M I L L E N I U M."
	icon = 'modular_darkpack/modules/decor/icons/city_sign.dmi'
	icon_state = "millenium1"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	dir = NORTH
	pixel_y = 32

/obj/structure/sign/city/millenium/Initialize(mapload)
	. = ..()
	set_light(3, 3, "#4299bb")

/obj/structure/sign/city/anarch
	name = "sign"
	desc = "It says B A R."
	icon = 'modular_darkpack/modules/decor/icons/city_sign.dmi'
	icon_state = "bar"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	dir = WEST

/obj/structure/sign/city/anarch/Initialize(mapload)
	. = ..()
	set_light(3, 3, "#ffffff")
	if(check_holidays(FESTIVE_SEASON))
		var/area/my_area = get_area(src)
		if(istype(my_area) && my_area.outdoors)
			icon_state = "[initial(icon_state)]-snow"

/obj/structure/sign/city/chinese
	name = "sign"
	desc = "雨天和血的机会."
	icon = 'modular_darkpack/modules/decor/icons/city_sign.dmi'
	icon_state = "chinese1"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/chinese, 0)

/obj/structure/sign/city/chinese/Initialize(mapload)
	. = ..()
	if(check_holidays(FESTIVE_SEASON))
		var/area/my_area = get_area(src)
		if(istype(my_area) && my_area.outdoors)
			icon_state = "[initial(icon_state)]-snow"

/obj/structure/sign/city/chinese/alt
	icon_state = "chinese2"
MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/chinese/alt, 0)

/obj/structure/sign/city/chinese/alt2
	icon_state = "chinese3"
MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/chinese/alt2, 0)

/obj/structure/sign/city/chinese/alt3
	icon_state = "chinese4"
MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/chinese/alt3, 0)

/obj/structure/sign/city/chinese/alt4
	icon_state = "chinese5"
MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/chinese/alt4, 0)

/obj/structure/sign/city/chinese/alt5
	icon_state = "chinese6"
MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/chinese/alt5, 0)

// Hrm. Not synced with PRIMARY_NIGHTCLUB_COMPANY and it cant really be..
/obj/structure/sign/city/strip_club
	name = "sign"
	desc = "It says DO RA. Maybe it's some kind of strip club..."
	icon = 'modular_darkpack/modules/deprecated/icons/48x48.dmi'
	icon_state = "dora"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE
	pixel_w = -8
	//pixel_z = 32

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/strip_club, 32)

/obj/structure/sign/city/strip_club/Initialize(mapload)
	. = ..()
	set_light(3, 2, "#8e509e")

/obj/structure/sign/city/cabaret_sign
	name = "cabaret"
	desc = "An enticing pair of legs... I wonder what's inside?"
	icon = 'modular_darkpack/modules/decor/icons/cabaret.dmi'
	icon_state = "cabar"
	layer = ABOVE_ALL_MOB_LAYER
	anchored = TRUE

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/cabaret_sign, 32)

/obj/structure/sign/city/cabaret_sign/Initialize(mapload)
	. = ..()
	set_light(3, 2, "#d98aec")

/obj/structure/sign/city/cabaret_sign/two
	icon_state = "et"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/cabaret_sign/two, 32)

/obj/structure/sign/city/store
	icon = 'modular_darkpack/modules/decor/icons/store_sign.dmi'
	icon_state = "bacotell"
	anchored = TRUE
	pixel_w = -16

/obj/structure/sign/city/store/bacotell
	name = "Baco Tell"
	desc = "Eat some precious tacos and pizza!"
	icon_state = "bacotell"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/store/bacotell, 32)

/obj/structure/sign/city/store/bubway
	name = "BubWay"
	desc = "Eat some precious burgers and pizza!"
	icon_state = "bubway"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/store/bubway, 32)

/obj/structure/sign/city/store/gummaguts
	name = "Gumma Guts"
	desc = "Eat some precious chicken nuggets and donuts!"
	icon_state = "gummaguts"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/store/gummaguts, 32)

/obj/structure/sign/city/skateshop
	name = "Beralta Skateshop"
	icon_state = "beralta1"
	desc = "Bowell Beralta, apart from having a very unfortunate name, is one of the biggest names in authentic knock-off skateboards."

/obj/structure/sign/city/skateshop/two
	icon_state = "beralta2"

/obj/structure/sign/city/skateshop/three
	icon_state = "beralta3"

/obj/structure/sign/city/skateshop/four
	icon_state = "beralta4"
MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/skateshop, 32)
MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/skateshop/two, 32)
MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/skateshop/three, 32)
MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/skateshop/four, 32)

/obj/structure/sign/city/store/reddragon
	name = "Red Dragon"
	desc = "Eat yummy-yummy flame fire noodles!"
	icon_state = "reddragon"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/store/reddragon, 32)

/obj/structure/sign/city/store/otolleys
	name = "O\'Tolleys"
	desc = "O-o-o Oh Toll-ees, Families Welcome!"
	icon_state = "otolleys"

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/city/store/otolleys, 32)

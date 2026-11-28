// BASE AREAS

/area/vtm/sunnycoast
	name = "Exterior"
	outdoors = TRUE
	icon_state = "sewer"
	icon = 'modular_darkpack/modules/areas/icons/areas.dmi'
	zone_type = ZONE_MASQUERADE

/area/vtm/sunnycoast/interior
	name = "Interior"
	icon_state = "interior"
	ambience_index = AMBIENCE_OFFICE
	outdoors = FALSE
	sound_environment = SOUND_ENVIRONMENT_ROOM
	ambient_buzz = 'modular_darkpack/modules/ambience/sounds/interior_generic.ogg'
	ambient_buzz_vol = 30

// DISTRICTS

/area/vtm/sunnycoast/marina
	name = "Marina District"
	icon_state = "marina"
	icon = 'modular_darkpack/modules/sunnycoast/icons/areas.dmi'

/area/vtm/sunnycoast/heritage
	name = "Heritage District"
	icon_state = "heritage"
	icon = 'modular_darkpack/modules/sunnycoast/icons/areas.dmi'

/area/vtm/sunnycoast/heritage/italy
	name = "Heritage District - Little Italy"

/area/vtm/sunnycoast/heritage/china
	name = "Heritage District - Chinatown"

/area/vtm/sunnycoast/commerce
	name = "Commerce District"
	icon_state = "commerce"
	icon = 'modular_darkpack/modules/sunnycoast/icons/areas.dmi'

// SHOPS

/area/vtm/interior/shop/diner
	name = "Sunset Diner"
	icon_state = "shop"

/area/vtm/interior/shop/icecream
	name = "Icecream Parlor"
	icon_state = "shop"

/area/vtm/interior/shop/tattoo
	name = "Tattoo Studio"
	icon_state = "shop"

/area/vtm/interior/shop/antique
	name = "Antique Store"
	icon_state = "shop"

/area/vtm/interior/shop/fancyclothes
	name = "Upscale Boutique"
	icon_state = "shop"

/area/vtm/interior/shop/pizza
	name = "Papa's Pizzaria"
	icon_state = "shop"

/area/vtm/interior/shop/deli
	name = "Italian Deli"
	icon_state = "shop"

/area/vtm/interior/shop/gasstation/endron
	name = "Endroil Gas Station"
	music_index = MUSIC_ENDRON

// MOTELS

/area/vtm/sunnycoast/motel
	name = "Coastside Motel - Courtyard"
	outdoors = TRUE
	icon_state = "hotel"

/area/vtm/sunnycoast/motel/interior
	name = "Coastside Motel"
	icon_state = "hotel"
	ambience_index = AMBIENCE_OFFICE
	outdoors = FALSE

/area/vtm/sunnycoast/anarchmotel
	name = "Old Marina Motel - Courtyard"
	outdoors = TRUE
	icon_state = "hotel"

/area/vtm/sunnycoast/anarchmotel/interior
	name = "Old Marina Motel"
	icon_state = "hotel"
	ambience_index = AMBIENCE_OFFICE
	music_index = MUSIC_BAR
	outdoors = FALSE

// RESIDENCES

/area/vtm/interior/apartment/fifthave
	name = "5th Avenue Apartments"

/area/vtm/interior/apartment/penthouse
	name = "Millenium Apartments - Landlord's Club Penthouse"

/area/vtm/interior/apartment/italy
	name = "Heritage District - Little Italy Apartments"

/area/vtm/interior/apartment/china
	name = "Heritage District - Chinatown Apartments"

// MISC

/area/vtm/sunnycoast/interior/carwash
	name = "Car Wash"

/area/vtm/sunnycoast/interior/citymaint
	name = "City Maintenance Office"

/area/vtm/sunnycoast/interior/citymaint/yard
	name = "City Maintenance Yard"
	outdoors = TRUE

/area/vtm/sunnycoast/interior/carwash
	name = "Car Wash"

/area/vtm/sunnycoast/interior/metro
	name = "Metro Station"

/area/vtm/sunnycoast/interior/gambling
	name = "Gambling Den"

/area/vtm/sunnycoast/junkyard
	name = "Junkyard"
	outdoors = TRUE

/area/vtm/sunnycoast/interior/tunnels
	name = "Junkyard Tunnels"
	zone_type = ZONE_NO_MASQUERADE

/area/vtm/sunnycoast/interior/arcade
	name = "Arcade"

/area/vtm/sunnycoast/interior/selfstorage
	name = "Self Storage Units"

/area/vtm/sunnycoast/interior/selfstorage/yard
	name = "Self Storage Yard"

/area/vtm/sunnycoast/interior/gym
	name = "Gym"

/area/vtm/sunnycoast/interior/blackmarket
	name = "Chinatown Underground Market"

/area/vtm/sunnycoast/interior/rednews
	name = "Red News Office"

// STREETS

/area/vtm/sunnycoast/street
	name = "Street"
	outdoors = TRUE
	icon_state = "sewer"

/area/vtm/sunnycoast/street/firstave
	name = "1st Avenue - Main"

/area/vtm/sunnycoast/street/firstave/outskirts
	name = "1st Avenue - City Outskirts"

/area/vtm/sunnycoast/street/thirdave
	name = "3rd Avenue"

/area/vtm/sunnycoast/street/fifthave
	name = "5th Avenue"

/area/vtm/sunnycoast/street/seventhave
	name = "7th Avenue - Waterfront"

/area/vtm/sunnycoast/street/secondst
	name = "2nd Street"

/area/vtm/sunnycoast/street/fourthst
	name = "4th Street"

/area/vtm/sunnycoast/street/sixthst
	name = "6th Street"

/area/vtm/sunnycoast/street/eighthst
	name = "8th Street"

/area/vtm/sunnycoast/street/tenthst
	name = "10th Street"

// TUNNELS

/area/vtm/sunnycoast/interior/tunnel
	name = "Tunnel"
	ambience_index = AMBIENCE_CITY

/area/vtm/sunnycoast/interior/tunnel/firstave
	name = "1st Avenue - Northside Tunnel"

/area/vtm/sunnycoast/interior/tunnel/firstave/south
	name = "1st Avenue - Southside Tunnel"

/area/vtm/sunnycoast/interior/tunnel/firstave/outskirts
	name = "1st Avenue - City Outskirts Tunnel"

/area/vtm/sunnycoast/interior/tunnel/railway
	name = "Railway Tunnel"

/area/vtm/sunnycoast/interior/tunnel/sixthst
	name = "6th Street Tunnel"

/area/vtm/sunnycoast/interior/tunnel/eighthst
	name = "8th Street Tunnel"

// THE FOREST STUFF

/area/vtm/planetgeneration/woodland/sunnycoast
	name = "Pacific Heights Forest"

/area/vtm/sunnycoast/forest
	name = "Pacific Heights Forest"
	outdoors = TRUE
	icon_state = "park"
	ambience_index = AMBIENCE_NATURE
	music_index = MUSIC_FOREST
	zone_type = ZONE_NO_MASQUERADE

/area/vtm/sunnycoast/interior/ranger
	name = "NPS Ranger Station"
	music_index = MUSIC_FOREST

/area/vtm/sunnycoast/interior/cabin
	name = "Rental Cabin"
	music_index = MUSIC_FOREST

/area/vtm/sunnycoast/interior/cave
	name = "Pacific Heights Forest - Caves"
	music_index = MUSIC_FOREST
	sound_environment = SOUND_ENVIRONMENT_CAVE

/area/vtm/sunnycoast/interior/cave/mineshaft
	name = "Pacific Heights Forest - Condemned Mineshafts"
	music_index = MUSIC_CAERN
	ambience_index = AMBIENCE_NATURE
	sound_environment = SOUND_ENVIRONMENT_CAVE

// TZIM MANSION BUT LESS BREACHY AND WITH A COURTYARD SUBTYPE

/area/vtm/sunnycoast/interior/oldmansion
	name = "Heritage Listed Mansion"
	icon_state = "old_clan_tzimisce"
	ambience_index = AMBIENCE_OFFICE
	music_index = MUSIC_SAFE

/area/vtm/sunnycoast/interior/oldmansion/courtyard
	name = "Heritage Listed Mansion - Courtyard"
	outdoors = TRUE

// THE CLUB I HAVENT RENAMED BECAUSE I NEED TO SPRITE A NEW SIGN

/area/vtm/sunnycoast/interior/nightclub
	name = "DORA Nightclub"
	icon_state = "strip"
	fire_controled = TRUE
	domain = TRUE
	musictracks = list('modular_darkpack/modules/ambience/sounds/music/strip_club.ogg')

/area/vtm/sunnycoast/interior/nightclub/vip
	name = "DORA Nightclub - Elysium Tier VIP Area"

/area/vtm/sunnycoast/interior/nightclub/staff
	name = "DORA Nightclub - Staff Area"

// PARKING GARAGE

/area/vtm/sunnycoast/interior/parking
	name = "Parking Garage - Level 0"

/area/vtm/sunnycoast/interior/parking/one
	name = "Parking Garage - Level 1"

/area/vtm/sunnycoast/interior/parking/two
	name = "Parking Garage - Level 2"

/area/vtm/sunnycoast/interior/parking/three
	name = "Parking Garage - Level 3"

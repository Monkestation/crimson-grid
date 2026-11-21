// Shops:
/area/vtm/interior/shop/arts
	name = "Art Supplies Store"
	icon_state = "shop_arts"

/area/vtm/interior/shop/black_market
	name = "Black Market"
	icon_state = "shop_black_market"

/area/vtm/interior/shop/antiques
	name = "Antique Store"
	icon_state = "shop_antique"

/area/vtm/interior/hos
	name = "Helios Overnight Services"
	icon = 'modular_vcg/modules/areas/icons/cg_areas.dmi'
	icon_state = "corax"
	ambience_index = AMBIENCE_OFFICE
	music_index = MUSIC_CHURCH

/area/vtm/interior/corax_caern
	name = "Corax Caern"
	icon = 'modular_vcg/modules/areas/icons/cg_areas.dmi'
	icon_state = "corax_caern"
	zone_type = ZONE_ELYSIUM
	ambience_index = AMBIENCE_OFFICE
	music_index = MUSIC_CHURCH

/area/vtm/interior/corax/bawn
	name = "Corax Bawn"
	icon = 'modular_vcg/modules/areas/icons/cg_areas.dmi'
	icon_state = "corax_caern"

/area/vtm/interior/corax/bawn/LateInitialize()
	. = ..()
	AddComponent(/datum/component/bawn_area, /obj/structure/werewolf_totem/corax)


/area/vtm/interior/mail_office
	name = "Mail Office"
	icon_state = "shop"
	ambience_index = AMBIENCE_OFFICE
	music_index = MUSIC_CITY

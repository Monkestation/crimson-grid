/obj/effect/mapping_helpers/door/access
	layer = DOOR_ACCESS_HELPER_LAYER
	icon = 'modular_darkpack/modules/doors/icons/mapping_helpers.dmi'
	icon_state = "access_helper"
	var/lock_id

/obj/effect/mapping_helpers/door/access/payload(obj/structure/vampdoor/payload)
	payload.lock_id = lock_id
	GLOB.city_door_lock_ids |= lock_id

/obj/effect/mapping_helpers/door/access/all
	name = "all access"
	desc = "Any keys can lock or unlock this door."
	lock_id = LOCKACCESS_ALL

/obj/effect/mapping_helpers/door/access/camarilla
	icon_state = "access_helper_cam"
	lock_id = LOCKACCESS_CAMARILLA

/obj/effect/mapping_helpers/door/access/prince
	icon_state = "access_helper_cam"
	lock_id = LOCKACCESS_PRINCE

/obj/effect/mapping_helpers/door/access/primogen
	icon_state = "access_helper_cam"
	lock_id = LOCKACCESS_PRIMOGEN


/obj/effect/mapping_helpers/door/access/banu
	icon_state = "access_helper_cam"
	lock_id = LOCKACCESS_BANU

/obj/effect/mapping_helpers/door/access/banu_haqim_primogen
	icon_state = "access_helper_cam"
	lock_id = LOCKACCESS_BANU_PRIMOGEN

/obj/effect/mapping_helpers/door/access/strip
	icon_state = "access_helper_cam"
	lock_id = LOCKACCESS_STRIP

/obj/effect/mapping_helpers/door/access/chantry
	icon_state = "access_helper_cam"
	lock_id = LOCKACCESS_CHANTRY

/obj/effect/mapping_helpers/door/access/clerk
	icon_state = "access_helper_cam"
	lock_id = LOCKACCESS_CLERK


/obj/effect/mapping_helpers/door/access/bankboss
	lock_id = LOCKACCESS_BANKBOSS

/obj/effect/mapping_helpers/door/access/bank
	lock_id = LOCKACCESS_BANK


/obj/effect/mapping_helpers/door/access/theatre
	lock_id = LOCKACCESS_THEATRE

/obj/effect/mapping_helpers/door/access/jazz_club
	lock_id = LOCKACCESS_JAZZ_CLUB

/obj/effect/mapping_helpers/door/access/jazz_club_delivery
	lock_id = LOCKACCESS_JAZZ_CLUB_DELIVERY


/obj/effect/mapping_helpers/door/access/director
	lock_id = LOCKACCESS_DIRECTOR

/obj/effect/mapping_helpers/door/access/clinic
	lock_id = LOCKACCESS_CLINIC


/obj/effect/mapping_helpers/door/access/primogen_ventrue
	lock_id = LOCKACCESS_PRIMOGEN_VENTRUE

/obj/effect/mapping_helpers/door/access/ventrue
	lock_id = LOCKACCESS_VENTRUE


/obj/effect/mapping_helpers/door/access/primogen_toreador
	lock_id = LOCKACCESS_PRIMOGEN_TOREADOR

/obj/effect/mapping_helpers/door/access/toreador
	lock_id = LOCKACCESS_TOREADOR


/obj/effect/mapping_helpers/door/access/primogen_malkavian
	lock_id = LOCKACCESS_MALK_PRIMOGEN

/obj/effect/mapping_helpers/door/access/malkavian
	lock_id = LOCKACCESS_MALK


/obj/effect/mapping_helpers/door/access/primogen_brujah
	lock_id = LOCKACCESS_PRIMOGEN_BRUJAH

/obj/effect/mapping_helpers/door/access/brujah
	lock_id = LOCKACCESS_BRUJAH


/obj/effect/mapping_helpers/door/access/primogen_nosferatu
	lock_id = LOCKACCESS_PRIMOGEN_NOSFERATU

/obj/effect/mapping_helpers/door/access/nosferatu
	lock_id = LOCKACCESS_NOSFERATU


/obj/effect/mapping_helpers/door/access/giovanni
	lock_id = LOCKACCESS_GIOVANNI

/obj/effect/mapping_helpers/door/access/daughters
	lock_id = LOCKACCESS_DAUGHTERS

/obj/effect/mapping_helpers/door/access/cappadocian
	lock_id = LOCKACCESS_CAPPADOCIAN

/obj/effect/mapping_helpers/door/access/salubri
	lock_id = LOCKACCESS_SALUBRI

/obj/effect/mapping_helpers/door/access/old_clan_tzimisce
	lock_id = LOCKACCESS_OLD_CLAN_TZI

/obj/effect/mapping_helpers/door/access/baali
	lock_id = LOCKACCESS_BAALI

/obj/effect/mapping_helpers/door/access/lasombra
	lock_id = LOCKACCESS_LASOMBRA

/obj/effect/mapping_helpers/door/access/lasombra_primogen
	icon_state = "access_helper_cam"
	lock_id = LOCKACCESS_PRIMOGEN_LASOMBRA

/obj/effect/mapping_helpers/door/access/setite
	lock_id = LOCKACCESS_SETITE

/obj/effect/mapping_helpers/door/access/sabbat
	lock_id = LOCKACCESS_SABBAT

/obj/effect/mapping_helpers/door/access/baron
	icon_state = "access_helper_bar"
	lock_id = LOCKACCESS_BARON

/obj/effect/mapping_helpers/door/access/anarch
	icon_state = "access_helper_bar"
	lock_id = LOCKACCESS_ANARCH

/obj/effect/mapping_helpers/door/access/bar
	icon_state = "access_helper_bar"
	lock_id = LOCKACCESS_BAR

/obj/effect/mapping_helpers/door/access/bar_delivery
	icon_state = "access_helper_bar"
	lock_id = LOCKACCESS_BAR_DELIVERY


/obj/effect/mapping_helpers/door/access/supply
	lock_id = LOCKACCESS_SUPPLY

/obj/effect/mapping_helpers/door/access/graveyard
	lock_id = LOCKACCESS_GRAVEYARD

/obj/effect/mapping_helpers/door/access/church
	lock_id = LOCKACCESS_CHURCH

/obj/effect/mapping_helpers/door/access/taxi
	lock_id = LOCKACCESS_TAXI


/obj/effect/mapping_helpers/door/access/triad
	lock_id = LOCKACCESS_TRAID

/obj/effect/mapping_helpers/door/access/cleaning
	lock_id = LOCKACCESS_CLEANING

/obj/effect/mapping_helpers/door/access/laundromat
	lock_id = LOCKACCESS_LAUNDROMAT

/obj/effect/mapping_helpers/door/access/hunter
	lock_id = LOCKACCESS_HUNTER

/obj/effect/mapping_helpers/door/access/police
	lock_id = LOCKACCESS_POLICE

/obj/effect/mapping_helpers/door/access/kiasyd
	lock_id = LOCKACCESS_KIASYD

/obj/effect/mapping_helpers/door/access/dispatch
	lock_id = LOCKACCESS_DISPATCH

/obj/effect/mapping_helpers/door/access/police_secure
	lock_id = LOCKACCESS_POLICE_SECURE

/obj/effect/mapping_helpers/door/access/police_captain
	lock_id = LOCKACCESS_POLICE_CAPTAIN

/obj/effect/mapping_helpers/door/access/federal
	lock_id = LOCKACCESS_FEDERAL


/obj/effect/mapping_helpers/door/access/wolftech
	lock_id = LOCKACCESS_WOLFTECH

/obj/effect/mapping_helpers/door/access/park_ranger
	lock_id = LOCKACCESS_PARK_RANGER

/obj/effect/mapping_helpers/door/access/coggie
	lock_id = LOCKACCESS_COGGIE

/obj/effect/mapping_helpers/door/access/pentex
	lock_id = LOCKACCESS_PENTEX

/obj/effect/mapping_helpers/door/access/pentex_leader
	lock_id = LOCKACCESS_PENTEX_LEADER

/obj/effect/mapping_helpers/door/access/npc
	icon_state = "access_helper_rand"

/obj/effect/mapping_helpers/door/access/npc/payload(obj/structure/vampdoor/payload)
	payload.lock_id = "npc[rand(1, 20)]"

/obj/effect/mapping_helpers/door/access/claimable

/obj/effect/mapping_helpers/door/access/claimable/payload(obj/structure/vampdoor/payload)
	if(!payload.lock_id)
		payload.lock_id = "[rand(1,9999999)]"
	payload.AddComponent(/datum/component/door_ownership)

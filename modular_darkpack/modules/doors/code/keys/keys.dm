GLOBAL_LIST_INIT(key_access_by_types, init_key_access_by_types())
GLOBAL_LIST_INIT(city_door_lock_ids, list())

/// Builds a list of the access locks because we cant pull lists from un initlizied keys and we dont want to qdel a key for every spawn.
/proc/init_key_access_by_types()
	var/list/keys_by_type = list()
	for(var/subtype in valid_subtypesof(/obj/item/vamp/keys))
		var/obj/item/vamp/keys/temp_key = new subtype()
		keys_by_type[subtype] = temp_key.accesslocks
		qdel(temp_key)

	return keys_by_type

/proc/key_has_matching_door(key_type)
	for(var/access in GLOB.key_access_by_types[key_type])
		if(access in GLOB.city_door_lock_ids)
			return TRUE

	return FALSE


/obj/item/vamp/keys
	name = "keys"
	desc = "Those can open some doors."
	icon = 'modular_darkpack/modules/deprecated/icons/items.dmi'
	icon_state = "keys"
	gender = PLURAL
	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_TINY
	armor_type = /datum/armor/keys
	resistance_flags = FIRE_PROOF | ACID_PROOF
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/deprecated/icons/onfloor.dmi')

	var/list/accesslocks = list(
		"nothing"
	)
	var/roundstart_fix = FALSE

/datum/armor/keys
	fire = 100
	acid = 100

//===========================VAMPIRE KEYS===========================
/obj/item/vamp/keys/camarilla
	name = "\improper Camarilla keys"
	accesslocks = list(LOCKACCESS_CAMARILLA)
	color = "#bd3327"

/obj/item/vamp/keys/prince
	name = "prince's keys"
	accesslocks = list(
		LOCKACCESS_CAMARILLA,
		LOCKACCESS_PRINCE,
		LOCKACCESS_CLERK,
		LOCKACCESS_CHANTRY,
		LOCKACCESS_THEATRE,
		LOCKACCESS_JAZZ_CLUB,
		LOCKACCESS_PRIMOGEN,
		LOCKACCESS_JAZZ_CLUB_DELIVERY,
	)
	color = "#bd3327"

/obj/item/vamp/keys/sheriff
	name = "sheriff's keys"
	accesslocks = list(
		LOCKACCESS_CAMARILLA,
		LOCKACCESS_PRINCE,
		LOCKACCESS_THEATRE,
		LOCKACCESS_JAZZ_CLUB,
		LOCKACCESS_PRIMOGEN,
		LOCKACCESS_CLERK,
		LOCKACCESS_JAZZ_CLUB_DELIVERY,
	)
	color = "#bd3327"

/obj/item/vamp/keys/clerk
	name = "clerk's keys"
	accesslocks = list(
		LOCKACCESS_CAMARILLA,
		LOCKACCESS_CLERK,
		LOCKACCESS_THEATRE,
		LOCKACCESS_JAZZ_CLUB,
		LOCKACCESS_PRIMOGEN,
		LOCKACCESS_JAZZ_CLUB_DELIVERY,
		LOCKACCESS_PRINCE,
	)
	color = "#bd3327"

/obj/item/vamp/keys/camarilla
	name = "\improper Millenium Tower keys"
	accesslocks = list(
		LOCKACCESS_JAZZ_CLUB,
		LOCKACCESS_CLERK,
		LOCKACCESS_CAMARILLA,
		LOCKACCESS_JAZZ_CLUB_DELIVERY,
	)
	color = "#bd3327"

/obj/item/vamp/keys/camarilla/ghoul
	name = "\improper Millenium Tower Employee keys"
	accesslocks = list(
		LOCKACCESS_JAZZ_CLUB,
		LOCKACCESS_CLERK,
		LOCKACCESS_CAMARILLA
	)
	color = "#bd3327"

/obj/item/vamp/keys/archive
	name = "archive keys"
	accesslocks = list(
		LOCKACCESS_CHANTRY
	)

/obj/item/vamp/keys/regent
	name = "very archival keys"
	accesslocks = list(
		LOCKACCESS_CHANTRY,
		LOCKACCESS_JAZZ_CLUB,
		LOCKACCESS_PRIMOGEN,
		LOCKACCESS_CAMARILLA,
		LOCKACCESS_JAZZ_CLUB_DELIVERY,
	)

/obj/item/vamp/keys/baron
	name = "baron keys"
	accesslocks = list(
		LOCKACCESS_BAR,
		LOCKACCESS_ANARCH,
		LOCKACCESS_BAR_DELIVERY,
		LOCKACCESS_BARON,
	)
	color = "#434343"

/obj/item/vamp/keys/anarch
	name = "bar keys"
	accesslocks = list(
		LOCKACCESS_BAR,
		LOCKACCESS_ANARCH,
		LOCKACCESS_BAR_DELIVERY,
	)
	color = "#434343"

/obj/item/vamp/keys/anarch_limited
	name = "barkeeper keys"
	accesslocks = list(
		LOCKACCESS_BAR
	)
	color = "#434343"

/obj/item/vamp/keys/giovanni
	name = "mafia keys"
	accesslocks = list(
		LOCKACCESS_GIOVANNI,
		LOCKACCESS_BANK
	)

/obj/item/vamp/keys/capo
	name = "capo keys"
	accesslocks = list(
		LOCKACCESS_BANKBOSS,
		LOCKACCESS_BANK,
		LOCKACCESS_GIOVANNI
	)


/obj/item/vamp/keys/baali
	name = "satanic keys"
	accesslocks = list(
		LOCKACCESS_BAALI
	)

/obj/item/vamp/keys/lasombra
	name = "dark keys"
	accesslocks = list(
		LOCKACCESS_LASOMBRA,
		LOCKACCESS_KIASYD,
		LOCKACCESS_CHURCH
	)
	color = "#290355"

/obj/item/vamp/keys/lasombra/primogen
	name = "really dark keys"
	accesslocks = list(
		LOCKACCESS_LASOMBRA,
		LOCKACCESS_KIASYD,
		LOCKACCESS_CHURCH,
		LOCKACCESS_PRIMOGEN,
		LOCKACCESS_PRIMOGEN_LASOMBRA,
		LOCKACCESS_JAZZ_CLUB,
		LOCKACCESS_THEATRE,
		LOCKACCESS_CAMARILLA,
		LOCKACCESS_PRIMOGEN_LASOMBRA,
	)
	color = "#4b039c"

/obj/item/vamp/keys/daughters
	name = "eclectic keys"
	accesslocks = list(
		LOCKACCESS_DAUGHTERS
	)

/obj/item/vamp/keys/salubri
	name = "conspiracy keys"
	accesslocks = list(
		LOCKACCESS_SALUBRI
	)

/obj/item/vamp/keys/old_clan_tzimisce
	name = "regal keys"
	accesslocks = list(
		LOCKACCESS_OLD_CLAN_TZI
	)

/obj/item/vamp/keys/malkav
	name = "insane keys"
	accesslocks = list(
		LOCKACCESS_MALK
	)
	color = "#8cc4ff"

/obj/item/vamp/keys/malkav/primogen
	name = "really insane keys"
	accesslocks = list(
		LOCKACCESS_MALK_PRIMOGEN,
		LOCKACCESS_MALK,
		LOCKACCESS_PRIMOGEN,
		LOCKACCESS_JAZZ_CLUB,
		LOCKACCESS_CAMARILLA,
		LOCKACCESS_JAZZ_CLUB_DELIVERY,
	)
	color = "#2c92ff"

/obj/item/vamp/keys/toreador
	name = "sexy keys"
	accesslocks = list(
		LOCKACCESS_TOREADOR,
		"toreador1",
		"toreador2",
		"toreador3",
		"toreador4"
	)
	color = "#ffa7e6"

/obj/item/vamp/keys/banuhaqim
	name = "just keys"
	accesslocks = list(
		LOCKACCESS_BANU
	)
	color = "#06053d"

/obj/item/vamp/keys/banuhaqim/primogen
	name = "really just keys" // lol
	accesslocks = list(
		LOCKACCESS_JAZZ_CLUB,
		LOCKACCESS_THEATRE,
		LOCKACCESS_CAMARILLA,
		LOCKACCESS_BANU,
		LOCKACCESS_BANU_PRIMOGEN,
	)
/obj/item/vamp/keys/toreador/primogen
	name = "really sexy keys"
	accesslocks = list(
		LOCKACCESS_PRIMOGEN_TOREADOR,
		LOCKACCESS_TOREADOR,
		LOCKACCESS_PRIMOGEN,
		LOCKACCESS_JAZZ_CLUB,
		LOCKACCESS_CAMARILLA,
		LOCKACCESS_JAZZ_CLUB_DELIVERY,
	)
	color = "#ff2fc4"

/obj/item/vamp/keys/nosferatu
	name = "ugly keys"
	accesslocks = list(
		LOCKACCESS_NOSFERATU
	)
	color = "#93bc8e"

/obj/item/vamp/keys/nosferatu/primogen
	name = "really ugly keys"
	accesslocks = list(
		LOCKACCESS_PRIMOGEN_NOSFERATU,
		LOCKACCESS_NOSFERATU,
		LOCKACCESS_PRIMOGEN,
		LOCKACCESS_JAZZ_CLUB,
		LOCKACCESS_CAMARILLA,
		LOCKACCESS_JAZZ_CLUB_DELIVERY,
	)
	color = "#367c31"

/obj/item/vamp/keys/brujah
	name = "punk keys"
	accesslocks = list(
		LOCKACCESS_BRUJAH
	)
	color = "#ecb586"

/obj/item/vamp/keys/brujah/primogen
	name = "really punk keys"
	accesslocks = list(
		LOCKACCESS_PRIMOGEN_BRUJAH,
		LOCKACCESS_BRUJAH,
		LOCKACCESS_PRIMOGEN,
		LOCKACCESS_JAZZ_CLUB,
		LOCKACCESS_CAMARILLA
	)
	color = "#ec8f3e"

/obj/item/vamp/keys/ventrue
	name = "businessy keys"
	accesslocks = list(
		LOCKACCESS_VENTRUE,
		LOCKACCESS_JAZZ_CLUB
	)
	color = "#f6ffa7"

/obj/item/vamp/keys/ventrue/primogen
	name = "really businessy keys"
	accesslocks = list(
		LOCKACCESS_PRIMOGEN_VENTRUE,
		LOCKACCESS_VENTRUE,
		LOCKACCESS_JAZZ_CLUB,
		LOCKACCESS_PRIMOGEN,
		LOCKACCESS_CAMARILLA,
		LOCKACCESS_JAZZ_CLUB_DELIVERY,
	)
	color = "#e8ff29"

/obj/item/vamp/keys/cappadocian
	name = "eroded keys"
	accesslocks = list(
		LOCKACCESS_CAPPADOCIAN
	)
	color = "#99620e"

/obj/item/vamp/keys/sabbat
	name = "dirty keys"
	accesslocks = list(
		LOCKACCESS_SABBAT
	)
	color = "#6a2e1d"

/obj/item/vamp/keys/setite
	name = "setite keys"
	accesslocks = list(
		LOCKACCESS_SETITE
	)

//===========================CLINIC KEYS===========================
/obj/item/vamp/keys/clinic
	name = "clinic keys"
	accesslocks = list(
		LOCKACCESS_CLINIC
	)

/obj/item/vamp/keys/clinics_director
	name = "clinic director keys"
	accesslocks = list(
		LOCKACCESS_CLINIC,
		LOCKACCESS_DIRECTOR
	)

//===========================POLICE KEYS===========================
/obj/item/vamp/keys/police
	name = "police keys"
	accesslocks = list(
		LOCKACCESS_POLICE
	)

/obj/item/vamp/keys/police/federal
	name = "federal agent keys"
	accesslocks = list(
		LOCKACCESS_POLICE,
		LOCKACCESS_FEDERAL
	)

/obj/item/vamp/keys/dispatch
	name = "dispatcher keys"
	accesslocks = list(
		LOCKACCESS_DISPATCH
	)

/obj/item/vamp/keys/police/secure
	name = "sergeant police keys"
	accesslocks = list(
		LOCKACCESS_POLICE,
		LOCKACCESS_POLICE_SECURE
	)

/obj/item/vamp/keys/police/secure/captain
	name = "police captain keys"
	accesslocks = list(
		LOCKACCESS_DISPATCH,
		LOCKACCESS_POLICE,
		LOCKACCESS_POLICE_SECURE,
		LOCKACCESS_POLICE_CAPTAIN
	)

//===========================FERA KEYS===========================

/obj/item/vamp/keys/nps
	name = "\improper Park Service keys"
	accesslocks = list(
		LOCKACCESS_PARK_RANGER
	)
	color = "#1e7531"

/obj/item/vamp/keys/techstore
	name = "tech store keys"
	accesslocks = list(
		LOCKACCESS_WOLFTECH
	)
	color = "#466a72"

/obj/item/vamp/keys/pentex
	name = "\improper " + MAIN_EVIL_COMPANY + " facility keys"
	accesslocks = list(
		LOCKACCESS_PENTEX
	)
	color = "#062e03"

/obj/item/vamp/keys/pentex/leader
	name = "\improper " + MAIN_EVIL_COMPANY + " management keys"
	accesslocks = list(
		LOCKACCESS_PENTEX,
		LOCKACCESS_PENTEX_LEADER
	)
	color = "#062e03"

/obj/item/vamp/keys/children_of_gaia
	name = "food pantry keys"
	accesslocks = list(
		LOCKACCESS_COGGIE
	)
	color = "#339933"

//===========================MISC KEYS===========================

/obj/item/vamp/keys/triads
	name = "rusty keys"
	accesslocks = list(
		LOCKACCESS_TRAID,
		LOCKACCESS_LAUNDROMAT
	)

/obj/item/vamp/keys/graveyard
	name = "graveyard keys"
	accesslocks = list(
		LOCKACCESS_GRAVEYARD
	)

/obj/item/vamp/keys/cleaning
	name = "cleaning keys"
	accesslocks = list(
		LOCKACCESS_CLEANING
	)

/obj/item/vamp/keys/church
	name = "church keys"
	accesslocks = list(
		LOCKACCESS_CHURCH
	)

/obj/item/vamp/keys/hunter
	name = "strange keys"
	accesslocks = list(
		LOCKACCESS_HUNTER
	)

/obj/item/vamp/keys/kiasyd
	name = "museum keys"
	accesslocks = list(
		LOCKACCESS_KIASYD
	)

/obj/item/vamp/keys/supply
	name = "supply keys"
	accesslocks = list(
		LOCKACCESS_SUPPLY
	)
	color = "#434343"

/obj/item/vamp/keys/strip
	name = "strip keys"
	accesslocks = list(
		LOCKACCESS_STRIP
	)

/obj/item/vamp/keys/taxi
	name = "taxi keys"
	accesslocks = list(
		LOCKACCESS_TAXI
	)
	color = "#fffb8b"

/obj/item/vamp/keys/apartment
	name = "apartment keys"
	desc = "The key to someone's home. Hope it's not lost."
	accesslocks = list(
		"apartment"
	)

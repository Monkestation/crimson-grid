/// Index to a define to point at a runtime-global list at compile-time.
#define NETWORK_ID 1
/// Index to a string, for the contact title.
#define OUR_ROLE 2
/// Index to a boolean, on whether to replace role with job title (or alt-title).
#define USE_JOB_TITLE 3

/obj/item/smartphone/prince
	contact_networks_pre_init = list(
		alist(NETWORK_ID = MILLENIUM_TOWER_NETWORK, OUR_ROLE = "C.E.O.", USE_JOB_TITLE = FALSE)
		, alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "TransAmerica Corporation C.E.O.", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/seneschal
	contact_networks_pre_init = list(
		alist(NETWORK_ID = MILLENIUM_TOWER_NETWORK, OUR_ROLE = "C.O.O.", USE_JOB_TITLE = FALSE)
		, alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "TransAmerica Corporation C.O.O", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/sheriff
	contact_networks_pre_init = list(
		alist(NETWORK_ID = MILLENIUM_TOWER_NETWORK, OUR_ROLE = "Head of Security", USE_JOB_TITLE = FALSE)
		, alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Millenium Group Head of Security", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/harpy
	contact_networks_pre_init = list(
		alist(NETWORK_ID = MILLENIUM_TOWER_NETWORK, OUR_ROLE = "Public Relations", USE_JOB_TITLE = FALSE)
		, alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Millenium Group Public Relations", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/hound
	contact_networks_pre_init = list(
		alist(NETWORK_ID = MILLENIUM_TOWER_NETWORK, OUR_ROLE = "Tower Security", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/tower_employee
	contact_networks_pre_init = list(
		alist(NETWORK_ID = MILLENIUM_TOWER_NETWORK, OUR_ROLE = "Tower Employee", USE_JOB_TITLE = TRUE)
		)

// VENTRUE

/obj/item/smartphone/ventrue_primo
	important_contact_of = VAMPIRE_CLAN_VENTRUE
	contact_networks_pre_init = list(
		alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Crown Blue Jazz Club Owner", USE_JOB_TITLE = FALSE)
		)

// TOREADOR

/obj/item/smartphone/toreador_primo
	important_contact_of = VAMPIRE_CLAN_TOREADOR
	contact_networks_pre_init = list(
		alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = (PRIMARY_NIGHTCLUB_COMPANY + " Night Club Owner"), USE_JOB_TITLE = FALSE)
		)

// NOSFERATU

/obj/item/smartphone/nosferatu_primo
	important_contact_of = VAMPIRE_CLAN_NOSFERATU
	contact_networks_pre_init = list(
		alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Utility Administrator", USE_JOB_TITLE = FALSE)
		)

// MALKAVIAN

/obj/item/smartphone/malkavian_primo
	important_contact_of = VAMPIRE_CLAN_MALKAVIAN
	contact_networks_pre_init = list(
		alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Hospital Administrator", USE_JOB_TITLE = FALSE)
		)

// LASOMBRA

/obj/item/smartphone/lasombra_primo
	important_contact_of = VAMPIRE_CLAN_LASOMBRA
	contact_networks_pre_init = list(
		alist(NETWORK_ID = LASOMBRA_NETWORK, OUR_ROLE = "Church Administrator", USE_JOB_TITLE = FALSE)
		, alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Church Administrator", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/lasombra_caretaker
	contact_networks_pre_init = list(
		alist(NETWORK_ID = LASOMBRA_NETWORK, OUR_ROLE = "Church Caretaker", USE_JOB_TITLE = FALSE)
		)

// BANU HAQIM

/obj/item/smartphone/banu_primo
	important_contact_of = VAMPIRE_CLAN_BANU_HAQIM
	contact_networks_pre_init = list(
		alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "SFPD Civilian Consultant", USE_JOB_TITLE = FALSE)
		)

// TREMERE

/obj/item/smartphone/tremere_regent
	important_contact_of = VAMPIRE_CLAN_TREMERE
	contact_networks_pre_init = list(
		alist(NETWORK_ID = TREMERE_NETWORK, OUR_ROLE = "Library Manager", USE_JOB_TITLE = FALSE)
		, alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Library Manager", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/archivist
	contact_networks_pre_init = list(
		alist(NETWORK_ID = TREMERE_NETWORK, OUR_ROLE = "Library Archivist", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/gargoyle
	contact_networks_pre_init = list(
		alist(NETWORK_ID = TREMERE_NETWORK, OUR_ROLE = "Library Maintenance", USE_JOB_TITLE = FALSE)
		)

// GIOVANNI

/obj/item/smartphone/giovanni_capo
	important_contact_of = VAMPIRE_CLAN_GIOVANNI
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GIOVANNI_NETWORK, OUR_ROLE = "Bank Manager", USE_JOB_TITLE = FALSE)
		, alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Bank Manager", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/giovanni_squadra
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GIOVANNI_NETWORK, OUR_ROLE = "Bank Security", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/giovanni_famiglia
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GIOVANNI_NETWORK, OUR_ROLE = "Bank Employee", USE_JOB_TITLE = FALSE)
		)

// TZMISCE

/obj/item/smartphone/voivode
	important_contact_of = VAMPIRE_CLAN_TZIMISCE
	contact_networks_pre_init = list(
		alist(NETWORK_ID = TZMISCE_NETWORK, OUR_ROLE = "Lord of the Manor", USE_JOB_TITLE = FALSE)
		, alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Lord of the Manor", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/bogatyr
	contact_networks_pre_init = list(
		alist(NETWORK_ID = TZMISCE_NETWORK, OUR_ROLE = "Resident of the Manor", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/zadruga
	contact_networks_pre_init = list(
		alist(NETWORK_ID = TZMISCE_NETWORK, OUR_ROLE = "Servant of the Manor", USE_JOB_TITLE = FALSE)
		)

// ANARCHS

/obj/item/smartphone/baron
	contact_networks_pre_init = list(
		alist(NETWORK_ID = ANARCH_NETWORK, OUR_ROLE = "Club Manager", USE_JOB_TITLE = FALSE)
		, alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Anarchy Rose Club Manager", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/emissary
	contact_networks_pre_init = list(
		alist(NETWORK_ID = ANARCH_NETWORK, OUR_ROLE = "Club Representative", USE_JOB_TITLE = FALSE)
		, alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Anarchy Rose Club Representative", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/bruiser
	contact_networks_pre_init = list(
		alist(NETWORK_ID = ANARCH_NETWORK, OUR_ROLE = "Club Bouncer", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/sweeper
	contact_networks_pre_init = list(
		alist(NETWORK_ID = ANARCH_NETWORK, OUR_ROLE = "Club Bartender", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/liaison
	contact_networks_pre_init = list(
		alist(NETWORK_ID = ANARCH_NETWORK, OUR_ROLE = "Club Promotor", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/tapster
	contact_networks_pre_init = list(
		alist(NETWORK_ID = ANARCH_NETWORK, OUR_ROLE = "Club Bartender", USE_JOB_TITLE = FALSE)
		)

// SUPPLY

/obj/item/smartphone/supply_tech
	contact_networks_pre_init = list(
		alist(NETWORK_ID = SUPPLY_NETWORK, OUR_ROLE = "Supply Technician", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/dealer
	contact_networks_pre_init = list(
		alist(NETWORK_ID = SUPPLY_NETWORK, OUR_ROLE = "Supply Manager", USE_JOB_TITLE = FALSE),
		alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Warehouse Manager", USE_JOB_TITLE = FALSE)
	)

// ENDRON

/obj/item/smartphone/endron_lead
	contact_networks_pre_init = list(
		alist(NETWORK_ID = ENDRON_NETWORK, OUR_ROLE = "Endron Branch Lead", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/endron_exec
	contact_networks_pre_init = list(
		alist(NETWORK_ID = ENDRON_NETWORK, OUR_ROLE = "Endron Executive", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/endron_affairs
	contact_networks_pre_init = list(
		alist(NETWORK_ID = ENDRON_NETWORK, OUR_ROLE = "Endron Internal Affairs Agent", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/endron_sec_chief
	contact_networks_pre_init = list(
		alist(NETWORK_ID = ENDRON_NETWORK, OUR_ROLE = "Endron Chief of Security", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/endron_security
	contact_networks_pre_init = list(
		alist(NETWORK_ID = ENDRON_NETWORK, OUR_ROLE = "Endron Security Agent", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/endron_employee
	contact_networks_pre_init = list(
		alist(NETWORK_ID = ENDRON_NETWORK, OUR_ROLE = "Endron Employee", USE_JOB_TITLE = TRUE)
		)

#undef NETWORK_ID
#undef OUR_ROLE
#undef USE_JOB_TITLE

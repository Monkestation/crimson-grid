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
		alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Asylum Administrator", USE_JOB_TITLE = FALSE)		// CRIMSON EDIT — Original: OUR_ROLE = "Hospital Administrator"
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

/obj/item/smartphone/giovanni_nonni
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GIOVANNI_NETWORK, OUR_ROLE = "Bank Shareholder", USE_JOB_TITLE = FALSE)
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
		alist(NETWORK_ID = ANARCH_NETWORK, OUR_ROLE = "Club Promoter", USE_JOB_TITLE = FALSE)
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

/obj/item/smartphone/novice
	contact_networks_pre_init = list(
		alist(NETWORK_ID = SOCIETY_OF_LEOPOLD_NETWORK, OUR_ROLE = "Novice", USE_JOB_TITLE = TRUE)
		)

/obj/item/smartphone/condottieri
	contact_networks_pre_init = list(
		alist(NETWORK_ID = SOCIETY_OF_LEOPOLD_NETWORK, OUR_ROLE = "Condottieri", USE_JOB_TITLE = TRUE)
		)

/obj/item/smartphone/inquisitor
	contact_networks_pre_init = list(
		alist(NETWORK_ID = SOCIETY_OF_LEOPOLD_NETWORK, OUR_ROLE = "Inquisitor", USE_JOB_TITLE = TRUE)
		)

/obj/item/smartphone/abbe
	contact_networks_pre_init = list(
		alist(NETWORK_ID = SOCIETY_OF_LEOPOLD_NETWORK, OUR_ROLE = "Abbé", USE_JOB_TITLE = TRUE)
		)

// CIVILIAN

/obj/item/smartphone/janitor
	contact_networks_pre_init = list(
		alist(NETWORK_ID = CIVILIAN_NETWORK, OUR_ROLE = "Janitor", USE_JOB_TITLE = TRUE)
		)

/obj/item/smartphone/taxi
	contact_networks_pre_init = list(
		alist(NETWORK_ID = CIVILIAN_NETWORK, OUR_ROLE = "Taxi Driver", USE_JOB_TITLE = TRUE)
		)

/obj/item/smartphone/club_worker
	contact_networks_pre_init = list(
		alist(NETWORK_ID = CIVILIAN_NETWORK, OUR_ROLE = "Club Worker", USE_JOB_TITLE = TRUE)
		)

/obj/item/smartphone/priest
	contact_networks_pre_init = list(
		alist(NETWORK_ID = CIVILIAN_NETWORK, OUR_ROLE = "Priest", USE_JOB_TITLE = TRUE)
		)

/obj/item/smartphone/clinic_director
	contact_networks_pre_init = list(
		alist(NETWORK_ID = MEDICAL_NETWORK, OUR_ROLE = "Clinic Director", USE_JOB_TITLE = TRUE)
		)

/obj/item/smartphone/red_news
	contact_networks_pre_init = list(
		alist(NETWORK_ID = MEDICAL_NETWORK, OUR_ROLE = "Red News Reporter", USE_JOB_TITLE = TRUE)
		)

/obj/item/smartphone/doctor
	contact_networks_pre_init = list(
		alist(NETWORK_ID = MEDICAL_NETWORK, OUR_ROLE = "Clinic Staff", USE_JOB_TITLE = FALSE)
		)

// SEPT

/obj/item/smartphone/garou_council
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GAROU_NETWORK, OUR_ROLE = "NPS Oversight Committee", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/garou_guardian
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GAROU_NETWORK, OUR_ROLE = "Park Ranger", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/garou_truthcatcher
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GAROU_NETWORK, OUR_ROLE = "Park Guide", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/garou_warder
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GAROU_NETWORK, OUR_ROLE = "Lead Park Ranger", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/garou_wyrmfoe
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GAROU_NETWORK, OUR_ROLE = "NPS Biologist", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/garou_keeper
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GAROU_NETWORK, OUR_ROLE = "Park Staff", USE_JOB_TITLE = FALSE)
		)

// POLICE

/obj/item/smartphone/police_captain
	contact_networks_pre_init = list(
		alist(NETWORK_ID = POLICE_NETWORK, OUR_ROLE = "SFPD Captain", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/dispatch
	contact_networks_pre_init = list(
		alist(NETWORK_ID = POLICE_NETWORK, OUR_ROLE = "Emergency Dispatcher", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/federal_investigator
	contact_networks_pre_init = list(
		alist(NETWORK_ID = POLICE_NETWORK, OUR_ROLE = "Federal Investigator", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/police_officer
	contact_networks_pre_init = list(
		alist(NETWORK_ID = POLICE_NETWORK, OUR_ROLE = "SFPD Officer", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/police_sergeant
	contact_networks_pre_init = list(
		alist(NETWORK_ID = POLICE_NETWORK, OUR_ROLE = "SFPD Sergeant", USE_JOB_TITLE = FALSE)
		)

// SABBAT

/obj/item/smartphone/sabbat_ductus
	contact_networks_pre_init = list(
		alist(NETWORK_ID = SABBAT_NETWORK, OUR_ROLE = "Shift Manager", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/sabbat_pack
	contact_networks_pre_init = list(
		alist(NETWORK_ID = SABBAT_NETWORK, OUR_ROLE = "Dipshit Co-worker", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/sabbat_priest
	contact_networks_pre_init = list(
		alist(NETWORK_ID = SABBAT_NETWORK, OUR_ROLE = "Assistant Manager", USE_JOB_TITLE = FALSE)
		)

// CRIMSON EDIT ADD - Triads and Rolelocks

/obj/item/smartphone/brujah_primo
	important_contact_of = VAMPIRE_CLAN_BRUJAH
	contact_networks_pre_init = list(
		alist(NETWORK_ID = VAMPIRE_LEADER_NETWORK, OUR_ROLE = "Gym Owner", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/garou_keeper
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GAROU_NETWORK, OUR_ROLE = "Park Staff", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/mountain_master
	contact_networks_pre_init = list(
		alist(NETWORK_ID = TRIAD_NETWORK, OUR_ROLE = "Big Boss", USE_JOB_TITLE = FALSE),
		alist(NETWORK_ID = SUPPLY_NETWORK, OUR_ROLE = "Chinatown Realtor", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/deputy_mountain_master
	contact_networks_pre_init = list(
		alist(NETWORK_ID = TRIAD_NETWORK, OUR_ROLE = "Deputy Big Boss", USE_JOB_TITLE = FALSE),
		alist(NETWORK_ID = SUPPLY_NETWORK, OUR_ROLE = "Chinatown Broker", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/red_pole
	contact_networks_pre_init = list(
		alist(NETWORK_ID = TRIAD_NETWORK, OUR_ROLE = "Chinatown Protection", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/blue_lantern
	contact_networks_pre_init = list(
		alist(NETWORK_ID = TRIAD_NETWORK, OUR_ROLE = "Chinatown Shopkeep", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/clinic_officer
	contact_networks_pre_init = list(
		alist(NETWORK_ID = MEDICAL_NETWORK, OUR_ROLE = "Clinic Orderly", USE_JOB_TITLE = FALSE)
		)
// CRIMSON EDIT ADD END - Triads and Rolelocks


#undef NETWORK_ID
#undef OUR_ROLE
#undef USE_JOB_TITLE

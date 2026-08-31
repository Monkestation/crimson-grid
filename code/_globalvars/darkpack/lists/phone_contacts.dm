// Important Contacts

GLOBAL_LIST_EMPTY(phones_list)
GLOBAL_LIST_EMPTY(important_contacts)

// Contact Networks

GLOBAL_LIST_EMPTY(millenium_tower_network)
GLOBAL_LIST_EMPTY(lasombra_network)
GLOBAL_LIST_EMPTY(tremere_network)
GLOBAL_LIST_EMPTY(giovanni_network)
GLOBAL_LIST_EMPTY(tzmisce_network)
GLOBAL_LIST_EMPTY(anarch_network)
GLOBAL_LIST_EMPTY(supply_network)
GLOBAL_LIST_EMPTY(vampire_leader_network)
GLOBAL_LIST_EMPTY(endron_network)
GLOBAL_LIST_EMPTY(society_network)
GLOBAL_LIST_EMPTY(society_of_leopold_network)
GLOBAL_LIST_EMPTY(civilian_network)
GLOBAL_LIST_EMPTY(police_network)
GLOBAL_LIST_EMPTY(medical_network)
GLOBAL_LIST_EMPTY(garou_network)
GLOBAL_LIST_EMPTY(sabbat_network)
// CRIMSON EDIT ADD - Triad
GLOBAL_LIST_EMPTY(triad_network)
// CRIMSON EDIT END - Triad

#define MILLENIUM_TOWER_NETWORK 1
#define LASOMBRA_NETWORK 2
#define TREMERE_NETWORK 3
#define GIOVANNI_NETWORK 4
#define TZMISCE_NETWORK 5
#define ANARCH_NETWORK 6
#define SUPPLY_NETWORK 7
#define VAMPIRE_LEADER_NETWORK 8
#define ENDRON_NETWORK 9
#define SOCIETY_OF_LEOPOLD_NETWORK 10
#define CIVILIAN_NETWORK 11
#define POLICE_NETWORK 12
#define MEDICAL_NETWORK 13
#define GAROU_NETWORK 14
#define SABBAT_NETWORK 15
// CRIMSON EDIT ADD - Triads
#define TRIAD_NETWORK 16
// CRIMSON EDIT END - Triads

// An indexed list of all the different phone networks that connect the phones that are part of them together.
GLOBAL_LIST_INIT(contact_networks, alist(
		MILLENIUM_TOWER_NETWORK = GLOB.millenium_tower_network,
		LASOMBRA_NETWORK = GLOB.lasombra_network,
		TREMERE_NETWORK = GLOB.tremere_network,
		GIOVANNI_NETWORK = GLOB.giovanni_network,
		TZMISCE_NETWORK = GLOB.tzmisce_network,
		ANARCH_NETWORK = GLOB.anarch_network,
		SUPPLY_NETWORK = GLOB.supply_network,
		VAMPIRE_LEADER_NETWORK = GLOB.vampire_leader_network,
		ENDRON_NETWORK = GLOB.endron_network,
		SOCIETY_OF_LEOPOLD_NETWORK = GLOB.society_network,
		CIVILIAN_NETWORK = GLOB.civilian_network,
		POLICE_NETWORK = GLOB.police_network,
		MEDICAL_NETWORK = GLOB.medical_network,
		GAROU_NETWORK = GLOB.garou_network,
		SABBAT_NETWORK = GLOB.sabbat_network,
		// CRIMSON EDIT ADD - Triads
		TRIAD_NETWORK = GLOB.triad_network,
		// CRIMSON EDIT END - Triads
	))

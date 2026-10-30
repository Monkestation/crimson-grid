// Add police leadership and FBI to the law enforcement liaison network along with the Ranger leadership.
// Overrides modular_darkpack/modules/phones/code/phone_subtypes.dm

// phone_subtypes undefines these at end of file, so we need to redefine them for a bit
#define NETWORK_ID 1
#define OUR_ROLE 2
#define USE_JOB_TITLE 3

/obj/item/smartphone/police_captain
	contact_networks_pre_init = list(
		alist(NETWORK_ID = POLICE_NETWORK, OUR_ROLE = "SFPD Captain", USE_JOB_TITLE = FALSE),
		alist(NETWORK_ID = LAW_ENFORCEMENT_LIAISON_NETWORK, OUR_ROLE = "SFPD Captain", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/police_sergeant
	contact_networks_pre_init = list(
		alist(NETWORK_ID = POLICE_NETWORK, OUR_ROLE = "SFPD Sergeant", USE_JOB_TITLE = FALSE),
		alist(NETWORK_ID = LAW_ENFORCEMENT_LIAISON_NETWORK, OUR_ROLE = "SFPD Sergeant", USE_JOB_TITLE = FALSE)
		)

/obj/item/smartphone/federal_investigator
	contact_networks_pre_init = list(
		alist(NETWORK_ID = POLICE_NETWORK, OUR_ROLE = "Federal Investigator", USE_JOB_TITLE = FALSE),
		alist(NETWORK_ID = LAW_ENFORCEMENT_LIAISON_NETWORK, OUR_ROLE = "Federal Investigator", USE_JOB_TITLE = FALSE)
		)

#undef NETWORK_ID
#undef OUR_ROLE
#undef USE_JOB_TITLE

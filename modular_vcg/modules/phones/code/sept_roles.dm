// Override Sept job titles.

// phone_subtypes undefines these at end of file, so we need to redefine them for a bit
#define NETWORK_ID 1
#define OUR_ROLE 2
#define USE_JOB_TITLE 3

/* /obj/item/smartphone/garou_council // Currently unmodified.
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GAROU_NETWORK, OUR_ROLE = "NPS Oversight Committee", USE_JOB_TITLE = FALSE)
		) */

/obj/item/smartphone/garou_guardian
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GAROU_NETWORK, OUR_ROLE = "NPS Ranger", USE_JOB_TITLE = FALSE), // Make Ranger titles consistently include NPS.
		alist(NETWORK_ID = LAW_ENFORCEMENT_LIAISON_NETWORK, OUR_ROLE = "NPS Ranger", USE_JOB_TITLE = FALSE) // Share contacts with police sergeant/captain and FBI
		)

/obj/item/smartphone/garou_truthcatcher
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GAROU_NETWORK, OUR_ROLE = "NPS Special Agent", USE_JOB_TITLE = FALSE), // Why on earth was the Truthcatcher a mere park guide?
		alist(NETWORK_ID = LAW_ENFORCEMENT_LIAISON_NETWORK, OUR_ROLE = "NPS Special Agent", USE_JOB_TITLE = FALSE) // Share contacts with police sergeant/captain and FBI
		)

/obj/item/smartphone/garou_warder
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GAROU_NETWORK, OUR_ROLE = "NPS Chief Ranger", USE_JOB_TITLE = FALSE), // Warder ranks up from Lead to Chief, because the Wyrmfoe is no longer a 'biologist'.
		alist(NETWORK_ID = LAW_ENFORCEMENT_LIAISON_NETWORK, OUR_ROLE = "NPS Chief Ranger", USE_JOB_TITLE = FALSE) // Share contacts with police sergeant/captain and FBI
		)

/obj/item/smartphone/garou_wyrmfoe
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GAROU_NETWORK, OUR_ROLE = "NPS Lead Ranger", USE_JOB_TITLE = FALSE), // Why were Guardians and the Warder rated Rangers but not the Wyrmfoe? Bizarre.
		alist(NETWORK_ID = LAW_ENFORCEMENT_LIAISON_NETWORK, OUR_ROLE = "NPS Lead Ranger", USE_JOB_TITLE = FALSE) // Share contacts with police sergeant/captain and FBI
		)

/* /obj/item/smartphone/garou_keeper // Currently unmodified.
	contact_networks_pre_init = list(
		alist(NETWORK_ID = GAROU_NETWORK, OUR_ROLE = "Park Staff", USE_JOB_TITLE = FALSE)
		) */

#undef NETWORK_ID
#undef OUR_ROLE
#undef USE_JOB_TITLE

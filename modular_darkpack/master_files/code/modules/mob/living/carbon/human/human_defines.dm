/mob/living/carbon/human
	// Humans have a default bloodpool of 10
	maxbloodpool = 10
	bloodpool = 10
	mob_flags = MOB_HAS_SCREENTIPS_NAME_OVERRIDE
	// NPC humans get the area of effect, player humans dont.
	var/violation_aoe = FALSE
	/// List of ownership types the player has claimed keys for (e.g., "apartment", "car")
	var/list/received_ownership_keys = list()
	// Visible adjectives, used for Guestbooks.
	var/visible_adjective = ""

	///Where this mob comes from
	var/country_of_origin

	/// A datum that tracks all the information at the time of there death. Used for powers that tell you the sitatuons of there demise.
	var/datum/death_report/last_death_info

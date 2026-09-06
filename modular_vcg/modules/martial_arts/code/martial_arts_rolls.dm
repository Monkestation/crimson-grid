//Seperated by Brawl/Melee & Defending/Attacking. We have these seperated from /attack/punch due to being numerical-based.
/datum/storyteller_roll/brawl_strength
	bumper_text = "martial (strength)"
	spammy_roll = TRUE
	applicable_stats = list(STAT_STRENGTH, STAT_BRAWL)
	numerical = TRUE
	roll_output_type = ROLL_PRIVATE_AND_TARGET

/datum/storyteller_roll/brawl_dex
	bumper_text = "martial (dexterity)"
	numerical = TRUE
	spammy_roll = TRUE
	applicable_stats = list(STAT_DEXTERITY, STAT_BRAWL)

/datum/storyteller_roll/brawl_special
	bumper_text = "attack"
	numerical = TRUE
	spammy_roll = TRUE
	applicable_stats = list(STAT_DEXTERITY, STAT_BRAWL)

/datum/storyteller_roll/brawl_defend
	bumper_text = "resisting"
	spammy_roll = TRUE
	numerical = TRUE
	applicable_stats = list(STAT_STAMINA)

/datum/storyteller_roll/brawl_defend/athletics
	applicable_stats = list(STAT_STAMINA, STAT_ATHLETICS)

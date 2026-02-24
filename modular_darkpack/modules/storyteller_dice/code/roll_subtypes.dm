// Pretty generic ones for reuse if you dont really want/need a subtype
/datum/storyteller_roll/turn_cooldown
	reroll_cooldown = 1 TURNS

/datum/storyteller_roll/scene_cooldown
	reroll_cooldown = 1 SCENES

/datum/storyteller_roll/spammy
	spammy_roll = TRUE

// Mostly TTRPG accurate rolls

// Combat
/datum/storyteller_roll/attack
	bumper_text = "attack"
	spammy_roll = TRUE
	applicable_stats = list(STAT_DEXTERITY, STAT_BRAWL)

/datum/storyteller_roll/attack/punch
	bumper_text = "attack (punch)"

/datum/storyteller_roll/attack/bite
	bumper_text = "attack (bite)"
	difficulty = 5

/datum/storyteller_roll/attack/kick
	bumper_text = "attack (kick)"
	difficulty = 7

/datum/storyteller_roll/attack/claw
	bumper_text = "attack (claw)"

/datum/storyteller_roll/attack/sweep
	bumper_text = "attack (sweep)"
	difficulty = 8


/datum/storyteller_roll/damage
	bumper_text = "damage"
	numerical = TRUE
	spammy_roll = TRUE
	applicable_stats = list(STAT_STRENGTH)

/datum/storyteller_roll/damage/punch
	bumper_text = "damage (punch)"

/datum/storyteller_roll/damage/bite
	bumper_text = "damage (bite)"
	// + 1

/datum/storyteller_roll/damage/kick
	bumper_text = "damage (kick)"
	// + 1

/datum/storyteller_roll/damage/claw
	bumper_text = "damage (claw)"
	// + 2

// Physical Feats
/datum/storyteller_roll/lockpick
	bumper_text = "lockpicking"
	reroll_cooldown = 1 SCENES
	applicable_stats = list(STAT_DEXTERITY, STAT_LARCENY)

/datum/storyteller_roll/bash_door
	bumper_text = "bash door"
	reroll_cooldown = 1 SCENES
	applicable_stats = list(STAT_STRENGTH)

/datum/storyteller_roll/grappling
	bumper_text = "grappling"
	applicable_stats = list(STAT_STRENGTH, STAT_BRAWL)
	numerical = TRUE
	spammy_roll = TRUE

/datum/storyteller_roll/grappled
	bumper_text = "resisting"
	applicable_stats = list(STAT_STRENGTH, STAT_BRAWL)
	numerical = TRUE
	spammy_roll = TRUE

/datum/storyteller_roll/climbing
	bumper_text = "climbing"
	applicable_stats = list(STAT_DEXTERITY, STAT_ATHLETICS)

/datum/storyteller_roll/shooting
	bumper_text = "shooting"
	applicable_stats = list(STAT_DEXTERITY, STAT_FIREARMS)
	reroll_cooldown = 1 TURNS
	numerical = TRUE

// DARKPACK TODO - (Attacks need a rework on how they calcuate landing a hit.)
/datum/storyteller_roll/punch
	bumper_text = "punch"
	applicable_stats = list(STAT_DEXTERITY, STAT_BRAWL)
	spammy_roll = TRUE

/datum/storyteller_roll/damage
	bumper_text = "damage"
	applicable_stats = list(STAT_STRENGTH)
	numerical = TRUE
	spammy_roll = TRUE

// Mental Feats
/datum/storyteller_roll/investigation
	bumper_text = "investigation"
	applicable_stats = list(STAT_PERCEPTION, STAT_INVESTIGATION)


// Made up shittttt
/datum/storyteller_roll/identify_occult
	bumper_text = "identify"
	applicable_stats = list(STAT_INTELLIGENCE, STAT_OCCULT)
	reroll_cooldown = 1 SCENES

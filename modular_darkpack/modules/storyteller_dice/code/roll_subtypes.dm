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

/datum/storyteller_roll/damage/punch/calculate_used_dice(mob/living/roller, bonus)
	. = ..()
	if(HAS_TRAIT(roller, TRAIT_RAZOR_CLAWS)) // Your still using claws. A bit homebrew tho.
		. += 1

/datum/storyteller_roll/damage/bite
	bumper_text = "damage (bite)"
	// + 1

/datum/storyteller_roll/damage/kick
	bumper_text = "damage (kick)"
	// + 1

/datum/storyteller_roll/damage/claw
	bumper_text = "damage (claw)"
	// + 2

/datum/storyteller_roll/damage/claw/calculate_used_dice(mob/living/roller, bonus)
	. = ..()
	if(HAS_TRAIT(roller, TRAIT_RAZOR_CLAWS))
		. += 2

/* DARKPACK TODO - (Requires https://github.com/DarkPack13/SecondCity/pull/683)
/datum/storyteller_roll/damage/claw/calculate_used_difficulty(mob/living/roller)
	. = ..()
	if(HAS_TRAIT(roller, TRAIT_RAZOR_CLAWS))
		. -= 1
*/

/datum/storyteller_roll/shooting
	bumper_text = "shooting"
	applicable_stats = list(STAT_DEXTERITY, STAT_FIREARMS)
	reroll_cooldown = 1 TURNS
	numerical = TRUE

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

// Mental Feats
/datum/storyteller_roll/investigation
	bumper_text = "investigation"
	applicable_stats = list(STAT_PERCEPTION, STAT_INVESTIGATION)


// Made up shittttt
/datum/storyteller_roll/identify_occult
	bumper_text = "identify"
	applicable_stats = list(STAT_INTELLIGENCE, STAT_OCCULT)
	reroll_cooldown = 1 SCENES

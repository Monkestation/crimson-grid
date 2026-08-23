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
	alert_prefix = "⚔"
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
	// Ok listen I know this is just an emoji but it looks fine ingame.
	alert_prefix = "✊"
	alert_delay = 0.2 SECONDS
	applicable_stats = list(STAT_STRENGTH)

/datum/storyteller_roll/damage/punch
	bumper_text = "damage (punch)"

/datum/storyteller_roll/damage/punch/calculate_used_dice(mob/living/roller, bonus)
	. = ..()
	if(HAS_TRAIT(roller, TRAIT_RAZOR_CLAWS)) // Your still using claws. A bit homebrew tho.
		. += 1
	if(HAS_TRAIT(roller, TRAIT_BRASSKNUCKLES))	// Method for giving brass knuckles bonus punch damage. It's blunt, and punch damage is naturally low, so equals out.
		. += 2

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


/datum/storyteller_roll/tackle_attacker
	numerical = TRUE
	applicable_stats = list(STAT_STRENGTH, STAT_BRAWL)

/*
/datum/storyteller_roll/tackle_attacker/using_stats(mob/living/roller)
	. = ..()
	var/strength_brawl = roller.st_get_stat(STAT_STRENGTH) + roller.st_get_stat(STAT_BRAWL)
	var/dex_athletics = roller.st_get_stat(STAT_DEXTERITY) + roller.st_get_stat(STAT_ATHLETICS)
	if(strength_brawl >= dex_athletics)
		. = list(STAT_STRENGTH, STAT_BRAWL)
	else
		. = list(STAT_DEXTERITY, STAT_ATHLETICS)
*/

/datum/storyteller_roll/tackle_defender
	numerical = TRUE
	applicable_stats = list(STAT_DEXTERITY, STAT_ATHLETICS)

// Physical Feats
/datum/storyteller_roll/lockpick
	bumper_text = "lockpicking"
	reroll_cooldown = 1 SCENES
	applicable_stats = list(STAT_DEXTERITY, STAT_LARCENY)

/datum/storyteller_roll/bash_door
	bumper_text = "bash door"
	reroll_cooldown = 1 SCENES
	applicable_stats = list(STAT_STRENGTH)

/datum/storyteller_roll/bash_door/calculate_used_dice(mob/living/roller, bonus)
	. = ..()
	if(HAS_TRAIT(roller, TRAIT_HUGE_SIZE))
		. += 2

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
	roll_output_type = ROLL_PRIVATE


// Made up shittttt
/datum/storyteller_roll/identify_occult
	bumper_text = "identify"
	applicable_stats = list(STAT_INTELLIGENCE, STAT_OCCULT)
	reroll_cooldown = 1 SCENES
	difficulty = 8

/datum/storyteller_roll/restraint_break
	bumper_text = "breaking restraints"
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	reroll_cooldown = 1 TURNS
	difficulty = 9

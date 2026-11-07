// Modification of existing martial arts to make them work with claw attacks and still trigger combos. Combo damage and effects are not changed.

/datum/martial_art/cqc/kailindo
	name = "Kailindo"
	id = "Kailindo"
	help_verb = "Recall the Kailindo forms"

// returns TRUE if attacker's form has unarmed claw attacks (Lupus, Hispo, Crinos)
/datum/martial_art/cqc/kailindo/proc/has_natural_weapons(mob/living/attacker)
	return iscrinos(attacker) || ishispo(attacker) || islupus(attacker)

/datum/martial_art/cqc/kailindo/harm_act(mob/living/attacker, mob/living/defender)
	if(!has_natural_weapons(attacker))
		return ..() // Homid and Glabro are unaffected

	// Pass necksnap through to normal handler
	if(attacker.grab_state == GRAB_KILL && attacker.zone_selected == BODY_ZONE_HEAD && attacker.pulling == defender && defender.stat != DEAD)
		return ..()

	// Pass through legsweep to normal handler. This move also isn't listed on the normal help verb for some reason.
	if(attacker.resting && defender.stat != DEAD && defender.body_position == STANDING_UP)
		return ..()

	add_to_streak("H", defender)
	if(check_streak(attacker, defender)) // replace normal claw attack with combo move when the combo is complete
		return MARTIAL_ATTACK_SUCCESS
	return MARTIAL_ATTACK_INVALID // no combo, continues with standard claw attack. Has its own block check

/datum/martial_art/cqc/kailindo/get_style_help()
	. = list()
	. += "<b><i>You recall the forms of the shifting war-dance of the Stargazers: Kailindo.</i></b>"
	. += "[span_notice("Deceptive Wind")]: Grab Punch. Slam opponent into the ground, knocking them down."
	. += "[span_notice("Forceful Wind")]: Punch Punch. Knocks opponent away. Knocks out stunned opponents and does stamina damage."
	. += "[span_notice("Falling Tempest")]: Grab Grab. Locks opponents into a restraining position, disarm to knock them out with a chokehold."
	. += "[span_notice("Wrist Lock")]: Shove Grab. Decent stamina damage."
	. += "[span_notice("Tornado Kick")]: Shove Shove Punch. Mainly offensive move, huge damage and decent stamina damage."
	. += "[span_notice("Little Cyclone")]: Rest Punch. Sweeps an opponent's legs while laying down, knocks them down."
	. += "[span_notice("Chakra Strike")]: Punch head while strangling. Kills instantly."
	. += "[span_notice("Binding Wind")]: Throw mode on. Gives you a chance to block and sometimes counter melee attacks."

	. += "<b><i>In Lupus, Hispo and Crinos, unarmed attacks that don't finish a combo use your claws instead.</i></b>"

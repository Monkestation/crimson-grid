// V20 p.298 + W20 p.261

// Fleeing is used for either fox frenzies, or rotschreck
/mob/living/proc/enter_frenzy_mode(atom/target, fleeing = FALSE, source = "Unknown cause")
	if(HAS_TRAIT(src, TRAIT_IN_FRENZY))
		return
	if(IS_UNCONSCIOUS(src))
		return
	add_traits(list(TRAIT_IN_FRENZY, TRAIT_NOSOFTCRIT, TRAIT_ANALGESIA), FRENZY_TRAIT)
	message_admins("[ADMIN_LOOKUPFLW(src)] has entered frenzy[target ? " targeting [ADMIN_LOOKUPFLW(target)]": ""]. ([source])")
	log_combat(src, (src || target), "has frenzied on because of \"[source]\" on")

	if(fleeing)
		to_chat(src, span_danger("FLEE."))
	else
		to_chat(src, span_bolddanger("FRENZY."))

	SEND_SOUND(src, sound('modular_darkpack/modules/frenzy/sounds/frenzy.ogg', volume = 50))

	apply_status_effect(/datum/status_effect/frenzy, target)

	// This is assuming no other interaction happens to remove it before this.
	addtimer(CALLBACK(src, PROC_REF(exit_frenzy_mode)), 1 SCENES)

/mob/living/proc/exit_frenzy_mode()
	if(!HAS_TRAIT(src, TRAIT_IN_FRENZY))
		return
	remove_traits(list(TRAIT_IN_FRENZY, TRAIT_NOSOFTCRIT, TRAIT_ANALGESIA), FRENZY_TRAIT)
	log_message("exited frenzy.", LOG_ATTACK, color="red")

	remove_status_effect(/datum/status_effect/frenzy)

/datum/storyteller_roll/frenzy
	abstract_type = /datum/storyteller_roll/frenzy
	bumper_text = "frenzy"
	roll_output_type = ROLL_PRIVATE_AND_TARGET
	numerical = TRUE

/datum/storyteller_roll/frenzy/rotschreck
	bumper_text = "rotschrek"
	applicable_stats = list(STAT_COURAGE)

/datum/storyteller_roll/frenzy/kindred

// Specificly kindred as I dont really think brujah are meant to rotschreck easier.
/datum/storyteller_roll/frenzy/kindred/calculate_used_difficulty(mob/living/roller)
	. = ..()
	// V20 p.51
	if(HAS_TRAIT(roller, TRAIT_DIFFICULT_FRENZY))
		. += 2
	if(HAS_TRAIT(roller, TRAIT_UNCONTROLLABLE))
		. = 10

/datum/storyteller_roll/frenzy/kindred/calculate_used_dice(mob/living/roller, bonus)
	. = ..()
	if(HAS_TRAIT(roller, TRAIT_CALM_HEART))
		. += 2

/datum/storyteller_roll/frenzy/rage

/datum/storyteller_roll/frenzy/rage/calculate_used_difficulty(mob/living/roller)
	. = ..()
	if(HAS_TRAIT(roller, TRAIT_DIFFICULT_RAGE))
		. += 1


/mob/living/proc/trigger_rotschreck(atom/fire, difficulty = 6, successes = 0)
	if(IS_UNCONSCIOUS(src))
		return
	if(!get_kindred_splat(src))
		return

	var/datum/storyteller_roll/frenzy/rotschreck/frenzy_roll = new()
	frenzy_roll.difficulty = difficulty
	var/frenzy_result = frenzy_roll.st_roll(src, fire)
	if(frenzy_result <= 0)
		enter_frenzy_mode(fire, TRUE, "Rotshreck")
		return
	successes += frenzy_result
	if(successes >= 5)
		return

	addtimer(CALLBACK(src, PROC_REF(trigger_rotschreck), fire, difficulty, successes), 1 TURNS)


/mob/living/proc/trigger_kindred_frenzy(atom/target, difficulty = 6, successes = 0, flavor_text = "Something")
	if(IS_UNCONSCIOUS(src))
		return
	if(!get_kindred_splat(src))
		return

	var/stat_to_roll = is_enlightenment() ? STAT_INSTINCT : STAT_SELF_CONTROL
	var/datum/storyteller_roll/frenzy/kindred/frenzy_roll = new()
	frenzy_roll.applicable_stats = list(stat_to_roll)
	frenzy_roll.difficulty = difficulty
	var/frenzy_result = frenzy_roll.st_roll(src, target)
	if(frenzy_result <= 0)
		to_chat(src, span_userdanger("[flavor_text] sends you into a frenzy!"))
		var/victim = get_closest_atom(/atom, get_frenzy_victims(), src)
		enter_frenzy_mode(victim, source = "Kindred")
		return

	successes += frenzy_result
	if(successes >= 5)
		to_chat(src, span_green("[flavor_text] almost drives you into frenzy but you steel your nerves and it subsides!"))
		return

	addtimer(CALLBACK(src, PROC_REF(trigger_kindred_frenzy), target, difficulty, successes, flavor_text), 1 TURNS)


/mob/living/proc/trigger_rage_frenzy(atom/target, difficulty = 6, successes = 0)
	if(IS_UNCONSCIOUS(src))
		return
	var/datum/splat/werewolf/shifter/shifter_splat = get_shifter_splat(src)
	if(!shifter_splat)
		return

	var/datum/storyteller_roll/frenzy/rage/frenzy_roll = new()
	frenzy_roll.difficulty = difficulty
	var/frenzy_result = frenzy_roll.st_roll(src, target, shifter_splat.rage)
	if(frenzy_result >= 5)
		enter_frenzy_mode(target, TRUE, "Rage")
	return frenzy_result


GAME_VERB_PROC_DESC(/mob/living/carbon/human, manual_frenzy_roll, "Manual Frenzy Roll", "Trigger a roll for a frenzy", null)
	VERB_ARG_TYPED(AM, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_VIEW, /mob/living)

	if(!istype(AM))
		return
	if(!issupernatural(src))
		return

	if(get_shifter_splat(src))
		trigger_rage_frenzy(AM)
	else if(get_vampire_splat(src))
		trigger_kindred_frenzy(AM)

// Used by the berserker merit. or possibly even for that one vampire thing of riding the frenzy in future?
GAME_VERB_PROC_DESC(/mob/living/carbon/human, manual_frenzy, "Manual Frenzy", "Enter a frenzy at will", null)
	VERB_ARG_TYPED(AM, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_VIEW, /mob/living)

	if(!istype(AM))
		return
	if(!issupernatural(src))
		return

	enter_frenzy_mode(AM, source = "Manual")

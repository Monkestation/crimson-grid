/datum/quirk/darkpack/seizures
	name = "Seizures"
	desc = {"When you're under the gun, you lose control of your body.
	When you botch an important roll, make a Willpower check (difficulty 8).
	Scoring less than three successes makes you writhe uncontrollably."}
	icon = FA_ICON_BRAIN
	value = -4 // Made up since its not a "real" flaw and is instead listed in the crinos-born section
	gain_text = span_warning("You feel less in control of your body...")
	lose_text = span_notice("You feel more in control of yourself.")
	ttrpg_sources = list(/datum/source_book/wta20 = 75)
	COOLDOWN_DECLARE(seizure_cooldown)

/datum/quirk/darkpack/seizures/add(client/client_source)
	RegisterSignal(quirk_holder, COMSIG_LIVING_DICE_ROLLED, PROC_REF(on_dice_rolled))

/datum/quirk/darkpack/seizures/remove()
	UnregisterSignal(quirk_holder, COMSIG_LIVING_DICE_ROLLED)

/datum/quirk/darkpack/seizures/proc/on_dice_rolled(mob/living/roller, datum/storyteller_roll/roll_datum, atom/target, output)
	SIGNAL_HANDLER

	if(!COOLDOWN_FINISHED(src, seizure_cooldown))
		return

	if(roll_datum.spammy_roll)
		return

	if(roll_datum.numerical)
		if(output >= 0)
			return
	else
		if(output != ROLL_BOTCH)
			return

	var/datum/storyteller_roll/seizures/seizure_roll_datum = new()
	var/result = seizure_roll_datum.st_roll(roller)

	if(result == ROLL_SUCCESS)
		return

	roller.apply_status_effect(/datum/status_effect/seizure/flaw)
	COOLDOWN_START(src, seizure_cooldown, 1 SCENES)


/datum/status_effect/seizure/flaw
	dur_min = 25 SECONDS
	dur_max = 35 SECONDS


/datum/storyteller_roll/seizures
	bumper_text = "seizures"
	applicable_stats = list(STAT_TEMPORARY_WILLPOWER)
	difficulty = 8
	successes_needed = 3
	roll_output_type = ROLL_PRIVATE

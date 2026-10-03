/// Preliminary wrapper for the prefs write_preference_midround that ensures your acctually on the same character as the one you spawned in as.
/mob/living/carbon/human/proc/write_preference_midround(datum/preference/preference, preference_value)
	if(!(client?.prefs))
		return FALSE
	var/fail_to_save_reason = cant_save_midround_reason()
	return client.prefs.write_preference_midround(GLOB.preference_entries[preference], preference_value, src, fail_to_save_reason)

/// Wrapper for write_preference to prevent writing for non-canon events like EORG
/// Returns TRUE for a successful preference application.
/// Returns FALSE if it is invalid or the round was not canon.
/datum/preferences/proc/write_preference_midround(datum/preference/preference, preference_value, mob/user, fail_to_save_reason)
	if(fail_to_save_reason)
		to_chat(parent, span_warning("Cannot save preference: [preference.savefile_key]; [fail_to_save_reason]"))
		user.log_message("failed to write pref: [preference.savefile_key] due to; [fail_to_save_reason]", LOG_STATS)
		return FALSE

	to_chat(parent, span_info("Saved preference: [preference.savefile_key] to \"[preference_value]\""))
	user.log_message("wrote to pref '[preference.savefile_key]' midround. set to '[preference_value]'", LOG_STATS)
	var/result = write_preference(preference, preference_value)
	save_character()
	return result

/mob/living/carbon/human/proc/cant_save_midround_reason()
	if(!GLOB.canon_event)
		return "current round is not canon."
	if(HAS_TRAIT(src, TRAIT_NO_CANON))
		return "current character not canon"

	if(!(client?.prefs))
		return "no prefs"
	if(!(mind?.original_character_slot_index))
		return "mind lacking orginal slot index"

	var/mob/living/carbon/human/original_human = mind.original_character.resolve()
	if(!original_human || (original_human != src))
		return "not original character"

	else if(!("[client.prefs.default_slot]" in persistent_client.joined_as_slots))
		return "selected character sheet not spawned in."

	return FALSE

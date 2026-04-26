/*
 * Runs an extended suite of eligibility checks to make sure the player can take the requested job.
 *
 * Checks:
 * * Species Availability
 * * Species Slots
 * * Whitelist - TODO
 * * Kindred Age
 * * Kindred Generation
 * * Kindred Clan
 *
 * Arguments:
 * * player - The player to check for job eligibility.
 * * possible_job - The job to check for eligibility against.
 * * debug_prefix - Logging prefix for the job_debug log entries. For example, GRJ during give_random_job or DO during divide_occupations.
 * * add_job_to_log - If TRUE, appends the job type to the log entry. If FALSE, does not. Set to FALSE when check is part of iterating over players for a specific job, set to TRUE when check is part of iterating over jobs for a specific player and you don't want extra log entry spam.
 */
/datum/controller/subsystem/job/proc/check_job_eligibility_darkpack(mob/dead/new_player/player, datum/job/possible_job, debug_prefix = "", add_job_to_log = FALSE)
	var/client/player_client = GET_CLIENT(player)
	var/splat_pref = player_client.prefs.read_preference(/datum/preference/choiced/splats)
	var/player_splat_id
	if(ispath(splat_pref))
		var/datum/splat/player_splat = GLOB.splat_prototypes[splat_pref]
		player_splat_id = player_splat.id
	else
		player_splat_id = splat_pref

	if(possible_job.allowed_splats && !(player_splat_id in possible_job.allowed_splats))
		job_debug("[debug_prefix] Error: [get_job_unavailable_error_message(JOB_UNAVAILABLE_SPLAT, possible_job.title)], Player: [player][add_job_to_log ? ", Job: [possible_job]" : ""]")
		return JOB_UNAVAILABLE_SPLAT

	if(possible_job.splat_slots && (possible_job.splat_slots[player_splat_id] == 0))
		job_debug("[debug_prefix] Error: [get_job_unavailable_error_message(JOB_UNAVAILABLE_SPLAT_SLOTS, possible_job.title)], Player: [player][add_job_to_log ? ", Job: [possible_job]" : ""]")
		return JOB_UNAVAILABLE_SPLAT_SLOTS

	/*
	if(possible_job.whitelisted)
		job_debug("[debug_prefix] Error: [get_job_unavailable_error_message(JOB_UNAVAILABLE_WHITELIST, possible_job.title)], Player: [player][add_job_to_log ? ", Job: [possible_job]" : ""]")
		return JOB_UNAVAILABLE_WHITELIST
	*/

	var/splat_checks
	switch(player_splat_id)
		if(SPLAT_KINDRED)
			splat_checks = check_kindred_prefs(player_client, player, possible_job, debug_prefix, add_job_to_log)
		if(SPLAT_GAROU)
			splat_checks = check_garou_prefs(player_client, player, possible_job, debug_prefix, add_job_to_log)
	if(splat_checks)
		return splat_checks

	return JOB_AVAILABLE

/datum/controller/subsystem/job/proc/check_kindred_prefs(client/player_client, mob/dead/new_player/player, datum/job/possible_job, debug_prefix = "", add_job_to_log = FALSE)
	if((player_client.prefs.read_preference(/datum/preference/numeric/immortal_age) < possible_job.minimum_immortal_age))
		job_debug("[debug_prefix] Error: [get_job_unavailable_error_message(JOB_UNAVAILABLE_KINDRED_AGE, possible_job.title)], Player: [player][add_job_to_log ? ", Job: [possible_job]" : ""]")
		return JOB_UNAVAILABLE_KINDRED_AGE

	if((player_client.prefs.read_preference(/datum/preference/numeric/generation) > possible_job.minimal_generation))
		job_debug("[debug_prefix] Error: [get_job_unavailable_error_message(JOB_UNAVAILABLE_KINDRED_GENERATION, possible_job.title)], Player: [player][add_job_to_log ? ", Job: [possible_job]" : ""]")
		return JOB_UNAVAILABLE_KINDRED_GENERATION

	var/datum/subsplat/vampire_clan/clan = get_vampire_clan(player_client.prefs.read_preference(/datum/preference/choiced/subsplat/vampire_clan))
	if(possible_job.allowed_clans && !(clan.id in possible_job.allowed_clans))
		job_debug("[debug_prefix] Error: [get_job_unavailable_error_message(JOB_UNAVAILABLE_KINDRED_CLAN, possible_job.title)], Player: [player][add_job_to_log ? ", Job: [possible_job]" : ""]")
		return JOB_UNAVAILABLE_KINDRED_CLAN
	if(possible_job.disallowed_clans && (clan.id in possible_job.disallowed_clans))
		job_debug("[debug_prefix] Error: [get_job_unavailable_error_message(JOB_UNAVAILABLE_KINDRED_CLAN, possible_job.title)], Player: [player][add_job_to_log ? ", Job: [possible_job]" : ""]")
		return JOB_UNAVAILABLE_KINDRED_CLAN

/datum/controller/subsystem/job/proc/check_garou_prefs(client/player_client, mob/dead/new_player/player, datum/job/possible_job, debug_prefix = "", add_job_to_log = FALSE)
	var/datum/subsplat/werewolf/auspice/auspice = get_fera_auspice(player_client.prefs.read_preference(/datum/preference/choiced/subsplat/garou_auspice))
	if(possible_job.allowed_auspice && !(auspice.name in possible_job.allowed_auspice))
		job_debug("[debug_prefix] Error: [get_job_unavailable_error_message(JOB_UNAVAILABLE_FERA_AUSPICE, possible_job.title)], Player: [player][add_job_to_log ? ", Job: [possible_job]" : ""]")
		return JOB_UNAVAILABLE_FERA_AUSPICE
	if(possible_job.disallowed_auspice && (auspice.name in possible_job.disallowed_auspice))
		job_debug("[debug_prefix] Error: [get_job_unavailable_error_message(JOB_UNAVAILABLE_FERA_AUSPICE, possible_job.title)], Player: [player][add_job_to_log ? ", Job: [possible_job]" : ""]")
		return JOB_UNAVAILABLE_FERA_AUSPICE

	var/datum/subsplat/werewolf/tribe/tribe = get_fera_tribe(player_client.prefs.read_preference(/datum/preference/choiced/subsplat/garou_tribe))
	if(possible_job.allowed_tribes && !(tribe.name in possible_job.allowed_tribes))
		job_debug("[debug_prefix] Error: [get_job_unavailable_error_message(JOB_UNAVAILABLE_FERA_TRIBE, possible_job.title)], Player: [player][add_job_to_log ? ", Job: [possible_job]" : ""]")
		return JOB_UNAVAILABLE_FERA_TRIBE
	if(possible_job.disallowed_tribes && (tribe.name in possible_job.disallowed_tribes))
		job_debug("[debug_prefix] Error: [get_job_unavailable_error_message(JOB_UNAVAILABLE_FERA_TRIBE, possible_job.title)], Player: [player][add_job_to_log ? ", Job: [possible_job]" : ""]")
		return JOB_UNAVAILABLE_FERA_TRIBE

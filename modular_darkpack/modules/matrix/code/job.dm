/datum/controller/subsystem/job/proc/FreeRole(mob/living/carbon/despawning_mob)
	if(!despawning_mob.mind)
		return
	var/datum/job/job_datum = despawning_mob.mind.assigned_role
	if(!job_datum)
		return
	job_debug("Freeing role: [job_datum.title]")
	job_datum.current_positions = max(0, job_datum.current_positions - 1)


	//Getting it from prefs is untrustworthy as they could have unlocked there sheet. (even before the move to splats)
	//But getting it from spalts is impercise as those can change.
	//What to do with you.
	/*
	var/datum/species/player_species = despawning_mob.dna?.species
	var/player_species_id = player_species?.id
	if(job_datum.splat_slots[player_species_id] >= 0)
		job_datum.splat_slots[player_species_id] = job_datum.splat_slots[player_species_id] + 1
	*/

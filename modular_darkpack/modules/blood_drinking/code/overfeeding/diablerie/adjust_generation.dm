/mob/living/carbon/human/proc/adjust_generation(mob/living/carbon/human/victim)
	var/datum/splat/vampire/kindred/kindred = get_kindred_splat(src)
	var/generation = get_generation()
	var/victim_generation = victim.get_generation()

	var/new_generation = generation
	if(victim_generation < generation)
		new_generation = max(generation - 1, LOWEST_GENERATION_LIMIT)
	kindred.set_generation(new_generation)

	// CORVAX EDIT START
	if(client?.prefs)
		client.prefs.generation_write_bypass = TRUE
		write_preference_midround(/datum/preference/numeric/generation, new_generation)
		client.prefs.generation_write_bypass = FALSE
	// CORVAX EDIT END

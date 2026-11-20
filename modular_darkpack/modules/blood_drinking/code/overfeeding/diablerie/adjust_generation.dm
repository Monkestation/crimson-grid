/mob/living/carbon/human/proc/adjust_generation(mob/living/carbon/human/victim)
	var/datum/splat/vampire/kindred/kindred = get_kindred_splat(src)
	var/generation = get_generation()
	var/victim_generation = victim.get_generation()

	var/new_generation = generation
	if(victim_generation < generation)
		new_generation = max(generation - 1, MAX_TRUSTED_GENERATION)
	// CRIMSON EDIT ADD START - Diablerie progression
	if(new_generation >= generation)
		return
	// CRIMSON EDIT ADD END - Diablerie progression
	kindred.set_generation(new_generation)

	write_preference_midround(/datum/preference/numeric/generation, new_generation)

#define DOGGY_ANIMATION_TIME 1 TURNS

/datum/storyteller_roll/fera_trans
	bumper_text = "transformation"
	applicable_stats = list(STAT_STAMINA)

/datum/storyteller_roll/banned_transformation
	bumper_text = "banned transformation bypass"
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	difficulty = 8
	roll_output_type = ROLL_PRIVATE

// Remeber if you remove homid being species that this will break.
/datum/splat/werewolf/shifter/proc/transform_fera(datum/species/human/shifter/form_to_transform, costs_rage = FALSE, requires_roll = TRUE, force = FALSE)
	if(!form_to_transform)
		return
	if(!istype(owner))
		return
	if(!(form_to_transform in transformation_list))
		return
	var/datum/species/human/shifter/current_form = owner?.dna?.species
	if(istype(current_form, form_to_transform))
		return
	if(!force && !COOLDOWN_FINISHED(src, transform_cd))
		to_chat(owner, span_warning("Your shifting is on cooldown for [DisplayTimeText(COOLDOWN_TIMELEFT(src, transform_cd))]."))
		return
	if(HAS_TRAIT(owner, TRAIT_METAMORPH))
		requires_roll = FALSE
	else if(ispath(get_breed_form_species(), form_to_transform))
		requires_roll = FALSE
	else if(costs_rage)
		if(adjust_rage(-1, TRUE))
			requires_roll = FALSE
		else
			to_chat(owner, span_warning("You don't have enough <b>RAGE</b> to do that!"))
			SEND_SOUND(owner, sound('modular_darkpack/modules/werewolf_the_apocalypse/sounds/werewolf_cast_failed.ogg', volume = 50))
			return

	COOLDOWN_START(src, transform_cd, 1 TURNS)
	var/time_to_transform = DOGGY_ANIMATION_TIME

	if(HAS_TRAIT(owner, TRAIT_BANNED_TRANSFORMATION))
		if(owner.st_get_stat(STAT_TEMPORARY_WILLPOWER) <= 1)
			to_chat(owner, span_warning("You don't have enough <b>WILLPOWER</b> to do that!"))
			return
		else
			var/datum/storyteller_roll/banned_transformation/bypass_roll = new()
			to_chat(owner, span_notice("You expend your willpower trying to transform!"))
			owner.st_change_stat(STAT_TEMPORARY_WILLPOWER, -1)
			if(bypass_roll.st_roll(owner, owner) != ROLL_SUCCESS)
				return

	// TODO: should accctually require an amount of successes equal to the forms your shifting through
	if(requires_roll)
		var/datum/storyteller_roll/fera_trans/transform_roll = new()
		if(current_form)
			transform_roll.difficulty = current_form.shift_difficulty
			transform_roll.successes_needed = steps_between_forms(current_form.type, form_to_transform)
		switch(transform_roll.st_roll(owner, owner, PRIMAL_URGE_PLACEHOLDER))
			if(ROLL_SUCCESS)
				pass()
			if(ROLL_FAILURE, ROLL_BOTCH)
				return

	// If it doesnt require a roll it must be instant/free action
	if(requires_roll)
		playsound(owner, transform_sound, 50, FALSE)
	else
		playsound(owner, 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/speedtrans.ogg', 50, FALSE)
		time_to_transform *= 0.1

	// owner.Stun(time_to_transform, ignore_canstun = TRUE)

	for(var/obj/item/clothing/equipped in owner.get_equipped_items(INCLUDE_ABSTRACT))
		equipped.take_damage(rand(25, 50), sound_effect = FALSE)

	var/matrix/ntransform = matrix(owner.transform)
	ntransform.Scale(1.1, 1.1)
	animate(owner, transform = ntransform, color = "#000000", time = time_to_transform * 0.9)

	SEND_SIGNAL(owner, COMSIG_MASQUERADE_VIOLATION)

	addtimer(CALLBACK(src, PROC_REF(transform_finish), form_to_transform, time_to_transform), time_to_transform * 0.9)

/datum/splat/werewolf/shifter/proc/steps_between_forms(datum/species/human/shifter/first_form, datum/species/human/shifter/second_form)
	var/first_index = transformation_list.Find(first_form)
	var/second_index = transformation_list.Find(second_form)
	return abs(first_index - second_index)

/datum/splat/werewolf/shifter/proc/revert_to_breed_form()
	SIGNAL_HANDLER

	ASYNC // We dont return anything important to death and we want to be able to sleep for metamorph
		if(HAS_TRAIT(owner, TRAIT_METAMORPH))
			var/datum/storyteller_roll/metamorph/roll_datum = new()
			if(roll_datum.st_roll(owner, bonus = PRIMAL_URGE_PLACEHOLDER) == ROLL_SUCCESS)
				// First valid use of timeout discovered (we dont want to be able to hold it out)
				var/choice = tgui_input_list(owner, "Revert to your choosen form", "Metamorph", transformation_list, get_breed_form_species(), 1 TURNS)
				if(choice in transformation_list)
					transform_fera(choice, force = TRUE)
					return

		transform_fera(get_breed_form_species(), force = TRUE)

/datum/splat/werewolf/shifter/proc/transform_finish(form_to_transform, time_taken = DOGGY_ANIMATION_TIME)
	animate(owner, transform = null, color = "#FFFFFF", time = time_taken * 0.1)

	// Hacky fix for angle getting messed up when transforming into a human while resting
	if (owner.body_position == LYING_DOWN && ispath(form_to_transform, /datum/species/human/shifter/homid))
		var/previous_angle = owner.set_lying_angle(0)
		owner.set_species(form_to_transform)
		owner.set_lying_angle(previous_angle)
		return

	owner.set_species(form_to_transform)

/datum/splat/werewolf/shifter/proc/is_breed_form()
	if(!owner?.dna)
		return FALSE
	if(owner.dna.species?.type != get_breed_form_species())
		return FALSE
	return TRUE

/datum/splat/werewolf/shifter/proc/get_breed_form_species()
	return breed_form?.breed_species

#undef DOGGY_ANIMATION_TIME

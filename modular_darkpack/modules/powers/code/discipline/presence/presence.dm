#define TRAIT_PRESENCE_IMMUNE "presence_immune"

/datum/discipline/presence
	name = "Presence"
	desc = "Allows you to attract, sway, and control crowds through supernatural allure and emotional manipulation."
	icon_state = "presence"
	power_type = /datum/discipline_power/presence

/datum/discipline/presence/post_gain()
	. = ..()
	ADD_TRAIT(owner, TRAIT_CHARMER, /datum/discipline/presence)

/datum/discipline_power/presence
	name = "Presence power name"
	desc = "Presence power description"
	activate_sound = 'modular_darkpack/modules/powers/sounds/presence_activate.ogg'
	deactivate_sound = 'modular_darkpack/modules/powers/sounds/presence_deactivate.ogg'

//lets not have people be able to cast this through walls


/datum/discipline_power/presence/proc/presence_check(mob/living/carbon/human/owner, mob/living/carbon/human/target, using_stats, difficulty)
	if(!ishuman(target))
		return FALSE

	if(HAS_TRAIT(target, TRAIT_PRESENCE_IMMUNE))
		to_chat(owner, span_warning("A presence attempt has botched against this person and they may no longer have Presence used on them for the rest of the night."))
		return FALSE

	//is the difficulty pre-defined? if not, its probably their willpower.
	var/theirpower = difficulty || target.st_get_stat(STAT_TEMPORARY_WILLPOWER)

	// Do we have traits to modify our difficulties?
	if((!(owner.obscured_slots & HIDEFACE))&(HAS_TRAIT(owner, TRAIT_DISFIGURED_APPEARANCE))) // Are we visibly disfigured?
		theirpower += 2 // Increase the difficulty by two.

	if(!get_kindred_splat(target)) // Is our target mortal?
		if(HAS_TRAIT(owner, TRAIT_GRAVE_SMELL)) // Are we stinky?
			theirpower += 1
		if((HAS_TRAIT(owner, TRAIT_GLOWING_EYES)) && (!owner.is_eyes_covered()) && (STAT_INTIMIDATION in using_stats)) // Are we intimidating a mortal with uncovered eyes?
			theirpower -= 1

	var/successes = SSroll.storyteller_roll_datum(owner, target, difficulty = theirpower, applic_stats = using_stats, numerical = TRUE)

	//botch
	if(successes < 0)
		ADD_TRAIT(target, TRAIT_PRESENCE_IMMUNE, TRAIT_GENERIC)
		to_chat(owner, span_warning("A presence attempt has botched against this person and they may no longer have Presence used on them for the rest of the night."))
		return FALSE

	//number of successes is rather critical for the efficacy of the power
	return successes

/datum/discipline_power/presence/proc/apply_presence_overlay(mob/living/carbon/target)
	target.remove_overlay(POWERS_LAYER)
	var/mutable_appearance/presence_overlay = mutable_appearance('modular_darkpack/modules/powers/icons/presence.dmi', "presence", -POWERS_LAYER)
	presence_overlay.pixel_z = 1
	target.overlays_standing[POWERS_LAYER] = presence_overlay
	target.apply_overlay(POWERS_LAYER)
	SEND_SOUND(target, sound('modular_darkpack/modules/powers/sounds/presence_activate.ogg'))

//used in awe - v20 book states that awe affects the targets of lowest willpower first if affecting multiple targets.
/datum/discipline_power/presence/proc/sort_targets_by_willpower(list/targets)
	var/list/sorted = list()
	for(var/mob/living/carbon/target in targets)
		var/target_willpower = target.st_get_stat(STAT_TEMPORARY_WILLPOWER)
		var/inserted = FALSE

		for(var/i = 1; i <= length(sorted); i++)
			var/mob/living/carbon/existing = sorted[i]
			if(target_willpower < existing.st_get_stat(STAT_TEMPORARY_WILLPOWER))
				sorted.Insert(i, target)
				inserted = TRUE
				break

		if(!inserted)
			sorted += target
	return sorted


/datum/storyteller_roll/presence_awe
	difficulty = 7
	applicable_stats = list(STAT_CHARISMA, STAT_PERFORMANCE)
	numerical = TRUE

// AWE
/datum/discipline_power/presence/awe
	name = "Awe"
	desc = "Make those around you admire and want to be closer to you."
	level = 1
	vitae_cost = 1
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	range = 7
	multi_activate = FALSE
	cooldown_length = 15 SECONDS
	duration_length = 10 SECONDS
	vitae_cost = 1
	var/successes = 0
	var/list/affected_targets = list()

/datum/discipline_power/presence/awe/pre_activation_checks()
	. = ..()

	//charisma + performance
	successes = SSroll.storyteller_roll_datum(owner, roll_datum = /datum/storyteller_roll/presence_awe)
	if(successes > 0)
		return TRUE

	to_chat(owner, span_warning("Your presence fails to captivate anyone around you."))
	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/awe/activate()
	. = ..()

	var/list/potential_targets = list()
	for(var/mob/living/carbon/target in hearers(range, owner))
		if(target != owner)
			potential_targets += target

	if(!length(potential_targets))
		to_chat(owner, span_warning("There is no one around to be awed by your presence."))
		return

	var/list/target_counts = list(1, 2, 6, 20, length(potential_targets)) //V20 core rulebook presence -> awe
	var/targets_to_affect = target_counts[clamp(successes, 1, 5)]

	potential_targets = sort_targets_by_willpower(potential_targets)
	affected_targets = list()

	for(var/i = 1; i <= min(targets_to_affect, length(potential_targets)); i++)
		var/mob/living/carbon/target = potential_targets[i]
		apply_presence_overlay(target)
		to_chat(target, span_yellowteamradio("You feel extremely attracted to and persuaded by [owner]'s words, no matter what they're saying!"))
		target.apply_status_effect(STATUS_EFFECT_AWE)
		affected_targets += target

	var/affected_count = length(affected_targets)
	if(affected_count > 0)
		to_chat(owner, span_warning("Your commanding presence captivates [affected_count] [affected_count == 1 ? "person" : "people"] around you!"))
	else
		to_chat(owner, span_warning("Your presence fails to affect anyone around you."))

/datum/discipline_power/presence/awe/deactivate()
	. = ..()
	for(var/mob/living/carbon/target in affected_targets)
		target.remove_overlay(POWERS_LAYER)
	affected_targets.Cut()

// DREAD GAZE
/datum/discipline_power/presence/dread_gaze
	name = "Dread Gaze"
	desc = "Incite fear in others through only your words and gaze."
	level = 2
	vitae_cost = 0
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK | DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	range = 7
	multi_activate = TRUE
	cooldown_length = 15 SECONDS
	duration_length = 10 SECONDS
	var/successes = 0


/datum/discipline_power/presence/dread_gaze/pre_activation_checks(mob/living/target)

	//charisma + intimidation, difficulty equal to the victims wits + courage
	successes = presence_check(owner, target, list(STAT_CHARISMA, STAT_INTIMIDATION), difficulty = (target.st_get_stat(STAT_WITS) + target.st_get_stat(STAT_COURAGE)))
	if(successes > 0)
		return TRUE

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/dread_gaze/activate(mob/living/carbon/human/target)
	. = ..()
	apply_presence_overlay(target)
	if(successes >= (target.st_get_stat(STAT_WITS) + target.st_get_stat(STAT_COURAGE)))	//We check if you just flat out have more successes than their dice pool total.
		var/extended_action_prompt = tgui_input_list(owner, "Attempt to force your target to cower in fear? This will take time to preform this extended action to stun and debuff your opponent!", "Terrifying Presence", list("Yes", "No"), "No")
		switch(extended_action_prompt)
			if("Yes")
				ADD_TRAIT(owner, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))
				if(do_after(owner, 3 SECONDS))
					to_chat(owner, span_warning("You force [target] to cower to your mere presence!"))
					to_chat(target, span_userdanger("You are consumed with an overhwelming sense of dread, forced to cower before [owner] as even your legs betray you and your very being is rocked to its core!"))
					target.Stun(1 TURNS)	//~5 seconds
					target.emote("tremble")	//Shaking emote for visibility
					target.emote(pick("scream","cry"))	//Audible emote
					target.apply_status_effect(/datum/status_effect/dread_gaze)	//Debuffs for set time
				REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))
				return TRUE
	if(successes <= 3) // already checked for above 0 in pre_activation
		to_chat(target, span_userdanger("You are consumed with terror toward [owner]!"))
		to_chat(owner, span_warning("You've struck terror into [target]'s heart with your dreadful gaze!"))
	else
		to_chat(target, span_userdanger("Overwhelming dread fills you! You must get away from [owner]!"))
		to_chat(owner, span_warning("Your terrifying presence sends [target] fleeing in terror!"))

		//V20's 'dread gaze' section states that with 3 or more successes targets will find themselves scratching at the walls or fleeing against their will because they are so terrified.
		GLOB.move_manager.move_away(target, owner, 10, target.cached_multiplicative_slowdown)

/datum/discipline_power/presence/dread_gaze/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(POWERS_LAYER)

// ENTRANCEMENT
/datum/discipline_power/presence/entrancement
	name = "Entrancement"
	desc = "Manipulate minds by bending emotions to your will."
	level = 3
	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK | DISC_CHECK_DIRECT_SEE
	target_type = TARGET_HUMAN
	range = 7
	multi_activate = TRUE
	cooldown_length = 3 MINUTES
	duration_length = 5 SECONDS
	vitae_cost = 1
	var/successes = 0

/datum/discipline_power/presence/entrancement/pre_activation_checks(mob/living/target)

	successes = presence_check(owner, target, list(STAT_APPEARANCE, STAT_EMPATHY))
	if(successes > 0)
		return TRUE

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/entrancement/activate(mob/living/carbon/human/target)
	. = ..()
	if(!.)
		to_chat(owner, span_warning("[target] doesnt seem entranced by your words."))
		return
	target.throw_alert("entrancement", /atom/movable/screen/alert/entrancement)
	log_combat(owner, target, "Used Presence Entrancement")

	apply_presence_overlay(target, successes * 1 MINUTES)
	to_chat(target, span_hypnophrase("You find yourself becoming completely entraced by [owner]. You are now their willing servant."))
	to_chat(target, span_info("You are now the willing servant of [owner]. You will seek to please them and fulfill their every desire, but this desire will fade soon."))
	addtimer(CALLBACK(src, PROC_REF(end_entrancement), target), successes * 10 MINUTES)

/datum/discipline_power/presence/entrancement/proc/end_entrancement(mob/living/carbon/human/target)
	to_chat(target, span_hypnophrase("Your desire to fulfill [owner]'s every desire fades."))
	target.clear_alert("entrancement")

/datum/discipline_power/presence/entrancement/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(POWERS_LAYER)

// SUMMON
/datum/discipline_power/presence/summon
	name = "Summon"
	desc = "Call anyone you've ever met to be by your side."
	level = 4
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	range = 7
	multi_activate = TRUE
	cooldown_length = 10 MINUTES
	duration_length = 5 SECONDS
	vitae_cost = 1
	var/successes = 0
	var/mob/living/carbon/human/summon_target

/datum/discipline_power/presence/summon/pre_activation_checks(mob/living/target)
	var/summon_target_name = tgui_input_text(owner, "Summon Target:", "Summon Target")
	if(!summon_target_name)
		return FALSE
	summon_target_name = sanitize_name(summon_target_name)

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.real_name == summon_target_name)
			summon_target = H
			break

	if(!summon_target)
		to_chat(owner, span_warning("You cannot sense anyone by that name."))
		return FALSE

	//this ability has a difficulty of 4 or 5 or something for people the summoner has met, and 8 for those they've only met briefly.
	//i thought that was too low and the ability for the misuse of this disc caused me to raise it to 7 difficulty
	successes = presence_check(owner, summon_target, list(STAT_CHARISMA, STAT_SUBTERFUGE), 7)
	if(successes > 0)
		return TRUE

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/summon/activate(mob/living/carbon/human/target)
	. = ..()
	if(!. || !summon_target)
		to_chat(owner, span_warning("Your summons failed to reach [summon_target ? summon_target.real_name : "your target"]."))
		return

	apply_presence_overlay(summon_target, 5 MINUTES)

	var/turf/owner_turf = get_turf(owner)
	var/location_info = "[get_area_name(owner_turf)], X:[owner_turf.x] Y:[owner_turf.y] Z:[owner_turf.z]"
	to_chat(summon_target, span_yellowteamradio("[owner.real_name] is summoning you to their location. [owner.real_name] is currently at [location_info]"))

	//V20 presence -> 'summon' section for this flavortext
	var/list/flavor_texts = list(
		"You feel a faint pull towards [owner.real_name], approaching slowly and hesitantly.",
		"You feel reluctantly compelled to seek out [owner.real_name], though obstacles easily deter you.",
		"You feel a strong urge to go to [owner.real_name] with reasonable speed.",
		"You feel compelled to rush to [owner.real_name] with haste, overcoming any obstacles in your way, but not endangering yourself.",
		"You feel an overwhelming need to rush to [owner.real_name], doing anything to get to them."
	)

	var/flavor_index = clamp(successes, 1, 5)
	to_chat(summon_target, span_yellowteamradio(flavor_texts[flavor_index]))
	to_chat(summon_target, span_info("Summon only affects targets who have reasonably met the summoner. If you believe your character would reasonably have never met the summoner, this power is ineffective."))
	to_chat(owner, span_warning("You've successfully summoned [summon_target.real_name] to your presence! ([successes] success\s)"))
	summon_target.do_jitter_animation(3 SECONDS)

/datum/discipline_power/presence/summon/deactivate(mob/living/carbon/human/target)
	. = ..()
	summon_target?.remove_overlay(POWERS_LAYER)

// MAJESTY
/datum/discipline_power/presence/majesty
	name = "Majesty"
	desc = "Become so grand that others find it nearly impossible to disobey or harm you."
	level = 5
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SPEAK
	range = 7
	multi_activate = TRUE
	cooldown_length = 3 MINUTES
	duration_length = 2 MINUTES
	vitae_cost = 0
	willpower_cost = 1
	violates_masquerade = TRUE
	var/list/affected_targets = list()

/datum/discipline_power/presence/majesty/pre_activation_checks(mob/living/target)
	return TRUE

/datum/discipline_power/presence/majesty/activate(mob/living/carbon/human/target)
	. = ..()
	affected_targets = list()
	for(var/mob/living/carbon/human/hearer in get_hearers_in_view(range, owner))
		if(hearer == owner)
			continue

		var/roll_difficulty = owner.st_get_stat(STAT_CHARISMA) + owner.st_get_stat(STAT_INTIMIDATION)
		//'the victim must make a courage roll with a difficulty equal to the caster's charisma + intimidation to a maximum of 10'
		var/hearer_successes = SSroll.storyteller_roll_datum(hearer, owner, difficulty = roll_difficulty, applic_stats = list(STAT_COURAGE), numerical = TRUE)
		hearer_successes = max(0, hearer_successes)

		apply_presence_overlay(hearer, 3 MINUTES)
		affected_targets[hearer] = hearer_successes

		to_chat(hearer, span_hypnophrase("You find yourself completely submitting to the Majesty of [owner]. Their every word is your utmost priority, every frown of displeasure crushing your soul. You find yourself humbled entirely in their overwhelming presence."))

		// this ability is often used to end combat scenes but it often ignored.
		var/pacifism_delay = hearer_successes * 10 SECONDS
		if(hearer_successes > 0)
			to_chat(hearer, span_info("Despite the overwhelming presence, your will allows you to resist for [pacifism_delay / 10] seconds before you're forced into pacifism."))
			addtimer(CALLBACK(src, PROC_REF(apply_pacifism), hearer), pacifism_delay)
		else
			ADD_TRAIT(hearer, TRAIT_PACIFISM, "Majesty")
			to_chat(hearer, span_info("You are completely unable to act against [owner]."))
		ADD_TRAIT(owner, TRAIT_PACIFISM, "Majesty")

		if(hearer_successes > 0)
			to_chat(hearer, span_info("Despite the overwhelming presence, your will allows you to make [hearer_successes] contradictory action\s until youre allowed to leave [owner]'s company."))

	var/total_affected = length(affected_targets)
	if(total_affected > 0)
		to_chat(owner, span_warning("Your Majesty overwhelms [total_affected] individual[total_affected == 1 ? "" : "s"] in your presence!"))
	else
		to_chat(owner, span_warning("No one is present to witness your Majesty."))

/datum/discipline_power/presence/majesty/deactivate(mob/living/carbon/human/target)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, "Majesty")
	for(var/mob/living/carbon/human/affected_target in affected_targets)
		if(affected_target)
			affected_target.remove_overlay(POWERS_LAYER)
			to_chat(affected_target, span_hypnophrase("The overwhelming presence of [owner] fades, and your will returns to normal."))
			REMOVE_TRAIT(affected_target, TRAIT_PACIFISM, "Majesty")
	affected_targets.Cut()

/datum/discipline_power/presence/majesty/proc/apply_pacifism(mob/living/carbon/human/hearer)
	if(hearer && (hearer in affected_targets))
		ADD_TRAIT(hearer, TRAIT_PACIFISM, "Majesty")
		to_chat(hearer, span_warning("Your resistance crumbles - you can no longer bring yourself to act against [owner]!"))

// LOVE
/datum/discipline_power/presence/love
	name = "Love"
	desc = "Make someone enamored with you as if in a blood bond."
	level = 6
	check_flags = DISC_CHECK_CAPABLE|DISC_CHECK_SPEAK
	target_type = TARGET_HUMAN
	range = 7
	cooldown_length = 15 SECONDS
	var/presence_succeeded = FALSE

/datum/discipline_power/presence/love/pre_activation_checks(mob/living/target)

	presence_succeeded = presence_check(owner, target)
	if(presence_succeeded)
		return TRUE

	do_cooldown(cooldown_length)
	return FALSE

/datum/discipline_power/presence/love/activate(mob/living/carbon/human/target)
	. = ..()
	if(presence_succeeded)
		apply_presence_overlay(target)
		//target.apply_status_effect(STATUS_EFFECT_INLOVE, owner)
		to_chat(owner, span_warning("You've enthralled [target] with your presence, and bonded them to you!"))
	else
		to_chat(owner, span_warning("[target]'s mind has resisted your attempt to sway!"))
		to_chat(target, span_warning("An overwhelming aura radiates from [owner], compelling your love… but you steel your heart and turn away from their unnatural allure."))

///mob/living/carbon/proc/walk_to_caster(mob/living/step_to)
	//walk(src, 0)
	//if(!CheckFrenzyMove())
		//set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		//step_to(src, step_to, 0)
		//face_atom(step_to)

///mob/living/carbon/human/proc/step_away_caster(mob/living/step_from)
	//walk(src, 0)
	//if(!CheckFrenzyMove())
		//set_glide_size(DELAY_TO_GLIDE_SIZE(total_multiplicative_slowdown()))
		//step_away(src, step_from, 99)

#undef TRAIT_PRESENCE_IMMUNE

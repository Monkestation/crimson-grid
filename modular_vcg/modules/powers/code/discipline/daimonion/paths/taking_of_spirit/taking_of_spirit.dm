/datum/discipline/path/spirit
	name = "Taking of Spirit"
	desc = "A path of Dark Thaumaturgy that allows the manipulation of willpower."
	icon = 'modular_vcg/modules/paths/icons/paths.dmi'
	icon_state = "spirit"
	power_type = /datum/discipline_power/daimonion/path/spirit
	//lazylists of weakrefs
	var/list/botched_targets
	var/list/drained_targets

/datum/discipline/path/spirit/post_gain()
	. = ..()
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_owner_death))
	ADD_TRAIT(owner, TRAIT_TAKING_SPIRIT_KNOWLEDGE, TAKING_OF_SPIRIT_TRAIT)

/datum/discipline/path/spirit/proc/on_owner_death(mob/living/dead)
	SIGNAL_HANDLER

	if(LAZYLEN(drained_targets))
		for(var/datum/weakref/ref in drained_targets)
			var/mob/living/carbon/human/drained = ref.resolve()
			if(!drained)
				continue
			if(!CAN_THEY_SEE(drained, dead))
				continue
			var/willpower_amount = drained_targets[ref]
			drained.st_set_stat(STAT_TEMPORARY_WILLPOWER, drained.st_get_stat(STAT_TEMPORARY_WILLPOWER) + willpower_amount)
			to_chat(drained, span_notice("Your stolen Willpower returns as you witness [dead]'s death, their control on you fades."))
	LAZYNULL(drained_targets)

/datum/discipline_power/daimonion/path/spirit
	name = "Dark Thaumaturgy: Taking of Spirit Power Name"
	desc = "Dark Thaumaturgy: Taking of Spirit Power Description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/thaum.ogg'

	target_type = TARGET_PLAYER
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_TORPORED
	aggravating = FALSE
	hostile = TRUE
	violates_masquerade = FALSE
	range = 1

	cooldown_length = 5 MINUTES
	var/success_count
	var/willpower_drain_amount

/datum/storyteller_roll/taking_of_spirit
	bumper_text = "willpower draining"
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	numerical = TRUE
	roll_output_type = ROLL_PRIVATE_AND_TARGET

/datum/storyteller_roll/taking_of_spirit_resist
	bumper_text = "willpower draining resist"
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	numerical = TRUE
	roll_output_type = ROLL_PRIVATE_AND_TARGET

/datum/discipline_power/daimonion/path/spirit/can_activate(mob/living/target, alert)
	. = ..()
	var/datum/discipline/path/spirit/parent_disc = discipline

	//someone has botched taking of spirit against this human
	if(LAZYLEN(parent_disc.botched_targets))
		for(var/datum/weakref/ref in parent_disc.botched_targets)
			var/mob/living/carbon/human/botched = ref.resolve()
			if(!botched)
				LAZYREMOVE(parent_disc.botched_targets, ref)
				continue
			if(botched == target)
				to_chat(owner, span_warning("Your previous failed attempt has made [target] invulnerable to your Taking of Spirit."))
				return FALSE
	if(target.st_get_stat(STAT_TEMPORARY_WILLPOWER) == 0)
		to_chat(owner, span_warning("[target] has no Willpower left to take!"))
		return FALSE
	return TRUE

/datum/discipline_power/daimonion/path/spirit/activate(mob/living/target)
	. = ..()
	var/datum/discipline/path/spirit/parent_disc = discipline

	success_count = SSroll.storyteller_roll_datum(owner, target, /datum/storyteller_roll/taking_of_spirit, difficulty = (level + 3))
	if(success_count < 0)
		owner.visible_message(span_danger("[owner] stares blankly, struggling to concentrate."), \
			span_notice("You stare blankly, struggling to concentrate."))
		to_chat(owner, span_danger("You feel your Willpower being drained!"))
		spirit_botch_effect()
		return
	else if(success_count == 0)
		to_chat(owner, span_notice("Your magic fizzles out!"))
		return
	if(HAS_TRAIT(target, TRAIT_TAKING_SPIRIT_KNOWLEDGE))
		var/resist_count = SSroll.storyteller_roll_datum(target, owner, /datum/storyteller_roll/taking_of_spirit_resist, difficulty = 7)
		if(resist_count > success_count)
			LAZYADD(parent_disc.botched_targets, WEAKREF(target))
			to_chat(owner, span_warning("Your Taking of Spirit attempt has failed! [target] is now invulnerable to your Taking of Spirit."))
			return
	owner.visible_message(span_danger("[owner] reaches out towards [target]'s head, chanting a demonic incantation."), \
		span_notice("You begin to chant a demonic incantation on [target]'s mind..."))
	if(do_after(owner, 15 SECONDS, target = target, timed_action_flags = (IGNORE_HELD_ITEM)))
		owner.visible_message(span_danger("[owner] successfully performs a vile chant on [target]'s mind."), \
			span_notice("You successfully perform a vile chant on [target]'s mind."))
		to_chat(target, span_danger("You feel your Willpower being drained!"))
		var/actual_drain = min(target.st_get_stat(STAT_TEMPORARY_WILLPOWER), willpower_drain_amount)
		target.st_set_stat(STAT_TEMPORARY_WILLPOWER, target.st_get_stat(STAT_TEMPORARY_WILLPOWER) - actual_drain)
		if(target.st_get_stat(STAT_TEMPORARY_WILLPOWER) == 0)
			to_chat(target, span_hypnophrase("As you lose the last bits of your Willpower, you feel your emotions dull, the only one left is obeying [owner]."))
			to_chat(target, span_info("You are now a soulless automaton, serving [owner] should be your utmost priority."))
			target.visible_message(span_danger("[target] stares blankly, their gaze devoid of life."), \
			span_notice("You stare blankly, your gaze devoid of life."))
		ADD_TRAIT(target, TRAIT_TAKING_SPIRIT_KNOWLEDGE, TAKING_OF_SPIRIT_TRAIT)
		if(LAZYLEN(parent_disc.drained_targets))
			for(var/datum/weakref/ref in parent_disc.drained_targets)
				var/mob/living/carbon/human/drained = ref.resolve()
				if(!drained)
					LAZYREMOVE(parent_disc.drained_targets, ref)
					continue
				if(drained == target)
					parent_disc.drained_targets[ref] += actual_drain
					return
		LAZYADDASSOC(parent_disc.drained_targets, WEAKREF(target), actual_drain)
	else
		to_chat(owner, span_notice("Your concentration breaks! The worst of the backlash seems to pass, however."))

/datum/discipline_power/daimonion/path/spirit/proc/spirit_botch_effect()
	owner.st_set_stat(STAT_TEMPORARY_WILLPOWER, owner.st_get_stat(STAT_TEMPORARY_WILLPOWER) - willpower_drain_amount)

/datum/discipline_power/daimonion/path/spirit/one
	name = "Dark Thaumaturgy: Taking of Spirit One"
	desc = "Drain the victims of willpower."

	level = 1
	willpower_drain_amount = 1

	grouped_powers = list(
		/datum/discipline_power/daimonion/path/spirit/two,
		/datum/discipline_power/daimonion/path/spirit/three,
		/datum/discipline_power/daimonion/path/spirit/four,
		/datum/discipline_power/daimonion/path/spirit/five,
	)

/datum/discipline_power/daimonion/path/spirit/two
	name = "Dark Thaumaturgy: Taking of Spirit Two"
	desc = "Drain the victims of willpower."

	level = 2
	willpower_drain_amount = 2

	grouped_powers = list(
		/datum/discipline_power/daimonion/path/spirit/one,
		/datum/discipline_power/daimonion/path/spirit/three,
		/datum/discipline_power/daimonion/path/spirit/four,
		/datum/discipline_power/daimonion/path/spirit/five,
	)

/datum/discipline_power/daimonion/path/spirit/three
	name = "Dark Thaumaturgy: Taking of Spirit Three"
	desc = "Drain the victims of willpower."

	level = 3
	willpower_drain_amount = 4

	grouped_powers = list(
		/datum/discipline_power/daimonion/path/spirit/one,
		/datum/discipline_power/daimonion/path/spirit/two,
		/datum/discipline_power/daimonion/path/spirit/four,
		/datum/discipline_power/daimonion/path/spirit/five,
	)

/datum/discipline_power/daimonion/path/spirit/four
	name = "Dark Thaumaturgy: Taking of Spirit Four"
	desc = "Drain the victims of willpower."

	level = 4
	willpower_drain_amount = 6

	grouped_powers = list(
		/datum/discipline_power/daimonion/path/spirit/one,
		/datum/discipline_power/daimonion/path/spirit/two,
		/datum/discipline_power/daimonion/path/spirit/three,
		/datum/discipline_power/daimonion/path/spirit/five,
	)

/datum/discipline_power/daimonion/path/spirit/five
	name = "Dark Thaumaturgy: Taking of Spirit Five"
	desc = "Drain the victims of willpower."

	level = 5
	willpower_drain_amount = 8

	grouped_powers = list(
		/datum/discipline_power/daimonion/path/spirit/one,
		/datum/discipline_power/daimonion/path/spirit/two,
		/datum/discipline_power/daimonion/path/spirit/three,
		/datum/discipline_power/daimonion/path/spirit/four,
	)

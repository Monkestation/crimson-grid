
/datum/action/cooldown/power/gift/resist_pain
	name = "Resist Pain"
	desc = "Through force of will, the Philodox is able to ignore the pain of his wounds and continue acting normally."
	button_icon_state = "resist_pain"
	rank = 1
	willpower_cost = 1

/datum/action/cooldown/power/gift/resist_pain/Activate(atom/target)
	. = ..()
	var/mob/living/living_owner = astype(owner)

	playsound(owner, 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/gifts/resist_pain.ogg', 75, FALSE)
	living_owner.apply_status_effect(/datum/status_effect/resist_pain)

/datum/status_effect/resist_pain
	id = "resist_pain"
	duration = 1 SCENES
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/gift/resist_pain

/datum/status_effect/resist_pain/on_apply()
	. = ..()

	to_chat(owner, span_notice("You feel your skin thickening..."))
	owner.add_traits(list(TRAIT_NOSOFTCRIT, TRAIT_ANALGESIA), GIFT_TRAIT)

/datum/status_effect/resist_pain/on_remove()
	owner.remove_traits(list(TRAIT_NOSOFTCRIT, TRAIT_ANALGESIA), GIFT_TRAIT)
	to_chat(owner, span_warning("Your skin is thin again..."))

	return ..()

/atom/movable/screen/alert/status_effect/gift/resist_pain
	name = /datum/action/cooldown/power/gift/resist_pain::name
	desc = /datum/action/cooldown/power/gift/resist_pain::desc
	overlay_state = /datum/action/cooldown/power/gift/resist_pain::button_icon_state


/datum/storyteller_roll/gift/scent_of_the_true_form
	applicable_stats = list(STAT_PERCEPTION)
	numerical = TRUE
	roll_output_type = ROLL_PRIVATE

/datum/action/cooldown/power/gift/scent_of_the_true_form
	name = "Scent Of The True Form"
	desc = "This Gift allows the Garou to determine the true nature of a person."
	button_icon_state = "scent_of_the_true_form"
	click_to_activate = TRUE
	rank = 1
	var/static/list/wyld_descriptors = list(
		"ozone",
		"euphoria",
		"flowers",
		"an unseen breeze",
		"petrichor",
		"the calm after a thunderstorm",
		"a primal ocean",
		"the anticipation of limitless possibility"
	)
	var/static/list/weaver_descriptors = list(
		"sound patterns",
		"cleaning fluid",
		"hand sanitizer",
		"a spider\'s web",
		"silken thread",
		"metal",
		"a sudden drain of energy",
		"flashing lights",
		"alarms and sirens"
	)
	var/static/list/wyrm_descriptors = list(
		"rot",
		"decay",
		"fear",
		"an animal that died in fear",
		"depression",
		"hopelessness",
		"pain",
		"lengethening shadows"
	)

/datum/action/cooldown/power/gift/scent_of_the_true_form/set_click_ability(mob/on_who)
	. = ..()
	SEND_SOUND(owner, 'modular_darkpack/modules/werewolf_the_apocalypse/sounds/gifts/scent_of_the_true_form.ogg') // Vulture sound mixed with fleshtostone.ogg

/datum/action/cooldown/power/gift/scent_of_the_true_form/Activate(atom/target)
	if(!isliving(target))
		return
	if(!(target in range(3, owner)))
		to_chat(owner, span_warning("You can't smell [target] from here."))
		return

	. = ..()

	var/mob/living/victim = target
	var/mob/living/caster = owner
	var/datum/splat/werewolf/target_splat = get_werewolf_splat(victim)

	if(istype(target_splat))
		var/secondary_descriptor = "[pick(wyld_descriptors)]"
		switch(target_splat.tribe?.name)
			if(TRIBE_GLASS_WALKERS)
				secondary_descriptor = "[pick(weaver_descriptors)]"
			if(TRIBE_BONE_GNAWERS)
				secondary_descriptor = "[pick(weaver_descriptors)]"
			if(TRIBE_BLACK_SPIRAL_DANCERS)
				secondary_descriptor = "[pick(wyrm_descriptors)]"
		to_chat(owner, span_purple("[victim] smells like kin[secondary_descriptor ? "...<br>...and of [secondary_descriptor]." : "."]"))
	else
		var/successes = SSroll.storyteller_roll_datum(owner, null, /datum/storyteller_roll/gift/scent_of_the_true_form, bonus = PRIMAL_URGE_PLACEHOLDER)
		// CRIMSON EDIT ADD START - true_form oversuccess fix
		if (successes > 4)
			successes = 4
		// CRIMSON EDIT ADD END - true_form oversuccess fix
		switch(successes)
			if(0)
				to_chat(owner, span_purple("You can't exactly tell what [victim] smells like."))
			if(1)
				to_chat(owner, span_purple("[victim] smells mundane."))
			if(2 to 3)
				if(get_kindred_splat(victim))
					to_chat(owner, span_purple("[victim] smells of [HAS_TRAIT(victim, TRAIT_HIDDEN_WYRMTAINT) ? pick(wyld_descriptors) : pick(wyrm_descriptors)]")) // CRIMSON EDIT CHANGE - ORIGINAL: to_chat(owner, span_purple("[victim] smells of [pick(wyrm_descriptors)]"))
				if(get_shifter_splat(victim) && !get_garou_splat(victim))
					to_chat(owner, span_purple("They smell of kin, but not Garou."))
//				if(ishungrydead(victim))
//					to_chat(owner, span_purple("[victim] smells of [pick(wyrm_descriptors)]"))
//				if(ischangeling(victim))
//					to_chat(owner, span_purple("[victim] smells of [pick(wyld_descriptors)]"))
//				if(isdemon(victim))
//					to_chat(owner, span_purple("[victim] smells of brimstone."))
//				if(ismummy(victim))
//					to_chat(owner, span_purple("[victim] smells of [pick(wyld_descriptors)]"))
				else
					to_chat(owner, span_purple("[victim] smells mundane."))
			if(4)
				if(get_kindred_splat(victim))
					to_chat(owner, span_purple("[victim] smells of [HAS_TRAIT(victim, TRAIT_HIDDEN_WYRMTAINT) ? pick(wyld_descriptors) : pick(wyrm_descriptors)]")) // CRIMSON EDIT CHANGE - ORIGINAL: to_chat(owner, span_purple("[victim] smells of [pick(wyrm_descriptors)]"))
				if(get_ghoul_splat(victim))
					to_chat(owner, span_purple("[victim] smells of [pick(wyrm_descriptors)]"))
				if(get_shifter_splat(victim) && !get_garou_splat(victim))
					to_chat(owner, span_purple("They smell of kin, but not Garou."))
//				if(isfomor(victim))
//					to_chat(owner, span_purple("[victim] smells of [pick(wyrm_descriptors)]"))
//				if(ischangeling(victim))
//					to_chat(owner, span_purple("[victim] smells of [pick(wyld_descriptors)]"))
//				if(isdemon(victim))
//					to_chat(owner, span_purple("[victim] smells of brimstone."))
//				if(ismummy(victim))
//					to_chat(owner, span_purple("[victim] smells of [pick(wyld_descriptors)]"))
//				if(ismage(victim))
//					to_chat(owner, span_purple("[victim] smells of pure energy."))
				else
					to_chat(owner, span_purple("[victim] smells mundane."))

	caster.emote("sniff")

	StartCooldown()
	return TRUE


/datum/action/cooldown/power/gift/truth_of_gaia
	name = "Truth Of Gaia"
	desc = "As judges of the Litany, Philodox have the ability to sense whether others have spoken truth or falsehood."
	button_icon_state = "truth_of_gaia"
	click_to_activate = TRUE
	rank = 1

/datum/action/cooldown/power/gift/truth_of_gaia/Activate(atom/target)
	var/mob/living/living_target = astype(target)
	if(!living_target)
		return FALSE

	. = ..()

	var/datum/storyteller_roll/roll_datum = new()
	roll_datum.applicable_stats = list(STAT_INTELLIGENCE, STAT_EMPATHY)
	roll_datum.difficulty = living_target.st_get_stat(STAT_MANIPULATION) + living_target.st_get_stat(STAT_SUBTERFUGE)
	roll_datum.roll_output_type = ROLL_PRIVATE_AND_TARGET
	var/roll_result = roll_datum.st_roll(owner)

	if(roll_result != ROLL_SUCCESS)
		return

	SEND_SOUND(target, sound('sound/effects/magic/clockwork/invoke_general.ogg', volume = 50)) // LOOK OUT! A WEREWOLF IS SMELLING YOU!

	ASYNC
		var/response_w = tgui_input_list(target, "Does your character believe your last statement is the truth?", name, list("Yes", "No", "Not sure"))
		switch(response_w)
			if("Yes")
				to_chat(owner, span_notice("[target]'s scent bares the aroma of truthfulness."))
			if("No") // Lying!
				to_chat(owner, span_notice("[target]'s scent bares the aroma of deceit."))
			else // Dunno
				to_chat(owner, span_notice("[target]'s scent is uncertain. You can't determine the truth one way or the other."))

	StartCooldown()
	return TRUE

/datum/discipline/daimoinon
	name = "Daimoinon"
	desc = {"Draw power from the demons and infernal nature of Hell. Use subtle power to manipulate people and when you must, draw upon fire itself and protect yourself.
● Sense the Sin: Perception + Empathy vs. target's Self-Control + 4
●● Fear of the Void Below: Wits + Intimidation vs. target's Courage + 4
●●● Conflagration: No roll
●●●● Psychomania: target's lowest Virtue
●●●●● Condemnation: Intelligence + Occult vs. target's Willpower"}
	icon_state = "daimonion"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/daimoinon
	signature_clan = VAMPIRE_CLAN_BAALI

/datum/discipline_power/daimoinon
	name = "Daimoinon power name"
	desc = "Daimoinon power description"

	activate_sound = 'modular_darkpack/modules/deprecated/sounds/protean_activate.ogg'
	deactivate_sound = 'modular_darkpack/modules/deprecated/sounds/protean_deactivate.ogg'

//SENSE THE SIN
/datum/discipline_power/daimoinon/sense_the_sin
	name = "Sense the Sin"
	desc = "Sense the sins and cruelties of your victim."

	target_type = TARGET_HUMAN
	range = 7
	level = 1
	vitae_cost = 0

	cancelable = TRUE
	var/datum/storyteller_roll/sense_the_sin/sense_the_sin_roll

/datum/storyteller_roll/sense_the_sin
	bumper_text = "sense the sin"
	applicable_stats = list(STAT_PERCEPTION, STAT_EMPATHY)
	roll_output_type = ROLL_PRIVATE

/datum/discipline_power/daimoinon/sense_the_sin/pre_activation_checks(mob/living/target)
	if(!sense_the_sin_roll)
		sense_the_sin_roll = new()
	sense_the_sin_roll.difficulty = max(target.st_get_stat(STAT_SELF_CONTROL), target.st_get_stat(STAT_INSTINCT)) + 4
	var/roll = sense_the_sin_roll.st_roll(owner, target)
	if(roll != ROLL_SUCCESS)
		return FALSE
	else
		return TRUE

/datum/discipline_power/daimoinon/sense_the_sin/activate(mob/living/carbon/human/target)
	. = ..()
	if(target.st_get_stat(STAT_CHARISMA) <= 2)
		to_chat(owner, span_notice("They are not social or influencing."))
	if(target.st_get_stat(STAT_PERMANENT_WILLPOWER) <= 2)
		to_chat(owner, span_notice("They lack appropiate willpower."))
	if(target.st_get_stat(STAT_STRENGTH) <= 2)
		to_chat(owner, span_notice("Their body is weak and feeble."))
	if(target.st_get_stat(STAT_DEXTERITY) <= 2)
		to_chat(owner, span_notice("They lack coordination."))
	if(get_garou_splat(target))
		to_chat(owner, span_notice("Their natural banishment is silver..."))
	if(get_kindred_splat(target))
		var/datum/subsplat/vampire_clan/target_clan = target.get_clan()
		if(!target_clan)
			return
		var/target_sense_the_sin_weakness = target_clan.sense_the_sin_text
		baali_get_stolen_disciplines(target, owner)
		if(target_sense_the_sin_weakness)
			to_chat(owner, span_notice("[target.name] [target_sense_the_sin_weakness]"))
	/* DARKPACK TODO - bloodbonds
	if(isghoul(target))
		var/mob/living/carbon/human/ghoul = target

		if(ghoul.mind.enslaved_to)
			to_chat(owner, span_notice("Victim is addicted to vampiric vitae and its true master is [ghoul.mind.enslaved_to]"))
		else
			to_chat(owner, span_notice("Victim is addicted to vampiric vitae, but is independent and free."))
	*/
	/* DARKPACK TODO : Kuei-Jin
	if(iscathayan(target))
		if(target.mind.dharma?.Po == "Legalist")
			to_chat(owner, span_notice("[target] hates to be controlled!"))
		if(target.mind.dharma?.Po == "Rebel")
			to_chat(owner, span_notice("[target] doesn't like to be touched."))
		if(target.mind.dharma?.Po == "Monkey")
			to_chat(owner, span_notice("[target] is too focused on money, toys and other sources of easy pleasure."))
		if(target.mind.dharma?.Po == "Demon")
			to_chat(owner, span_notice("[target] is addicted to pain, as well as to inflicting it to others."))
		if(target.mind.dharma?.Po == "Fool")
			to_chat(owner, span_notice("[target] doesn't like to be pointed at!"))
	*/
	if(!get_kindred_splat(target) && !get_ghoul_splat(target) && !get_shifter_splat(target) /*&& !iscathayan(target)*/)
		to_chat(owner, span_notice("[target] is a feeble worm with no strengths or visible weaknesses, a mere human."))


			/* DARKPACK TODO: Warrior Salubri / Salubri Warrior
			if(VAMPIRE_CLAN_SALUBRI_WARRIOR)
				to_chat(owner, span_notice("[target] pursues an endless revenge."))
				return
			*/

/datum/discipline_power/daimoinon/sense_the_sin/proc/baali_get_stolen_disciplines(mob/living/target, mob/living/owner)
	if(!owner || !target)
		return
	var/datum/splat/vampire/kindred/vampire = get_kindred_splat(target)
	if(!vampire)
		return
	var/datum/subsplat/vampire_clan/target_clan = vampire.clan
	for(var/datum/action/discipline/disc_action as anything in vampire.powers)
		var/datum/discipline/discipline = disc_action.discipline
		if(!discipline?.selectable)
			continue
		var/signature_clan = discipline.signature_clan
		if(!signature_clan)
			continue
		if(signature_clan != target_clan.id)
			to_chat(owner, span_warning("[target] has stolen [discipline.name]!"))

//FEAR OF THE VOID BELOW
/datum/discipline_power/daimoinon/fear_of_the_void_below
	name = "Fear of the Void Below"
	desc = "Induce fear in a target."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS

	target_type = TARGET_HUMAN
	range = 7
	cooldown_length = 30 SECONDS // CRIMSON GRID ADD: DARK THAUMATURGY
	vitae_cost = 0

	var/datum/storyteller_roll/fear_of_the_void_below/fear_of_the_void_below_roll
	// CRIMSON GRID ADD: DARK THAUMATURGY
	var/datum/storyteller_roll/fear_of_the_void_below_resist/fear_of_the_void_below_resist
	var/success_count
	// CRIMSON GRID ADD END: DARK THAUMATURGY

/datum/storyteller_roll/fear_of_the_void_below
	bumper_text = "fear of the void below"
	applicable_stats = list(STAT_WITS, STAT_INTIMIDATION)
	roll_output_type = ROLL_PRIVATE
	numerical = TRUE // CRIMSON GRID ADD: DARK THAUMATURGY

// CRIMSON GRID ADD: DARK THAUMATURGY
/datum/storyteller_roll/fear_of_the_void_below_resist
	bumper_text = "control the beast"
	applicable_stats = list(STAT_COURAGE)
	roll_output_type = ROLL_NONE
	numerical = TRUE
// CRIMSON GRID ADD END: DARK THAUMATURGY

/datum/discipline_power/daimoinon/fear_of_the_void_below/activate(mob/living/carbon/human/target)
	. = ..()
	// CRIMSON GRID ADD: DARK THAUMATURGY
	if(!fear_of_the_void_below_roll)
		fear_of_the_void_below_roll = new()
	fear_of_the_void_below_roll.difficulty = target.st_get_stat(STAT_COURAGE) + 4
	success_count = SSroll.storyteller_roll_datum(owner, target, /datum/storyteller_roll/fear_of_the_void_below, difficulty = target.st_get_stat(STAT_COURAGE) + 4)
	if(success_count <= 0)
		to_chat(owner, span_warning("[target] has too much willpower to induce fear into them!"))
		return
	if(get_kindred_splat(target))
		if(!fear_of_the_void_below_resist)
			fear_of_the_void_below_resist = new()
		var/resist_count = SSroll.storyteller_roll_datum(target, owner, /datum/storyteller_roll/fear_of_the_void_below_resist, difficulty = owner.st_get_stat(STAT_PERMANENT_WILLPOWER))
		if(resist_count > success_count)
			to_chat(owner, span_warning("You fail to envelop [target]'s mind as they subdue their their beast!"))
			return
	target.apply_status_effect(/datum/status_effect/dread_gaze)
	target.emote("tremble")
	target.emote(pick("scream","cry"))
	to_chat(target, span_warning("Your greatest fear envelops you!"))
	switch(success_count)
		if(1)
			target.adjust_confusion(3 SECONDS)
		if(2)
			GLOB.move_manager.move_away(target, owner, 10, target.cached_multiplicative_slowdown, 1 SCENES)
			to_chat(target, span_userdanger("R U N !"))
		if(3 to INFINITY)
			target.Immobilize(3 SECONDS)
			if(target.body_position == STANDING_UP)
				target.toggle_resting()
			target.adjust_temp_blindness(3 SECONDS) // You're "unconscious"
	// CRIMSON GRID ADD END: DARK THAUMATURGY

//CONFLAGRATION
/datum/discipline_power/daimoinon/conflagration
	name = "Conflagration"
	desc = "Draw out the destructive essence of the Beyond."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING | TARGET_TURF | TARGET_OBJ // CRIMSON GRID ADD: DARK THAUMATURGY
	range = 7
	activate_sound = 'modular_darkpack/modules/powers/sounds/daimonion_fireball.ogg'
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

/obj/projectile/flames/baali
	color = "#1c1f1d"
	damage = 40 //CRIMSON GRID ADD: DARK THAUMATURGY
	damage_type = BURN // CRIMSON GRID ADD END: DARK THAUMATURGY

/datum/discipline_power/daimoinon/conflagration/activate(atom/target)
	. = ..()
	var/turf/start = get_turf(owner)
	var/obj/projectile/flames/baali/created_fireball = new(start)
	created_fireball.firer = owner
	var/angle = get_angle(owner, target)
	created_fireball.fire(angle, target)

//PSYCHOMANIA
/datum/discipline_power/daimoinon/psychomania
	name = "Psychomania"
	desc = "Bring forth the target's greatest fear."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE
	target_type = TARGET_LIVING
	range = 7
	cooldown_length = 30 SECONDS // CRIMSON GRID ADD: DARK THAUMATURGY
	vitae_cost = 0

	violates_masquerade = FALSE

	var/datum/storyteller_roll/psychomania/psychomania_roll

/datum/storyteller_roll/psychomania
	bumper_text = "psychomania"
	roll_output_type = ROLL_PRIVATE

/datum/discipline_power/daimoinon/psychomania/pre_activation_checks(mob/living/target)
	if(!psychomania_roll)
		psychomania_roll = new()

	// CRIMSON GRID ADD: DARK THAUMATURGY
	var/list/humanity_virtues = list(STAT_CONSCIENCE, STAT_SELF_CONTROL, STAT_COURAGE)
	var/list/enlightenment_virtues = list(STAT_CONVICTION, STAT_INSTINCT, STAT_COURAGE)
	var/list/current_virtues = target.is_enlightenment() ? enlightenment_virtues : humanity_virtues
	// CRIMSON GRID ADD END: DARK THAUMATURGY

	//forces the subject's player to roll her lowest Virtue
	var/datum/st_stat/virtue/lowest_virtue
	for(var/virtue_type in current_virtues) // CRIMSON GRID ADD: DARK THAUMATURGY
		var/datum/st_stat/virtue/target_stat = target.storyteller_stats["[virtue_type]"]
		if(!lowest_virtue || target_stat.get_score() < lowest_virtue.get_score())
			lowest_virtue = target_stat

	psychomania_roll.applicable_stats = list(lowest_virtue)
	var/roll = psychomania_roll.st_roll(target, owner)

	if(roll != ROLL_SUCCESS)
		to_chat(owner, span_cult("[target] will suffer greatly."))
		return TRUE

	to_chat(owner, span_warning("[target] is too pure to manifest their fears!"))
	return FALSE

/datum/discipline_power/daimoinon/psychomania/activate(mob/living/target)
	. = ..()

	var/datum/splat/werewolf/shifter/garou_splat = get_shifter_splat(target)
	if(garou_splat)
		garou_splat.tribe.psychomania_effect(target, owner)
		return

	var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(target)
	if(kindred_splat)
		kindred_splat.clan.psychomania_effect(target, owner)
		return

	to_chat(target, span_cult("SOMETHING IS COMING, WHAT IS IT?!!"))
	var/obj/effect/client_image_holder/baali_demon/demon = new(get_turf(target), list(target))
	RegisterSignal(demon, COMSIG_BAALI_DEMON_REACHED_TARGET, PROC_REF(on_demon_contact))
	return

/datum/discipline_power/daimoinon/psychomania/proc/on_demon_contact(obj/effect/client_image_holder/baali_demon/source, mob/living/victim)
	SIGNAL_HANDLER
	source.on_contact(victim)
	step_away(victim, get_turf(source))

//CONDEMNATION
/datum/discipline_power/daimoinon/condemnation
	name = "Condemnation"
	desc = "Condemn a soul to suffering."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_IMMOBILE
	target_type = TARGET_LIVING
	range = 7
	violates_masquerade = TRUE
	vitae_cost = 0
	var/datum/storyteller_roll/condemnation/condemnation_roll
	var/list/available_curses

/datum/storyteller_roll/condemnation
	bumper_text = "condemnation"
	applicable_stats = list(STAT_INTELLIGENCE, STAT_OCCULT)
	roll_output_type = ROLL_PRIVATE

/datum/discipline_power/daimoinon/condemnation/activate(mob/living/target)
	. = ..()

	if(target.has_status_effect(/datum/status_effect/condemnation))
		to_chat(owner, span_warning("They are already damned!"))
		return

	var/datum/splat/vampire/kindred/kindred_splat = get_kindred_splat(owner)
	if(!available_curses)
		for(var/curse_type in subtypesof(/datum/status_effect/condemnation))
			var/datum/status_effect/condemnation/curse = curse_type
			if(kindred_splat.generation <= curse.genrequired)
				LAZYSET(available_curses, curse.name, curse_type)

	var/chosen_curse_name = tgui_input_list(owner, "What curse shall befall the damned?", "Curse Selection", available_curses)
	if(!chosen_curse_name)
		return

	var/datum/status_effect/condemnation/chosen_curse_datum = available_curses[chosen_curse_name]

	if(!condemnation_roll)
		condemnation_roll = new()

	condemnation_roll.difficulty = target.st_get_stat(STAT_TEMPORARY_WILLPOWER)
	var/roll = condemnation_roll.st_roll(owner, target)
	if(roll != ROLL_SUCCESS)
		to_chat(owner, span_warning("You fail to pierce their mind and the target remains free of your curse."))
		//not sure if target should get a to_chat?
		return

	target.apply_status_effect(chosen_curse_datum)
	owner.maxbloodpool -= chosen_curse_datum.bloodcost
	owner.bloodpool = clamp(owner.bloodpool, 0, owner.maxbloodpool)



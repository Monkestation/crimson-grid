/datum/discipline/path/inferno
	name = "Fires of Inferno"
	desc = "A path of Dark Thaumaturgy that allows the manipulation of fire. Violates Masquerade."
	icon = 'modular_vcg/modules/paths/icons/paths.dmi' // Doesn't work apparently
	icon_state = "inferno"
	power_type = /datum/discipline_power/dark_thaumaturgy/path/inferno

/datum/discipline_power/dark_thaumaturgy/path/inferno
	name = "Dark Thaumaturgy: Fires of Inferno Power Name"
	desc = "Dark Thaumaturgy: Fires of Inferno Power Description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/thaum.ogg'

	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_TORPORED
	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE
	range = 7

	cooldown_length = 3 TURNS
	var/success_count

/datum/storyteller_roll/fires_of_inferno
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	numerical = TRUE

/datum/discipline_power/dark_thaumaturgy/path/inferno/activate(atom/target)
	. = ..()
	success_count = SSroll.storyteller_roll_datum(owner, target, /datum/storyteller_roll/fires_of_inferno, difficulty = (level + 3))
	if(success_count < 0)
		owner.visible_message(span_notice("[owner] gets lit ablaze!."), \
			span_notice("You get lit ablaze!"))
		inferno_botch_effect()
		return TRUE
	else if(success_count == 0)
		to_chat(owner, span_notice("Your magic fizzles out!"))
		return TRUE
	return FALSE

/datum/discipline_power/dark_thaumaturgy/path/inferno/proc/inferno_botch_effect()
	to_chat(owner, span_userdanger("You feel like there's a sun inside of you!"))
	owner.adjust_fire_stacks(5, overwrite_color = COLOR_VERY_DARK_LIME_GREEN)
	owner.ignite_mob()

/datum/discipline_power/dark_thaumaturgy/path/inferno/post_gain()
	. = ..()
	ADD_TRAIT(owner, TRAIT_AURA_OF_INFERNO, FIRES_OF_INFERNO_TRAIT)
	SEND_SIGNAL(owner, COMSIG_MOB_UPDATE_AURA)

/datum/discipline_power/dark_thaumaturgy/path/inferno/lighter
	name = "Lighter"
	desc = "Touch the blood of a subject and gain information about the subject."

	level = 1
	range = 7
	target_type = TARGET_MOB

/datum/discipline_power/dark_thaumaturgy/path/inferno/lighter/activate(mob/living/target)
	if(..())
		return
	to_chat(owner, span_warning("You conjure a spark of infernal flames, lighting [target]!"))
	target.adjust_fire_stacks(1, overwrite_color = COLOR_VERY_DARK_LIME_GREEN)
	target.ignite_mob()

/datum/discipline_power/dark_thaumaturgy/path/inferno/stovetop
	name = "Stovetop"
	desc = "Touch the blood of a subject and gain information about the subject."

	level = 2
	range = 2
	target_type = TARGET_MOB

/datum/discipline_power/dark_thaumaturgy/path/inferno/stovetop/activate(mob/living/target)
	if(..())
		return
	var/throwtarget = get_edge_target_turf(owner, get_dir(owner, get_step_away(target, owner)))
	target.safe_throw_at(throwtarget, 3, 1, src, spin = TRUE, force = MOVE_FORCE_VERY_STRONG, gentle = TRUE)
	target.Knockdown(0.1 SECONDS)
	target.apply_damage(5 * success_count, BURN)
	target.adjust_fire_stacks(1, overwrite_color = COLOR_VERY_DARK_LIME_GREEN)
	owner.visible_message(span_warning("[owner] hurls infernal flames at [target]!"), \
			span_notice("You hurl infernal flames at [target]!"))

/datum/discipline_power/dark_thaumaturgy/path/inferno/blowtorch
	name = "Blowtorch"
	desc = "Touch the blood of a subject and gain information about the subject."

	level = 3
	range = 7
	target_type = TARGET_MOB

/datum/discipline_power/dark_thaumaturgy/path/inferno/blowtorch/activate(mob/living/target)
	if(..())
		return
	var/beam_duration = clamp(success_count*2 SECONDS, 2 SECONDS, 10 SECONDS)
	var/datum/beam/blowtorch/new_beam = new(owner, target, 'icons/effects/beam.dmi', "sm_arc_supercharged", beam_duration, 9, /obj/effect/ebeam/reacting/blowtorch, COLOR_VERY_DARK_LIME_GREEN)
	INVOKE_ASYNC(new_beam, TYPE_PROC_REF(/datum/beam/, Start))
	owner.visible_message(span_warning("[owner] unleashes a burning beam of infernal fire at [target]!"), \
			span_notice("You unleash a burning beam of infernal fire at [target]!"))

/datum/discipline_power/dark_thaumaturgy/path/inferno/flamethrower
	name = "Flame-thrower"
	desc = "Touch the blood of a subject and gain information about the subject."

	level = 4
	range = 7
	target_type = TARGET_TURF

/datum/discipline_power/dark_thaumaturgy/path/inferno/flamethrower/activate(turf/target_turf)
	if(..())
		return
	var/turf/owner_turf = get_turf(owner)
	var/dir = get_cardinal_dir(owner_turf, target_turf)
	owner.setDir(dir)
	var/datum/action/cooldown/spell/cone/staggered/entropic_plume_infernal/flamethrower = new(owner)
	flamethrower.cast(owner)
	owner.visible_message(span_warning("[owner] manifests a devastating cloud of inferno!"), \
			span_notice("You manifest a devastating cloud of inferno!"))

/datum/discipline_power/dark_thaumaturgy/path/inferno/conflagration
	name = "Conflagration"
	desc = "Unleash a growing storm of green fire that expands outward."

	level = 5
	range = 7
	target_type = TARGET_TURF | TARGET_LIVING

/datum/discipline_power/dark_thaumaturgy/path/inferno/conflagration/activate(atom/target)
	if(..())
		return

	to_chat(owner, span_notice("You begin channeling a deadly inferno..."))

	var/turf/center = get_turf(target)

	new /obj/effect/temp_visual/inferno_warning/infernal(center)
	owner.visible_message(span_warning("Sparks of green flame begin to fly and the temperature begins to climb... Something terrible is about to happen!"))

	if(!do_after(owner, 2 SECONDS))
		to_chat(owner, span_warning("Your inferno casting was interrupted!"))
		for(var/obj/effect/temp_visual/inferno_warning/infernal/warning in center)
			qdel(warning)
		return

	var/base_damage = 40 + (success_count * 5)
	var/fire_stacks_amount = 3 + success_count
	var/ignite_chance = min(60 + (success_count * 10), 95)

	// fire at center
	for(var/obj/effect/temp_visual/inferno_warning/infernal/warning in center)
		qdel(warning)
	new /obj/effect/abstract/turf_fire/infernal(center, 20, COLOR_VERY_DARK_LIME_GREEN)
	do_inferno_effect(center, base_damage, fire_stacks_amount, ignite_chance)

	// ghost flame 1x1
	for(var/turf/selected_turf in orange(1, center))
		new /obj/effect/temp_visual/inferno_warning/infernal(selected_turf)

	// 3x3 fire
	addtimer(CALLBACK(src, PROC_REF(spread_fire), center, 1, base_damage, fire_stacks_amount, ignite_chance), 2 SECONDS)

	// ghost flame 5x5
	addtimer(CALLBACK(src, PROC_REF(create_ghost_fire), center, 2), 2 SECONDS)

	// 5x5 fire
	addtimer(CALLBACK(src, PROC_REF(spread_fire), center, 2, base_damage, fire_stacks_amount, ignite_chance), 4 SECONDS)

	playsound(center, effect_sound, 100, TRUE)
	owner.visible_message(span_danger("[owner] unleashes a devastating inferno!"))

	switch(success_count)
		if(1)
			to_chat(owner, span_bolddanger("Your inferno burns with modest intensity."))
		if(2)
			to_chat(owner, span_bolddanger("Your inferno rages with considerable power."))
		if(3 to INFINITY)
			to_chat(owner, span_bolddanger("Your inferno burns with devastating supernatural fury!"))

/datum/discipline_power/dark_thaumaturgy/path/inferno/conflagration/proc/spread_fire(turf/selected_turf, dist, base_damage, fire_stacks_amount, ignite_chance)
	for(var/turf/open/open_turf in orange(dist, selected_turf))
		for(var/obj/effect/temp_visual/inferno_warning/infernal/inferno_fire in open_turf)
			qdel(inferno_fire)
		if(!open_turf.turf_fire)
			new /obj/effect/abstract/turf_fire/infernal(open_turf, 20, COLOR_VERY_DARK_LIME_GREEN)
		do_inferno_effect(open_turf, base_damage, fire_stacks_amount, ignite_chance)

/datum/discipline_power/dark_thaumaturgy/path/inferno/conflagration/proc/do_inferno_effect(turf/selected_turf, base_damage, fire_stacks_amount, ignite_chance)
	for(var/mob/living/living_target in selected_turf)
		if(living_target == owner)
			continue
		living_target.adjust_fire_loss(base_damage)
		if(prob(ignite_chance))
			living_target.adjust_fire_stacks(fire_stacks_amount, overwrite_color = COLOR_VERY_DARK_LIME_GREEN)
			living_target.ignite_mob()
		to_chat(living_target, span_userdanger("You are caught in a supernatural inferno!"))

/datum/discipline_power/dark_thaumaturgy/path/inferno/conflagration/proc/create_ghost_fire(turf/selected_turf, dist)
	for(var/turf/open/open_turf in orange(dist, selected_turf))
		if(!open_turf.turf_fire)
			new /obj/effect/temp_visual/inferno_warning/infernal(open_turf)

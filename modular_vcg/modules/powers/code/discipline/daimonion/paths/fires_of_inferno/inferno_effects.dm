#define TURF_FIRE_REQUIRED_TEMP (T0C+10)
#define TURF_FIRE_POWER_LOSS_ON_LOW_TEMP 7
#define TURF_FIRE_BURN_PLAY_SOUND_EFFECT_CHANCE 6
#define TURF_FIRE_MIN_POWER_TO_SPREAD 20
#define TURF_FIRE_SPREAD_RATE 0.3
#define TURF_FIRE_MAX_POWER 50
#define TURF_FIRE_TEMP_INCREMENT_PER_POWER 3
#define TURF_FIRE_TEMP_BASE (T0C+100)
#define TURF_FIRE_VOLUME 150

// Fires of Inferno 3 - Blowtorch

/datum/beam/blowtorch
	beam_type = /obj/effect/ebeam/reacting/blowtorch

/datum/beam/blowtorch/Start()
	. = ..()
	START_PROCESSING(SSfastprocess, src)

/datum/beam/blowtorch/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/effect/ebeam/reacting/blowtorch
	name = "blowtorch"
	react_on_init = TRUE

/datum/beam/blowtorch/process(seconds_per_tick)
	if(isliving(target))
		var/mob/living/living_target = target
		living_target.apply_damage(10*seconds_per_tick, BURN)

/obj/effect/ebeam/reacting/blowtorch/beam_entered(atom/movable/entered)
	. = ..()
	if(!isliving(entered))
		return
	var/mob/living/living_entered = entered
	if(living_entered == owner.origin || living_entered == owner.target)
		return
	living_entered.adjust_fire_stacks(3, overwrite_color = COLOR_VERY_DARK_LIME_GREEN)
	living_entered.ignite_mob()

// Fires of Inferno 4 - Flame-thrower

/datum/action/cooldown/spell/cone/staggered/entropic_plume_infernal
	name = "Entropic Plume"
	desc = "Spews forth a disorienting plume that causes enemies to strike each other, \
		briefly blinds them (increasing with range) and poisons them (decreasing with range). \
		Also spreads rust in the path of the plume."
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "entropic_plume"
	sound = 'sound/effects/magic/forcewall.ogg'

	school = SCHOOL_EVOCATION
	cooldown_time = 30 SECONDS

	invocation_type = NONE
	spell_requirements = NONE

	cone_levels = 6
	respect_density = TRUE

/obj/effect/temp_visual/dir_setting/entropic/infernal
	color = COLOR_VERY_DARK_LIME_GREEN

/datum/action/cooldown/spell/cone/staggered/entropic_plume_infernal/cast(atom/cast_on)
	. = ..()
	new /obj/effect/temp_visual/dir_setting/entropic/infernal(get_step(cast_on, cast_on.dir), cast_on.dir)

/datum/action/cooldown/spell/cone/staggered/entropic_plume_infernal/do_turf_cone_effect(turf/target_turf, mob/living/caster, level)
	return

/datum/action/cooldown/spell/cone/staggered/entropic_plume_infernal/do_mob_cone_effect(mob/living/victim, atom/caster, level)
	victim.apply_damage(50, BURN)
	victim.adjust_fire_stacks(3, overwrite_color = COLOR_VERY_DARK_LIME_GREEN)
	victim.ignite_mob()
	to_chat(victim, span_boldwarning("You are engulfed in infernal flames!"))

/datum/action/cooldown/spell/cone/staggered/entropic_plume_infernal/calculate_cone_shape(current_level)
	// At the first level (that isn't level 1) we will be small
	if(current_level == 2)
		return 3
	// At the max level, we turn small again
	if(current_level == cone_levels)
		return 3
	// Otherwise, all levels in between will be wider
	return 5

// Fires of Inferno 5 - Conflagration

/obj/effect/temp_visual/inferno_warning/infernal
	color = COLOR_VERY_DARK_LIME_GREEN

/obj/effect/abstract/turf_fire/infernal

/obj/effect/abstract/turf_fire/infernal/process(seconds_per_tick)
	var/turf/current_turf = loc
	if(!isopenturf(current_turf)) //This can happen, how I'm not sure
		qdel(src)
		return
	var/turf/open/open_turf = loc
	if(open_turf.active_hotspot) //If we have an active hotspot, let it do the damage instead and lets not loose power
		return
	if(interact_with_atmos)
		if(!process_waste())
			qdel(src)
			return

	if(passive_loss)
		if(open_turf.air.return_temperature() < TURF_FIRE_REQUIRED_TEMP)
			fire_power -= TURF_FIRE_POWER_LOSS_ON_LOW_TEMP
		//var/area/fire_area = get_area(src)
		//if(fire_area.active_weather?.fire_suppression)
		//	fire_power -= fire_area.active_weather.fire_suppression
		fire_power = min(fire_power + open_turf.flammability - 1, TURF_FIRE_MAX_POWER)
		if(fire_power <= 0)
			qdel(src)
			return
		for(var/turf/open/turf_to_spread in open_turf.atmos_adjacent_turfs)
			if(turf_to_spread.turf_fire)
				continue
			if(fire_power + turf_to_spread.flammability < TURF_FIRE_MIN_POWER_TO_SPREAD)
				continue
			if(!prob(turf_to_spread.flammability * fire_power * TURF_FIRE_SPREAD_RATE))
				continue
			turf_to_spread.ignite_turf(fire_power * TURF_FIRE_SPREAD_RATE, hex_color, /obj/effect/abstract/turf_fire/infernal)
		UpdateFireState()

	open_turf.hotspot_expose(TURF_FIRE_TEMP_BASE + (TURF_FIRE_TEMP_INCREMENT_PER_POWER*fire_power), TURF_FIRE_VOLUME)
	for(var/atom/movable/burning_atom as anything in open_turf)
		fire_power += burning_atom.fire_act(TURF_FIRE_TEMP_BASE + (TURF_FIRE_TEMP_INCREMENT_PER_POWER*fire_power), TURF_FIRE_VOLUME, hex_color)
	if(interact_with_atmos)
		if(prob(fire_power))
			open_turf.burn_tile()
		if(prob(TURF_FIRE_BURN_PLAY_SOUND_EFFECT_CHANCE))
			playsound(open_turf, 'sound/effects/comfyfire.ogg', 40, TRUE)

/obj/effect/abstract/turf_fire/infernal/on_entered(datum/source, atom/movable/atom_crossing)
	var/turf/open/open_turf = loc
	if(open_turf.active_hotspot) //If we have an active hotspot, let it do the damage instead
		return
	atom_crossing.fire_act(TURF_FIRE_TEMP_BASE + (TURF_FIRE_TEMP_INCREMENT_PER_POWER*fire_power), TURF_FIRE_VOLUME, hex_color)
	return

#undef TURF_FIRE_REQUIRED_TEMP
#undef TURF_FIRE_POWER_LOSS_ON_LOW_TEMP
#undef TURF_FIRE_BURN_PLAY_SOUND_EFFECT_CHANCE
#undef TURF_FIRE_MIN_POWER_TO_SPREAD
#undef TURF_FIRE_SPREAD_RATE
#undef TURF_FIRE_MAX_POWER
#undef TURF_FIRE_TEMP_INCREMENT_PER_POWER
#undef TURF_FIRE_TEMP_BASE
#undef TURF_FIRE_VOLUME

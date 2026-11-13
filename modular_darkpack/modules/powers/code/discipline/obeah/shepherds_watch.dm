/datum/storyteller_roll/shepherds_watch
	bumper_text = "shepherd's watch"
	applicable_stats = list(STAT_PERMANENT_WILLPOWER)
	roll_output_type = ROLL_FLAG_ROLLER
	numerical = TRUE
	spammy_roll = TRUE
	difficulty = 1 // This changes for both.

/datum/storyteller_roll/shepherds_watch/contested
	bumper_text = "shepherds watch"

/datum/proximity_monitor/advanced/shepherds_watch
	edge_is_a_field = TRUE
	var/list/ignored_mobs
	var/datum/storyteller_roll/salubri_roll_type = /datum/storyteller_roll/shepherds_watch
	var/datum/storyteller_roll/contested_roll_type = /datum/storyteller_roll/shepherds_watch/contested

/datum/proximity_monitor/advanced/shepherds_watch/New(atom/_host, range, _ignore_if_not_on_turf = TRUE)
	. = ..()
	ignored_mobs = new()
	recalculate_field(full_recalc = TRUE)

/datum/proximity_monitor/advanced/shepherds_watch/Destroy()
	ignored_mobs = null
	return ..()

/datum/proximity_monitor/advanced/shepherds_watch/setup_field_turf(turf/target)
	if(QDELETED(src))
		return
	for(var/mob/living/possible_mob in target)
		if(possible_mob == host)
			continue
		barrier_check(host, possible_mob)

/datum/proximity_monitor/advanced/shepherds_watch/on_entered(atom/source, atom/movable/arrived, turf/old_loc)
	. = ..()
	if(QDELETED(src))
		return
	if(!isliving(arrived))
		return
	if(arrived == host)
		return
	barrier_check(host, arrived, old_loc)

/datum/proximity_monitor/advanced/shepherds_watch/on_moved(atom/movable/source, atom/old_loc)
	. = ..()
	if(QDELETED(src))
		return
	if(!isliving(source))
		return
	if(source == host)
		return
	barrier_check(host, source, old_loc)

/datum/proximity_monitor/advanced/shepherds_watch/on_z_change(datum/source, turf/old_turf, turf/new_turf)
	. = ..()
	if(QDELETED(src))
		return
	if(!isliving(source))
		return
	if(source == host)
		return
	barrier_check(host, source, old_turf)

/datum/proximity_monitor/advanced/shepherds_watch/proc/barrier_check(mob/living/salubri, mob/living/opponent, turf/old_loc)
	if(opponent in ignored_mobs)
		return
	if(roll_contested_willpower(salubri, opponent) > 3)
		ignored_mobs |= opponent
		return
	var/throwtarget = old_loc
	if(!throwtarget)
		throwtarget = get_edge_target_turf(salubri, get_dir(salubri, get_step_away(opponent, salubri)))
	opponent.safe_throw_at(throwtarget, 1, 1, src, spin = FALSE, force = MOVE_FORCE_VERY_STRONG, gentle = TRUE)

/datum/proximity_monitor/advanced/shepherds_watch/proc/roll_contested_willpower(mob/living/salubri, mob/living/opponent)
	var/datum/storyteller_roll/shepherds_watch/salubri_roll = new salubri_roll_type()
	var/datum/storyteller_roll/shepherds_watch/contested/contested_roll = new contested_roll_type()
	salubri_roll.difficulty = opponent.st_get_stat(STAT_TEMPORARY_WILLPOWER)
	contested_roll.difficulty = salubri.st_get_stat(STAT_TEMPORARY_WILLPOWER)

	var/salubri_successes = salubri_roll.st_roll(salubri, opponent)
	var/opponent_successes = contested_roll.st_roll(opponent, salubri)
	return (opponent_successes - salubri_successes)

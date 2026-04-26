/// Global list to track mobs grabbed by any tentacle
GLOBAL_LIST_EMPTY(global_tentacle_grabs)

/mob/living/basic/abyss_tentacle
	name = "abyssal tentacle"
	desc = "A shadowy tentacle from the abyss that seeks to grab and crush its prey."
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_state = "goliath_tentacle_wiggle"
	icon_living = "goliath_tentacle_wiggle"
	icon_dead = "goliath_tentacle_retract"
	color = rgb(0,0,0)
	layer = BELOW_MOB_LAYER
	density = FALSE
	maxHealth = 120
	health = 120
	see_in_dark = 10

	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_verb_continuous = "crushes"
	attack_verb_simple = "crush"
	attack_sound = 'sound/items/weapons/punch1.ogg'
	speak_emote = list("writhes")
	basic_mob_flags = DEL_ON_DEATH
	mobility_flags = NONE


	environment_smash = ENVIRONMENT_SMASH_NONE

	var/mob/living/carbon/human/owner
	var/mob/living/grabbed_mob = null
	var/list/recently_released = list()
	var/aggro_mode = "Aggressive"
	COOLDOWN_DECLARE(grab_cooldown)
	COOLDOWN_DECLARE(damage_cooldown)
	ai_controller = /datum/ai_controller/basic_controller/abyss_tentacle

/datum/ai_controller/basic_controller/abyss_tentacle
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
	)
	ai_movement = /datum/ai_movement/complete_stop
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/tentacle_grab_and_crush,
	)

/datum/ai_planning_subtree/tentacle_grab_and_crush

/datum/ai_planning_subtree/tentacle_grab_and_crush/SelectBehaviors(datum/ai_controller/controller, delta_time)
	var/mob/living/basic/abyss_tentacle/tentacle = controller.pawn
	if(!istype(tentacle))
		return

	if(tentacle.aggro_mode == "Passive")
		if(tentacle.grabbed_mob)
			tentacle.release_grabbed_mob()
		return

	if(tentacle.grabbed_mob)
		if(tentacle.aggro_mode == "Aggressive")
			controller.queue_behavior(/datum/ai_behavior/tentacle_crush_victim)
		return SUBTREE_RETURN_FINISH_PLANNING

	var/mob/living/target = find_valid_grab_target(tentacle)
	if(target)
		controller.queue_behavior(/datum/ai_behavior/tentacle_grab_target, target)
		return SUBTREE_RETURN_FINISH_PLANNING

	return


/datum/ai_planning_subtree/tentacle_grab_and_crush/proc/find_valid_grab_target(mob/living/basic/abyss_tentacle/tentacle)
	for(var/mob/living/potential_target in oview(2, tentacle))
		//dont attack our owner, dead things, other tentacles, things being grabbed by tentacles, or things recently released
		if(potential_target == tentacle.owner)
			continue
		if(potential_target.stat == DEAD)
			continue
		if(istype(potential_target, /mob/living/basic/abyss_tentacle))
			continue
		if(potential_target in GLOB.global_tentacle_grabs)
			continue
		if(potential_target in tentacle.recently_released)
			continue

		return potential_target
	return null

/datum/ai_behavior/tentacle_grab_target
	action_cooldown = 2 SECONDS

/datum/ai_behavior/tentacle_grab_target/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/mob/living/target = target_key
	if(!istype(target))
		return FALSE
	return TRUE

/datum/ai_behavior/tentacle_grab_target/perform(seconds_per_tick, datum/ai_controller/controller, mob/living/target)
	. = ..()
	var/mob/living/basic/abyss_tentacle/tentacle = controller.pawn

	if(!istype(tentacle))
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	tentacle.grab_mob(target)

	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED

/datum/ai_behavior/tentacle_crush_victim
	action_cooldown = 5 SECONDS

/datum/ai_behavior/tentacle_crush_victim/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/basic/abyss_tentacle/tentacle = controller.pawn

	if(!istype(tentacle) || !tentacle.grabbed_mob)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	tentacle.grabbed_mob.apply_damage(40, BRUTE)
	to_chat(tentacle.grabbed_mob, span_danger("The tentacle tightens its grip, crushing you!"))
	playsound(tentacle, 'sound/mobs/non-humanoids/venus_trap/venus_trap_hurt.ogg', 50, FALSE)

	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED

/mob/living/basic/abyss_tentacle/Initialize(mapload, mob/living/summoner)
	. = ..()
	if(summoner)
		owner = summoner
	if(owner?.tentacle_aggro_mode)
		aggro_mode = owner.tentacle_aggro_mode

/mob/living/basic/abyss_tentacle/Destroy(force)
	if(owner)
		var/datum/splat/vampire/vampire = get_splat_with_discipline(owner)
		var/datum/discipline_power/obtenebration/arms_of_the_abyss/power = vampire.get_discipline_power(/datum/discipline_power/obtenebration/arms_of_the_abyss)
		power.active_tentacles -= src

	. = ..()

/mob/living/basic/abyss_tentacle/proc/grab_mob(mob/living/target)
	// More checks
	if(target == owner || istype(target, /mob/living/basic/abyss_tentacle))
		return
	if(target in GLOB.global_tentacle_grabs)
		return
	if(grabbed_mob)
		return
	if(target.client)
		to_chat(target, span_userdanger("A shadowy tentacle grabs you!"))
	visible_message(span_danger("[src] grabs hold of [target]!"))

	playsound(src, 'sound/misc/moist_impact.ogg', 50, FALSE)
	target.Stun(5)
	target.forceMove(get_turf(src))
	target.set_tentacle_grab(src)

	if(aggro_mode == "Control")
		target.mobility_flags &= ~(MOBILITY_STAND | MOBILITY_MOVE)
		target.set_resting(TRUE, TRUE, TRUE)
		to_chat(target, span_userdanger("The tentacle forces you to the ground!"))

	grabbed_mob = target
	GLOB.global_tentacle_grabs += target

	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_grabbed_mob_move))

/mob/living/basic/abyss_tentacle/proc/release_mob(mob/living/target, add_cooldown = TRUE)
	if(target == grabbed_mob)
		grabbed_mob = null
		GLOB.global_tentacle_grabs -= target
		target.Stun(0)
		target.clear_tentacle_grab()

		if(aggro_mode == "Control")
			target.mobility_flags |= (MOBILITY_STAND | MOBILITY_MOVE)
			target.set_resting(FALSE, TRUE, TRUE)

		UnregisterSignal(target, COMSIG_MOVABLE_MOVED)
		to_chat(target, span_notice("The tentacle releases you!"))

		if(add_cooldown)
			recently_released += target
			addtimer(CALLBACK(src, PROC_REF(remove_from_recently_released), target), 10 SECONDS)

/mob/living/basic/abyss_tentacle/proc/remove_from_recently_released(mob/living/target)
	recently_released -= target

/mob/living/basic/abyss_tentacle/proc/release_grabbed_mob()
	if(grabbed_mob)
		release_mob(grabbed_mob, FALSE)

/mob/living/basic/abyss_tentacle/proc/on_grabbed_mob_move(mob/living/source, atom/old_loc, movement_dir, forced)
	SIGNAL_HANDLER

	if(!source || QDELETED(source))
		return

	if(get_dist(source, src) > 0)
		if(world.time >= source.tentacle_escape_attempt)
			source.tentacle_escape_attempt = world.time + 1 TURNS
			var/rollcheck = SSroll.storyteller_roll(source.st_get_stat(STAT_STRENGTH), 6, source)
			switch(rollcheck)
				if(ROLL_SUCCESS)
					to_chat(source, span_notice("You break free from the tentacle's grasp!"))
					release_mob(source, TRUE)
					return
				if(ROLL_FAILURE, ROLL_BOTCH)
					to_chat(source, span_warning("You struggle against the tentacle but can't break free!"))

		source.visible_message(span_danger("The tentacle pulls [source] back!"))
		source.forceMove(get_turf(src))

/mob/living/basic/abyss_tentacle/death(gibbed)
	visible_message(span_danger("[src] retracts back into the shadows!"))
	release_grabbed_mob()
	. = ..()

/mob/living/proc/set_tentacle_grab(obj/tentacle)
	return

/mob/living/proc/clear_tentacle_grab()
	tentacle_escape_attempt = 0

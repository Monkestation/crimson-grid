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
	move_resist = MOVE_FORCE_EXTREMELY_STRONG

	environment_smash = ENVIRONMENT_SMASH_NONE

	ai_controller = /datum/ai_controller/basic_controller/abyss_tentacle

	var/mob/living/carbon/human/owner
	var/list/recently_released = list()
	COOLDOWN_DECLARE(grab_cooldown)
	COOLDOWN_DECLARE(damage_cooldown)

/datum/ai_controller/basic_controller/abyss_tentacle
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/abyss_tentacle,
	)
	ai_movement = /datum/ai_movement/complete_stop

	behavior_tree_json = "modular_darkpack/modules/npc/code/nonhuman/hostile/abyss_tentacle.bt.json"


/datum/targeting_strategy/abyss_tentacle

/datum/targeting_strategy/abyss_tentacle/is_valid_target(mob/living/living_mob, atom/the_target, vision_range, datum/ai_controller/controller = null)
	var/mob/living/basic/abyss_tentacle/tentacle = astype(living_mob)
	var/mob/living/target = astype(the_target)
	if(!tentacle || !target)
		return FALSE
	//dont attack our owner, dead things, other tentacles, things being grabbed by tentacles, or things recently released
	if(target == tentacle.owner)
		return FALSE
	if(target.stat == DEAD)
		return FALSE
	if(istype(target, /mob/living/basic/abyss_tentacle))
		return FALSE
	if(target in GLOB.global_tentacle_grabs)
		return FALSE
	if(target in tentacle.recently_released)
		return FALSE

	return ..()


/datum/bt_node/ai_behavior/tentacle_grab_target
	time_between_perform = 2 SECONDS

/datum/bt_node/ai_behavior/tentacle_grab_target/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/basic/abyss_tentacle/tentacle = astype(controller.pawn)
	var/mob/living/target = astype(controller.blackboard[BB_CURRENT_TARGET])
	if(!tentacle)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED
	if(!target)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	tentacle.grab_mob(target)

	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED


/datum/bt_node/ai_behavior/tentacle_crush_victim
	time_between_perform = 5 SECONDS

/datum/bt_node/ai_behavior/tentacle_crush_victim/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/basic/abyss_tentacle/tentacle = astype(controller.pawn)
	var/mob/living/grabbed = astype(controller.blackboard[BB_ABYSS_TENTACLE_GRABBED])
	if(!tentacle || !grabbed)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	grabbed.apply_damage(40, BRUTE)
	to_chat(grabbed, span_danger("The tentacle tightens its grip, crushing you!"))
	playsound(tentacle, 'sound/mobs/non-humanoids/venus_trap/venus_trap_hurt.ogg', 50, FALSE)

	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED


/datum/bt_node/ai_behavior/tentacle_release_target

/datum/bt_node/ai_behavior/tentacle_release_target/perform(seconds_per_tick, datum/ai_controller/controller)
	. = ..()
	var/mob/living/basic/abyss_tentacle/tentacle = astype(controller.pawn)
	var/mob/living/grabbed = astype(controller.blackboard[BB_ABYSS_TENTACLE_GRABBED])
	if(!tentacle || !grabbed)
		return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_FAILED

	tentacle.release_grabbed_mob()
	return AI_BEHAVIOR_DELAY | AI_BEHAVIOR_SUCCEEDED


/mob/living/basic/abyss_tentacle/Initialize(mapload, mob/living/summoner)
	. = ..()
	if(summoner)
		owner = summoner

/mob/living/basic/abyss_tentacle/Destroy(force)
	if(owner)
		var/datum/splat/vampire/vampire = get_splat_with_discipline(owner)
		var/datum/discipline_power/obtenebration/arms_of_the_abyss/abyss_power = vampire?.get_discipline_power(/datum/discipline_power/obtenebration/arms_of_the_abyss)
		if(abyss_power)
			abyss_power.active_tentacles -= src
		release_grabbed_mob()

	. = ..()

/mob/living/basic/abyss_tentacle/proc/grab_mob(mob/living/target)
	// More checks
	if(target == owner || istype(target, /mob/living/basic/abyss_tentacle))
		return
	if(target in GLOB.global_tentacle_grabs)
		return
	if(ai_controller?.blackboard[BB_ABYSS_TENTACLE_GRABBED])
		return
	if(target.client)
		to_chat(target, span_userdanger("A shadowy tentacle grabs you!"))
	visible_message(span_danger("[src] grabs hold of [target]!"))

	playsound(src, 'sound/misc/moist_impact.ogg', 50, FALSE)
	target.Stun(5)
	target.forceMove(get_turf(src))
	target.set_tentacle_grab(src)

	if(ai_controller?.blackboard[BB_ABYSS_TENTACLE_MODE] == ABYSS_TENTACLE_MODE_CONTROL)
		target.mobility_flags &= ~(MOBILITY_STAND | MOBILITY_MOVE)
		target.set_resting(TRUE, TRUE, TRUE)
		to_chat(target, span_userdanger("The tentacle forces you to the ground!"))

	ai_controller?.set_blackboard_key(BB_ABYSS_TENTACLE_GRABBED, target)
	GLOB.global_tentacle_grabs += target

	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(on_grabbed_mob_move))

/mob/living/basic/abyss_tentacle/proc/release_mob(mob/living/target, add_cooldown = TRUE)
	if(target == ai_controller?.blackboard[BB_ABYSS_TENTACLE_GRABBED])
		ai_controller?.clear_blackboard_key(BB_ABYSS_TENTACLE_GRABBED)
		GLOB.global_tentacle_grabs -= target
		target.Stun(0)
		target.clear_tentacle_grab()

		if(ai_controller?.blackboard[BB_ABYSS_TENTACLE_MODE] == ABYSS_TENTACLE_MODE_CONTROL)
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
	var/mob/living/grabbed_mob = ai_controller?.blackboard[BB_ABYSS_TENTACLE_GRABBED]
	if(grabbed_mob)
		release_mob(grabbed_mob, FALSE)

/mob/living/basic/abyss_tentacle/proc/on_grabbed_mob_move(mob/living/source, atom/old_loc, movement_dir, forced)
	SIGNAL_HANDLER

	if(!source || QDELETED(source))
		return

	if(get_dist(source, src) > 0)
		if(world.time >= source.tentacle_escape_attempt)
			source.tentacle_escape_attempt = world.time + 1 TURNS
			var/rollcheck = SSroll.storyteller_roll_datum(source, applic_stats = list(STAT_STRENGTH))
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

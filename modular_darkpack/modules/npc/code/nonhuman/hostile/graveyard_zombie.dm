/mob/living/basic/zombie/darkpack
	name = "Shambling Corpse"
	desc = "When there is no more room in Hell, the dead will walk on Earth."
	icon = 'modular_darkpack/modules/npc/icons/zombies.dmi'
	icon_state = "zombie"
	icon_living = "zombie"
	icon_dead = "zombie_dead"
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	maxHealth = 50
	health = 50
	melee_damage_lower = 21
	melee_damage_upper = 21
	default_blood_volume = 100
	blood_volume = 100
	bloodpool = 2
	maxbloodpool = 2
	living_flags = LIVING_CAN_HAVE_BLOOD
	obj_damage = 2
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'modular_darkpack/modules/deprecated/sounds/zombuzi.ogg'
	status_flags = CANPUSH
	basic_mob_flags = NONE
	speed = 1
	faction = list("zombie")
	ai_controller = /datum/ai_controller/basic_controller/zombie/darkpack
	outfit = null
	death_message = null

	var/obj/vampgrave/source_grave

/mob/living/basic/zombie/darkpack/Initialize(mapload)
	. = ..()
	// the parent is causing them to appear as space station 13 zombies - this removes that.
	icon = 'modular_darkpack/modules/npc/icons/zombies.dmi'
	icon_state = icon_living
	cut_overlays()
	update_body()
	AddElement(/datum/element/ai_retaliate)

/mob/living/basic/zombie/darkpack/Destroy()
	if(source_grave)
		source_grave.spawned_zombies -= src
	source_grave = null
	return ..()

/mob/living/basic/zombie/darkpack/skeleton
	name = "Skeleton"
	health = 30
	maxHealth = 30
	bloodpool = 0
	maxbloodpool = 0
	default_blood_volume = 0
	blood_volume = 0
	icon_living = "skeleton"
	icon_state = "skeleton"
	icon_dead = "skeleton_dead"
	speed = 2

/mob/living/basic/zombie/darkpack/fat_zombie
	name = "Fat Zombie"
	health = 70
	maxHealth = 70
	melee_damage_lower = 31
	melee_damage_upper = 31
	bloodpool = 5
	maxbloodpool = 5
	icon_living = "zombietop"
	icon_state = "zombietop"
	icon_dead = "zombietop_dead"
	speed = 0.5

/mob/living/basic/zombie/darkpack/suit_zombie
	icon_living = "zombieup"
	icon_state = "zombieup"
	icon_dead = "zombieup_dead"


// need a custom targeting strategy so they don't kill other zombies
/datum/targeting_strategy/basic/zombie_darkpack

/datum/targeting_strategy/basic/zombie_darkpack/can_attack(mob/living/basic/basic_mob, atom/target, vision_range)
	if(istype(target, /mob/living/basic/zombie/darkpack))
		return FALSE

	// don't break down the fence - just try to break the gate
	if(istype(target, /obj/structure/vampfence/rich))
		return FALSE

	if(istype(target, /obj/structure/vampgate))
		return TRUE

	// use the parent class for everything else
	return ..()

// planning subtree specifically for finding and targeting vampire gates
/datum/ai_planning_subtree/find_and_attack_vampgate
	var/scan_range = 9

/datum/ai_planning_subtree/find_and_attack_vampgate/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/mob/living/basic/zombie = controller.pawn

	var/atom/current_target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	// if we're attacking a gate, use the targeting strategy to find nearby living mobs.
	if(istype(current_target, /obj/structure/vampgate))
		var/datum/targeting_strategy/targeter = GET_TARGETING_STRATEGY(controller.blackboard[BB_TARGETING_STRATEGY])
		if(targeter)
			for(var/mob/living/potential_target in oview(controller.blackboard[BB_VISION_RANGE], zombie))
				if(targeter.can_attack(zombie, potential_target, controller.blackboard[BB_VISION_RANGE]))
					// if we can attack the potential target clear the gate from the list and attack the nearby living thing.
					controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
					return

	// if we already have a living current target don't run this
	if(isliving(current_target))
		return

	// if we currently have a mob target from the blackboard then don't run this
	if(controller.blackboard_key_exists(BB_BASIC_MOB_CURRENT_TARGET))
		return

	// is there a nearby vampgate?
	for(var/obj/structure/vampgate/gate in oview(scan_range, zombie))
		if(!gate.broken)
			// theres one, kill it
			controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, gate)
			controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
		return

// AI controller for darkpack zombies
/datum/ai_controller/basic_controller/zombie/darkpack
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic/zombie_darkpack,
		BB_TARGET_MINIMUM_STAT = DEAD,
		BB_VISION_RANGE = 9,
	)
	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/find_and_attack_vampgate,
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)


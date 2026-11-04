/// How long someone this NPC attacked may hit back without bystanders siding with the NPC
#define NPC_SELF_DEFENSE_WINDOW (30 SECONDS)

/mob/living/carbon/human/npc
	var/datum/weakref/attacking_target_ref
	var/last_attacking_time = 0

/mob/living/carbon/human/npc/proc/mark_attacking(mob/living/target)
	attacking_target_ref = WEAKREF(target)
	last_attacking_time = world.time

/mob/living/carbon/human/npc/proc/is_attacker_defending(atom/attacker)
	if(world.time - last_attacking_time > NPC_SELF_DEFENSE_WINDOW)
		return FALSE
	return attacking_target_ref?.resolve() == attacker

#undef NPC_SELF_DEFENSE_WINDOW

/// Combat vars are plain references, without this every player an NPC ever fought could not be garbage collected
/mob/living/carbon/human/npc/proc/remember_combatant(mob/living/combatant)
	RegisterSignal(combatant, COMSIG_QDELETING, PROC_REF(forget_combatant), override = TRUE)

/mob/living/carbon/human/npc/proc/forget_combatant(mob/living/source)
	SIGNAL_HANDLER
	if(danger_source == source)
		danger_source = null
	if(last_attacker == source)
		last_attacker = null
	if(last_damager == source)
		last_damager = null

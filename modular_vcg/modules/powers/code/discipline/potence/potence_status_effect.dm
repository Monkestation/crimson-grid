/datum/status_effect/potence/proc/apply_melee_modifier(mob/source, mob/M, mob/user, list/modifiers, list/attack_modifiers)
	SIGNAL_HANDLER
	MODIFY_ATTACK_FORCE_MULTIPLIER(attack_modifiers, 1 + (0.1 * level))
//Crimson Grid Edit multiplier was 0.4 reduced to 0.1 

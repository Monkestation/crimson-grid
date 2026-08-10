/datum/status_effect/potence
	id = "potence"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null

	var/level = 1
	var/datum/component/tackler/tackler
	var/list/obj/item/bodypart/affected_bodyparts

/datum/status_effect/potence/on_creation(mob/living/new_owner, level)
	src.level = level
	. = ..()

/datum/status_effect/potence/on_apply()
	. = ..()
	if (!.)
		return

	owner.st_remove_stat_mod(STAT_STRENGTH, "Potence")
	owner.st_add_auto_successes(STAT_STRENGTH, level, "Potence")

	if (iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		for (var/obj/item/bodypart/limb as anything in carbon_owner.bodyparts)
			if (!istype(limb, /obj/item/bodypart/arm) && !istype(limb, /obj/item/bodypart/leg))
				continue

			LAZYADD(affected_bodyparts, limb)
			limb.unarmed_attack_sound = 'modular_darkpack/modules/powers/sounds/heavypunch.ogg'
	else if (isbasicmob(owner))
		var/mob/living/basic/basic_owner = owner
		basic_owner.attack_sound = 'modular_darkpack/modules/powers/sounds/heavypunch.ogg'

	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(apply_melee_modifier))

	tackler = owner.AddComponent(/datum/component/tackler, stamina_cost=0, base_knockdown = 1 SECONDS, range = 2 + level, speed = 1, skill_mod = 0, min_distance = 0)

/datum/status_effect/potence/on_remove()
	. = ..()

	owner.st_remove_auto_successes(STAT_STRENGTH, "Potence")
	owner.st_add_stat_mod(STAT_STRENGTH, level, "Potence")

	if (iscarbon(owner))
		for (var/obj/item/bodypart/limb in affected_bodyparts)
			limb.unarmed_attack_sound = initial(limb.unarmed_attack_sound)
	else if (isbasicmob(owner))
		var/mob/living/basic/basic_owner = owner
		basic_owner.attack_sound = initial(basic_owner.attack_sound)

	LAZYCLEARLIST(affected_bodyparts)

	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)

	qdel(tackler)

// This is bad and bypasses it being a strength dice thing. Remove the second melee has any usage of strength for damage
/datum/status_effect/potence/proc/apply_melee_modifier(mob/source, mob/M, mob/user, list/modifiers, list/attack_modifiers)
	SIGNAL_HANDLER
	MODIFY_ATTACK_FORCE_MULTIPLIER(attack_modifiers, 1 + (0.4 * level))

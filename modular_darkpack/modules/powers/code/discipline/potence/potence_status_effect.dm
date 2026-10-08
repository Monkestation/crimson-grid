/datum/status_effect/potence
	id = "potence"
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null

	var/level = 1
	var/datum/component/tackler/tackler
	var/list/datum/weakref/affected_bodyparts

/datum/status_effect/potence/on_creation(mob/living/new_owner, level)
	src.level = level
	. = ..()

/datum/status_effect/potence/on_apply()
	. = ..()
	if (!.)
		return

	//owner.st_remove_stat_mod(STAT_STRENGTH, "Potence") CRIMSON EDIT REMOVAL - Nerfs on Potence, Fortitude, Melee, Guns, Recoil
	owner.st_add_auto_successes(STAT_STRENGTH, level, "Potence")

	if (iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		for (var/obj/item/bodypart/limb as anything in carbon_owner.bodyparts)
			if (!istype(limb, /obj/item/bodypart/arm) && !istype(limb, /obj/item/bodypart/leg))
				continue

			LAZYADD(affected_bodyparts, WEAKREF(limb))
			limb.unarmed_attack_sound = 'modular_darkpack/modules/powers/sounds/heavypunch.ogg'
	else if (isbasicmob(owner))
		var/mob/living/basic/basic_owner = owner
		basic_owner.attack_sound = 'modular_darkpack/modules/powers/sounds/heavypunch.ogg'

	tackler = owner.AddComponent(/datum/component/tackler, stamina_cost=0, base_knockdown = 1 SECONDS, range = 2 + level, speed = 1, skill_mod = 0, min_distance = 0)

/datum/status_effect/potence/on_remove()
	. = ..()

	owner.st_remove_auto_successes(STAT_STRENGTH, "Potence")
	//owner.st_add_stat_mod(STAT_STRENGTH, level, "Potence") CRIMSON EDIT REMOVAL - Nerfs on Potence, Fortitude, Melee, Guns, Recoil

	for(var/datum/weakref/limb_weakref in affected_bodyparts)
		var/obj/item/bodypart/limb = limb_weakref.resolve()
		if(!limb)
			continue
		limb.unarmed_attack_sound = limb::unarmed_attack_sound

	if(isbasicmob(owner))
		var/mob/living/basic/basic_owner = owner
		basic_owner.attack_sound = basic_owner::attack_sound

	LAZYCLEARLIST(affected_bodyparts)

	qdel(tackler)

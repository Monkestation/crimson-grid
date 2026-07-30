/obj/effect/spawner/umbra_corpse_setpiece
	var/fetish_value = 4

/obj/effect/spawner/umbra_corpse_setpiece/Initialize(mapload)
	var/static/list/obj/item/occult_artifact/werewolf/fetish_types = valid_subtypesof(/obj/item/occult_artifact/werewolf)
	var/static/list/mob/living/basic/bane/bane_protectors = valid_subtypesof(/mob/living/basic/bane)

	. = ..()

	fetish_value += rand(-1, 1)
	// Store the value so we can match the value of fetishes
	var/bane_protection = fetish_value + rand(-1, 1)

	var/turf/center_turf = get_turf(src)
	new /obj/effect/mob_spawn/corpse/human/garou(center_turf)
	for(var/i in 1 to 10)
		if(fetish_value <= 0)
			break

		var/obj/item/occult_artifact/werewolf/artifact_type = pick(fetish_types)
		if(artifact_type::rank < fetish_value)
			var/spawning_turf = pick(get_adjacent_open_turfs(center_turf) + center_turf)
			fetish_value -= artifact_type::rank
			new artifact_type(spawning_turf)

	for(var/i in 1 to 10)
		if(bane_protection <= 0)
			break

		var/mob/living/basic/bane/chud = pick(bane_protectors)
		if(chud::power_rank < bane_protection)
			var/spawning_turf = pick(get_adjacent_open_turfs(center_turf) + center_turf)
			bane_protection -= chud::power_rank
			new chud(spawning_turf)



/obj/effect/mob_spawn/corpse/human/garou
	mob_type = /mob/living/carbon/human/splat/garou
	outfit = /datum/outfit/job/vampire/guardian
	outfit_override = list("r_pocket" = /obj/item/stack/dollar/rand)

/datum/controller/subsystem/minor_mapping/proc/spawn_umbra_artifacts(amount)
	var/list/zlevels = SSmapping.levels_by_trait(ZTRAIT_MINING)

	if(!length(zlevels))
		return

	for(var/i in 1 to amount)
		var/turf/center = find_safe_turf(zlevels)
		if(center)
			new /obj/effect/spawner/umbra_corpse_setpiece(center)


/datum/config_entry/number/umbra_artifact_min
	default = 1
	min_val = 0

/datum/config_entry/number/umbra_artifact_max
	default = 3
	min_val = 0

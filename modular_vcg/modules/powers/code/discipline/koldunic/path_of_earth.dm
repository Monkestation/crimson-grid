/datum/discipline/path_of_earth
	name = "Path of Earth"
	desc = {"Gives Power over the earth allowing one to use it to immobilize their enemies
	● Grasp of Earth: Charisma + Empathy
	●● The Haunting: Manipulation + Subterfuge
	●●● Eyes of Chaos: Perception + Occult
	●●●● Voice of Madness: Manipulation + Empathy
	●●●●● Total Insanity: Manipulation + Intimidation"}
	icon = 'modular_vcg/modules/powers/icons/actions.dmi'
	icon_state = "koldunic"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/path_of_earth
	signature_clan = VAMPIRE_CLAN_OLD_CLAN_TZIMISCE

/datum/discipline_power/path_of_earth
	name = "path of earth power name"
	desc = "path of earth power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/visceratika.ogg'//placeholder sound ignore


/datum/discipline_power/path_of_earth/grasp_of_earth
	name = "Grasp Of Earth"
	desc = "Utilize the earth to grasp at a foe immobilizing them for a short period of time"

	level = 1
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SEE
	target_type = TARGET_LIVING
	range = 7
	vitae_cost = 1

	aggravating = FALSE
	hostile = TRUE
	violates_masquerade = TRUE

	multi_activate = TRUE
	duration_length = 1.5 SECONDS
	cooldown_length = 40 SECONDS

/datum/discipline_power/path_of_earth/grasp_of_earth/proc/immobilize_target(mob/living/target, duration = 1.5 SECONDS)
	ADD_TRAIT(target, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))

/datum/discipline_power/path_of_earth/grasp_of_earth/proc/release_target(mob/living/target)
	to_chat(target, span_danger("You feel the earth fall away you are able to move again"))
	REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))

/datum/discipline_power/path_of_earth/grasp_of_earth/activate(mob/living/target)
	. = ..()
	target.visible_message(span_danger("<b>The earth grasps [target] immobilizing them</b>"), span_warning("<b>The earth grasps you immobilzing you</b>"))
	immobilize_target(target)
//		var/mob/living/carbon/human/H = target
//		H.remove_overlay(POWERS_LAYER)
//		var/mutable_appearance/serpentis_overlay = mutable_appearance('modular_darkpack/modules/powers/icons/serpentis.dmi', "serpentis", -POWERS_LAYER)
//		H.overlays_standing[POWERS_LAYER] = serpentis_overlay           //overlay stuff please ignore remove once finished
//		H.apply_overlay(POWERS_LAYER)
	immobilize_target(target)

/datum/discipline_power/path_of_earth/grasp_of_earth/deactivate(mob/living/target)
	. = ..()
	release_target(target)


/datum/discipline_power/path_of_earth/endurance_of_stone
	name = "Endurance of Stone"
	desc = "Become as hard as stone. Let nothing bring you down"

	level = 2
	var/activating = FALSE
	var/active_armor = FALSE
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 2
	toggled = TRUE
	duration_length = 20 TURNS

/datum/discipline_power/path_of_earth/endurance_of_stone/pre_activation_checks()
	. = ..()
	if(activating) // Prevent multi-activation while the do_after is ongoing
		to_chat(owner, span_warning("You are already hardening your skin"))
		return FALSE

	activating = TRUE
	to_chat(owner, span_warning("Your body starts to harden"))
	if(do_after(owner, 1 TURNS, timed_action_flags = (IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM)))
		return TRUE

/datum/discipline_power/path_of_earth/endurance_of_stone/activate()
	. = ..()
	activating = FALSE
	var/roll = SSroll.storyteller_roll_datum(owner, difficulty = 7, applic_stats = list(STAT_PERMANENT_WILLPOWER))
	switch(roll)
		if(ROLL_SUCCESS)
			active_armor = TRUE
			owner.damage_resistance += 20
			to_chat(owner, span_green("You successfuly harness the earth armoring yourself"))
		if(ROLL_FAILURE)
			to_chat(owner, span_warning("You fail to harness the earth"))
			deactivate()
		if(ROLL_BOTCH)
			owner.apply_damage(20, BRUTE)
			to_chat(owner, span_danger("The earth refuses your will injuring you"))
			deactivate()

/datum/discipline_power/path_of_earth/endurance_of_stone/deactivate()
	. = ..()
	if(!active_armor)
		return
	to_chat(owner, span_notice("The earth falls away from your body"))
	owner.damage_resistance -= 20


/datum/discipline_power/path_of_earth/hungry_earth
	name = "Hungry Earth"
	desc = "Cause the earth to rise and swallow a area"
	level = 3
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 2
	cooldown_length = 40 SECONDS
	target_type = TARGET_TURF
	range = 7
/datum/discipline_power/path_of_earth/hungry_earth/activate(target)
	. = ..()

	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		return
	var/roll = SSroll.storyteller_roll_datum(owner, difficulty = 7, applic_stats = list(STAT_PERMANENT_WILLPOWER))
	switch(roll)
		if(ROLL_SUCCESS)
			owner.damage_resistance += 20
			to_chat(owner, span_green("You successfuly will the earth to encase the target"))
		if(ROLL_FAILURE)
			to_chat(owner, span_warning("You fail to harness the earth to encase your target"))
			return
		if(ROLL_BOTCH)
			owner.apply_damage(20, BRUTE)
			to_chat(owner, span_danger("The earth refuses your will injuring you"))
			return
	// Earthquake-style warning: shake the target turf and nearby viewers.
	target_turf.Shake(pixelshiftx = 0.1, pixelshifty = 0.1, duration = 1 SECONDS)

	for(var/mob/viewer in viewers(7, target_turf))
		shake_camera(viewer, 1 SECONDS, 1)
		viewer.playsound_local(
			viewer,
			pick(
				'sound/ambience/earth_rumble/earth_rumble_distant1.ogg',
				'sound/ambience/earth_rumble/earth_rumble_distant2.ogg',
				'sound/ambience/earth_rumble/earth_rumble_distant3.ogg',
				'sound/ambience/earth_rumble/earth_rumble_distant4.ogg',
			),
			75,
		)

	to_chat(owner, span_notice("The ground rumbles around [target]"))
	target_turf.visible_message(span_warning("The ground erupts upward with a deafening rumble!"))
	addtimer(CALLBACK(src, PROC_REF(raise_earth_walls), target_turf.x, target_turf.y, target_turf.z), 2 SECONDS)

/datum/discipline_power/path_of_earth/hungry_earth/proc/raise_earth_walls(x, y, z)
	var/turf/target_turf = locate(x, y, z)
	if(!target_turf)
		return

	var/list/temporary_walls = list()

	for(var/turf/open/nearby_turf in range(1, target_turf))
		// Skip the target and diagonal tiles; keep only north, south, east, and west.
		if(nearby_turf == target_turf)
			continue
		if(nearby_turf.x != target_turf.x && nearby_turf.y != target_turf.y)
			continue

		var/list/old_baseturfs = islist(nearby_turf.baseturfs) \
			? nearby_turf.baseturfs.Copy() \
			: nearby_turf.baseturfs

		temporary_walls += list(list(
			nearby_turf.x,
			nearby_turf.y,
			nearby_turf.z,
			nearby_turf.type,
			old_baseturfs
		))

		var/turf/closed/wall/vampwall/earth_wall = nearby_turf.ChangeTurf(/turf/closed/wall)
		if(!earth_wall)
			continue

		earth_wall.name = "\improper earthen [earth_wall.name]"
		earth_wall.hardness = 60
		earth_wall.sheet_amount = 0
		earth_wall.girder_type = null

	if(length(temporary_walls))
		addtimer(CALLBACK(src, PROC_REF(remove_earth_walls), temporary_walls), 1 MINUTES)

/datum/discipline_power/path_of_earth/hungry_earth/proc/remove_earth_walls(list/saved_tiles)
	for(var/list/saved_tile as anything in saved_tiles)
		var/turf/current_turf = locate(saved_tile[1], saved_tile[2], saved_tile[3])
		if(!istype(current_turf, /turf/closed/wall))
			continue

		current_turf.ChangeTurf(saved_tile[4], saved_tile[5])



/datum/discipline_power/path_of_earth/earths_embrace
	name = "Earth's Embrace"
	desc = "The earth encases you and slowly mends your wounds."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 2
	duration_length = 45 SECONDS
	cooldown_length = 480 SECONDS
	cancelable = TRUE

	var/list/encased_tile_data = list()
	var/heal_timer
	var/encasement_active = FALSE

/datum/discipline_power/path_of_earth/earths_embrace/activate()
	. = ..()

	var/turf/center_turf = get_turf(owner)
	if(!center_turf)
		return

	encasement_active = TRUE

	// Save and replace the eight open tiles surrounding the caster.
	for(var/turf/open/nearby_turf in range(1, center_turf))
		if(nearby_turf == center_turf)
			continue

		var/list/old_baseturfs = islist(nearby_turf.baseturfs) \
			? nearby_turf.baseturfs.Copy() \
			: nearby_turf.baseturfs

		encased_tile_data += list(list(
			nearby_turf.x,
			nearby_turf.y,
			nearby_turf.z,
			nearby_turf.type,
			old_baseturfs
		))//same behavior as previous ability but this one can heal and locks you in place

		var/turf/closed/wall/earth_wall = nearby_turf.ChangeTurf(/turf/closed/wall)
		if(!earth_wall)
			continue

		earth_wall.name = "\improper earthen [earth_wall.name]"
		earth_wall.hardness = 60
		earth_wall.sheet_amount = 0
		earth_wall.girder_type = null

	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))
	to_chat(owner, span_notice("The earth closes around you, sheltering and mending your body."))

	heal_timer = addtimer(CALLBACK(src, PROC_REF(heal_encased_caster)), 1 SECONDS)

/datum/discipline_power/path_of_earth/earths_embrace/proc/heal_encased_caster()
	heal_timer = null

	if(!encasement_active || !owner || owner.stat == DEAD)
		return

	// Heal one point from each supported damage category.
	for(var/damage_type in list(BRUTE, BURN, AGGRAVATED, TOX, OXY, STAMINA))
		owner.heal_ordered_damage(1, list(damage_type))

	heal_timer = addtimer(CALLBACK(src, PROC_REF(heal_encased_caster)), 1 SECONDS)

/datum/discipline_power/path_of_earth/earths_embrace/deactivate()
	. = ..()

	encasement_active = FALSE
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))

	if(heal_timer)
		deltimer(heal_timer)
		heal_timer = null

	// Restore the floor tiles that the power changed.
	for(var/list/saved_tile as anything in encased_tile_data)
		var/turf/current_turf = locate(saved_tile[1], saved_tile[2], saved_tile[3])
		if(!istype(current_turf, /turf/closed/wall))
			continue

		current_turf.ChangeTurf(saved_tile[4], saved_tile[5])

	encased_tile_data.Cut()

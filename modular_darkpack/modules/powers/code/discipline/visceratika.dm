/datum/discipline/visceratika
	name = "Visceratika"
	desc = "The Discipline of Visceratika is the exclusive possession of the Gargoyle bloodline and is an extension of their natural affinity for stone, earth, and things made thereof."
	icon_state = "visceratika"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/visceratika

/datum/discipline_power/visceratika
	name = "Visceratika power name"
	desc = "Visceratika power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/visceratika.ogg'

/datum/discipline/visceratika/post_gain()
	. = ..()
	// it is rumored that, if a non-gargoyle kindred were to learn Visceratika, their skin would turn stony
	owner.skin_tone = "albino"
	owner.set_body_sprite("gargoyle")
	owner.update_body_parts()
	owner.update_body()
	// since dot 4 is always active and requires no roll
	if(level >= 4)
		owner.physiology.brute_mod *= 0.8
		owner.physiology.heat_mod *= 0.5
		//owner.physiology.clone_mod *= 0.9
		//ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)
		ADD_TRAIT(owner, TRAIT_NOSOFTCRIT, DISCIPLINE_TRAIT(type))
		if(!(owner.is_clan(/datum/subsplat/vampire_clan/gargoyle)))
			ADD_TRAIT(owner, TRAIT_MASQUERADE_VIOLATING_FACE, DISCIPLINE_TRAIT(type))

//SKIN OF THE CHAMELEON
/datum/discipline_power/visceratika/skin_of_the_chameleon
	name = "Skin of the Chameleon"
	desc = "Change your skin to become a reasonable fascimile of whatever your surroundings are, allowing you increased stealth."
	level = 1
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE
	cooldown_length = 2 SCENES
	duration_length = 1 SCENES
	cancelable = TRUE
	vitae_cost = 1

/datum/discipline_power/visceratika/skin_of_the_chameleon/activate()
	. = ..()
	skin_chameleon_run()
	RegisterSignal(owner, COMSIG_MOVE_INTENT_TOGGLED, PROC_REF(skin_chameleon_run))

/datum/discipline_power/visceratika/skin_of_the_chameleon/deactivate(atom/target, direct)
	. = ..()
	UnregisterSignal(owner, COMSIG_MOVE_INTENT_TOGGLED)
	owner.alpha = 255
	remove_wibbly_filters(owner)

/datum/discipline_power/visceratika/skin_of_the_chameleon/proc/skin_chameleon_run()
	SIGNAL_HANDLER
	if(owner.move_intent == MOVE_INTENT_RUN)
		owner.alpha = 40
		apply_wibbly_filters(owner)
	else
		owner.alpha = 10
		remove_wibbly_filters(owner)

//SCRY THE HEARTHSTONE
/datum/discipline_power/visceratika/scry_the_hearthstone
	name = "Scry the Hearthstone"
	desc = "Sense the exact locations of individuals around you."
	willpower_cost = 1

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_SEE
	toggled = TRUE
	var/area/starting_area
	var/datum/storyteller_roll/scry_the_hearthstone/scry_roll
/datum/storyteller_roll/scry_the_hearthstone
	bumper_text = "scry the hearthstone"
	applicable_stats = list(STAT_PERCEPTION, STAT_AWARENESS)

/datum/discipline_power/visceratika/scry_the_hearthstone/pre_activation_checks()
	. = ..()
	if(!scry_roll)
		scry_roll = new()
	if(scry_roll.st_roll(owner, owner) == ROLL_SUCCESS)
		return TRUE
	else
		return FALSE

/datum/discipline_power/visceratika/scry_the_hearthstone/activate()
	. = ..()
	for(var/mob/living/player in GLOB.player_list)
		if(get_area(player) == get_area(owner))
			var/their_name = player.name
			if(ishuman(player))
				var/mob/living/carbon/human/human_player = player
				their_name = human_player.name
			to_chat(owner, "- [their_name]")
	starting_area = get_area(owner)
	ADD_TRAIT(owner, TRAIT_THERMAL_VISION, DISCIPLINE_TRAIT(type))
	owner.update_sight()
	//visceratika 2 gives a gargoyle a heatmap of all living people in a building. if they leave the building, they need to re-cast it.
	RegisterSignal(owner, COMSIG_EXIT_AREA, PROC_REF(on_area_exited))

/datum/discipline_power/visceratika/scry_the_hearthstone/proc/on_area_exited(atom/movable/source, area/old_area)
	SIGNAL_HANDLER

	to_chat(owner, span_warning("You lose your connection to the stone as you leave the area."))
	starting_area = null
	REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, DISCIPLINE_TRAIT(type))
	owner.update_sight()
	UnregisterSignal(owner, COMSIG_EXIT_AREA)
	try_deactivate()

//BOND WITH THE MOUNTAIN
/datum/discipline_power/visceratika/bond_with_the_mountain
	name = "Bond with the Mountain"
	desc = "Merge with your surroundings and become difficult to see."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE
	vitae_cost = 2
	cancelable = TRUE
	toggled = TRUE
	duration_length = 0
	cooldown_length = 10 SECONDS
	var/datum/weakref/exit_turf
	var/datum/weakref/stone_turf

/datum/discipline_power/visceratika/bond_with_the_mountain/pre_activation_checks()
	. = ..()
	for(var/turf/closed/adjacent in orange(1, owner))
		stone_turf = WEAKREF(adjacent)
		break

	if(!stone_turf)
		to_chat(owner, span_warning("You must be adjacent to a stone surface to bond with the mountain."))
		return FALSE
	return TRUE

/datum/discipline_power/visceratika/bond_with_the_mountain/activate()
	. = ..()

	exit_turf = WEAKREF(get_turf(owner))
	to_chat(owner, span_notice("You begin to sink into the stone..."))

	if(!do_after(owner, 2 TURNS))
		to_chat(owner, span_warning("Your bond with the nearby stone is interrupted!"))
		exit_turf = null
		return FALSE

	var/turf/resolved_stone = stone_turf?.resolve()

	if(resolved_stone)
		owner.forceMove(resolved_stone)
	owner.alpha = 30
	ADD_TRAIT(owner, TRAIT_BOND_WITHIN_THE_MOUNTAIN, DISCIPLINE_TRAIT(type))
	ADD_TRAIT(owner, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))
	owner.damage_deflection = 3 TTRPG_DAMAGE

/datum/discipline_power/visceratika/bond_with_the_mountain/deactivate(forced = TRUE)
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))
	REMOVE_TRAIT(owner, TRAIT_BOND_WITHIN_THE_MOUNTAIN, DISCIPLINE_TRAIT(type))
	owner.damage_deflection = 0
	if(forced) //only false when using visceratika 5. we inherit the alpha from this ability and when visceratika 5 deactivates, return to 255
		var/turf/resolved_exit = exit_turf?.resolve()
		if(resolved_exit)
			owner.forceMove(resolved_exit)
		owner.alpha = 255
	exit_turf = null
	stone_turf = null

//ARMOR OF TERRA
/datum/discipline_power/visceratika/armor_of_terra
	name = "Armor of Terra"
	desc = "This power requires no roll and is always active. Your stony skin has hardened to the point where nearly all damage against you is lessened."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

	vitae_cost = 0

/datum/discipline_power/visceratika/armor_of_terra/activate()
	. = ..()
	to_chat(owner, span_danger("This is a passive ability. The effects are already active!"))


//FLOW WITHIN THE MOUNTAIN
/datum/discipline_power/visceratika/flow_within_the_mountain
	name = "Flow Within the Mountain"
	desc = "Merge with solid stone, and move through it without disturbing it."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 2
	violates_masquerade = TRUE

	cancelable = TRUE
	duration_length = 1 SCENES // might be too long...
	cooldown_length = 10 SECONDS

/datum/discipline_power/visceratika/flow_within_the_mountain/try_activate()
	// placed in try_activate instead of pre_activation_checks so as to not consume blood while running this check
	if(!HAS_TRAIT(owner, TRAIT_BOND_WITHIN_THE_MOUNTAIN))
		to_chat(owner, span_notice("You must cast Bond with the Mountain first before using Flow within the Mountain"))
		return FALSE
	..()

/datum/discipline_power/visceratika/flow_within_the_mountain/activate()
	. = ..()
	var/datum/discipline_power/visceratika/bond_with_the_mountain/bond = discipline.get_power(/datum/discipline_power/visceratika/bond_with_the_mountain)
	bond.deactivate(forced = FALSE)
	owner.generic_canpass = FALSE
	RegisterSignal(owner, COMSIG_MOVABLE_CAN_PASS_THROUGH, PROC_REF(can_pass_through_walls))
	apply_wibbly_filters(owner)

/datum/discipline_power/visceratika/flow_within_the_mountain/deactivate()
	. = ..()
	owner.generic_canpass = TRUE
	UnregisterSignal(owner, COMSIG_MOVABLE_CAN_PASS_THROUGH)
	owner.alpha = 255
	remove_wibbly_filters(owner)

/datum/discipline_power/visceratika/flow_within_the_mountain/proc/can_pass_through_walls(datum/source, atom/blocker, movement_dir)
	SIGNAL_HANDLER
	if(!istype(blocker, /turf/closed))
		return
	if(istype(blocker, /turf/cordon))
		return
	if(get_area(owner) == get_area(blocker))
		return COMSIG_COMPONENT_PERMIT_PASSAGE

/*
//ROCKHEART
/datum/discipline_power/visceratika/rockheart
	name = "Rockheart"
	desc = "Solidify your innermost organs to prevent damage"

	level = 6
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_LYING

	violates_masquerade = FALSE

	toggled = TRUE
	cooldown_length = 1 MINUTES

/datum/discipline_power/visceratika/rockheart/activate()
	. = ..()
	to_chat(owner, span_warning("You harden your internal organs, protecting you against many forms of damage and stakes!"))
	ADD_TRAIT(owner, TRAIT_STUNIMMUNE, MAGIC)
	ADD_TRAIT(owner, TRAIT_PUSHIMMUNE, MAGIC)
	ADD_TRAIT(owner, TRAIT_NOBLEED, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_PIERCEIMMUNE, MAGIC_TRAIT)
	ADD_TRAIT(owner, TRAIT_NEVER_WOUNDED, MAGIC_TRAIT)

	owner.stakeimmune = TRUE

/datum/discipline_power/visceratika/rockheart/deactivate()
	. = ..()
	to_chat(owner, span_warning("You soften your internal organs, to their normal durability."))
	REMOVE_TRAIT(owner, TRAIT_STUNIMMUNE, MAGIC)
	REMOVE_TRAIT(owner, TRAIT_PUSHIMMUNE, MAGIC)
	REMOVE_TRAIT(owner, TRAIT_NOBLEED, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_PIERCEIMMUNE, MAGIC_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_NEVER_WOUNDED, MAGIC_TRAIT)

	owner.stakeimmune = FALSE
*/

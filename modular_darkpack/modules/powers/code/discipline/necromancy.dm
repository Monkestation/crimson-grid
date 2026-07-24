// necromancy zombies located in npc module, beastmaster/necromancy_zombies.dm

/datum/discipline/necromancy
	name = "Necromancy"
	desc = "Offers control over another, undead reality."
	icon_state = "necromancy"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/necromancy
	signature_clan = VAMPIRE_CLAN_GIOVANNI

/datum/discipline/necromancy/post_gain()
	. = ..()
	var/datum/action/ritual_drawing/necromancy/ritualist = new()
	ritualist.Grant(owner)
	ritualist.level = level

/datum/discipline/necromancy/post_loss()
	. = ..()
	for(var/datum/action/action as anything in owner.actions)
		if(istype(action, /datum/action/ritual_drawing/necromancy))
			qdel(action)

/datum/discipline_power/necromancy/pre_activation_checks(mob/living/target)
	. = ..()
	return SSroll.storyteller_roll_datum(owner, applic_stats = list(STAT_WITS, STAT_OCCULT))

/datum/discipline_power/necromancy
	name = "Necromancy power name"
	desc = "Necromancy power description"

//SHROUDSIGHT V20 p. 163
/datum/storyteller_roll/shroudsight
	bumper_text = "shroudsight"
	applicable_stats = list(STAT_PERCEPTION, STAT_AWARENESS)
	difficulty = 7
	reroll_cooldown = 1 SCENES
	roll_output_type = ROLL_PRIVATE

/datum/discipline_power/necromancy/shroudsight
	name = "Shroudsight"
	desc = "See in darkness clearly and see ghosts present."

	level = 1
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 1

	activate_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy1on.ogg'
	deactivate_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy1off.ogg'

	cooldown_length = 3 SCENES
	duration_length = 1 SCENES

	var/datum/storyteller_roll/shroudsight/roll_datum

/datum/discipline_power/necromancy/shroudsight/pre_activation_checks(mob/living/target)
	if(!roll_datum)
		roll_datum = new()

	var/roll_result = roll_datum.st_roll(owner)
	if(roll_result == ROLL_COOLDOWN)
		return FALSE
	return roll_result == ROLL_SUCCESS

/datum/discipline_power/necromancy/shroudsight/activate()
	. = ..()

	ADD_TRAIT(owner, TRAIT_GHOST_VISION, NECROMANCY_TRAIT)
	ADD_TRAIT(owner, TRAIT_LOCAL_SIXTHSENSE, NECROMANCY_TRAIT)
	owner.update_sight()

	to_chat(owner, span_notice("You peek beyond the Shroud."))

/datum/discipline_power/necromancy/shroudsight/deactivate()
	. = ..()

	REMOVE_TRAIT(owner, TRAIT_GHOST_VISION, NECROMANCY_TRAIT)
	REMOVE_TRAIT(owner, TRAIT_LOCAL_SIXTHSENSE, NECROMANCY_TRAIT)
	owner.update_sight()

	to_chat(owner, span_warning("Your vision returns to the mortal realm."))

//ETHEREAL HORDE
/datum/discipline_power/necromancy/ethereal_horde
	name = "Ethereal Horde"
	desc = "Summon a pair of Drones from the Shadowlands to defend you."

	level = 2
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	vitae_cost = 1

	effect_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy2.ogg'

	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS
	grouped_powers = list(
		/datum/discipline_power/necromancy/ashes_to_ashes,
		/datum/discipline_power/necromancy/cold_of_the_grave,
		/datum/discipline_power/necromancy/shambling_horde
	)

/datum/discipline_power/necromancy/ethereal_horde/activate()
	. = ..()
	owner.visible_message(span_warning("Wailing shades step forth from [owner]'s shadow."))
	owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level1)
	owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level1)

//ASHES TO ASHES
/datum/discipline_power/necromancy/ashes_to_ashes
	name = "Ashes to Ashes"
	desc = "Dissolve a corpse to gain its lifeforce, or steal such from a wraith."

	level = 3
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB | TARGET_GHOST
	range = 3 //to not wallbang people mid-surgery at the hospital
	vitae_cost = 0

	activate_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy3.ogg'

	violates_masquerade = TRUE

	cooldown_length = 10 SECONDS
	grouped_powers = list(
		/datum/discipline_power/necromancy/ethereal_horde,
		/datum/discipline_power/necromancy/cold_of_the_grave,
		/datum/discipline_power/necromancy/shambling_horde
	)

/datum/discipline_power/necromancy/ashes_to_ashes/activate(mob/target)
	. = ..()

	if(isavatar(target))
		to_chat(owner, span_warning("This spirit is yet linked to a corporeal form.")) // cant absorb auspex ghosts
		return

	if (isobserver(target))
		var/mob/dead/observer/ghost = target
		to_chat(target, span_notice("[owner] siphons your plasm; [owner.p_they()] steal from your being to sustain [owner.p_their()] own."))

		if(!ghost.soul_taken)
			to_chat(owner, span_warning("You've slaked your Hunger on a wraith's passion. You gain <b>BLOOD</b> and <b>A SOUL</b>."))
			owner.adjust_blood_pool(1)
			if(isliving(owner))
				owner.collected_souls += 1
				to_chat(owner, span_cult("You absorb the soul of the departed into your necromantic grimoire. It's essence can now assist you in your studies from beyond the Shroud..."))

			ghost.soul_taken = TRUE
		else
			to_chat(owner, span_warning("You've slaked your Hunger on a wraith's passion. You gain <b>BLOOD</b>, but its soul has already slipped away."))
			owner.adjust_blood_pool(1)
		return

	if (isliving(target) && target.stat == DEAD)
		var/mob/living/dusted = target
		owner.visible_message(span_warning("[owner] motions towards [target]."))
		dusted.visible_message(span_danger("[target]'s body dissolves into dust before your very eyes!"))
		to_chat(owner, span_warning("You've absorbed the body's residual lifeforce. You gain <b>BLOOD</b> and <b>A SOUL</b>."))
		dusted.dust(just_ash = TRUE)
		owner.adjust_blood_pool(2) // corpses = 2 blood
		if(isliving(owner))
			owner.collected_souls += 1
			to_chat(owner, span_cult("You absorb the soul of the departed into your necromantic grimoire. It's essence can now assist you in your studies from beyond the Shroud..."))
		return

	to_chat(owner, span_warning("Death has not yet claimed this one - there is nothing to pillage."))


//COLD OF THE GRAVE
/datum/discipline_power/necromancy/cold_of_the_grave
	name = "Cold of the Grave"
	desc = "Place a chosen target, including yourself, into a corpse-like state."

	level = 4
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_SELF | TARGET_LIVING
	range = 5
	vitae_cost = 1

	effect_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy4.ogg'

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	multi_activate = TRUE
	cooldown_length = 20 SECONDS
	duration_length = 20 SECONDS
	grouped_powers = list(
		/datum/discipline_power/necromancy/ethereal_horde,
		/datum/discipline_power/necromancy/ashes_to_ashes,
		/datum/discipline_power/necromancy/shambling_horde
	)

/datum/movespeed_modifier/corpsebuff
	multiplicative_slowdown = 0.4

/datum/movespeed_modifier/corpsenerf
	multiplicative_slowdown = 0.8 //lasts for a while

/datum/discipline_power/necromancy/cold_of_the_grave/activate(mob/living/target)
	. = ..()

	owner.visible_message(span_warning("[owner] motions towards [target]."))
	if(iscarbon(target))
		var/mob/living/carbon/human/corpsebuff = target
		// removed iscathayan(target) || from line 183 DARKPACK TODO - readd KJs Kuei-Jin
		if(get_kindred_splat(target) || iszombie(target)) //undead become spongier, but move slightly slower
			corpsebuff.visible_message(span_danger("[target]'s body seizes with rigor mortis."), span_danger("Your senses dull to pain and everything else."))

			for(var/obj/item/bodypart/part as anything in corpsebuff.bodyparts)
				part.brute_modifier = max(0.2, part.brute_modifier - 0.3)

			ADD_TRAIT(corpsebuff, TRAIT_NOSOFTCRIT, NECROMANCY_TRAIT)
			ADD_TRAIT(corpsebuff, TRAIT_NOHARDCRIT, NECROMANCY_TRAIT)
			//ADD_TRAIT(corpsebuff, TRAIT_IGNOREDAMAGESLOWDOWN, NECROMANCY_TRAIT)
			corpsebuff.add_movespeed_modifier(/datum/movespeed_modifier/corpsebuff)
			corpsebuff.do_jitter_animation(2 SECONDS)
		else //everyone else eats tox and CC
			corpsebuff.visible_message(span_danger("[target]'s skin grays, terrible illness gripping [target.p_their()] body."), span_userdanger("You feel terribly sick."))
			corpsebuff.vomit()

			corpsebuff.apply_status_effect(/datum/status_effect/dizziness, 10 SECONDS)

			corpsebuff.apply_status_effect(/datum/status_effect/confusion, 10 SECONDS)

			corpsebuff.apply_damage(50, TOX)
			corpsebuff.Stun(3 SECONDS) // ignored by tough flesh and shapeshifted werewolves
			corpsebuff.add_movespeed_modifier(/datum/movespeed_modifier/corpsenerf)
			corpsebuff.do_jitter_animation(2 SECONDS)

	else
		target.apply_damage(100, BRUTE)
		target.visible_message(span_danger("[target] shrivels up and withers!"))

/datum/discipline_power/necromancy/cold_of_the_grave/deactivate(mob/living/target)
	. = ..()

	if(iscarbon(target))
		var/mob/living/carbon/human/corpsebuff = target
		// || iscathayan(target) removed that from line 211 DARKPACK TODO -- readd KJS Kuei-Jin
		if(get_kindred_splat(target))
			corpsebuff.visible_message(span_notice("[target]'s body regains its luster."), span_notice("Feeling comes flooding back into your body."))
			for(var/obj/item/bodypart/part as anything in corpsebuff.bodyparts)
				part.brute_modifier = initial(part.brute_modifier)
			REMOVE_TRAIT(corpsebuff, TRAIT_NOSOFTCRIT, NECROMANCY_TRAIT)
			REMOVE_TRAIT(corpsebuff, TRAIT_NOHARDCRIT, NECROMANCY_TRAIT)
			//REMOVE_TRAIT(corpsebuff, TRAIT_IGNOREDAMAGESLOWDOWN, NECROMANCY_TRAIT)
			corpsebuff.remove_movespeed_modifier(/datum/movespeed_modifier/corpsebuff)
		else
			corpsebuff.remove_movespeed_modifier(/datum/movespeed_modifier/corpsenerf)
			corpsebuff.visible_message(span_notice("[target]'s body regains its luster."), span_notice("Your unnatural ailing abates."))


//SHAMBLING HORDE
/datum/discipline_power/necromancy/shambling_horde
	name = "Shambling Horde"
	desc = "Raise savage zombies from corpses, their lethality determined by source material. Attack the living, and rebuild sentient undead."

	level = 5
	check_flags = DISC_CHECK_CONSCIOUS | DISC_CHECK_CAPABLE | DISC_CHECK_FREE_HAND | DISC_CHECK_IMMOBILE
	target_type = TARGET_MOB
	range = 5 //less range than thaum, nerf if 2stronk

	effect_sound = 'modular_darkpack/modules/ritual_necromancy/sounds/necromancy5.ogg'

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE

	cooldown_length = 5 SECONDS
	grouped_powers = list(
		/datum/discipline_power/necromancy/ethereal_horde,
		/datum/discipline_power/necromancy/ashes_to_ashes,
		/datum/discipline_power/necromancy/cold_of_the_grave

	)

/datum/discipline_power/necromancy/shambling_horde/activate(mob/living/target)
	. = ..()
	if (target.stat == DEAD)
		owner.visible_message(span_warning("[owner] gestures over [target]'s carcass."))
		target.visible_message(span_danger("[target] twitches and rises, puppeteered by an invisible force."))
		if(iscarbon(target))
			owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level4)
			qdel(target)
		else
			switch(target.maxHealth)
				if (-INFINITY to 20) //rats and whatnot
					owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level2)
					qdel(target)
				if (20 to 70) //cats and whatnot
					owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level3)
					qdel(target)
				if (70 to 150) //dogs/biters and whatnot
					owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level4)
					qdel(target)
				if (150 to INFINITY) //szlachta and whatnot
					owner.add_beastmaster_minion(/mob/living/basic/beastmaster/giovanni_zombie/level5)
					qdel(target)

	else if(iszombie(target))
		owner.visible_message(span_warning("[owner] aggressively gestures at [target]!"))
		target.visible_message(span_warning("[target]'s flesh knits together'!"), span_danger("Your rotten flesh reconstitutes!"))
		var/mob/living/carbon/human/zombie = target
		zombie.heal_ordered_damage(120, list(BRUTE, TOX, BURN, AGGRAVATED, OXY, BRAIN))
		zombie.adjust_blood_pool(3)
		if(length(zombie.all_wounds))
			var/datum/wound/wound = pick(zombie.all_wounds)
			wound.remove_wound()
	else
		owner.visible_message(span_warning("[owner] aggressively gestures at [target]!"))
		target.visible_message(span_warning("[target] is assaulted by necromantic energies!"), span_danger("You feel yourself rot from within!"))
		target.apply_damage(55, AGGRAVATED, owner.zone_selected) // 1/5 of a 5-dot "healthbar" in aggravated damage, on level with thaumaturgy's average output
		target.emote("scream")


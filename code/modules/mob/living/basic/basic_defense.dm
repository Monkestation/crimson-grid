/mob/living/basic/attack_hand(mob/living/carbon/human/user, list/modifiers)
	// so that martial arts don't double dip
	if (..())
		return TRUE

	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		user.disarm(src)
		return TRUE

	if(!user.combat_mode)
		if (stat != DEAD)
			visible_message(
				span_notice("[user] [response_help_continuous] [src]."),
				span_notice("[user] [response_help_continuous] you."),
				ignored_mobs = user,
			)
			to_chat(user, span_notice("You [response_help_simple] [src]."))
			playsound(loc, 'sound/items/weapons/thudswoosh.ogg', 50, TRUE, -1)
		return TRUE

	if(HAS_TRAIT(user, TRAIT_PACIFISM))
		to_chat(user, span_warning("You don't want to hurt [src]!"))
		return TRUE
	// DARKPACK EDIT CHANGE START - STORYTELLER_STATS
	if(check_block(user, 0, "[user]'s punch", UNARMED_ATTACK))
		return

	var/obj/item/bodypart/attacking_bodypart = user.get_attacking_limb(src)
	if(!attacking_bodypart)
		user.balloon_alert(user, "can't attack!")
		return FALSE

	var/atk_verb_index = rand(1, length(attacking_bodypart.unarmed_attack_verbs))
	var/atk_verb = attacking_bodypart.unarmed_attack_verbs[atk_verb_index]
	var/atk_verb_continuous = "[atk_verb]s"
	if (length(attacking_bodypart.unarmed_attack_verbs_continuous) >= atk_verb_index) // Just in case
		atk_verb_continuous = attacking_bodypart.unarmed_attack_verbs_continuous[atk_verb_index]

	var/atk_effect = attacking_bodypart.unarmed_attack_effect

	var/attack_roll_type = /datum/storyteller_roll/attack/punch
	var/damage_roll_type = /datum/storyteller_roll/damage/punch

	var/attack_difficulty_bonus = 0
	var/attack_bonus_dice = 0
	var/damage_difficulty_bonus = 0
	var/damage_bonus_dice = 0

	if(atk_effect == ATTACK_EFFECT_BITE)
		attack_roll_type = /datum/storyteller_roll/attack/bite
		damage_roll_type = /datum/storyteller_roll/damage/bite
		damage_bonus_dice++
	else if(atk_effect == ATTACK_EFFECT_KICK)
		attack_roll_type = /datum/storyteller_roll/attack/kick
		damage_roll_type = /datum/storyteller_roll/damage/kick
		damage_bonus_dice++
	else if(atk_effect == ATTACK_EFFECT_CLAW)
		attack_roll_type = /datum/storyteller_roll/attack/claw
		damage_roll_type = /datum/storyteller_roll/damage/claw
		damage_bonus_dice += 2

	user.do_attack_animation(src, atk_effect)

	//has our src been shoved recently? If so, they're staggered and we get an easy hit.
	var/staggered = has_status_effect(/datum/status_effect/staggered)

	//Someone in a grapple is much more vulnerable to being harmed by punches.
	var/grappled = (pulledby && pulledby.grab_state >= GRAB_AGGRESSIVE)

	// Limb sharpness determines the type of wounds this unarmed strike could possibly roll. By default, most limbs are blunt and have no sharpness.
	var/limb_sharpness = attacking_bodypart.unarmed_sharpness

	if(grappled)
		var/pummel_bonus = attacking_bodypart.unarmed_pummeling_bonus
		attack_bonus_dice += round(1 * pummel_bonus)

	if(body_position == LYING_DOWN)
		attack_bonus_dice++
	if(staggered)
		attack_bonus_dice++

	var/attack_landed = FALSE
	if(HAS_TRAIT(user, TRAIT_PERFECT_ATTACKER) || grappled)
		attack_landed = TRUE
	else
		var/datum/storyteller_roll/attack/attack_roll = new attack_roll_type()
		attack_roll.difficulty += attack_difficulty_bonus
		if(attack_roll.st_roll(user, src, attack_bonus_dice) == ROLL_SUCCESS)
			attack_landed = TRUE

	var/damage = 0
	if(attack_landed)
		if(HAS_TRAIT(user, TRAIT_PERFECT_ATTACKER))
			damage = user.st_get_stat(STAT_STRENGTH) TTRPG_DAMAGE
		else
			var/datum/storyteller_roll/damage/damage_roll = new damage_roll_type()
			damage_roll.difficulty += damage_difficulty_bonus
			damage = damage_roll.st_roll(user, src, damage_bonus_dice) TTRPG_DAMAGE
	damage = (basic_mob_flags & IMMUNE_TO_FISTS) ? 0 : damage

	if(damage <= 0 || !attack_landed)
		playsound(loc, attacking_bodypart.unarmed_miss_sound, 25, TRUE, -1)
		visible_message(span_danger("[user]'s [atk_verb] misses [src]!"), \
						span_danger("You avoid [user]'s [atk_verb]!"), span_hear("You hear a swoosh!"), COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_warning("Your [atk_verb] misses [src]!"))
		log_combat(user, src, "attempted to punch")
		return FALSE

	var/armor_block = run_armor_check(attack_flag = MELEE)

	playsound(loc, attacking_bodypart.unarmed_attack_sound, 25, TRUE, -1)

	if(grappled && attacking_bodypart.grappled_attack_verb)
		atk_verb = attacking_bodypart.grappled_attack_verb
		atk_verb_continuous = attacking_bodypart.grappled_attack_verb_continuous

	visible_message(span_danger("[user] [atk_verb_continuous] [src]!"), \
					span_userdanger("[user] [atk_verb_continuous] you!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("You [atk_verb] [src]!"))

	lastattacker = user.real_name
	lastattackerckey = user.ckey

	var/attack_direction = get_dir(user, src)
	var/attack_type = attacking_bodypart.attack_type
	var/kicking = (atk_effect == ATTACK_EFFECT_KICK)
	var/biting = (atk_effect == ATTACK_EFFECT_BITE)

	apply_damage(damage, attack_type, null, armor_block, attack_direction = attack_direction, sharpness = limb_sharpness)
	if(grappled)
		log_combat(user, src, "grapple punched")
	else if(kicking)
		log_combat(user, src, "kicked")
	else if(biting)
		log_combat(user, src, "bit")
	else
		log_combat(user, src, "punched")

	/* // DARKPACK EDIT REMOVAL - (A decent amount of combat involves biting here which creates issue from being getting fat from combat)
	if(biting && (mob_biotypes & MOB_ORGANIC)) //Good for you. You probably just ate someone alive.
		var/datum/reagents/tasty_meal = new()
		tasty_meal.add_reagent(/datum/reagent/consumable/nutriment/protein, round(damage/3, 1))
		tasty_meal.trans_to(user, tasty_meal.total_volume, transferred_by = user, methods = INGEST)
	*/
	// DARKPACK EDIT CHANGE END
	updatehealth()
	return TRUE

/mob/living/basic/get_shoving_message(mob/living/shover, obj/item/weapon, shove_flags)
	if(weapon) // no "gently pushing aside" if you're pressing a shield at them.
		return ..()
	var/moved = !(shove_flags & SHOVE_BLOCKED)
	shover.visible_message(
		span_danger("[shover.name] [response_disarm_continuous] [src][moved ? ", pushing [p_them()]" : ""]!"),
		span_danger("You [response_disarm_simple] [src][moved ? ", pushing [p_them()]" : ""]!"),
		span_hear("You hear aggressive shuffling!"),
		COMBAT_MESSAGE_RANGE,
		list(src),
	)
	to_chat(src, span_userdanger("You're [moved ? "pushed" : "shoved"] by [shover.name]!"))

/mob/living/basic/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	playsound(loc, SFX_PUNCH, 25, TRUE, -1)
	visible_message(span_danger("[user] punches [src]!"), \
					span_userdanger("You're punched by [user]!"), null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("You punch [src]!"))
	apply_damage(15, damagetype = BRUTE)

/mob/living/basic/attack_paw(mob/living/carbon/human/user, list/modifiers)
	if(..()) //successful monkey bite.
		if(stat != DEAD)
			return apply_damage(rand(1, 3))

	if (!user.combat_mode)
		if (health > 0)
			visible_message(span_notice("[user.name] [response_help_continuous] [src]."), \
							span_notice("[user.name] [response_help_continuous] you."), null, COMBAT_MESSAGE_RANGE, user)
			to_chat(user, span_notice("You [response_help_simple] [src]."))
			playsound(loc, 'sound/items/weapons/thudswoosh.ogg', 50, TRUE, -1)


/mob/living/basic/attack_alien(mob/living/carbon/alien/adult/user, list/modifiers)
	. = ..()
	if(!.)
		return
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		playsound(loc, 'sound/items/weapons/pierce.ogg', 25, TRUE, -1)
		visible_message(span_danger("[user] [response_disarm_continuous] [name]!"), \
			span_userdanger("[user] [response_disarm_continuous] you!"), null, COMBAT_MESSAGE_RANGE, user)
		to_chat(user, span_danger("You [response_disarm_simple] [name]!"))
		log_combat(user, src, "disarmed")
		return
	var/damage = rand(user.melee_damage_lower, user.melee_damage_upper)
	visible_message(span_danger("[user] slashes at [src]!"), \
		span_userdanger("You're slashed at by [user]!"), null, COMBAT_MESSAGE_RANGE, user)
	to_chat(user, span_danger("You slash at [src]!"))
	playsound(loc, 'sound/items/weapons/slice.ogg', 25, TRUE, -1)
	apply_damage(damage)
	log_combat(user, src, "attacked")

/mob/living/basic/attack_larva(mob/living/carbon/alien/larva/attacking_larva, list/modifiers)
	. = ..()
	if(. && stat != DEAD) //successful larva bite
		var/damage_done = apply_damage(rand(attacking_larva.melee_damage_lower, attacking_larva.melee_damage_upper), BRUTE)
		if(damage_done > 0)
			attacking_larva.amount_grown = min(attacking_larva.amount_grown + damage_done, attacking_larva.max_grown)

/mob/living/basic/attack_drone(mob/living/basic/drone/attacking_drone)
	if(attacking_drone.combat_mode) //No kicking dogs even as a rogue drone. Use a weapon.
		return
	return ..()

/mob/living/basic/attack_drone_secondary(mob/living/basic/drone/attacking_drone)
	if(attacking_drone.combat_mode)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	return ..()

/mob/living/basic/check_projectile_armor(def_zone, obj/projectile/impacting_projectile, is_silent)
	return 0

/mob/living/basic/ex_act(severity, target, origin)
	. = ..()
	if(!. || QDELETED(src))
		return FALSE

	var/bomb_armor = getarmor(null, BOMB)
	switch(severity)
		if (EXPLODE_DEVASTATE)
			if(prob(bomb_armor))
				apply_damage(500, damagetype = BRUTE)
			else
				investigate_log("has been gibbed by an explosion.", INVESTIGATE_DEATHS)
				gib(DROP_ALL_REMAINS)

		if (EXPLODE_HEAVY)
			var/bloss = 60
			if(prob(bomb_armor))
				bloss = bloss / 1.5
			apply_damage(bloss, damagetype = BRUTE)

		if (EXPLODE_LIGHT)
			var/bloss = 30
			if(prob(bomb_armor))
				bloss = bloss / 1.5
			apply_damage(bloss, damagetype = BRUTE)

	return TRUE

/mob/living/basic/blob_act(obj/structure/blob/attacking_blob)
	. = ..()
	if (!.)
		return
	apply_damage(20, damagetype = BRUTE)

/mob/living/basic/do_attack_animation(atom/attacked_atom, visual_effect_icon, used_item, no_effect)
	if(!no_effect && !visual_effect_icon && melee_damage_upper)
		if(attack_vis_effect && !iswallturf(attacked_atom)) // override the standard visual effect.
			visual_effect_icon = attack_vis_effect
		else if(melee_damage_upper < 10)
			visual_effect_icon = ATTACK_EFFECT_PUNCH
		else
			visual_effect_icon = ATTACK_EFFECT_SMASH
	..()

/mob/living/basic/update_stat()
	if(HAS_TRAIT(src, TRAIT_GODMODE))
		return
	if(stat != DEAD)
		if(health <= 0)
			death()
		else
			set_stat(CONSCIOUS)
	med_hud_set_status()

/mob/living/basic/emp_act(severity)
	. = ..()
	if(mob_biotypes & MOB_ROBOTIC)
		emp_reaction(severity)

/mob/living/basic/proc/emp_reaction(severity)
	switch(severity)
		if(EMP_LIGHT)
			visible_message(span_danger("[src] shakes violently, its parts coming loose!"))
			apply_damage(maxHealth * 0.6)
			Shake(duration = 1 SECONDS)
		if(EMP_HEAVY)
			visible_message(span_danger("[src] suddenly bursts apart!"))
			apply_damage(maxHealth)

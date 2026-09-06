#define LAUNCH_KICK_COMBO "HD"
#define DROP_KICK_COMBO "DD"
#define KNEE_STOMACH_COMBO "GH"

/datum/martial_art/darkpack_kungfu
	name = "Kung Fu"
	id = MARTIALART_DARKPACK_KUNGFU
	help_verb = "Remember The Basics"
	display_combos = TRUE
	grab_state_modifier = 1
	var/datum/storyteller_roll/brawl_strength/str_attack

/datum/martial_art/darkpack_kungfu/activate_style(mob/living/new_holder)
	. = ..()

	//We check that you are not in a forbiden form to avoid birds, dogs, crinos, etc from activating this form.
	if(iscrinos(new_holder) || ishispo(new_holder) || islupus(new_holder) || !iscarbon(new_holder))		//iscarbon is a check for gangrel beast forms; bit sloppy but works.
		to_chat(new_holder, span_warning("You cannot be in this form to use this martial art!"))
		return FALSE

	//RegisterSignal(new_holder, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(new_holder, COMSIG_ATOM_PRE_BULLET_ACT, PROC_REF(hit_by_projectile))
	RegisterSignal(new_holder, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(check_dodge))
	if (iscarbon(new_holder))
		var/list/obj/item/bodypart/affected_bodyparts
		var/mob/living/carbon/human/carbon_owner = new_holder
		for (var/obj/item/bodypart/limb as anything in carbon_owner.bodyparts)
			if (!istype(limb, /obj/item/bodypart/arm) && !istype(limb, /obj/item/bodypart/leg))
				continue

			LAZYADD(affected_bodyparts, limb)

			limb.unarmed_attack_effect = null
			limb.unarmed_attack_sound = 'modular_vcg/modules/martial_arts/sounds/harmboxing.ogg'

/datum/martial_art/darkpack_kungfu/deactivate_style(mob/living/remove_from)
	UnregisterSignal(remove_from, list(COMSIG_ATOM_ATTACKBY, COMSIG_ATOM_PRE_BULLET_ACT, COMSIG_LIVING_CHECK_BLOCK))
	return ..()

/datum/martial_art/darkpack_kungfu/proc/check_streak(mob/living/attacker, mob/living/defender)

	//If in various forms, we force a deactivate as a fail-safe.
	if(iscrinos(attacker) || ishispo(attacker) || islupus(attacker) || !iscarbon(attacker))
		reset_streak()
		return

	//Stops you from comboing unconcious people.
	if(defender.IsUnconscious())
		reset_streak()
		return

	//If you get knockedown or otherwise stunned your streak resets.
	if(attacker.IsKnockdown() || attacker.IsParalyzed() || attacker.IsStun() || attacker.body_position == LYING_DOWN)
		reset_streak()
		return

	if(findtext(streak,LAUNCH_KICK_COMBO))
		reset_streak()
		return launch_kick(attacker, defender)

	if(findtext(streak,DROP_KICK_COMBO))
		reset_streak()
		return drop_kick(attacker, defender)

	if(findtext(streak,KNEE_STOMACH_COMBO))
		reset_streak()
		return knee_stomach(attacker, defender)

	return FALSE

/// Frontal Kick: Harm Disarm combo, knocks back relative to Attacker Str - Defender Fort
/datum/martial_art/darkpack_kungfu/proc/launch_kick(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender, ATTACK_EFFECT_KICK)
	defender.visible_message(
		span_warning("[attacker] kicks [defender] square in the chest, sending them flying!"),
		span_userdanger("You are kicked square in the chest by [attacker], sending you flying!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger("You kick [defender] square in the chest, sending them flying!"))
	playsound(attacker, 'modular_vcg/modules/martial_arts/sounds/frontalkick.ogg', 50, TRUE, -1)
	var/atom/throw_target = get_edge_target_turf(defender, attacker.dir)
	var/throw_distance = clamp((attacker.st_get_stat(STAT_STRENGTH) - defender.st_get_stat(STAT_STAMINA)), 1, 3)
	defender.throw_at(throw_target, throw_distance, 4, attacker)
	var/armor_block = defender.run_armor_check(attacker.zone_selected, MELEE)
	defender.apply_damage(15, attacker.get_attack_type(), BODY_ZONE_CHEST, blocked = armor_block)
	log_combat(attacker, defender, "Frontal Kicked (Kungfu)")
	return TRUE

/// Roundhouse Kick: Disarm Disarm combo, knocks people down and deals substantial stamina damage, and also discombobulates them. Knocks objects out of their hands if they're already on the ground.
/datum/martial_art/darkpack_kungfu/proc/drop_kick(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender, ATTACK_EFFECT_KICK)
	playsound(attacker, 'modular_vcg/modules/martial_arts/sounds/roundhousekick.ogg', 50, TRUE, -1)
	if(!str_attack)
		str_attack = new()
	str_attack.difficulty = 7
	var/kickpower = str_attack.st_roll(attacker, defender)
	if(defender.body_position == STANDING_UP && (kickpower >= 0) && !iscrinos(defender))		//If crinos, they don't get knocked down
		defender.Knockdown(kickpower SECONDS)
		defender.visible_message(span_warning("[attacker] kicks [defender] in the head, sending them face first into the floor!"), \
					span_userdanger("You are kicked in the head by [attacker], sending you crashing to the floor!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, attacker)
	else
		defender.drop_all_held_items()
		defender.visible_message(span_warning("[attacker] kicks [defender] in the head!"), \
					span_userdanger("You are kicked in the head by [attacker]!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, attacker)
	defender.apply_damage(10, attacker.get_attack_type())
	defender.apply_damage(40, STAMINA)
	defender.adjust_dizzy_up_to(10 SECONDS, 10 SECONDS)
	log_combat(attacker, defender, "Roundhoused (KungFu)")
	return TRUE

/// Flying Knee: Grab Harm combo, causes them to be silenced and briefly stunned, as well as doing a moderate amount of stamina damage.
/datum/martial_art/darkpack_kungfu/proc/knee_stomach(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender, ATTACK_EFFECT_KICK)
	playsound(attacker, 'modular_vcg/modules/martial_arts/sounds/grabbed.ogg', 70, TRUE, -1)
	defender.visible_message(
		span_warning("[attacker] violently slams [attacker.p_their()] knee into [defender]!"),
		span_userdanger("You slam your knee straight into [defender]!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	if(!str_attack)
		str_attack = new()
	str_attack.difficulty = 8
	var/roll_success = str_attack.st_roll(attacker, defender)
	if(roll_success)
		if(iscrinos(defender))	//Crinos don't get knocked down, they just get stunned
			defender.Paralyze(3 SECONDS)
		else
			defender.Knockdown(3 SECONDS)
	defender.apply_damage(40, STAMINA)
	defender.adjust_silence_up_to(5 SECONDS, 5 SECONDS)
	log_combat(attacker, defender, "kneed in the stomach (Kung-Fu)")
	return TRUE

/datum/martial_art/darkpack_kungfu/grab_act(mob/living/attacker, mob/living/defender)
	if(!can_deflect(attacker)) //allows for deniability
		return MARTIAL_ATTACK_INVALID

	if(defender.check_block(attacker, 0, "[attacker]'s grab", UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	if(iscrinos(attacker) || ishispo(attacker) || islupus(attacker) || !iscarbon(attacker))
		return MARTIAL_ATTACK_INVALID

	add_to_streak("G", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

	var/grab_log_description = "grabbed"
	attacker.do_attack_animation(defender, ATTACK_EFFECT_PUNCH)
	playsound(defender, 'modular_vcg/modules/martial_arts/sounds/frontalkick2.ogg', 25, TRUE, -1)
	defender.apply_damage(20, STAMINA)
	log_combat(attacker, defender, "[grab_log_description] (Kung-Fu)")
	return MARTIAL_ATTACK_INVALID // normal grab

/datum/martial_art/darkpack_kungfu/harm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 10, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	if(iscrinos(attacker) || ishispo(attacker) || islupus(attacker) || !iscarbon(attacker))
		return MARTIAL_ATTACK_INVALID

	add_to_streak("H", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

	return MARTIAL_ATTACK_INVALID // normal punch

/datum/martial_art/darkpack_kungfu/disarm_act(mob/living/attacker, mob/living/defender)
	if(!can_deflect(attacker)) //allows for deniability
		return MARTIAL_ATTACK_INVALID
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	if(iscrinos(attacker) || ishispo(attacker) || islupus(attacker) || !iscarbon(attacker))
		return MARTIAL_ATTACK_INVALID

	add_to_streak("D", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

	attacker.do_attack_animation(defender, ATTACK_EFFECT_PUNCH)
	playsound(defender, 'sound/items/weapons/punch1.ogg', 25, TRUE, -1)
	defender.apply_damage(20, STAMINA)
	log_combat(attacker, defender, "disarmed (Kung-Fu)")
	return MARTIAL_ATTACK_INVALID // normal disarm

/datum/martial_art/darkpack_kungfu/proc/can_deflect(mob/living/user)
	if(!can_use(user) || !user.combat_mode)
		return FALSE
	if(INCAPACITATED_IGNORING(user, INCAPABLE_GRAB)) //NO STUN
		return FALSE
	if(!(user.mobility_flags & MOBILITY_USE)) //NO UNABLE TO USE
		return FALSE
	if(HAS_TRAIT(user, TRAIT_HULK)) //NO HULK
		return FALSE
	if(!isturf(user.loc)) //NO MOTHERFLIPPIN MECHS!
		return FALSE
	return TRUE

/datum/martial_art/darkpack_kungfu/proc/reset_animation(mob/living/user, fadein)
	if(fadein)
		animate(user, alpha = 225, time = 0.1 SECONDS)
		return
	else
		animate(user, pixel_x = 0, pixel_y = 0, time = 0.1 SECONDS)

/datum/martial_art/darkpack_kungfu/proc/hit_by_projectile(mob/living/user, obj/projectile/hitting_projectile, def_zone)
	SIGNAL_HANDLER

	if(iscrinos(user) || ishispo(user) || islupus(user) || !iscarbon(user))
		return NONE

	if(!user.is_clan(/datum/subsplat/vampire_clan/true_brujah))
		return NONE //No, you cant dodge bullets normally, bum

	var/determine_avoidance = ((user.st_get_stat(STAT_ATHLETICS) + user.st_get_stat(STAT_DEXTERITY)) * 7)

	if(!can_deflect(user))
		return NONE

	if(!prob(determine_avoidance))
		return NONE

	user.visible_message(
		span_danger("[user] effortlessly dodges the [hitting_projectile]! [user.p_They()] is unnaturally fast!"),
		span_userdanger("You dodge [hitting_projectile]!"),
	)
	playsound(user, SFX_BULLET_MISS, 75, TRUE)
	hitting_projectile.firer = user
	var/mob/living/carbon/human/dodger = user
	if(dodger.is_clan(/datum/subsplat/vampire_clan/true_brujah))
		animate(user, alpha = 0, time = 0.2 SECONDS)
		new /obj/effect/temporis/weskar(user.loc, user)
		addtimer(CALLBACK(src, PROC_REF(reset_animation), user, TRUE), 0.1 SECONDS)
	else
		animate(user, pixel_x = rand(-16,16), pixel_y = rand(-16,16), time = 0.2 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(reset_animation), user, FALSE), 0.1 SECONDS)
	//The bullet goes straight past, as the user was never in it's path to begin
	return COMPONENT_BULLET_PIERCED

/// Trained Kung-Fu practitioners can avoid melee attacks to varying levels of success, anything buffing this value above ~30% fully invested should be closed
/datum/martial_art/darkpack_kungfu/proc/check_dodge(mob/living/user, atom/movable/hitby, damage, attack_text, attack_type, ...)
	SIGNAL_HANDLER

	if(iscrinos(user) || ishispo(user) || islupus(user) || !iscarbon(user))
		return NONE

	var/determine_avoidance = ((user.st_get_stat(STAT_ATHLETICS) + user.st_get_stat(STAT_DEXTERITY)))

	if(!can_deflect(user))
		return

	if(user.throw_mode)
		determine_avoidance *= 2

	if(attack_type == PROJECTILE_ATTACK || attack_type == THROWN_PROJECTILE_ATTACK)
		return NONE

	if(!prob(determine_avoidance))
		return NONE

	user.visible_message(
		span_danger("[user] cleanly avoids [attack_text] with incredible speed!"),
		span_userdanger("You dodge [attack_text]"),
	)
	playsound(user.loc, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
	var/mob/living/carbon/human/dodger = user
	if(dodger.is_clan(/datum/subsplat/vampire_clan/true_brujah)) //More special snowflake Trujah Powers, TODO: Move the melee dodge after-image to be decided by celerity/temp investment
		animate(user, alpha = 0, time = 0.3 SECONDS)
		new /obj/effect/temporis/weskar(user.loc, user)
		addtimer(CALLBACK(src, PROC_REF(reset_animation), user, TRUE), 0.1 SECONDS)
	else
		animate(user, pixel_x = rand(-16,16), pixel_y = rand(-16,16), time = 0.1 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(reset_animation), user, FALSE), 0.1 SECONDS)

	return SUCCESSFUL_BLOCK

/datum/martial_art/darkpack_kungfu/get_style_help()
	. = list()

	. += "<b><i>You try to remember some of the basics of Kungfu.</i></b>"

	. += "[span_notice("Frontal Kick")]: Punch Shove. Launch your opponent away from you with incredible force!"
	. += "[span_notice("Roundhouse Kick")]: Shove Shove. Nonlethally kick an opponent to the floor, knocking them down, discombobulating them and dealing substantial stamina damage. If they're already prone, disarm them as well."
	. += "[span_notice("Flying Knee")]: Grab Punch. Deliver a knee jab into the opponent, dealing high stamina damage, as well as briefly stunning them, winding them and making it difficult for them to speak."
	. += "[span_notice("Grabs and Shoves")]: While in combat mode, your typical grab and shove do decent stamina damage, and your grabs harder to break. If you grab someone who has substantial amounts of stamina damage, you knock them out!"
	. += "[span_notice("Evasion")]: Training through the years has taught you how to dodge melee attacks while in Combat Mode. Seeking inner-scerenity within Throw Mode shall greatly increase the chance. Projectiles however are beyond the reaction speed of anyone short of [span_purple("stopping time")]..."

	return .

#undef LAUNCH_KICK_COMBO
#undef DROP_KICK_COMBO
#undef KNEE_STOMACH_COMBO

#define SLAM_COMBO "GH"
#define KICK_COMBO "HH"
#define RESTRAIN_COMBO "GGD"
#define PRESSURE_COMBO "DG"

/datum/martial_art/darkpack_cqb
	name = "CQB"
	id = MARTIALART_DARKPACK_CQB
	help_verb = "Remember The Basics"
	smashes_tables = TRUE
	display_combos = TRUE
	/// Weakref to a mob we're currently restraining (with grab-grab combo)
	VAR_PRIVATE/datum/weakref/restraining_mob
	var/datum/storyteller_roll/brawl_strength/str_attack
	var/datum/storyteller_roll/brawl_defend/stam_defend
	var/datum/storyteller_roll/brawl_defend/athletics/ath_defend

/datum/martial_art/darkpack_cqb/activate_style(mob/living/new_holder)
	. = ..()
	if (iscarbon(new_holder))
		var/list/obj/item/bodypart/affected_bodyparts
		var/mob/living/carbon/human/carbon_owner = new_holder
		for (var/obj/item/bodypart/limb as anything in carbon_owner.bodyparts)
			if (!istype(limb, /obj/item/bodypart/arm) && !istype(limb, /obj/item/bodypart/leg))
				continue

			LAZYADD(affected_bodyparts, limb)

			limb.unarmed_attack_effect = null
			limb.unarmed_attack_sound = 'sound/items/weapons/cqchit1.ogg'

/datum/martial_art/darkpack_cqb/deactivate_style(mob/living/remove_from)
	return ..()

/datum/martial_art/darkpack_cqb/reset_streak(mob/living/new_target)
	if(!IS_WEAKREF_OF(new_target, restraining_mob))
		restraining_mob = null
	return ..()

/datum/martial_art/darkpack_cqb/proc/check_streak(mob/living/attacker, mob/living/defender)

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

	if(findtext(streak, SLAM_COMBO))
		reset_streak()
		return Slam(attacker, defender)

	if(findtext(streak, KICK_COMBO))
		reset_streak()
		return Kick(attacker, defender)

	if(findtext(streak, RESTRAIN_COMBO))
		reset_streak()
		return Restrain(attacker, defender)

	if(findtext(streak, PRESSURE_COMBO))
		reset_streak()
		return Pressure(attacker, defender)

	return FALSE

/datum/martial_art/darkpack_cqb/proc/Slam(mob/living/attacker, mob/living/defender)
	if(defender.body_position != STANDING_UP)
		return FALSE

	attacker.do_attack_animation(defender) //Potentially change the flow of this combo to describe a failed slam if the Stam vs Str difference is high for optimal brick wall gameplay. Potentially 6 Str??
	defender.visible_message(
		span_danger("[attacker] slams [defender] into the ground!"),
		span_userdanger("You're slammed into the ground by [attacker]!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		null,
		attacker,
	)
	to_chat(attacker, span_danger("You slam [defender] into the ground!"))
	playsound(attacker, 'sound/items/weapons/slam.ogg', 50, TRUE, -1)
	defender.apply_damage(10, BRUTE)
	if(!iscrinos(defender))	//We check if defender is crinos. If they are? No knockdown; only a stun which you roll.
		defender.Knockdown(3 SECONDS)
	defender.Paralyze(3 SECONDS)
	log_combat(attacker, defender, "slammed (CQB)")
	return TRUE

/datum/martial_art/darkpack_cqb/proc/Kick(mob/living/attacker, mob/living/defender)
	if(IS_UNCONSCIOUS(defender))
		return FALSE

	attacker.do_attack_animation(defender)
	if(defender.body_position == LYING_DOWN && !defender.IsUnconscious() && !get_kindred_splat(defender) && defender.get_stamina_loss() >= 0) //This is EXTREMELY conditional to make sure it's not abused to shit
		log_combat(attacker, defender, "knocked out (Head kick)(CQC)")
		defender.visible_message(
			span_danger("[attacker] kicks [defender]'s head, knocking [defender.p_them()] out!"),
			span_userdanger("You're knocked unconscious by [attacker]!"),
			span_hear("You hear a sickening sound of flesh hitting flesh!"),
			null,
			attacker,
		)
		to_chat(attacker, span_danger("You kick [defender]'s head, knocking [defender.p_them()] out!"))
		playsound(attacker, 'sound/items/weapons/genhit1.ogg', 50, TRUE, -1)

		var/helmet_protection = (defender.run_armor_check(BODY_ZONE_HEAD, MELEE) + (defender.st_get_stat(STAT_STAMINA) * 5))
		defender.apply_effect(20 SECONDS, EFFECT_KNOCKDOWN, helmet_protection)
		defender.apply_effect(10 SECONDS, EFFECT_UNCONSCIOUS, helmet_protection)
		//defender.adjust_organ_loss(ORGAN_SLOT_BRAIN, 15, 150) brain damage is the WORST

	else
		defender.visible_message(
			span_danger("[attacker] kicks [defender] back!"),
			span_userdanger("You're kicked back by [attacker]!"),
			span_hear("You hear a sickening sound of flesh hitting flesh!"),
			COMBAT_MESSAGE_RANGE,
			attacker,
		)
		to_chat(attacker, span_danger("You kick [defender] back!"))
		playsound(attacker, 'sound/items/weapons/cqchit1.ogg', 50, TRUE, -1)

		if(defender.body_position == LYING_DOWN && !defender.IsUnconscious())
			defender.adjust_stamina_loss(45)
		if(iscrinos(defender))
			var/atom/throw_target = get_edge_target_turf(defender, attacker.dir)
			defender.throw_at(throw_target, 1, 4, attacker)
			defender.apply_damage(10, attacker.get_attack_type())
			log_combat(attacker, defender, "kicked (CQC)")
		else
			var/atom/throw_target = get_edge_target_turf(defender, attacker.dir)
			defender.throw_at(throw_target, 1, 14, attacker)
			defender.apply_damage(10, attacker.get_attack_type())
			log_combat(attacker, defender, "kicked (CQC)")

	return TRUE

/datum/martial_art/darkpack_cqb/proc/Pressure(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender)
	log_combat(attacker, defender, "pressured (CQC)")
	defender.visible_message(
		span_danger("[attacker] punches [defender]'s neck!"),
		span_userdanger("Your neck is punched by [attacker]!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_danger("You punch [defender]'s neck!"))
	defender.adjust_dizzy_up_to((10-defender.st_get_stat(STAT_STAMINA)) SECONDS, 10 SECONDS)
	defender.adjust_stamina_loss(50)
	playsound(attacker, 'sound/items/weapons/cqchit1.ogg', 50, TRUE, -1)
	return TRUE

/datum/martial_art/darkpack_cqb/proc/Restrain(mob/living/attacker, mob/living/defender)
	if(restraining_mob?.resolve())
		return FALSE
	if(IS_UNCONSCIOUS(defender))
		return FALSE
	log_combat(attacker, defender, "restrained (CQB)")
	defender.visible_message(
		span_warning("[attacker] locks [defender] into a restraining position!"),
		span_userdanger("You're locked into a restraining position by [attacker]!"),
		span_hear("You hear shuffling and a muffled groan!"),
		null,
		attacker,
	)
	to_chat(attacker, span_danger("You lock [defender] into a restraining position!"))
	defender.apply_damage(20, STAMINA)
	defender.Paralyze(2 SECONDS)
	restraining_mob = WEAKREF(defender)
	addtimer(VARSET_CALLBACK(src, restraining_mob, null), 5 SECONDS, TIMER_UNIQUE)
	return TRUE

/datum/martial_art/darkpack_cqb/grab_act(mob/living/attacker, mob/living/defender)
	if(attacker == defender)
		return MARTIAL_ATTACK_INVALID
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	if(iscrinos(attacker) || ishispo(attacker) || islupus(attacker) || !iscarbon(attacker))
		return MARTIAL_ATTACK_INVALID

	add_to_streak("G", defender)
	if(check_streak(attacker, defender)) //if a combo is made no grab upgrade is done
		return MARTIAL_ATTACK_SUCCESS
	if(attacker.body_position == LYING_DOWN)
		return MARTIAL_ATTACK_INVALID

	var/old_grab_state = attacker.grab_state
	defender.grabbedby(attacker, TRUE)
	if(old_grab_state == GRAB_PASSIVE)
		if(attacker.combat_mode)
			defender.drop_all_held_items()
			attacker.setGrabState(GRAB_AGGRESSIVE) //Instant aggressive grab if on grab intent
			defender.update_incapacitated()
			log_combat(attacker, defender, "grabbed", addition="aggressively")
			defender.visible_message(
				span_warning("[attacker] violently grabs [defender]!"),
				span_userdanger("You're grabbed violently by [attacker]!"),
				span_hear("You hear sounds of aggressive fondling!"),
				COMBAT_MESSAGE_RANGE,
				attacker,
			)
			to_chat(attacker, span_danger("You violently grab [defender]!"))
	return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/darkpack_cqb/harm_act(mob/living/attacker, mob/living/defender)

	if(iscrinos(attacker) || ishispo(attacker) || islupus(attacker) || !iscarbon(attacker))
		return MARTIAL_ATTACK_INVALID

	if(attacker.grab_state == GRAB_KILL \
		&& attacker.zone_selected == BODY_ZONE_HEAD \
		&& attacker.pulling == defender \
		&& defender.stat != DEAD \
	)
		var/obj/item/bodypart/head = defender.get_bodypart(BODY_ZONE_HEAD)
		if(!isnull(head))
			if(!do_after(attacker, (20 - (attacker.st_get_stat(STAT_DEXTERITY) + attacker.st_get_stat(STAT_MEDICINE))) , defender))
				defender.balloon_alert(attacker, "failed to necksnap!")
				to_chat(attacker, span_warning("Your hands slip off [defender]'s neck!"))
				return MARTIAL_ATTACK_FAIL
			if(iscrinos(defender) && !defender.body_position == LYING_DOWN)
				defender.balloon_alert(attacker, "failed to necksnap!")
				to_chat(attacker, span_warning("You can't get a good grip like this on [defender]'s neck!"))
				return MARTIAL_ATTACK_FAIL
			var/snappower = clamp((1 + attacker.st_get_stat(STAT_STRENGTH) - defender.st_get_stat(STAT_STAMINA)), 0, 10)
			if(snappower == 0)
				defender.balloon_alert(attacker, "not strong enough to necksnap!")
				defender.visible_message(
					span_notice("[attacker] fails to snap the neck of [defender]."),
					span_userdanger("[attacker]'s weak hands were unable to snap your neck'."),
				)
				return MARTIAL_ATTACK_FAIL
			playsound(defender, 'sound/effects/wounds/crack1.ogg', 100)
			defender.visible_message(
				span_danger("[attacker] snaps the neck of [defender]!"),
				span_userdanger("Your neck is snapped by [attacker]!"),
				span_hear("You hear a sickening snap!"),
				ignored_mobs = attacker
			)
			to_chat(attacker, span_danger("In a swift motion, you snap the neck of [defender]!"))
			log_combat(attacker, defender, "snapped neck") //I would call kill() for normal humans but necksnapping a NPC with Str 5 already does it
			defender.apply_damage(snappower LETHAL_TTRPG_DAMAGE, BRUTE, BODY_ZONE_HEAD, wound_bonus=CANT_WOUND)
			return MARTIAL_ATTACK_SUCCESS

	if(defender.check_block(attacker, 10, attacker.name, UNARMED_ATTACK)) //it's impossible to miss the neck of someone you're already strangling to death
		return MARTIAL_ATTACK_FAIL

	if(attacker.resting && defender.stat != DEAD && defender.body_position == STANDING_UP) //This probably needs to go, unsure currently
		defender.visible_message(
			span_danger("[attacker] leg sweeps [defender]!"),
			span_userdanger("Your legs are sweeped by [attacker]!"),
			span_hear("You hear a sickening sound of flesh hitting flesh!"),
			null,
			attacker,
		)
		to_chat(attacker, span_danger("You leg sweep [defender]!"))
		playsound(attacker, 'sound/effects/hit_kick.ogg', 50, TRUE, -1)
		attacker.do_attack_animation(defender)
		defender.apply_damage(10, BRUTE)
		defender.Knockdown(5 SECONDS)
		log_combat(attacker, defender, "sweeped (CQC)")
		reset_streak()
		return MARTIAL_ATTACK_SUCCESS

	add_to_streak("H", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	if(defender.body_position == LYING_DOWN)
		var/obj/item/bodypart/arm/active_arm = attacker.get_active_hand()
		var/stomp_force = ((active_arm.unarmed_damage_high + attacker.st_get_stat(STAT_STRENGTH))*(1 + ((attacker.st_get_stat(STAT_STRENGTH) - 2) / 5))) //I would prefer to move the different stomp effects into the attack chain properly, but that's a jankier solution then doing this
		var/picked_hit_type = pick("kick", "stomp")
		var/armor_block = defender.run_armor_check(attacker.zone_selected, MELEE)
		defender.apply_damage(stomp_force, BRUTE, blocked = armor_block)
		playsound(defender, (picked_hit_type == "kick" || picked_hit_type == "stomp") ? 'sound/items/weapons/cqchit2.ogg' : 'sound/items/weapons/cqchit1.ogg', 50, TRUE, -1)

		defender.visible_message(
			span_danger("[attacker] [picked_hit_type]ed [defender]!"),
			span_userdanger("You're [picked_hit_type]ed by [attacker]!"),
			span_hear("You hear a sickening sound of flesh hitting flesh!"),
			COMBAT_MESSAGE_RANGE,
			attacker,
		)
		to_chat(attacker, span_danger("You [picked_hit_type] [defender]!"))
		log_combat(attacker, defender, "attacked ([picked_hit_type]'d)(CQC)")
		return MARTIAL_ATTACK_SUCCESS

	return MARTIAL_ATTACK_INVALID //Outside these two exceptions, punching logic operates normally

/datum/martial_art/darkpack_cqb/disarm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	if(iscrinos(attacker) || ishispo(attacker) || islupus(attacker) || !iscarbon(attacker))
		return MARTIAL_ATTACK_INVALID

	add_to_streak("D", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

	if(IS_WEAKREF_OF(attacker.pulling, restraining_mob))
		log_combat(attacker, defender, "disarmed (CQC)", addition = "knocked out (CQC Chokehold)")
		defender.visible_message(
			span_danger("[attacker] puts [defender] into a chokehold!"),
			span_userdanger("You're put into a chokehold by [attacker]!"),
			span_hear("You hear shuffling and a muffled groan!"),
			null,
			attacker,
		)
		to_chat(attacker, span_danger("You put [defender] into a chokehold!"))
		//this is gonna be a tricky one to figure out
		if(!get_kindred_splat(defender))
			defender.SetSleeping(3 SECONDS)
		defender.adjust_oxy_loss(50)
		restraining_mob = null
		if(attacker.grab_state < GRAB_NECK && !HAS_TRAIT(attacker, TRAIT_PACIFISM))
			attacker.setGrabState(GRAB_NECK)
		return MARTIAL_ATTACK_SUCCESS

	attacker.do_attack_animation(defender, ATTACK_EFFECT_DISARM)
	if(prob(65) && (!(IS_UNCONSCIOUS(defender))) || !defender.IsParalyzed() || !restraining_mob?.resolve())
		var/obj/item/disarmed_item = defender.get_active_held_item()
		if(disarmed_item && defender.temporarilyRemoveItemFromInventory(disarmed_item))
			attacker.put_in_hands(disarmed_item)
		else
			disarmed_item = null

		defender.visible_message(
			span_danger("[attacker] strikes [defender]'s jaw with their hand[disarmed_item ? ", disarming [defender.p_them()] of [disarmed_item]" : ""]!"),
			span_userdanger("[attacker] strikes your jaw,[disarmed_item ? " disarming you of [disarmed_item] and" : ""] leaving you disoriented!"),
			span_hear("You hear a sickening sound of flesh hitting flesh!"),
			COMBAT_MESSAGE_RANGE,
			attacker,
		)
		to_chat(attacker, span_danger("You strike [defender]'s jaw,[disarmed_item ? " disarming [defender.p_them()] of [disarmed_item] and" : ""] leaving [defender.p_them()] disoriented!"))
		playsound(defender, 'sound/items/weapons/cqchit1.ogg', 50, TRUE, -1)
		defender.set_jitter_if_lower(4 SECONDS)
		defender.apply_damage(5, attacker.get_attack_type())
		log_combat(attacker, defender, "disarmed (CQC)", addition = disarmed_item ? "(disarmed of [disarmed_item])" : null)
		return MARTIAL_ATTACK_SUCCESS

	defender.visible_message(
		span_danger("[attacker] fails to disarm [defender]!"), \
		span_userdanger("You're nearly disarmed by [attacker]!"),
		span_hear("You hear a swoosh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	to_chat(attacker, span_warning("You fail to disarm [defender]!"))
	playsound(defender, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
	log_combat(attacker, defender, "failed to disarm (CQC)")
	return MARTIAL_ATTACK_FAIL

/datum/martial_art/darkpack_cqb/get_style_help()
	. = list()

	. += "<b><i>You try to remember some of the basics of CQC.</i></b>"

	. += "[span_notice("Slam")]: Grab Punch. Slam opponent into the ground, knocking them down."
	. += "[span_notice("CQC Kick")]: Punch Punch. Knocks opponent away. Knocks out stunned opponents and does stamina damage."
	. += "[span_notice("Restrain")]: Grab Grab Disarm. Locks opponents into a restraining position, disarm to knock them out with a chokehold."
	. += "[span_notice("Pressure")]: Shove Grab. Decent stamina damage."
	. += "[span_notice("Combat Training")]: Your past training has imparted various additional techniques. Getting someone in a strangehold will allow for you to snap their neck with a Punch. Certain techniques have unique interactions with knocked-down opponents."

	return .

#undef SLAM_COMBO
#undef KICK_COMBO
#undef RESTRAIN_COMBO
#undef PRESSURE_COMBO

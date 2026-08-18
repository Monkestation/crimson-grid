#define UPPERCUT_COMBO "HDH"
#define JAB_COMBO "GHH"
#define CROSS_COMBO "DHH"
#define DIRTY_COMBO "GGD"

/datum/martial_art/darkpack_boxing
	name = "Street Boxing"
	id = MARTIALART_DARKPACK_BOXING
	help_verb = "Remember The Basics"
	display_combos = TRUE
	var/datum/storyteller_roll/brawl_dex/dex_attack
	var/datum/storyteller_roll/brawl_strength/str_attack

/datum/martial_art/darkpack_boxing/activate_style(mob/living/new_holder)
	. = ..()

	//We check that you are not in a forbiden form to avoid birds, dogs, crinos, etc from activating this form.
	if(iscrinos(new_holder) || ishispo(new_holder) || islupus(new_holder) || !iscarbon(new_holder))		//iscarbon is a check for gangrel beast forms; bit sloppy but works.
		to_chat(new_holder, span_warning("You cannot be in this form to use this martial art!"))
		return FALSE

	//RegisterSignal(new_holder, COMSIG_ATOM_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(new_holder, COMSIG_LIVING_CHECK_BLOCK, PROC_REF(check_dodge))
	if(iscarbon(new_holder))
		var/list/obj/item/bodypart/affected_bodyparts
		var/mob/living/carbon/human/carbon_owner = new_holder
		for (var/obj/item/bodypart/limb as anything in carbon_owner.bodyparts)
			if (!istype(limb, /obj/item/bodypart/arm) && !istype(limb, /obj/item/bodypart/leg))
				continue

			LAZYADD(affected_bodyparts, limb)

			limb.unarmed_damage_low += 5 //Boxers can have nice things, they deserve it
			limb.unarmed_damage_high += 5

/datum/martial_art/darkpack_boxing/deactivate_style(mob/living/remove_from)
	UnregisterSignal(remove_from, list(COMSIG_LIVING_CHECK_BLOCK))
	return ..()

/datum/martial_art/darkpack_boxing/proc/check_streak(mob/living/attacker, mob/living/defender)

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

	if(findtext(streak,UPPERCUT_COMBO))
		reset_streak()
		return uppercut(attacker, defender)

	if(findtext(streak,JAB_COMBO))
		reset_streak()
		return jab_combo(attacker, defender)

	if(findtext(streak,CROSS_COMBO))
		reset_streak()
		return cross_punch(attacker, defender)

	if(findtext(streak,DIRTY_COMBO))
		reset_streak()
		return dirty_hit(attacker, defender)

	return FALSE

/// Frontal Kick: Harm Disarm combo, knocks back relative to Attacker Str - Defender Fort
/datum/martial_art/darkpack_boxing/proc/uppercut(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender, ATTACK_EFFECT_PUNCH)
	uppercut_animation(attacker)
	addtimer(CALLBACK(src, PROC_REF(reset_animation), attacker, FALSE), 0.1 SECONDS)
	defender.visible_message(
		span_warning("[attacker] uppercuts [defender] square in the jaw, sending you flying"),
		span_userdanger("You are uppercut in the jaw by [attacker], sending you flying!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)

	playsound(attacker, 'modular_vcg/modules/martial_arts/sounds/uppercut.ogg', 50, TRUE, -1)
	var/atom/throw_target = get_edge_target_turf(defender, attacker.dir)
	var/throw_distance = clamp((attacker.st_get_stat(STAT_STRENGTH) - defender.st_get_stat(STAT_STAMINA)), 1, 3)
	defender.throw_at(throw_target, throw_distance, 4, attacker)
	var/armor_block = defender.run_armor_check(BODY_ZONE_HEAD, MELEE)
	defender.apply_damage(6 * attacker.st_get_stat(STAT_STRENGTH), attacker.get_attack_type(), BODY_ZONE_HEAD, blocked = armor_block)
	//defender.apply_damage(damage_total, blocked = armor_block, attacker.get_attack_type(), BODY_ZONE_HEAD)
	if(defender.is_clan(/datum/subsplat/vampire_clan/malkavian) || attacker.is_clan(/datum/subsplat/vampire_clan/malkavian))
		playsound(attacker, 'modular_vcg/modules/martial_arts/sounds/bell.ogg', 50, TRUE, -1)
	log_combat(attacker, defender, "Uppercut (Boxing)")
	return TRUE

/// Jab Combo: Hit the other guy twice in quick succession
/datum/martial_art/darkpack_boxing/proc/jab_combo(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender, ATTACK_EFFECT_PUNCH)
	playsound(attacker, 'modular_vcg/modules/martial_arts/sounds/jabcombo.ogg', 50, TRUE, -1)
	defender.visible_message(span_warning("[attacker] rapidly jabs [defender]'s head!"), \
				span_userdanger("You are jabbed in the head by [attacker], leaving you disoriented!"), span_hear("You hear a sickening sound of knuckles hitting flesh!"), COMBAT_MESSAGE_RANGE, attacker)
	defender.adjust_stamina_loss(45)
	if(!dex_attack)
		dex_attack = new()
	dex_attack.difficulty = 5
	var/roll_success = dex_attack.st_roll(attacker, defender)
	var/armor_block = defender.run_armor_check(attacker.zone_selected, MELEE)
	defender.apply_damage(7 * roll_success, attacker.get_attack_type(), BODY_ZONE_HEAD, blocked = armor_block) //Hopefully shouldnt be too much of a problem, needs testing
	defender.adjust_dizzy_up_to(10 SECONDS, 10 SECONDS)
	log_combat(attacker, defender, "Jab Comboed (Boxing)")
	return TRUE

/// Cross Punch: Figure out
/datum/martial_art/darkpack_boxing/proc/cross_punch(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender, ATTACK_EFFECT_SMASH)
	playsound(attacker, 'modular_vcg/modules/martial_arts/sounds/cross.ogg', 70, TRUE, -1)
	defender.visible_message(
		span_warning("[attacker] rapidly throws [attacker.p_their()] fist at [defender]'s head!"),
		span_userdanger("You throw a heavy punch at [defender]!"),
		span_hear("You hear a sickening sound of bone hitting bone!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	defender.apply_damage(20, STAMINA)
	var/armor_block = defender.run_armor_check(BODY_ZONE_CHEST, MELEE)
	defender.apply_damage(7 * attacker.st_get_stat(STAT_STRENGTH), attacker.get_attack_type(), BODY_ZONE_CHEST, blocked = armor_block)
	log_combat(attacker, defender, "Cross Punched (Kung-Fu)")
	return TRUE

/// Dirty Move: Liver Punch or something
/datum/martial_art/darkpack_boxing/proc/dirty_hit(mob/living/attacker, mob/living/defender)
	attacker.do_attack_animation(defender, ATTACK_EFFECT_KICK)
	playsound(attacker, 'modular_vcg/modules/martial_arts/sounds/hook.ogg', 70, TRUE, -1)
	defender.visible_message(
		span_warning("[attacker] strikes [defender] directly in the stomach!"),
		span_userdanger("You hit [defender]'s lower abdomen!"),
		span_hear("You hear a sickening sound of flesh hitting flesh!"),
		COMBAT_MESSAGE_RANGE,
		attacker,
	)
	if(!dex_attack)
		dex_attack = new()
	dex_attack.difficulty = defender.st_get_stat(STAT_STAMINA)
	var/roll_success = dex_attack.st_roll(attacker, defender)
	if(roll_success)	//If success, stun + knockdown and damage. If no success, only the damage.
		if(ishuman(defender))
			var/mob/living/carbon/human/human_owner = defender
			// Normally vomit can stun for 20 seconds but that's.. really rough. Instead we do 5, and 3 seconds knockdown
			if(get_kindred_splat(human_owner))	//Did you know that kindred use blood in place of bodily fluids?
				if(prob(50))
					human_owner.Knockdown(1 SECONDS)
					human_owner.vomit(vomit_flags = (MOB_VOMIT_MESSAGE | MOB_VOMIT_FORCE | VOMIT_CATEGORY_BLOOD), lost_nutrition = 0, distance = rand(1,2))
				human_owner.Paralyze(2 SECONDS)
			if(iscrinos(human_owner))			//We don't knock down Garou; they're able to tank it
				if(prob(50))
					human_owner.vomit(vomit_flags = (MOB_VOMIT_MESSAGE | MOB_VOMIT_FORCE), lost_nutrition = 10, distance = rand(1,2), purge_ratio = 0.5)
				human_owner.Paralyze(2 SECONDS)
			else								//Ghouls/humans/other get the base effect
				if(prob(50))
					human_owner.Knockdown(1 SECONDS)
					human_owner.vomit(vomit_flags = (MOB_VOMIT_MESSAGE | MOB_VOMIT_FORCE), lost_nutrition = 10, distance = rand(1,2), purge_ratio = 0.5)
				human_owner.Paralyze(2 SECONDS)

	defender.apply_damage(30, STAMINA)
	var/armor_block = defender.run_armor_check(BODY_ZONE_CHEST, MELEE)
	defender.apply_damage(30, attacker.get_attack_type(), BODY_ZONE_CHEST, blocked = armor_block)
	log_combat(attacker, defender, "gut punched (Street Boxing)")
	return TRUE

/datum/martial_art/darkpack_boxing/grab_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 0, "[attacker]'s grab", UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	if(iscrinos(attacker) || ishispo(attacker) || islupus(attacker) || !iscarbon(attacker))
		return MARTIAL_ATTACK_INVALID

	add_to_streak("G", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	defender.apply_damage(15, STAMINA)
	return MARTIAL_ATTACK_INVALID //Boxing is not known for holds

/datum/martial_art/darkpack_boxing/harm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 10, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	if(iscrinos(attacker) || ishispo(attacker) || islupus(attacker) || !iscarbon(attacker))
		return MARTIAL_ATTACK_INVALID

	add_to_streak("H", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS

	return MARTIAL_ATTACK_INVALID //You're gonna punch someone in the face normally and like it

/datum/martial_art/darkpack_boxing/disarm_act(mob/living/attacker, mob/living/defender)
	if(!can_deflect(attacker)) //you arent swiping at someone on the ground
		return MARTIAL_ATTACK_INVALID
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	if(iscrinos(attacker) || ishispo(attacker) || islupus(attacker) || !iscarbon(attacker))
		return MARTIAL_ATTACK_INVALID

	add_to_streak("D", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	//playsound(defender, 'modular_vcg/modules/martial_arts/sounds/swipe.ogg', 25, TRUE, -1) SFX didnt feel good using it
	defender.apply_damage(20, STAMINA)
	return MARTIAL_ATTACK_INVALID //Essentially taking a swipe at their face

/datum/martial_art/darkpack_boxing/proc/can_deflect(mob/living/user)
	if(!can_use(user) || !user.combat_mode)
		return FALSE
	if(INCAPACITATED_IGNORING(user, INCAPABLE_GRAB)) //NO STUN
		return FALSE
	if(!(user.mobility_flags & MOBILITY_USE)) //IF YOU CANT MOVE, YOU CANT DODGE
		return FALSE
	if(HAS_TRAIT(user, TRAIT_HULK)) //NO HULK
		return FALSE
	if(!isturf(user.loc)) //NO MOTHERFLIPPIN MECHS!
		return FALSE
	return TRUE

/datum/martial_art/darkpack_boxing/proc/reset_animation(mob/living/user, fadein)
	if(fadein)
		animate(user, alpha = 225, time = 0.1 SECONDS)
		return
	else
		animate(user, alpha = 225, pixel_x = 0, pixel_y = 0, time = 0.1 SECONDS)

/datum/martial_art/darkpack_boxing/proc/dodge_animation(mob/living/user)
	var/new_pixel_x
	var/new_pixel_y
	var/userdir = user.dir
	switch(userdir)
		if(EAST)
			new_pixel_x = rand(-16, -8)
			new_pixel_y = rand(-24, 24)
		if(WEST)
			new_pixel_x = rand(8, 16)
			new_pixel_y = rand(-24, 24)
		if(NORTH)
			new_pixel_x = rand(-16,16)
			new_pixel_y = rand(-16, -8)
		if(SOUTH)
			new_pixel_x = rand(-16,16)
			new_pixel_y = rand(8, 16)
	animate(user, alpha = 200, pixel_x = new_pixel_x, pixel_y = new_pixel_y, time = 0.2 SECONDS)

/datum/martial_art/darkpack_boxing/proc/uppercut_animation(mob/living/user)
	var/new_pixel_x
	var/new_pixel_y
	var/userdir = user.dir
	switch(userdir)
		if(EAST)
			new_pixel_x = rand(0, 4)
			new_pixel_y = rand(0, 12)
		if(WEST)
			new_pixel_x = rand(-4, 0)
			new_pixel_y = rand(0, 12)
		if(NORTH)
			new_pixel_y = rand(0, 12)
		if(SOUTH)
			new_pixel_y = rand(0, 12)
	animate(user, alpha = 200, pixel_x = new_pixel_x, pixel_y = new_pixel_y, time = 0.2 SECONDS)

/// Like the hit game "Punch Out!!" (1984) you can dodge incoming punches thrown at you. Melee weapons and projectiles? not so lucky
/datum/martial_art/darkpack_boxing/proc/check_dodge(mob/living/user, atom/movable/hitby, damage, attack_text, attack_type, ...)
	SIGNAL_HANDLER

	if(iscrinos(user) || ishispo(user) || islupus(user) || !iscarbon(user))
		return NONE

	var/determine_avoidance = ((user.st_get_stat(STAT_ATHLETICS) + user.st_get_stat(STAT_DEXTERITY) + user.st_get_stat(STAT_BRAWL)) * 2) //Theoretical max of 40% with Cel 5

	if(!can_deflect(user))
		return

	if(user.throw_mode) //Theoretical max of 80% with Cel 5
		determine_avoidance *= 2 //Note, this is ~2.7 times higher then Kung-Fu because of the extremely narrow use-case

	if(attack_type != UNARMED_ATTACK)
		return NONE

	if(!prob(determine_avoidance))
		return NONE

	user.visible_message(
		span_danger("[user] cleanly dodges [attack_text] with incredible speed!"),
		span_userdanger("You dodge [attack_text]"),
	)
	playsound(user.loc, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
	var/mob/living/attacker = GET_ASSAILANT(hitby)
	user.setDir(turn(attacker.dir, 180))
	var/mob/living/carbon/human/dodger = user
	dodge_animation(dodger)
	addtimer(CALLBACK(src, PROC_REF(reset_animation), dodger, FALSE), 0.1 SECONDS)


	return SUCCESSFUL_BLOCK

/datum/martial_art/darkpack_boxing/get_style_help()
	. = list()

	. += "<b><i>You try to remember some of the basics of street boxing.</i></b>"

	. += "[span_notice("Uppercut")]: Punch Shove Punch. Jump up and hit an opponent directly in the jaw, dealing significant damage and launching weaker foes away!"
	. += "[span_notice("Jab Combo")]: Grab Punch Punch. Release a flurry of jabs into your opponent's head, disorienting and tiring them, along with dealing decent amounts of brute damage."
	. += "[span_notice("Cross Punch")]: Shove Punch Punch. Throw a single, heavy punch directly at your opponents skull"
	. += "[span_notice("Dirty Hit")]: Grab Grab Shove. Disregard the rules of the ring and punch the liver of your opponent, making them puke and keel over."
	. += "[span_notice("Dodging")]: Like any trained boxer, you are able to avoid punches thrown at you while in Combat Mode. Throw mode greatly increases the avoidance chance"

	return .

#undef UPPERCUT_COMBO
#undef JAB_COMBO
#undef CROSS_COMBO
#undef DIRTY_COMBO

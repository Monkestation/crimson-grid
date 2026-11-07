/mob/living/proc/is_mortal_for_kiss()
    if(get_kindred_splat(src))
        return FALSE

    if(get_garou_splat(src) || get_corax_splat(src))
        return FALSE

    if(get_full_splat() && !get_ghoul_splat(src))
        return FALSE

    return TRUE

/mob/living/carbon/human/proc/drinksomeblood(mob/living/drunk_from, first_drink = FALSE)
	COOLDOWN_START(src, drinkblood_use_cd, 3 SECONDS)
	update_drinking_overlay(drunk_from)

	if(HAS_TRAIT(src, TRAIT_VICTIM_OF_THE_MASQUERADE))
		var/datum/quirk/darkpack/victim_of_the_masquerade/votm = src.get_quirk(/datum/quirk/darkpack/victim_of_the_masquerade)
		if(votm)
			if(!votm.victim_of_the_masquerade_roll)
				votm.victim_of_the_masquerade_roll = new()
			var/result = votm.victim_of_the_masquerade_roll.st_roll(src, drunk_from)
			if(result != ROLL_SUCCESS)
				to_chat(src, span_warning("Нет... это не по-настоящему. Я не могу этого делать!.."))
				SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
				Unconscious(5 SECONDS)
				SEND_SIGNAL(src, COMSIG_PATH_HIT, -1, 0, FALSE)
				remove_drinking_overlay(drunk_from)
				return


	if(HAS_TRAIT(src, TRAIT_BLOODY_SUCKER))
		src.emote("moan")
		Immobilize(30, TRUE)

	if(isnpc(drunk_from))
		var/mob/living/carbon/human/npc/NPC = drunk_from
		NPC.danger_source = null
		// drunk_from.Stun(40) //NPCs don't get to resist // CORVAX EDIT

	if(drunk_from.blood_volume <= BLOOD_VOLUME_BAD)
		to_chat(src, span_warning("Сердце жертвы едва бьётся. Смерть уже рядом."))

	//Check if we can drink this person to death
	if(drunk_from.bloodpool <= 0 && !check_can_drink_dry(drunk_from))
		remove_drinking_overlay(drunk_from)
		return


	if(drunk_from.bloodpool <= 1 && drunk_from.maxbloodpool > 1)
		to_chat(src, span_warning("Вы чувствуете: <b>КРОВИ</b> в жертве почти не осталось."))

	if(first_drink && !HAS_TRAIT(src, TRAIT_BLOODY_LOVER) && has_conscious_witness()) // CORVAX EDIT +first_drink +has_conscious_witness
		SEND_SIGNAL(src, COMSIG_MASQUERADE_VIOLATION)

	if(!do_after(src, 3 SECONDS, target = drunk_from, timed_action_flags = NONE, show_progress = FALSE))
		remove_drinking_overlay(drunk_from)
		// CORVAX EDIT ADD START
		if(!HAS_TRAIT(src, TRAIT_PAINFUL_VAMPIRE_KISS) \
			&& drunk_from.is_mortal_for_kiss() \
			&& !(SEND_SIGNAL(drunk_from, COMSIG_MOB_VAMPIRE_SUCKED, drunk_from) & COMPONENT_RESIST_VAMPIRE_KISS))
			drunk_from.apply_status_effect(/datum/status_effect/kissed)
		// CORVAX EDIT ADD END
		return

	drunk_from.adjust_blood_pool(-1)
	suckbar.icon_state = "[round(14*(drunk_from.bloodpool/drunk_from.maxbloodpool))]"

	if(ishuman(drunk_from))
		var/mob/living/carbon/human/H = drunk_from
		if(!get_kindred_splat(drunk_from))
			H.blood_volume = max(H.blood_volume-50, 150)

		if(H.reagents)
			if(length(H.reagents.reagent_list))
				if(prob(50))
					H.reagents.trans_to(src, min(10, H.reagents.total_volume), transferred_by = drunk_from, methods = INGEST)

	if(HAS_TRAIT(src, TRAIT_PAINFUL_VAMPIRE_KISS))
		drunk_from.adjust_brute_loss(20, TRUE)
		drunk_from.emote("scream") // CORVAX EDIT ADD

	//Ventrue can suck on normal people, but not homeless people and animals.
	//BLOOD_QUALITY_LOV - 1, BLOOD_QUALITY_NORMAL - 2, BLOOD_QUALITY_HIGH - 3. Blue blood gives +1 to suction
	if(HAS_TRAIT(src, TRAIT_FEEDING_RESTRICTION) && drunk_from.bloodquality < BLOOD_QUALITY_NORMAL)
		to_chat(src, span_warning("Такая дрянная <b>КРОВЬ</b> не для вас. Найдите что-нибудь поприличнее."))
		visible_message(span_danger("[capitalize(declent_ru(ACCUSATIVE))] рвёт!"), span_userdanger("Вас рвёт!"))
		playsound(get_turf(src), 'modular_darkpack/modules/deprecated/sounds/vomit.ogg', 75, TRUE)
		if(isturf(loc))
			add_splatter_floor(loc)
		remove_drinking_overlay(drunk_from)
		return

	if(get_kindred_splat(drunk_from))
		to_chat(src, span_userdanger("Кровь [drunk_from.declent_ru(GENITIVE)] на вкус БОЖЕСТВЕННА..."))
		adjust_brute_loss(-25, TRUE)
		adjust_fire_loss(-25, TRUE)
	else
		to_chat(src, span_warning("Вы делаете глоток <b>КРОВИ</b> жертвы. Какое блаженство."))

	var/drink_mod = calculate_drink_modifier(drunk_from)

	if(drink_mod)
		adjust_blood_pool(drink_mod*max(1, drunk_from.bloodquality-1))
		adjust_brute_loss(-10, TRUE)
		adjust_fire_loss(-10, TRUE)
		update_damage_overlays()
		update_health_hud()
		add_mood_event("did kissing", /datum/mood_event/did_kiss) // CRIMSON EDIT ADD - vamp bite mood
	if(drunk_from.bloodpool <= 0)
		handle_drink_dry(drunk_from)
		remove_drinking_overlay(drunk_from)
		return

	if(grab_state >= GRAB_PASSIVE)
		stop_sound_channel(CHANNEL_BLOOD)
		drinksomeblood(drunk_from)

// CORVAX EDIT START
/mob/living/carbon/human/proc/has_conscious_witness()
	for(var/mob/living/viewer in oviewers(DEFAULT_SIGHT_DISTANCE, src))
		if(viewer == src)
			continue

		if(viewer.is_blind() || IS_UNCONSCIOUS(viewer))
			continue

		if(viewer.has_status_effect(/datum/status_effect/incapacitating/sleeping))
			continue
		if(viewer.has_status_effect(/datum/status_effect/incapacitating/paralyzed))
			continue
		if(viewer.has_status_effect(/datum/status_effect/incapacitating/stun))
			continue
		if(viewer.has_status_effect(/datum/status_effect/incapacitating/knockdown))
			continue

		if(!istype(viewer, /mob/living/carbon) && !viewer.client)
			continue

		return TRUE
	return FALSE
// CORVAX EDIT END
// CRIMSON EDIT ADD START - vamp bite mood
/datum/mood_event/did_kiss
	description = "Выпивая кровь из тела, я испытываю эйфорию."
	mood_change = 50
	timeout = 5 MINUTES
// CRIMSON EDIT ADD END - vamp bite mood

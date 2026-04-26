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
				to_chat(src, span_warning("No... this isn't real. I can't be doing this...!"))
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
		drunk_from.Stun(40) //NPCs don't get to resist

	if(drunk_from.blood_volume <= BLOOD_VOLUME_BAD)
		to_chat(src, span_warning("Your victim's heart beats only weakly. Death comes for them."))

	//Check if we can drink this person to death
	if(drunk_from.bloodpool <= 0 && !check_can_drink_dry(drunk_from))
		remove_drinking_overlay(drunk_from)
		return


	if(drunk_from.bloodpool <= 1 && drunk_from.maxbloodpool > 1)
		to_chat(src, span_warning("You feel small amount of <b>BLOOD</b> in your victim."))

	if(!HAS_TRAIT(src, TRAIT_BLOODY_LOVER))
		SEND_SIGNAL(src, COMSIG_MASQUERADE_VIOLATION)

	if(!do_after(src, 3 SECONDS, target = drunk_from, timed_action_flags = NONE, progress = FALSE))
		remove_drinking_overlay(drunk_from)
		if(!(SEND_SIGNAL(drunk_from, COMSIG_MOB_VAMPIRE_SUCKED, drunk_from) & COMPONENT_RESIST_VAMPIRE_KISS))
			drunk_from.apply_status_effect(/datum/status_effect/kissed)
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

	//Ventrue can suck on normal people, but not homeless people and animals.
	//BLOOD_QUALITY_LOV - 1, BLOOD_QUALITY_NORMAL - 2, BLOOD_QUALITY_HIGH - 3. Blue blood gives +1 to suction
	if(HAS_TRAIT(src, TRAIT_FEEDING_RESTRICTION) && drunk_from.bloodquality < BLOOD_QUALITY_NORMAL)
		to_chat(src, span_warning("You are too privileged to drink that awful <b>BLOOD</b>. Go get something better."))
		visible_message(span_danger("[src] throws up!"), span_userdanger("You throw up!"))
		playsound(get_turf(src), 'modular_darkpack/modules/deprecated/sounds/vomit.ogg', 75, TRUE)
		if(isturf(loc))
			add_splatter_floor(loc)
		remove_drinking_overlay(drunk_from)
		return

	if(get_kindred_splat(drunk_from))
		to_chat(src, span_userdanger("[drunk_from]'s blood tastes HEAVENLY..."))
		adjust_brute_loss(-25, TRUE)
		adjust_fire_loss(-25, TRUE)
	else
		to_chat(src, span_warning("You sip some <b>BLOOD</b> from your victim. It feels good."))

	var/drink_mod = calculate_drink_modifier(drunk_from)

	if(drink_mod)
		adjust_blood_pool(drink_mod*max(1, drunk_from.bloodquality-1))
		adjust_brute_loss(-10, TRUE)
		adjust_fire_loss(-10, TRUE)
		update_damage_overlays()
		update_health_hud()

	if(drunk_from.bloodpool <= 0)
		handle_drink_dry(drunk_from)
		remove_drinking_overlay(drunk_from)
		return

	if(grab_state >= GRAB_PASSIVE)
		stop_sound_channel(CHANNEL_BLOOD)
		drinksomeblood(drunk_from)

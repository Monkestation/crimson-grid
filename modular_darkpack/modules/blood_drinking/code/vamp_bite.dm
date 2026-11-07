//this code is what should be called every time blood drinking is used on a character
/mob/living/carbon/human/proc/vamp_bite()
	if(!COOLDOWN_FINISHED(src, drinkblood_use_cd) || !COOLDOWN_FINISHED(src, drinkblood_click_cd))
		return
	COOLDOWN_START(src, drinkblood_click_cd, 1 SECONDS)
	if(grab_state > GRAB_PASSIVE)
		if(isliving(pulling))
			var/mob/living/bit_living = pulling
			if(!get_vampire_splat(src))
				SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
				to_chat(src, span_warning("Вы ещё не настолько отчаялись, чтобы пойти на <i>такое</i>."))
				return
			// Allow ghouls to steal viate?
			if(get_ghoul_splat(src))
				if(!get_kindred_splat(bit_living))
					SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
					to_chat(src, span_warning("Вы ещё не настолько отчаялись, чтобы пойти на <i>такое</i>."))
					return
			// Allow for diablor?
			if(!get_kindred_splat(bit_living) || !get_kindred_splat(src))
				if(!CAN_HAVE_BLOOD(bit_living) || (bit_living.blood_volume <= 50) || (bit_living.bloodpool <= 0))
					SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
					to_chat(src, span_warning("Этот сосуд пуст. Придётся искать другой."))
					return
			// Prey exclusion for anyone with the Flaw. Note that this is different than drinksomeblood.dm and TRAIT_FEEDING_RESTRICTION which disallows ventrue from drinking blood of poor npcs.
			var/datum/quirk/darkpack/prey_exclusion/prey_exclusion_datum = src.get_quirk(/datum/quirk/darkpack/prey_exclusion)
			if(prey_exclusion_datum && prey_exclusion_datum.prey_exclusion && istype(bit_living, prey_exclusion_datum.prey_exclusion))
				SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
				to_chat(src, span_warning("Такая добыча вам противна."))
				// DARKPACK TODO - FRENZY - tgui_input, yes or no to continue feeding in spite of the prey being excluded, if so, frenzy and path/humanity hit
				return

			// anthropic taste flaw
			if(HAS_TRAIT(src, TRAIT_ANTHROPIC_TASTE) && istype(bit_living, /mob/living/basic))
				SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
				to_chat(src, span_warning("Такая добыча вам противна."))
				// DARKPACK TODO - FRENZY - tgui_input, yes or no to continue feeding in spite of the prey being excluded, if so, frenzy and path/humanity hit
				return

			// victim of the masquerade flaw
			if(HAS_TRAIT(src, TRAIT_VICTIM_OF_THE_MASQUERADE))
				var/datum/quirk/darkpack/victim_of_the_masquerade/votm = src.get_quirk(/datum/quirk/darkpack/victim_of_the_masquerade)
				if(votm)
					if(!votm.victim_of_the_masquerade_roll)
						votm.victim_of_the_masquerade_roll = new()
					var/result = votm.victim_of_the_masquerade_roll.st_roll(src, bit_living)
					if(result != ROLL_SUCCESS)
						to_chat(src, span_warning("Что я, чёрт возьми, делаю? Я же не вампир... о боже... голова кружится..."))
						src.Unconscious(1 TURNS)
						SEND_SIGNAL(src, COMSIG_PATH_HIT, -1, 0, FALSE)
						SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
						return
					else
						to_chat(src, span_notice("Зубы... или это клыки?.. входят глубоко. Тепло, хорошо... о боже... так нельзя!.."))

			// territorial flaw
			if(HAS_TRAIT(src, TRAIT_VAMPIRE_TERRITORIAL))
				var/datum/quirk/darkpack/territorial/terr = src.get_quirk(/datum/quirk/darkpack/territorial)
				if(terr && terr.territory)
					var/area/current_area = get_area(bit_living)
					if(!istype(current_area, terr.territory))
						to_chat(src, span_warning("Это не ваша территория. Охотиться здесь вам не хочется."))
						SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
						return

			// Dulled Bite flaw, defanged kindred.
			if(HAS_TRAIT(src, TRAIT_DULLFANGS))
				to_chat(src, span_warning("Ваши клыки слишком тупы, чтобы прокусить плоть!"))
				SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
				return

			// Thirst Of Ages flaw.
			if(HAS_TRAIT(src, TRAIT_THIRST_OF_AGES))
				if(!bit_living.get_full_splat())
					to_chat(src, span_warning("Эта кровь слишком слаба для вас!"))
					SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
					return

			if(get_kindred_splat(src))
				bit_living.emote("groan")
			else if(get_ghoul_splat(src))
				bit_living.emote("scream")

			if(ishuman(bit_living))
				var/mob/living/carbon/human/bit_human = bit_living
				bit_human.add_bite_animation()

			var/skipface = (wear_mask && (wear_mask.flags_cover & MASKCOVERSMOUTH)) || (head && (head.flags_cover & HEADCOVERSMOUTH))
			if(!skipface)
				if(get_kindred_splat(src) && HAS_TRAIT(src, TRAIT_NEEDS_BLOOD))
					trigger_kindred_frenzy(bit_living, 6, 0, "Вкус крови на пике голода")

				if(!HAS_TRAIT(src, TRAIT_PAINFUL_VAMPIRE_KISS) && bit_living.is_mortal_for_kiss()) // CORVAX EDIT
					bit_living.Sleeping(30 SECONDS)
					bit_living.Paralyze(40 SECONDS, TRUE)

				if(!HAS_TRAIT(src, TRAIT_BLOODY_LOVER))
					playsound(src, 'modular_darkpack/modules/blood_drinking/sounds/drinkblood1.ogg', 30, TRUE) // CRIMSON EDIT CHANGE - ORIGINAL: playsound(src, 'modular_darkpack/modules/blood_drinking/sounds/drinkblood1.ogg', 50, TRUE)

					bit_living.visible_message(span_warning(span_bold("[capitalize(declent_ru(NOMINATIVE))] впивается в шею [bit_living.declent_ru(GENITIVE)]!")), span_warning(span_bold("[capitalize(declent_ru(NOMINATIVE))] впивается вам в шею!")))
				// if(!HAS_TRAIT(src, TRAIT_BLOODY_LOVER)) // CORVAX EDIT
				// 	SEND_SIGNAL(src, COMSIG_MASQUERADE_VIOLATION)
				else
					playsound(src, 'modular_darkpack/modules/blood_drinking/sounds/kiss.ogg', 50, TRUE)
					bit_living.visible_message(span_italics(span_bold("[capitalize(declent_ru(NOMINATIVE))] целует [bit_living.declent_ru(ACCUSATIVE)]!")), span_userlove(span_bold("[capitalize(declent_ru(NOMINATIVE))] целует вас!")))

				if(!HAS_TRAIT(src, TRAIT_BLOODY_LOVER) && has_conscious_witness(bit_living)) // CORVAX EDIT +has_conscious_witness
					SEND_SIGNAL(src, COMSIG_MASQUERADE_VIOLATION)

				log_combat(src, bit_living, "bit and is drinking blood from", "Drinker bloodpool : [bloodpool] ,  Victim bloodpool : [bit_living.bloodpool]")
				drinksomeblood(bit_living, TRUE)

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
				to_chat(src, span_warning("You're not desperate enough to try <i>that</i>."))
				return
			// Allow ghouls to steal viate?
			if(get_ghoul_splat(src))
				if(!get_kindred_splat(bit_living))
					SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
					to_chat(src, span_warning("You're not desperate enough to try <i>that</i>."))
					return
			// Allow for diablor?
			if(!get_kindred_splat(bit_living) || !get_kindred_splat(src))
				if(!CAN_HAVE_BLOOD(bit_living) || (bit_living.blood_volume <= 50) || (bit_living.bloodpool <= 0))
					SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
					to_chat(src, span_warning("This vessel is empty. You'll have to find another."))
					return
			// Prey exclusion for anyone with the Flaw. Note that this is different than drinksomeblood.dm and TRAIT_FEEDING_RESTRICTION which disallows ventrue from drinking blood of poor npcs.
			var/datum/quirk/darkpack/prey_exclusion/prey_exclusion_datum = src.get_quirk(/datum/quirk/darkpack/prey_exclusion)
			if(prey_exclusion_datum && prey_exclusion_datum.prey_exclusion && istype(bit_living, prey_exclusion_datum.prey_exclusion))
				SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
				to_chat(src, span_warning("You despise this kind of prey."))
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
						to_chat(src, span_warning("What the hell am I doing? I'm not a vampire... oh god... I feel lightheaded..."))
						src.Unconscious(1 TURNS)
						SEND_SIGNAL(src, COMSIG_PATH_HIT, -1, 0, FALSE)
						SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
						return
					else
						to_chat(src, span_notice("Your teeth... or are they fangs... sink deep. It feels warm and good... oh god... this is wrong...!"))

			// territorial flaw
			if(HAS_TRAIT(src, TRAIT_VAMPIRE_TERRITORIAL))
				var/datum/quirk/darkpack/territorial/terr = src.get_quirk(/datum/quirk/darkpack/territorial)
				if(terr && terr.territory)
					var/area/current_area = get_area(bit_living)
					if(!istype(current_area, terr.territory))
						to_chat(src, span_warning("This isn't your territory. You don't want to feed here."))
						SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
						return

			// Dulled Bite flaw, defanged kindred.
			if(HAS_TRAIT(src, TRAIT_DULLFANGS))
				to_chat(src, span_warning("Your fangs are too dull to pierce flesh!"))
				SEND_SOUND(src, sound('modular_darkpack/modules/blood_drinking/sounds/need_blood.ogg', volume = 75))
				return

			if(get_kindred_splat(src))
				bit_living.emote("groan")
			else if(get_ghoul_splat(src))
				bit_living.emote("scream")

			if(ishuman(bit_living))
				var/mob/living/carbon/human/bit_human = bit_living
				bit_human.add_bite_animation()

			var/skipface = (wear_mask && (wear_mask.flags_inv & HIDEFACE)) || (head && (head.flags_inv & HIDEFACE))
			if(!skipface)
				if(get_kindred_splat(src) && HAS_TRAIT(src, TRAIT_NEEDS_BLOOD))
					var/stat_to_roll = is_enlightenment() ? STAT_INSTINCT : STAT_SELF_CONTROL
					var/datum/storyteller_roll/frezy_roll = new()
					frezy_roll.applicable_stats = list(stat_to_roll)
					var/frenzy_result = frezy_roll.st_roll(src, bit_living)
					if(frenzy_result != ROLL_SUCCESS)
						to_chat(src, span_userdanger("The taste of blood sends you into a frenzy as you feed!"))
						// DARKPACK TODO: frenzy, please put the call here
					else
						to_chat(src, span_green("The taste of fresh blood while hungry almost drives you into frenzy!"))

				if(!HAS_TRAIT(src, TRAIT_BLOODY_LOVER))
					playsound(src, 'modular_darkpack/modules/blood_drinking/sounds/drinkblood1.ogg', 50, TRUE)
					bit_living.visible_message(span_warning(span_bold("[src] bites [bit_living]'s neck!")), span_warning(span_bold("[src] bites your neck!")))
				if(!HAS_TRAIT(src, TRAIT_BLOODY_LOVER))
					SEND_SIGNAL(src, COMSIG_MASQUERADE_VIOLATION)
				else
					playsound(src, 'modular_darkpack/modules/blood_drinking/sounds/kiss.ogg', 50, TRUE)
					bit_living.visible_message(span_italics(span_bold("[src] kisses [bit_living]!")), span_userlove(span_bold("[src] kisses you!")))
				drinksomeblood(bit_living, TRUE)
